extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Interactable1_pressed():
	print ("interactable1 pressed")
	$icon.visible = true
	$Interactable2.visible = true


func _on_Interactable2_pressed():
	print ("interactable2 pressed")
