extends Button

var launch_line
var show_launch_line
var astronaut

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
	#print ("button ready")
	launch_line = get_node("%LaunchLine")
	astronaut = get_node("%Astronaut")
	
	#launch_line.add_point(Vector2(196,260), 0)
	show_launch_line = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (show_launch_line):
		launch_line.remove_point(1)
		launch_line.remove_point(0)
		launch_line.add_point(Vector2(-12,4))
		var current_mouse_local = get_local_mouse_position()
		current_mouse_local.x -= 30
		current_mouse_local.y += 20
		launch_line.add_point(current_mouse_local)

		
	if Input.is_action_just_released("ClickMouse"):
		print("released")
		print(get_viewport().get_mouse_position())
		show_launch_line = false
		
		var launch_x = 5* launch_line.get_point_position(1).x + 12
		var launch_y = 5* launch_line.get_point_position(1).y - 4
		#print ("launchx: " + str(launch_x) + ", launchy: " + str(launch_y))
		
		astronaut.position.y = astronaut.position.y - 5
		astronaut.launching = true
		astronaut.velocity.y = launch_y * - 1
		astronaut.velocity.x = launch_x * - 1
		
		launch_line.remove_point(1)
		launch_line.remove_point(0)
		


func _on_pressed() -> void:
	if Input.is_action_just_pressed("ClickMouse"):
		print("pressed")
		print(get_viewport().get_mouse_position())
		show_launch_line = true
		#launch_line.add_point(get_viewport().get_mouse_position(), 1)
	
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
	#	print("pressed")
	#if Input.is_mouse_button_released(MOUSE_BUTTON_LEFT):
	#	print("released")
	#	#pass # Replace with function body.
