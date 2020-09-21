extends Sprite

const TEXT_TIME = 2

enum {READY, TXT1, TXT2, TXT3, SPAWN_MATS, GAMELOOP, LEVEL_WON, TXT4, TXT5, END_LEVEL}

var state
var prepared_mats
var third = false

func _ready():
	state = READY
	$Sprite/Speech.text = "Alright, what else could work?"
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
		if name == "folded_umbrella" and other == "girl":
			$folded_umbrella.hide()
			$broken_umbrella.reveal()
			$Sprite/Speech.text = $broken_umbrella.material_desc
		elif name == "haystack" and other == "girl":
			$haystack.hide()
			$needle.reveal()
			$Sprite/Speech.text = $needle.material_desc
		elif (name == "scissors" and other == "fabric") or (name == "fabric" and other == "scissors"):
			$Sprite/Speech.text = $patch.material_desc
			$scissors.hide()
			$fabric.hide()
			$patch.position = $fabric.position
			$patch.reveal()
		elif (name == "needle" and other == "thread") or (name == "thread" and other == "needle"):
			$Sprite/Speech.text = $threaded_needle.material_desc
			$needle.hide()
			$thread.hide()
			$threaded_needle.position = $thread.position
			$threaded_needle.reveal()
		elif third and (name == "threaded_needle" or name == "patch" or name == "broken_umbrella") and (other == "threaded_needle" or other == "patch" or other == "broken_umbrella"):
			$Sprite/Speech.text = $patched_umbrella.material_desc
			$threaded_needle.hide()
			$patch.hide()
			$broken_umbrella.hide()
			$patched_umbrella.position = $broken_umbrella.position
			$patched_umbrella.reveal()
			$patched_umbrella.freeze()
			state = LEVEL_WON
			$Timer.start(TEXT_TIME)
			$Sophia.make_animation()
		elif (name == "threaded_needle" or name == "patch" or name == "broken_umbrella") and (other == "threaded_needle" or other == "patch" or other == "broken_umbrella"):
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
				$Sprite/Speech.text = "Maybe an umbrella?"
				$Timer.start(TEXT_TIME)
			TXT2:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "I remember mom complaining about her umbrella flying away..."
				$Timer.start(TEXT_TIME)
			TXT3:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "That'll cover it!"
				$Timer.start(TEXT_TIME)
			TXT4:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "..."
				$Timer.start(TEXT_TIME)
			TXT5:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "It didn't work! What a way to rain on my parade..."
				$Timer.start(TEXT_TIME)
			END_LEVEL:
				$MusicPlayer.stream_paused = true
				$EndTune.play()
				$Sophia.z_index = 0
				$patched_umbrella.z_index = 10
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

