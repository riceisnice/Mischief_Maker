extends Sprite

signal pressed

func _ready():
	self_modulate = Color(1,1,1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("pressed")


func set_button_disabled(dis):
	$Button.disabled = dis

func get_button_disabled():
	return $Button.disabled
