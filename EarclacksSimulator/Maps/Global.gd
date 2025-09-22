extends Control

var MapName : Node = null
var Ball1=""
var Ball2=""

var GameOver=false
var Loser=""
var HP=250
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Restart"):
		get_tree().change_scene_to_file("res://Maps/Menu.tscn")
		Loser=""
		GameOver=false
