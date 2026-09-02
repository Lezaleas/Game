class_name ChoiceNode
extends RefCounted

enum State {AVAILABLE, SELECTED, BLOCKED}

var id := ""

var payload : Variant
var resolver : ChoiceResolver

var state := State.AVAILABLE

var tags : Array[String] = []

var data := {}

var texture: = preload("res://Assets/Sprites/Common/ElementalIcons/White.tres")
