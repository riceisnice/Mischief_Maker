extends Area2D

signal clicked(name)
signal released(name)

export(String) var material_name
export(String) var material_desc

var can_grab = false
var grabbed_offset = Vector2()
var grabbing = false
var hidden = false
var destroying = false

var overlapping = []

func _ready():
	$Sprite.visible = false
	$AnimatedSprite.visible = false
	monitorable = false
	monitoring = false
	hidden = true
	#reveal()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and not hidden:
		can_grab = event.pressed
		grabbed_offset = position - (get_global_mouse_position() / 2)
		var empty = true
		for n in get_tree().get_nodes_in_group("material"):
			if n.grabbing == true:
				empty = false
		if event.button_index == BUTTON_LEFT and event.pressed and empty: #pressed
			emit_signal("clicked", material_name)
			grabbing = true
		if grabbing and event.button_index == BUTTON_LEFT and !event.pressed: #released
			grabbing = false
			emit_signal("released", material_name)
			#print(overlapping)

func _process(_delta):
	var BACK = 155.5
	var FRONT = 284.5
	var sc
	var rel
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab and grabbing:
		position = (get_global_mouse_position() / 2) + grabbed_offset
	if position.y > BACK:
		rel = (position.y - BACK) / (FRONT - BACK)
		sc = 0.75 + (0.5 * rel)
	else:
		rel = 0
		sc = 0.75
	scale = Vector2(sc, sc)
	z_index = rel * 10

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.visible = false
	if not destroying:
		$Sprite.visible = true
		self.input_pickable = true
	else:
		hide()

func reveal():
	$AnimatedSprite.visible = true
	$AnimatedSprite.play()
	$AnimatedSprite/AudioStreamPlayer.play()
	monitorable = true
	monitoring = true
	hidden = false
	destroying = false

func freeze():
	input_pickable = false
	monitoring = false
	monitorable = false
	hidden = true

func hide():
	self.input_pickable = false
	self.visible = false
	monitoring = false
	monitorable = false
	hidden = true

func destroy():
	$AnimatedSprite.visible = true
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
	$AnimatedSprite/AudioStreamPlayer.play()
	destroying = true

func _on_Material_area_entered(area):
	overlapping.append(area)


func _on_Material_area_exited(area):
	overlapping.remove(overlapping.find(area))
