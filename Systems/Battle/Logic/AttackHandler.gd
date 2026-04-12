# MagicCaster.gd
extends Node
class_name AttackHandler

enum Tag { COUNTER }

## casts a magic attack from the caster to the targets in targetting type. target type choose allows
## a manual target in the third argument
func cast(caster: FighterState, element: int, potency: float, target_type: Defines.TARGETING_TYPE, choose = null, tags: Array = []):
	var targets = _get_targets(caster, target_type, choose)
	EventBus.emit("battle_action_cast", {
		"caster": caster,
		"targets": targets,
		"element": element,
		"tags": tags
	})
	for target in targets:
		_apply_magic_damage(caster, target, element, potency, tags)

func _get_targets(caster: FighterState, target_type: Defines.TARGETING_TYPE, choose = null) -> Array:
	match target_type:
		Defines.TARGETING_TYPE.Choose:
			return [choose]
		Defines.TARGETING_TYPE.Leader:
			if caster.parent.id == 1:
				return [Situation.teams[0].get_leftmost_fighter()]
			return [Situation.teams[1].get_rightmost_fighter()]
		Defines.TARGETING_TYPE.Enemies:
			return caster.get_enemy_team().fighters
		Defines.TARGETING_TYPE.Self:
			return [caster]
		Defines.TARGETING_TYPE.NextAlly:
			var next = caster.get_next_fighter() as FighterState
			return [next]
		Defines.TARGETING_TYPE.Allies:
			return caster.get_allied_team().fighters
		Defines.TARGETING_TYPE.Everyone:
			return Situation.fighters
		Defines.TARGETING_TYPE.EveryoneButMe:
			var fighters = Situation.fighters.duplicate() as Array[FighterState]
			fighters.erase(caster)
			return fighters
		_:
			push_error("Unhandled targeting type: %s" % target_type)
			return []

func _apply_magic_damage(attacker: FighterState, defender: FighterState, element: int, potency: float, tags: Array) -> void:
	var at_mana_mult = attacker.parent.reservoirs[element].mult
	var df_mana_mult = defender.parent.reservoirs[element].mult
	var at_spi = attacker.attributes[Defines.ATTRIBUTE.Spi].current
	var df_wis = defender.attributes[Defines.ATTRIBUTE.Wis].current
	var damage = Defines.ATTACK_MULT * at_mana_mult / df_mana_mult * at_spi / df_wis * potency
	#region Attack Event
	var attack_event = CmdAttack.new(attacker, defender, damage, tags)
	attack_event = Situation.skills.resolve(attack_event)
	if attack_event.is_cancelled: return
	damage = attack_event.damage
	#endregion
	_apply_push(attacker, defender, damage, tags)

func _apply_push(attacker: FighterState, defender: FighterState, damage: float, tags: Array) -> void:
	defender.position_x -= defender.parent.direction * damage
	attacker.dmg_del += damage
	defender.dmg_rec += damage
	Situation.skills.resolve(CmdDealDmg.new(attacker, damage, tags))
	Situation.skills.resolve(CmdReceiveDmg.new(defender, damage, tags))
