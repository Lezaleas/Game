extends Resource
class_name EnemyTemplate

## sprite_0 is the name of the stage 0 enemy and so on
@export var sprite_0: SpriteFrames
@export var sprite_1: SpriteFrames
@export var sprite_2: SpriteFrames
@export var sprite_3: SpriteFrames
@export var id_0: String
@export var id_1: String
@export var id_2: String
@export var id_3: String

## defines the power level for each attribute
## the list holds how much to multiply the base stage level power for
## so for example a stage 2 enemy with low spi attribute would have 40 * 0.7 spirit
const STAGE_BASE_POWER = [10,20,40,80]
const ATTRIBUTE_MULTIPLIER = [0.5,0.7,1,1.4,2.0]
@export var attribute_pow: Defines.ENEMY_ATTRIBUTE = Defines.ENEMY_ATTRIBUTE.Medium
@export var attribute_spi: Defines.ENEMY_ATTRIBUTE = Defines.ENEMY_ATTRIBUTE.Medium
@export var attribute_wis: Defines.ENEMY_ATTRIBUTE = Defines.ENEMY_ATTRIBUTE.Medium
@export var attribute_agi: Defines.ENEMY_ATTRIBUTE = Defines.ENEMY_ATTRIBUTE.Medium

## A stage 0 enemy should only have skill_0 and passive_0 enabled, a stage 1 should have up to
## skill_1 and passive_1 and so on
@export var skill_0: Skill
@export var skill_1: Skill
@export var skill_2: Skill
@export var skill_3: Skill
@export var passive_0: Skill
@export var passive_1: Skill
@export var passive_2: Skill
@export var passive_3: Skill
