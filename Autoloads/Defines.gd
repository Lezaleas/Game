extends Node

# ----------------------------
# Constants
# ----------------------------
const TEAM_SIZE = 4 # how many fighters do we expect per team
const MOVE_SPEED = 5 # multiplier for movespeed when the turn starts
const ATTACK_MULT = 250 # multiplier for all attacks
const CLASH_ENGAGE_RANGE = 100 # if whithin this distance, fighters engage in a clash
const LEFT_BOUNDARY = 0 #
const RIGHT_BOUNDARY = 1920
const NUMBER_OF_ELEMENTS = 4 # red, blue, yellow, green
const STAMINA_LOSS_VICTORY = 25 # stamina to lose after winning a clash
const MANA_LEVEL_BASE = 100 # mana base value for each level up before multiplier
const MANA_DECAY_TICK = 0.99 # mana decays to this fraction every 0.2 seconds
const WIN_THRESHOLD_RATIO = 0.0 # percentage of the map to control to win
const STAMINA_GAIN_TURN = 2 # how much stamina to regen each turn
const TIERS_PER_PERK_TREE = 4
const ATTRIBUTE_STARTING = 10 # base attribute level
const MAX_WEIGHT = 100
# ----------------------------
# Enums
# ----------------------------
enum ATTRIBUTE {Pwr, Spi, Wis, Agi, Crit, Cdmg, Cdef, Acc, Eva, Datk, Ddef}
enum PERKATT {Pwr, Spi, Wis, Agi}
enum ELEMENT {Red, Blue, Yellow, Green}
enum BUFF {Burn, Freeze, Shock, Poison, Shield}
enum EQUIP_TYPE {Sword, Staff, Armor, Boots}
enum EQUIP_QUALITY {Common, Rare, Epic, Legendary}
enum INVESTMENT {None, Minor, Major, Master, Grandmaster}

enum PROG_TAG {
	Metal, Martial, Fire, Precision,
	Arcane, Spirit, Occult, Knowledge,
	Nature, Discipline, Craftsmanship,
	Wind, Rhythm, Travel, Learning
}
enum PROG_METHOD {Experimental, Ritualistic, Reckless, Precise, Obsessive}
enum PROG_PERSONALITY {Stubborn, Ambitious, Fragile, Fanatical}
enum PROG_ELEMENT {Fire, Water, Arcane, Nature, Wind, Earth}


enum CMD_EVENT_TYPE {Walk, Attack, DealDmg, ReceiveDmg, TurnStart, ClashStart, ClashLink,
					  StatsCalc, ApplyBuff, ClashEvasion, ClashCrit, AttackEvasion, AttackCrit}
enum TARGETING_TYPE {Choose, Leader, Enemies, Self, NextAlly, Allies, Everyone, EveryoneButMe}
# ----------------------------
# Libraries
# ----------------------------
var skills = preload("res://Data/Libraries/SkillLibrary.tres")
var icons = preload("res://Data/Libraries/IconLibrary.tres")
var perktrees = preload("res://Data/Libraries/PerkTreeLibrary.tres")
var buffs = preload("res://Data/Libraries/BuffLibrary.tres")
