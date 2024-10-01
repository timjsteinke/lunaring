extends CharacterBody2D

const GRAVITY : int = 100
const SPEED = 50.0
const THRUST_VELOCITY = -50.0
const FUEL_COST = .25

@export var fuel = 100 # Makes this variable public 
var fuel_ui
var vertical_speed_ui
var alive
var last_vertical_speed
var second_to_last_vertical_speed

func start(pos):
	position = pos
	alive = true
	fuel = 100

func _ready():
	fuel_ui = get_node("%FuelUI") # Initialize fuel UI text node pointer
	vertical_speed_ui = get_node("%VerticalSpeedUI") # Initialize fuel UI text node pointer
	alive = false
	last_vertical_speed = 0
	second_to_last_vertical_speed = 0

	
func _physics_process(delta: float) -> void:
	
	
	if (alive):
		second_to_last_vertical_speed = last_vertical_speed
		last_vertical_speed = velocity.y * -1 / 4
		velocity.y += GRAVITY * delta # Add the gravity.
	
	#print ("velocity_y: " + str(velocity.y) + ", last_v_speed: " + str(last_vertical_speed))
		
	if (second_to_last_vertical_speed <= -30):
		#vertical_speed_ui.text = "V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH - !!!WARNING!!!"
		vertical_speed_ui.bbcode_text = "[color=#ff0000]V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH[/color]"
		
		vertical_speed_ui.pop()
		if (is_on_floor()):
			print ("Is on Floor")
			alive = false
			fuel = 0
			velocity.y = 0
			$AnimatedSprite2D.play("death")
	elif (second_to_last_vertical_speed <= -15):
		vertical_speed_ui.bbcode_text = "[color=#ffff00]V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH[/color]"
	else:
		vertical_speed_ui.bbcode_text = "[color=#ffffff]V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH[/color]"
			
	if (alive):
		# Handle Thrusters
		if Input.is_action_pressed("Jetpack_and_Start"): 
			if fuel > 0:
				velocity.y = THRUST_VELOCITY
				$AnimatedSprite2D.play("boosting")
				fuel -= FUEL_COST
				fuel_ui.text = "FUEL: " + str("%.2f" % fuel) + "%" # Format fuel to decimal places
			if fuel <= 0:
				$AnimatedSprite2D.play("idle")
			
		else:
			$AnimatedSprite2D.play("idle")
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		
		
		# Flip sprite based on current flip and key presses
		# May be able to clean this up later
		var flip_h = $AnimatedSprite2D.flip_h
		if (direction == 1 && flip_h == false):
			$AnimatedSprite2D.flip_h = false
		elif (direction == 1 && flip_h == true):
			$AnimatedSprite2D.flip_h = false
		elif (direction == -1 && flip_h == false):
			$AnimatedSprite2D.flip_h = true
		elif (direction == -1 && flip_h == true):
			$AnimatedSprite2D.flip_h = true
		
		if not is_on_floor():
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = 0
					
		move_and_slide()
		
		
		
	


	# useful other commands may need
	# is_action_just_pressed (handles only first occurence of press of key)
	# is_on_floor()	

func _on_pink_crystal_body_entered(body):
	#This function handles the player entering the pink crystal
	if is_on_floor() && alive:
		print ("Player has landed on the Pink Crystal")
		
