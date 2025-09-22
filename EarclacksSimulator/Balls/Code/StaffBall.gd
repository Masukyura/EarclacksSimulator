extends RigidBody2D

var Velocity=0
var Speed=1.5
var RotationDirection=1
var FireballCooldown=false
@onready var FireballScene = preload("res://Balls/Projectiles/StaffFireball.tscn")

var Damage=1
var DamageDealt=0
var HP=Global.HP

var Name="StaffBall"
var WeaponDetectName="StaffWeaponDetector"
var BallNum=0

signal Died

func Fireball():
	$ShootSound.play()
	var Fireball = FireballScene.instantiate()
	get_tree().current_scene.add_child(Fireball)
	Fireball.ReadStaffBodyName(self)
	Fireball.global_position = $StaffWeaponDetector/FireballSpawnLocation.global_position
	Fireball.look_at($StaffWeaponDetector/FireballFacing.global_position)
	Fireball.Damage=Damage
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
	await get_tree().create_timer(0.01).timeout
	Global.MapName.NumOfLabelsVisible(2,"Staff")
	Global.MapName.ChangeOneLabel("Damage/Radius: "+str(Damage),"Staff")
	Global.MapName.ChangeTwoLabel("Damage Dealt: "+str(DamageDealt),"Staff")
	$FireballCooldown.start()
	if Global.Ball1==Name:
		BallNum=1
	if Global.Ball2==Name:
		BallNum=2
func _process(_delta: float) -> void:
	$HP/Label.text=str(int(ceil(HP)))
	if len($HP/Label.text)==4:
		$HP/Label.add_theme_font_size_override("font_size", 325)
	else:
		$HP/Label.add_theme_font_size_override("font_size", 400)
	Global.MapName.ChangeOneLabel("Damage/Radius: "+str(Damage),"Staff")
	Global.MapName.ChangeTwoLabel("Damage Dealt: "+str(DamageDealt),"Staff")
	if HP<=0:
		Global.Loser=Name
func _physics_process(delta):
	$StaffWeaponDetector.rotate(deg_to_rad(delta*150*RotationDirection))
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * Velocity*Speed
func _on_colision_detector_body_entered(body: Node2D) -> void:
	if body.name=="Walls" or body.name=="Floor":
		var rand_angle = deg_to_rad(randf_range(-5, 5))
		linear_velocity = linear_velocity.rotated(rand_angle)
	if body.is_in_group("Balls"):
		if $HitSound.playing==false && BallNum==1:
			$HitOtherBall.play()

func DamageTick(time):
		get_tree().paused = true
		$Ball.play("Damaged")
		var OgModulate=$Ball.modulate
		$Ball.modulate=Color(1,1,1)
		await get_tree().create_timer(time, true).timeout  
		get_tree().paused = false
		$Ball.modulate=OgModulate
		$Ball.play("Normal")

func TakeDamage(Amount):
	if Global.GameOver==false:
		HP-=Amount
		if HP<=0:
			Global.GameOver=true
			emit_signal("Died",Name)
			$CollisionShape2D.set_deferred("disabled", true)
			visible = false
		$HP/Label.text=str(int(ceil(HP)))

func _on_staff_weapon_detector_body_entered(body: Node2D) -> void:
	if body!=self && body.is_in_group("Balls") && HP>0:
		body.TakeDamage(1)
		body.DamageTick(0.2)
		RotationDirection*=-1
		DamageDealt+=1
		if $HitSound.playing==false:
			$HitSound.play()


func _on_staff_weapon_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Weapon") and Global.GameOver==false:
		RotationDirection*=-1
		if BallNum==1:
			$ParrySound.play()
		

func _on_fireball_cooldown_timeout() -> void:
	$FireballCooldown.start()
	Fireball()
