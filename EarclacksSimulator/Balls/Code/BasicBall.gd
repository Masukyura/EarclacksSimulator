extends RigidBody2D

var Velocity=0
var Speed=1.5
var HP=100
var Name="BasicBall"
var WeaponDetectName="BasicWeaponDetector"
var Damage=1

func _ready():
	$Ball.play("Normal")
	$HP/Label.text=str(HP)
	gravity_scale = 0.2
	linear_damp = 0
	angular_damp = 0
	linear_velocity = Vector2(
		randi_range(250, 300),
		-randi_range(250, 300)
	)
	Velocity = linear_velocity.length()
func _process(_delta: float) -> void:
	$HP/Label.text=str(HP)
func _physics_process(_delta):
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * Velocity*Speed

func _on_colision_detector_body_entered(body: Node2D) -> void:
	pass #Make sound

func TakeDamage(Amount):
	HP-=Amount
	if HP<=0:
		$CollisionShape2D.set_deferred("disabled", true)
		visible = false
	$HP/Label.text=str(HP)
	$Ball.play("Damaged")
	get_tree().paused = true
	await get_tree().create_timer(0.15, true).timeout  
	get_tree().paused = false
	$Ball.play("Normal")

func _on_colision_detector_area_entered(area: Area2D) -> void:
	pass
	
func _on_basic_weapon_detector_body_entered(body: Node2D) -> void:
	if body!=self && body.is_in_group("Balls"):
		body.TakeDamage(Damage)
