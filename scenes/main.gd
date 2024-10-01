extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Jetpack_and_Start") && $HUD/StartButton.visible:
		_on_start_button_pressed()


func _on_start_button_pressed():
	$HUD/StartButton.hide()
	$Astronaut.start($StartPosition.position)
