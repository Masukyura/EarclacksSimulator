extends StaticBody2D

@onready var BulletScene = preload("res://Balls/Projectiles/TurretBullet.tscn")
var WrenchBody=null
var HasDecay=false
var Lifetime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ShootCooldown.start()
	$DecayTimer.wait_time=Lifetime
	$DecayTimer.start()
	

func GetWrenchName(Body):
	WrenchBody=Body
func Shoot():
	var Bullet = BulletScene.instantiate()
	get_tree().current_scene.add_child(Bullet)
	Bullet.global_position = $BulletStart.global_position
	Bullet.look_at($BulletFacing.global_position)
	Bullet.GetWrenchName
	Bullet.GetWrenchName(WrenchBody)
	

func Decay(delta):
	modulate.a-=5*delta
	if modulate.a<=0:
		WrenchBody.Turrets-=1
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(deg_to_rad(75*delta))
	if WrenchBody.HP<=0 or HasDecay==true:
		Decay(delta)



func _on_shoot_cooldown_timeout() -> void:
	$ShootCooldown.start()
	Shoot()


func _on_decay_timer_timeout() -> void:
	HasDecay=true
