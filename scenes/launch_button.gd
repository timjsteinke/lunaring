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
	
	#launch_line.clear_points()
	#launch_line.remove_point(1)
	#launch_line.remove_point(0)
	#print (launch_line.get_point_count()) 
	#print (launch_line.get_point_position(0))
	#print (launch_line.get_point_position(1))
	if (show_launch_line):
		launch_line.remove_point(1)
		launch_line.remove_point(0)
		launch_line.add_point(Vector2(0,0))
		
		#print (" local:" + str(launch_line.to_local(get_viewport().get_mouse_position())))
		#print ("global:" + str(get_viewport().get_mouse_position()))
		#var local_mouse_position = launch_line.to_local(get_viewport().get_mouse_position())
		#local_mouse_position.x -= 70
		#local_mouse_position.y += 223
		#print ("local2:" + str(launch_line.to_local(get_viewport().get_mouse_position())))
		
		
		
		#kinda working
		launch_line.add_point(Vector2(launch_line.to_local(get_viewport().get_mouse_position()).x - 120, launch_line.to_local(get_viewport().get_mouse_position()).y + 100))
		
		
		
		
		#var pos_global: Vector2 = get_viewport().get_mouse_position()
		#var global_to_line_local: Transform2D = launch_line.global_transform.affine_inverse()
		#var pos_line_local: Vector2 = global_to_line_local * pos_global
		#launch_line.add_point(pos_line_local)
		
		#not working
		#launch_line.add_point(launch_line.to_local(get_viewport().get_mouse_position()))
		#launch_line.add_point(get_viewport().get_mouse_position() - launch_line.get_parent().get_parent().global_position)
		
	if Input.is_action_just_released("ClickMouse"):
		print("released")
		print(get_viewport().get_mouse_position())
		show_launch_line = false
		
		var launch_x = launch_line.get_point_position(1).x
		var launch_y = launch_line.get_point_position(1).y
		print ("launchx: " + str(launch_x) + ", launchy: " + str(launch_y))
		#astronaut.velocity.x = launch_x
		#astronaut.velocity.y = launch_y
		astronaut.position.y = astronaut.position.y - 5
		
		#kinda working
		#astronaut.velocity = Vector2(3000, launch_y * -1)
		astronaut.launching = true
		astronaut.velocity.y = launch_y * - 1
		astronaut.velocity.x = launch_x * - 1
		
		#astronaut.move_and_slide()
		
		#launch_line.add_point(get_viewport().get_mouse_position(), 0)
		


#func _on_button_pressed():
	


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
