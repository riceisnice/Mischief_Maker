extends Sprite

const TEXT_TIME = 2

enum {READY, TXT1, TXT2, TXT3, SPAWN_MATS, GAMELOOP, LEVEL_WON, TXT4, TXT5, END_LEVEL}

var state
var prepared_mats

func _ready():
	state = READY
	$Sprite/Speech.text = "I need something else that will let me fly."
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
		if name == "pillow" and other == "girl":
			$pillow.hide()
			$feathers.reveal()
			$Sprite/Speech.text = $feathers.material_desc
		elif (name == "scissors" and other == "cardboard_box") or (name == "cardboard_box" and other == "scissors"):
			$Sprite/Speech.text = $cardboard_wings.material_desc
			$scissors.hide()
			$cardboard_box.hide()
			$cardboard_wings.position = $cardboard_box.position
			$cardboard_wings.reveal()
		elif (name == "needle" and other == "thread") or (name == "thread" and other == "needle"):
			$Sprite/Speech.text = $threaded_needle.material_desc
			$needle.hide()
			$thread.hide()
			$threaded_needle.position = $thread.position
			$threaded_needle.reveal()
		elif (name == "cardboard_wings" and other == "feathers") or (name == "feathers" and other == "cardboard_wings"):
			$Sprite/Speech.text = $feathered_wings.material_desc
			$cardboard_wings.hide()
			$feathers.hide()
			$feathered_wings.position = $cardboard_wings.position
			$feathered_wings.reveal()
		elif (name == "cardboard_wings" and other == "twine") or (name == "twine" and other == "cardboard_wings"):
			$Sprite/Speech.text = $strapped_wings.material_desc
			$cardboard_wings.hide()
			$twine.hide()
			$strapped_wings.position = $cardboard_wings.position
			$strapped_wings.reveal()
		elif (name == "feathered_wings" and other == "twine") or (other == "feathered_wings" and name == "twine"):
			$Sprite/Speech.text = $wings.material_desc
			$feathered_wings.hide()
			$twine.hide()
			$wings.position = $feathered_wings.position
			$wings.reveal()
			$wings.freeze()
			state = LEVEL_WON
			$Timer.start(TEXT_TIME)
			$Sophia.make_animation()
		elif (name == "strapped_wings" and other == "feathers") or (other == "strapped_wings" and name == "feathers"):
			$Sprite/Speech.text = $wings.material_desc
			$strapped_wings.hide()
			$feathers.hide()
			$wings.position = $strapped_wings.position
			$wings.reveal()
			$wings.freeze()
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
				$Sprite/Speech.text = "Of course! Birds!"
				$Timer.start(TEXT_TIME)
			TXT2:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "I should make myself a set of wings."
				$Timer.start(TEXT_TIME)
			TXT3:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "I guess it's time to wing it!"
				$Timer.start(TEXT_TIME)
			TXT4:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "..."
				$Timer.start(TEXT_TIME)
			TXT5:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "That didn't work at all... At least they look pretty cool!"
				$Timer.start(TEXT_TIME)
			END_LEVEL:
				$MusicPlayer.stream_paused = true
				$EndTune.play()
				$Sophia.z_index = 0
				$wings.z_index = 10
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
	get_tree().change_scene("res://scenes/rooms/BalloonRoom.tscn")
