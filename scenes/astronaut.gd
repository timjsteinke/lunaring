extends CharacterBody2D

class_name Astronaut

const GRAVITY : int = 100
const SPEED = 50.0
const THRUST_VELOCITY = -50.0
const FUEL_COST = .25
const MAX_FUEL = 100

@export var fuel = MAX_FUEL # Makes this variable public 

signal fuelChanged

var vertical_speed_ui
var astro_cam

var alive
var dead_reason
var reasons = ["Try not flying into the ground so fast!", "Didn't you see the space debris?"]
var last_vertical_speed
var second_to_last_vertical_speed
var camera_zoom

var launching

func start(pos):
	position = pos
	alive = true
	fuel = MAX_FUEL

func _ready():
	fuel_ui = get_node("%FuelUI") # Initialize fuel UI text node pointer
	vertical_speed_ui = get_node("%VerticalSpeedUI") # Initialize vertical speed UI text node pointer
	astro_cam = get_node("%AstroCam") # Initialize astrocam pointer
	alive = true
	last_vertical_speed = 0
	second_to_last_vertical_speed = 0
	camera_zoom = 3
	launching = true
	dead_reason = 0

func useFuel():	
	fuel -= FUEL_COST	
	fuelChanged.emit(fuel)
	
	
func _physics_process(delta: float) -> void:
	
	if (alive):
		second_to_last_vertical_speed = last_vertical_speed
		last_vertical_speed = velocity.y * -1 / 4
		velocity.y += GRAVITY * delta # Add the gravity.
	
	#print ("velocity_y: " + str(velocity.y) + ", last_v_speed: " + str(last_vertical_speed))
		
		camera_zoom = (abs(position.y) / 452) * 3
		if camera_zoom < 1:
			camera_zoom = 1
		elif camera_zoom > 3:
			camera_zoom = 3
		astro_cam.zoom.x = camera_zoom
		astro_cam.zoom.y = camera_zoom
		
		#print ("current_zoom: " + str(camera_zoom))
	
	if (second_to_last_vertical_speed <= -30):
		#vertical_speed_ui.text = "V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH - !!!WARNING!!!"
		vertical_speed_ui.bbcode_text = "[color=#ff0000]V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH[/color]"
		
		#vertical_speed_ui.pop()
		if (is_on_floor()):
			print ("Is on Floor")
			alive = false
			died(0)
			fuel = 0
			fuelChanged.emit()
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
				#TODO: Perhaps consider lerping the velocity so we get some resistance to momentum before thrusting up
				velocity.y = THRUST_VELOCITY
				$AnimatedSprite2D.play("boosting")
				$GPUParticles2D.emitting = true
				useFuel()
			if fuel <= 0:
				$GPUParticles2D.emitting = false
				$AnimatedSprite2D.play("idle")
		else:
			$GPUParticles2D.emitting = false
			$AnimatedSprite2D.play("idle")
			
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		
		print ("Direction:" + str(direction))
		
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
				print("123")
				velocity.x = direction * SPEED
			#else:
			#	velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			if(launching):
				launching = false
			else:
				velocity.x = 0
		
						
		move_and_slide()
		



	# useful other commands may need
	# is_action_just_pressed (handles only first occurence of press of key)
	# is_on_floor()	
	# .position.x    ,    global_position.x

func died(reason):
	#This function handles the player dieing
	pass
	#$HUD/DeadLabel.text = "You died. " + reasons[dead_reason]
	#$DeadLabel.Show()
	#$HUD/RetryButton.Show()
	

func _on_pink_crystal_body_entered(body):
	#This function handles the player entering the pink crystal
	if is_on_floor() && alive:
		print ("Player has landed on the Pink Crystal")
		
