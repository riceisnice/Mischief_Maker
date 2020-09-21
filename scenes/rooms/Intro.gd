extends Panel


enum {A, B, C, D, E, F}
var state = A

func _ready():
	$Timer.start(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	match state:
		A:
			$CenterContainer/VBoxContainer/Label2.text = "who dreamed of flying..."
			$Timer.start(4)
			state = B
		B:
			$CenterContainer/VBoxContainer/Label1.text = ""
			$CenterContainer/VBoxContainer/Label2.text = ""
			$Timer.start(1)
			state = C
		C:
			$CenterContainer/VBoxContainer/Label1.text = "Until the day she decided"
			$Timer.start(4)
			state = D
		D:
			$CenterContainer/VBoxContainer/Label2.text = "to make her dreams a reality..."
			$Timer.start(4)
			state = E
		E:
			$CenterContainer/VBoxContainer/Label1.text = ""
			$CenterContainer/VBoxContainer/Label2.text = ""
			$Timer.start(1)
			state = F
		F:
			get_tree().change_scene("res://scenes/rooms/Room1.tscn")
