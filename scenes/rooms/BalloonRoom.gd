extends Sprite

const TEXT_TIME = 2

enum {READY, TXT1, TXT2, TXT3, SPAWN_MATS, GAMELOOP, LEVEL_WON, TXT4, TXT5, END_LEVEL}

var state
var prepared_mats

func _ready():
	state = READY
	$Sprite/Speech.text = "This next idea can't be too small, use magic, or require wind."
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
		if name == "helium_tank" and other == "girl":
			$Sprite/Speech.text = "As funny as it is, I don't want to waste any on changing my voice. This game doesn't have voice acting."
		elif (name == "helium_balloons" and other == "basket") or (name == "basket" and other == "helium_balloons"):
			$Sprite/Speech.text = $balloon_basket.material_desc
			$helium_balloons.hide()
			$helium_tank.hide()
			$basket.hide()
			$balloon_basket.position = $basket.position
			$balloon_basket.reveal()
			$balloon_basket.freeze()
			state = LEVEL_WON
			$Timer.start(TEXT_TIME)
			$Sophia.make_animation()
		elif (name == "helium_tank" and mat.overlapping.has(find_material("balloon_bag"))) and mat.overlapping.has(find_material("twine")) or (name == "helium_tank" and mat.overlapping.has(find_material("balloon_bag"))) and mat.overlapping.has(find_material("twine")) or (name == "twine" and mat.overlapping.has(find_material("helium_tank")) and mat.overlapping.has(find_material("balloon_bag"))):
			$Sprite/Speech.text = $helium_balloons.material_desc
			$balloon_bag.hide()
			$twine.hide()
			$helium_balloons.position = $balloon_bag.position
			$helium_balloons.reveal()
		elif (name == "helium_tank" or name == "balloon_bag" or name == "twine") and (other == "helium_tank" or other == "balloon_bag" or other == "twine"):
			$Sprite/Speech.text = "I think I need one more thing here."
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
				$Sprite/Speech.text = "I know what doesn't need wind... Balloons!"
				$Timer.start(TEXT_TIME)
			TXT2:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "If I use enough of them, I'm sure it'll work."
				$Timer.start(TEXT_TIME)
			TXT3:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "I think we even have a helium tank!"
				$Timer.start(TEXT_TIME)
			TXT4:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "..."
				$Timer.start(TEXT_TIME)
			TXT5:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "No dice... I guess I don't have enough of them to carry me."
				$Timer.start(TEXT_TIME)
			END_LEVEL:
				$MusicPlayer.stream_paused = true
				$EndTune.play()
				$Sophia.z_index = 0
				$balloon_basket.z_index = 10
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
	get_tree().change_scene("res://scenes/rooms/HotAirRoom.tscn")
