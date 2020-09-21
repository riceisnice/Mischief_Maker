extends Area2D


var material_name = "girl"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func make_animation():
	$AnimatedSprite.play("make")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "make":
		$AnimatedSprite.animation = "idle"
