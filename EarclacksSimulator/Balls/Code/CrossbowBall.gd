extends RigidBody2D

var Velocity=0
var Speed=1.5
var RotationDirection=1
var ArrowCooldown=false
@onready var ArrowScene = preload("res://Balls/Projectiles/CrossbowArrow.tscn")

var Damage=1
var ShootInterval=5
var DamageDealt=0
var HP=Global.HP

var Name="CrossbowBall"
var WeaponDetectName="CrossbowWeaponDetector"
var BallNum=0

signal Died

func Arrow():
	$ShootSound.play()
	for body in $CrossbowWeaponDetector.get_overlapping_bodies():
		if body.is_in_group("Walls"):
			Damage+=0.5
			if ShootInterval>=0.1:
				ShootInterval-=0.1
				ShootInterval=clamp(ShootInterval,0.1,1000000)
			return
	var Arrow = ArrowScene.instantiate()
	get_tree().current_scene.add_child(Arrow)
	Arrow.ReadCrossbowBodyName(self)
	Arrow.global_position = $CrossbowWeaponDetector/ArrowSpawnLocation.global_position
	Arrow.look_at($CrossbowWeaponDetector/ArrowFacing.global_position)
	Arrow.Damage=Damage
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
	Global.MapName.NumOfLabelsVisible(3,"Crossbow")
	Global.MapName.ChangeOneLabel("Damage/Radius: "+str(Damage),"Crossbow")
	Global.MapName.ChangeTwoLabel("Damage Dealt: "+str(DamageDealt),"Crossbow")
	$ArrowCooldown.start()
	if Global.Ball1==Name:
		BallNum=1
	if Global.Ball2==Name:
		BallNum=2
func _process(_delta: float) -> void:
	ShootInterval=clamp(ShootInterval,-0.05,1000000)
	$HP/Label.text=str(int(ceil(HP)))
	if len($HP/Label.text)==4:
		$HP/Label.add_theme_font_size_override("font_size", 325)
	else:
		$HP/Label.add_theme_font_size_override("font_size", 400)
	Global.MapName.ChangeOneLabel("Damage: "+str(round(Damage*100)/100),"Crossbow")
	Global.MapName.ChangeTwoLabel("Shoot Interval: "+str(round(ShootInterval*10)/10)+"sec","Crossbow")
	Global.MapName.ChangeThreeLabel("Damage Dealt: "+str(round(DamageDealt*10)/10),"Crossbow")
	if HP<=0:
		Global.Loser=Name
func _physics_process(delta):
	$CrossbowWeaponDetector.rotate(deg_to_rad(delta*150*RotationDirection))
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

func _on_crossbow_weapon_detector_body_entered(body: Node2D) -> void:
	if body!=self && body.is_in_group("Balls") && HP>0:
		body.TakeDamage(1)
		body.DamageTick(0.2)
		RotationDirection*=-1
		DamageDealt+=1
		if $HitSound.playing==false:
			$HitSound.play()


func _on_crossbow_weapon_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Weapon") and Global.GameOver==false:
		RotationDirection*=-1
		if BallNum==1:
			$ParrySound.play()
		

func _on_arrow_cooldown_timeout() -> void:
	ShootInterval=clamp(ShootInterval,0.05,1000000)
	$ArrowCooldown.wait_time=ShootInterval
	$ArrowCooldown.start()
	Arrow()
