extends Node2D

@export var speed := 400
var WrenchBody=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func GetWrenchName(Body):
	WrenchBody=Body
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation)*speed*delta


func _on_collision_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		queue_free()
	if body.is_in_group("Balls") and body!=WrenchBody:
		body.TakeDamage(1)
		body.DamageTick(0.1)
		WrenchBody.DamageDealt+=1
		Global.MapName.ChangeOneLabel("Turrets: "+str(WrenchBody.Turrets),"Wrench")
		Global.MapName.ChangeTwoLabel("Damage Dealt: "+str(WrenchBody.DamageDealt),"Wrench")
		queue_free()
