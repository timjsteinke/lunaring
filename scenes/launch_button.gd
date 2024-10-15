extends Button

var launch_line
var show_launch_line
var astronaut


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#pass # Replace with function body.
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
		
		# Limit launching to forward and up
		if (current_mouse_local.x < -75):
			current_mouse_local.x = -75
		if (current_mouse_local.x > -12):
			current_mouse_local.x = -12
		if (current_mouse_local.y > 67):
			current_mouse_local.y = 67
		if (current_mouse_local.y < 4):
			current_mouse_local.y = 4
		
		launch_line.add_point(current_mouse_local)

		if Input.is_action_just_released("ClickMouse"):
			show_launch_line = false
			
			var launch_x = 3* launch_line.get_point_position(1).x + 12
			var launch_y = 3* launch_line.get_point_position(1).y - 4
			
			astronaut.position.y = astronaut.position.y - 5
			astronaut.launching = true
			astronaut.velocity.y = launch_y * - 1
			astronaut.velocity.x = launch_x * - 1
			
			launch_line.remove_point(1)
			launch_line.remove_point(0)

func _on_pressed() -> void:
	if Input.is_action_just_pressed("ClickMouse"):
		show_launch_line = true
		#print("CLICKED")
