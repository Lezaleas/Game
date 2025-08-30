extends Node

# ----------------------------
# Constants
# ----------------------------
const MOVE_SPEED = 5			# multiplier for movespeed when the turn starts
const ATTACK_MULT = 250			# multiplier for all attacks
const CLASH_ENGAGE_RANGE = 100	# if whithin this distance, fighters engage in a clash
const LEFT_BOUNDARY = 0			# 
const RIGHT_BOUNDARY = 1920		
const NUMBER_OF_ELEMENTS = 4	# red, blue, yellow, green
const MANA_LEVEL_BASE = 100		# mana base value for each level up before multiplier
const MANA_DECAY_TICK = 0.99	# mana decays to this fraction every 0.2 seconds

# ----------------------------
# Enums
# ----------------------------
enum ATTRIBUTE { Pwr, Spi, Wis, Agi }
enum ELEMENT { Red, Blue, Yellow, Green }
enum BUFF { Burn, Freeze, Shock, Poison }

enum CMD_EVENT_TYPE { Walk, Attack, DealDmg, ReceiveDmg, TurnStart, ClashStart, ClashLink }
enum TARGETING_TYPE { Choose, Leader, Enemies, Self, NextAlly, Allies, Everyone, EveryoneButMe }
