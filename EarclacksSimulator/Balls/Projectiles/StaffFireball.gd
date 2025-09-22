extends Node2D

@export var speed := 600
var Exploded=false
var DeployZoom=false
var Damage=0
var StaffBody=null
var DealtDamage=false
var BodyList=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FireballSprite.play("Fireball")
	$ExplosionDetector.visible=false
	$ExplosionDetector/ScaleFactor.scale=Vector2(0.1,0.1)

func ReadStaffBodyName(Body):
	StaffBody=Body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ExplosionDetector.scale=Vector2(1.15+((Damage-1)*0.1),1.15+((Damage-1)*0.1))
	if Exploded==false:
		position += Vector2.RIGHT.rotated(rotation)*speed*delta
	if Exploded==true:
		DeployZoom=true
		if $ExplosionDetector/ScaleFactor.scale.y<1:
			BodyList=$ExplosionDetector.get_overlapping_bodies()
			for Body in BodyList:
				if Body.is_in_group("Balls") and Body.name!="StaffBall":
					if DealtDamage==false:
						Body.TakeDamage(Damage)
						DealtDamage=true
						StaffBody.DamageDealt+=Damage
						StaffBody.Damage+=1
			$ExplosionDetector/ScaleFactor.scale.x+=5*delta
			$ExplosionDetector/ScaleFactor.scale.y+=5*delta
		else:
			if $ExplosionDetector/ScaleFactor.modulate.a>0:
				$ExplosionDetector/ScaleFactor.modulate.a-=0.05
			else:
				visible=false
				if $ExplosionSound.playing==false:
					queue_free()

func CheckBallinExplosion():
	$ExplosionDetector.visible=true
	$ExplosionSound.play()

		
func _on_fireball_colision_body_entered(body: Node2D) -> void:
	CheckBallinExplosion()
	Exploded=true
	$FireballSprite.visible=false
	
