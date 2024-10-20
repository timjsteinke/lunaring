extends Button

var astronaut


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astronaut = get_node("%Astronaut")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	print("CLICKED RETRY1")
	if Input.is_action_just_pressed("ClickMouse"):
		astronaut.retry()
		print("CLICKED RETRY2")
		
