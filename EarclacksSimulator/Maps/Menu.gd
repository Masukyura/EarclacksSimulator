extends Node2D

var bobbing_speed := 3
var bobbing_height := 10
var original_position := Vector2.ZERO
var time_passed := 0.0

var CanStart="true"
var CharEdited=false
var WeaponCycle=["SwordBall","SpearBall","HammerBall","DaggerBall","StaffBall","ScepterBall","WrenchBall","BowBall","CrossbowBall"]
var WeaponNames=[]
var WeaponColor=["FF0000","5b8eff","c60060","00ff00","075de8","27b8b0","ffa600","ffff00","8a5117"]

func _ready() -> void:
	$BgMusic.play()
	for i in len(WeaponCycle):
		WeaponNames.append(WeaponCycle[i].substr(0,(WeaponCycle[i].length())-4))
	original_position = $VersesLabel.position
	set_deferred("monitoring", true)
	Global.Ball1="SwordBall"
	Global.Ball2="SpearBall"

func BallSelectSprite():
	for i in WeaponNames:
		get_node("Ball1Select/"+str(i)).visible=false
		get_node("Ball2Select/"+str(i)).visible=false
		get_node("Ball1/"+str(i)).visible=false
		get_node("Ball2/"+str(i)).visible=false
		
	get_node(("Ball1Select/")+str(Global.Ball1.substr(0, Global.Ball1.length() - 4))).visible=true
	get_node(("Ball1/")+str(Global.Ball1.substr(0, Global.Ball1.length() - 4))).visible=true
	$Ball1.self_modulate=Color(WeaponColor[WeaponNames.find(str(Global.Ball1.substr(0, Global.Ball1.length() - 4)))])
	$Ball2.self_modulate=Color(WeaponColor[WeaponNames.find(str(Global.Ball2.substr(0, Global.Ball2.length() - 4)))])
	get_node(("Ball2Select/")+str(Global.Ball2.substr(0, Global.Ball2.length() - 4))).visible=true
	get_node(("Ball2/")+str(Global.Ball2.substr(0, Global.Ball2.length() - 4))).visible=true

func _process(delta: float) -> void:
	BallSelectSprite()
	$TextField/HPEdit.text = str(int($TextField/HPEdit.text))
	$TextField/HPEdit.caret_column = $TextField/HPEdit.text.length()
	if Input.is_action_just_pressed("Click") and CanStart=="true":
		$ClickTheme.play()
		if $TextField/HPEdit.text=="0":
			$TextField/HPEdit.text="1"
		Global.HP=int($TextField/HPEdit.text)
		get_tree().change_scene_to_file("res://Maps/Map.tscn")
	if Input.is_action_just_pressed("Click") and CanStart!="true":
		$ClickTheme.play()
		if CanStart.contains("1"):
			if CanStart.contains("U"):
				var safe_index = wrapi(WeaponCycle.find(Global.Ball1)-1, 0, WeaponCycle.size())
				Global.Ball1=WeaponCycle[safe_index]
				if Global.Ball1==Global.Ball2:
					safe_index = wrapi(WeaponCycle.find(Global.Ball1)-1, 0, WeaponCycle.size())
					Global.Ball1=WeaponCycle[safe_index]
			if CanStart.contains("D"):
				var safe_index = wrapi(WeaponCycle.find(Global.Ball1)+1, 0, WeaponCycle.size())
				Global.Ball1=WeaponCycle[safe_index]
				if Global.Ball1==Global.Ball2:
					safe_index = wrapi(WeaponCycle.find(Global.Ball1)+1, 0, WeaponCycle.size())
					Global.Ball1=WeaponCycle[safe_index]
		if CanStart.contains("2"):
			if CanStart.contains("U"):
				var safe_index = wrapi(WeaponCycle.find(Global.Ball2)-1, 0, WeaponCycle.size())
				Global.Ball2=WeaponCycle[safe_index]
				if Global.Ball2==Global.Ball1:
					safe_index = wrapi(WeaponCycle.find(Global.Ball2)-1, 0, WeaponCycle.size())
					Global.Ball2=WeaponCycle[safe_index]
			if CanStart.contains("D"):
				var safe_index = wrapi(WeaponCycle.find(Global.Ball2)+1, 0, WeaponCycle.size())
				Global.Ball2=WeaponCycle[safe_index]
				if Global.Ball2==Global.Ball1:
					safe_index = wrapi(WeaponCycle.find(Global.Ball2)+1, 0, WeaponCycle.size())
					Global.Ball2=WeaponCycle[safe_index]
				
	time_passed += delta
	$Ball1.rotate(deg_to_rad(100 * delta))
	$Ball2.rotate(deg_to_rad(-120 * delta))
	$VersesLabel.position.y = original_position.y + sin(time_passed * bobbing_speed) * bobbing_height

func _on_up_button_1_mouse_entered() -> void:
	CanStart="1U"
	$Ball1Select/UpButton1/UpButtonSprite.scale=Vector2(1.1,1.1)

func _on_down_button_1_mouse_entered() -> void:
	CanStart="1D"
	$Ball1Select/DownButton1/DownButtonSprite.scale=Vector2(1.1,1.1)


func _on_up_button_1_mouse_exited() -> void:
	CanStart="true"
	$Ball1Select/UpButton1/UpButtonSprite.scale=Vector2(1,1)


func _on_down_button_1_mouse_exited() -> void:
	CanStart="true"
	$Ball1Select/DownButton1/DownButtonSprite.scale=Vector2(1,1)

func _on_up_button_2_mouse_entered() -> void:
	CanStart="2U"
	$Ball2Select/UpButton2/UpButtonSprite.scale=Vector2(1.1,1.1)

func _on_down_button_2_mouse_entered() -> void:
	CanStart="2D"
	$Ball2Select/DownButton2/DownButtonSprite.scale=Vector2(1.1,1.1)


func _on_up_button_2_mouse_exited() -> void:
	CanStart="true"
	$Ball2Select/UpButton2/UpButtonSprite.scale=Vector2(1,1)


func _on_down_button_2_mouse_exited() -> void:
	CanStart="true"
	$Ball2Select/DownButton2/DownButtonSprite.scale=Vector2(1,1)
	


func _on_hp_edit_mouse_entered() -> void:
	CanStart="false"

func _on_hp_edit_mouse_exited() -> void:
	CanStart="true"



func _on_hp_edit_text_changed(new_text: String) -> void:
	$TextField/HPEdit.caret_column = $TextField/HPEdit.text.length()
	if CharEdited==false:
		CharEdited=true
		$TextField/HPEdit.text=$TextField/HPEdit.text[-1]
