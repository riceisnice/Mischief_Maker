extends Sprite

const TEXT_TIME = 2

enum {READY, TXT1, TXT2, TXT3, SPAWN_MATS, GAMELOOP, LEVEL_WON, TXT4, TXT5, END_LEVEL}

var state
var prepared_mats
var third = false

func _ready():
	state = READY
	$Sprite/Speech.text = "I think I was onto something with the balloon idea."
	$Timer.start(TEXT_TIME)
	for n in get_tree().get_nodes_in_group("material"):
		n.connect("clicked", self, "on_material_click")
		n.connect("released", self, "on_material_released")


#func _process(delta):
#	pass

func on_material_click(name):
	$Sprite/Speech.text = find_material(name).material_desc

func on_material_released(name):
	var mat = find_material(name)
	var other
	if not mat.overlapping.empty():
		other = mat.overlapping.front().material_name
		if name == "twine" and other == "girl":
			$Sprite/Speech.text = $rope.material_desc
			$twine.hide()
			$rope.reveal()
		elif (name == "fabric" and other == "scissors") or (name == "scissors" and other == "fabric"):
			$Sprite/Speech.text = $large_balloon.material_desc
			$fabric.hide()
			$scissors.hide()
			$large_balloon.position = $fabric.position
			$large_balloon.reveal()
		elif name == "balloon_basket" and other == "girl":
			$Sprite/Speech.text = $basket.material_desc
			$balloon_basket.hide()
			$basket.reveal()
		elif (name == "twine" and other == "large_balloon") or (name == "large_balloon" and other == "twine"):
			$Sprite/Speech.text = "I don't think this twine is quite strong enough as it is."
		elif (name == "rope" and other == "large_balloon") or (name == "large_balloon" and other == "rope"):
			$Sprite/Speech.text = $roped_balloon.material_desc
			$rope.hide()
			$large_balloon.hide()
			$roped_balloon.position = $large_balloon.position
			$roped_balloon.reveal()
		elif (name == "basket" and other == "roped_balloon") or (name == "roped_balloon" and other == "basket"):
			$Sprite/Speech.text = $air_balloon.material_desc
			$basket.hide()
			$roped_balloon.hide()
			$air_balloon.position = $roped_balloon.position
			$air_balloon.reveal()
		elif (name == "air_balloon" and other == "propane_tank") or (name == "propane_tank" and other == "air_balloon"):
			$Sprite/Speech.text = $hot_air_balloon.material_desc
			$air_balloon.hide()
			$propane_tank.hide()
			$hot_air_balloon.position = $air_balloon.position
			$hot_air_balloon.reveal()
			$hot_air_balloon.freeze()
			state = LEVEL_WON
			$Timer.start(TEXT_TIME)
			$Sophia.make_animation()
		else:
			$Sprite/Speech.text = "That doesn't work..."
		

func find_material(name):
	var mats = get_tree().get_nodes_in_group("material")
	for m in mats:
		if m.material_name == name:
			return m

func spawn_material():
	var mat = prepared_mats.pop_back()
	if mat != null:
		mat.reveal()
		$Timer.start(1)
	else:
		#$Sprite/Speech.text = "Click a part to learn more about it."
		state = GAMELOOP

func _input(event):
	if event is InputEventMouseButton:
		match state:
			TXT1:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "What if I made a hot air balloon?"
				$Timer.start(TEXT_TIME)
			TXT2:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "Those are like, actual things that exist."
				$Timer.start(TEXT_TIME)
			TXT3:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "I can do this!"
				$Timer.start(TEXT_TIME)
			TXT4:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "..."
				$Timer.start(TEXT_TIME)
			TXT5:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "This might just actually work! Time to get airborne!"
				$Timer.start(TEXT_TIME)
			END_LEVEL:
				$MusicPlayer.stream_paused = true
				$EndTune.play()
				$Sophia.z_index = 0
				$hot_air_balloon.z_index = 10
				$fadeout.play()

func _on_Timer_timeout():
	match state:
		READY:
			state = TXT1
			$Sprite/Next.visible = true
		TXT1:
			state = TXT2
			$Sprite/Next.visible = true
		TXT2:
			state = TXT3
			$Sprite/Next.visible = true
		TXT3:
			state = SPAWN_MATS
			prepared_mats = get_tree().get_nodes_in_group("start_mats")
			spawn_material()
		SPAWN_MATS:
			spawn_material()
		LEVEL_WON:
			state = TXT4
			$Sprite/Next.visible = true
		TXT4:
			state = TXT5
			$Sprite/Next.visible = true
		TXT5:
			state = END_LEVEL
			$Sprite/Next.visible = true



func _on_EndTune_finished():
	pass # Replace with function body.
