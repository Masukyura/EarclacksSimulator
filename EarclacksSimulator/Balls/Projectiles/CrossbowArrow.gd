extends Node2D

@export var speed := 800
var Damage=0
var Hit=false
var CrossbowBody=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func ReadCrossbowBodyName(Body):
	CrossbowBody=Body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation)*speed*delta


func _on_arrow_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls") and Hit==false:
		CrossbowBody.Damage+=0.5
		Global.MapName.ChangeOneLabel("Damage: "+str(round(Damage*100)/100),"Crossbow")
		if CrossbowBody.ShootInterval>=0.1:
				CrossbowBody.ShootInterval-=0.1
				CrossbowBody.ShootInterval=clamp(CrossbowBody.ShootInterval,0.1,1000000)
		queue_free()
	if body.is_in_group("Balls") and Hit==false:
		if Hit==false && body!=CrossbowBody:
			body.TakeDamage(Damage)
			$HitSound.play()
			CrossbowBody.DamageDealt+=Damage
	Hit=true
	$Arrow.visible=false
