extends Sprite

const TEXT_TIME = 2

enum {READY, TXT1, TXT2, TXT3, SPAWN_MATS, GAMELOOP, LEVEL_WON, TXT4, TXT5, END_LEVEL}

var state
var prepared_mats
var third = false

func _ready():
	state = READY
	$Sprite/Speech.text = "What else is good at flying...? Think... Think!"
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
		if name == "swiffer" and other == "girl":
			$swiffer.destroy()
			$Sprite/Speech.text = "I don't need this, after all. Let's clean it out."
		elif (name == "branch" and other == "clippers") or (name == "clippers" and other == "branch"):
			$Sprite/Speech.text = $stick.material_desc
			$branch.hide()
			$clippers.hide()
			$stick.reveal()
			$twigs.reveal()
		elif third and (name == "stick" or name == "twigs" or name == "twine") and (other == "stick" or other == "twigs" or other == "twine"):
			$Sprite/Speech.text = $broom.material_desc
			$stick.hide()
			$twigs.hide()
			$twine.hide()
			$broom.position = $stick.position
			$broom.reveal()
			$broom.freeze()
			state = LEVEL_WON
			$Timer.start(TEXT_TIME)
			$Sophia.make_animation()
		elif (name == "stick" or name == "twigs" or name == "twine") and (other == "stick" or other == "twigs" or other == "twine"):
			$Sprite/Speech.text = "I think I need one more thing here."
			third = true
		else:
			$Sprite/Speech.text = "That doesn't work..."
			third = false
		

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
				$Sprite/Speech.text = "I got it!"
				$Timer.start(TEXT_TIME)
			TXT2:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "Witches fly on brooms, why couldn't I?"
				$Timer.start(TEXT_TIME)
			TXT3:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "Sweep away all distractions, lets see what we got here."
				$Timer.start(TEXT_TIME)
			TXT4:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "..."
				$Timer.start(TEXT_TIME)
			TXT5:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "I guess it doesn't work like in the movies. Third time's the charm!"
				$Timer.start(TEXT_TIME)
			END_LEVEL:
				$MusicPlayer.stream_paused = true
				$EndTune.play()
				$Sophia.z_index = 0
				$broom.z_index = 10
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

