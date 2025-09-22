extends Node2D

@export var speed := 800
var Hit=false
var BowBody=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func ReadBowName(Body):
	BowBody=Body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation)*speed*delta


func _on_arrow_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls"):
		queue_free()
	if body.is_in_group("Balls"):
		if Hit==false && body!=BowBody:
			body.TakeDamage(1)
			BowBody.DamageDealt+=1
			$HitSound.play()
			BowBody.Arrows+=1
	if body!=BowBody:
		Hit=true
		$Arrow.visible=false
