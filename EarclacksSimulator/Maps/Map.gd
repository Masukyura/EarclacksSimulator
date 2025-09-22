extends Node2D
var Ball1Scene = null
var Ball2Scene = null
var GameoverSoundPlayed=false
var WeaponList=["Sword","Spear","Hammer","Dagger","Staff","Scepter","Wrench","Bow","Crossbow"]
var WeaponColor=["FF0000","5b8eff","c60060","00ff00","075de8","27b8b0","ffa600","ffff00","8a5117"]
func NumOfLabelsVisible(Num,BallName):
	if Global.Ball1.contains(BallName):
		$HudTest/WeaponLabel1/WeaponName.add_theme_color_override("font_color", Color(WeaponColor[WeaponList.find(str(BallName))]))
	if Global.Ball2.contains(BallName):
		$HudTest/WeaponLabel2/WeaponName.add_theme_color_override("font_color", Color(WeaponColor[WeaponList.find(str(BallName))]))
	if Global.Ball1.contains(BallName):
		$HudTest/WeaponLabel1/WeaponName.text=str(BallName)
		for i in range(Num):
			get_node("HudTest/WeaponLabel1/WeaponStats"+str(i+1)).visible=true
	else:
		$HudTest/WeaponLabel2/WeaponName.text=str(BallName)
		for i in range(Num):
			get_node("HudTest/WeaponLabel2/WeaponStats"+str(i+1)).visible=true

func ChangeOneLabel(Text,BallName):
	if Global.Ball1.contains(BallName):
		$HudTest/WeaponLabel1/WeaponStats1.text=str(Text)
	else:
		$HudTest/WeaponLabel2/WeaponStats1.text=str(Text)

func ChangeTwoLabel(Text,BallName):
	if Global.Ball1.contains(BallName):
		$HudTest/WeaponLabel1/WeaponStats2.text=str(Text)
	else:
		$HudTest/WeaponLabel2/WeaponStats2.text=str(Text)

func ChangeThreeLabel(Text,BallName):
	if Global.Ball1.contains(BallName):
		$HudTest/WeaponLabel1/WeaponStats3.text=str(Text)
	else:
		$HudTest/WeaponLabel2/WeaponStats3.text=str(Text)
	
func _ready() -> void:
	Ball1Scene=load("res://Balls/"+Global.Ball1+".tscn")
	Ball2Scene=load("res://Balls/"+Global.Ball2+".tscn")
	var Ball1Map = Ball1Scene.instantiate()
	var Ball2Map = Ball2Scene.instantiate()
	Ball1Map.position=Vector2(-150,-150)
	Ball2Map.position=Vector2(150,150)
	add_child(Ball1Map)
	add_child(Ball2Map)
	var Ball1Sprite=get_node(str(Global.Ball1)+"/"+"Ball")
	var Ball2Sprite=get_node(str(Global.Ball2)+"/"+"Ball")
	Ball1Sprite.modulate=Color(WeaponColor[WeaponList.find(str(Global.Ball1.substr(0, Global.Ball1.length() - 4)))])
	Ball2Sprite.modulate=Color(WeaponColor[WeaponList.find(str(Global.Ball2.substr(0, Global.Ball2.length() - 4)))])
	Global.MapName=self
	$HudTest/WeaponLabel1/WeaponStats1.visible = false
	$HudTest/WeaponLabel1/WeaponStats2.visible = false
	$HudTest/WeaponLabel1/WeaponStats3.visible = false
	$HudTest/WeaponLabel2/WeaponStats1.visible = false
	$HudTest/WeaponLabel2/WeaponStats2.visible = false
	$HudTest/WeaponLabel2/WeaponStats3.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("FastForwards"):
		Engine.time_scale=4
	else:
		if $"HudTest/ButtonControl/2x Button".is_pressed():
			Engine.time_scale=2
		else:
			Engine.time_scale=1
	if Global.GameOver==true && GameoverSoundPlayed==false:
		$BallDieDink.play()
		GameoverSoundPlayed=true
	if Global.GameOver and Global.Loser!="":
		if Global.Loser==Global.Ball1:
			$HudTest/WeaponLabel1/WeaponName.add_theme_color_override("font_color", Color("838383"))
		if Global.Loser==Global.Ball2:
			$HudTest/WeaponLabel2/WeaponName.add_theme_color_override("font_color", Color("838383"))


func _on_ball_sound_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Balls"):
		$BounceWallSound.play()
