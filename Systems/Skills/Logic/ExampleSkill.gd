extends Skill
class_name ExampleSkill

# This skill will explain how to implement skills
# the skill handler will check if skills active in battle have certain methods
# these methods correspond to each clash event possible
# the full list of clash events in on the defines autoload

func TurnStart(command: CmdTurnStart) -> CmdTurnStart:
	# this function will execute when a turnstart event is called
	# make sure to return the command so other skills can also process the event
	return command

func SelfClashLink(command: CmdClashLink) -> CmdClashLink:
	# since this function has the self prefix, it will execute on clash links,
	# but only if self = event main fighter
	command.damage_mult *= power
	# make sure to properly log each skill activation using the Log.entry method
	# the method will append skill name and owner fighter
	Log.entry("won a clash and allies deal more damage")
	return command
