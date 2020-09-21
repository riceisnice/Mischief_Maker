extends Sprite

const TEXT_TIME = 2

enum {READY, TXT1, TXT2, TXT3, SPAWN_MATS, GAMELOOP, LEVEL_WON, TXT4, END_LEVEL}

var state
var prepared_mats

func _ready():
	state = READY
	$Sprite/Speech.text = "What can I make that will let me fly?"
	$Timer.start(TEXT_TIME)
	state = TXT3
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
		if name == "toy_car" and other == "girl":
			$wheels.reveal()
			$Sprite/Speech.text = $wheels.material_desc
			$toy_car.hide()
		elif (name == "wheels" and other == "clothespin") or (name == "clothespin" and other == "wheels"):
			$Sprite/Speech.text = $pin_wheels.material_desc
			$wheels.hide()
			$clothespin.hide()
			$pin_wheels.position = $clothespin.position
			$pin_wheels.reveal()
		elif (name == "popsicle_sticks" and other == "clothespin") or (name == "clothespin" and other == "popsicle_sticks"):
			$Sprite/Speech.text = $pin_wings.material_desc
			$popsicle_sticks.hide()
			$clothespin.hide()
			$pin_wings.position = $clothespin.position
			$pin_wings.reveal()
		elif (name == "popsicle_sticks" and other == "pin_wheels") or (name == "pin_wheels" and other == "popsicle_sticks"):
			$Sprite/Speech.text = $plane.material_desc
			$popsicle_sticks.hide()
			$pin_wheels.hide()
			$plane.position = $pin_wheels.position
			$plane.reveal()
			$plane.freeze()
			state = LEVEL_WON
			$Timer.start(TEXT_TIME)
			$Sophia.make_animation()
		elif (name == "wheels" and other == "pin_wings") or (name == "pin_wings" and other == "wheels"):
			$Sprite/Speech.text = $plane.material_desc
			$wheels.hide()
			$pin_wings.hide()
			$plane.position = $pin_wings.position
			$plane.reveal()
			$plane.freeze()
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
		$Sprite/Speech.text= "Click a part to learn more about it."
		state = GAMELOOP

func _input(event):
	if event is InputEventMouseButton:
		match state:
			TXT1:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "Maybe an airplane?"
				$Timer.start(TEXT_TIME)
			TXT2:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "Yeah, I'll make an airplane."
				$Timer.start(TEXT_TIME)
			TXT3:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "First I need to gather some parts!"
				$Timer.start(TEXT_TIME)
			TXT4:
				$Sprite/Next.visible = false
				$Sprite/Speech.text = "I guess this is too small though. Oh well, back to the drawing board!"
				$Timer.start(TEXT_TIME)
			END_LEVEL:
				print ("level is over. move to next")

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
			state = END_LEVEL
			$Sprite/Next.visible = true
