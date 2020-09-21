extends AnimatedSprite

const TEXT_SPEED = 10
enum {A, B, C, D, E, F, G, H}
var state = A

func _ready():
	$Label.percent_visible = 0
	$Label2.percent_visible = 0
	$Label3.percent_visible = 0
	$Label4.percent_visible = 0
	$Label5.percent_visible = 0
	$Timer.start(5)

func _process(delta):
	if state == B:
		$Label3.percent_visible += 0.3 * delta
		$Label4.percent_visible += 0.3 * delta
		if $Label3.percent_visible >= 1 and $Label4.percent_visible >= 1:
			state = C
			$Timer.start(0.5)
	elif state == D:
		$Label.percent_visible += 0.3 * delta
		$Label2.percent_visible += 0.3 * delta
		if $Label.percent_visible >= 1 and $Label2.percent_visible >= 1:
			state = E
			$Timer.start(0.5)
	elif state == F:
		$Label5.percent_visible += 0.3 * delta
		if $Label5.percent_visible >= 1:
			state = G
			$Timer.start(1)
	elif state == H and Input.is_action_pressed("escape"):
		get_tree().quit()
	elif Input.is_action_pressed("escape"):
		$Label.percent_visible = 1
		$Label2.percent_visible = 1
		$Label3.percent_visible = 1
		$Label4.percent_visible = 1
		$Label5.percent_visible = 1
		state = H

func _on_Timer_timeout():
	match state:
		A:
			state = B
		C:
			state = D
		E:
			state = F
		G:
			state = H
