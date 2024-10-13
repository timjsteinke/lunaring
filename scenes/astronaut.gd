extends CharacterBody2D

class_name Astronaut

var gravity : int = 100
var SPEED = 1.0
var thrust_velocity = -3.0
var fuel_cost = .25
var max_fuel = 100
@export var is_on_platform = true

@export var fuel = max_fuel # Makes this variable readable to the ui 

signal fuelChanged(current_fuel)

var fuel_ui
var vertical_speed_ui
var astro_cam
var player_stats_ui

var alive
var dead_reason
var reasons = ["Try not flying into the ground so fast!", "Didn't you see the space debris?"]
var last_vertical_speed
var second_to_last_vertical_speed
var camera_zoom

var astronaut_max_inventory
var quantity_pink_crystal_left
var astronaut_quantity_pink_crystal
var quantity_blue_crystal_left
var astronaut_quantity_blue_crystal
var quantity_green_crystal_left
var astronaut_quantity_green_crystal

var launching

func start(pos):
	position = pos
	alive = true
	fuel = max_fuel

func _ready():
	print("astronaut ready")
	fuel_ui = get_node("%FuelUI") # Initialize fuel UI text node pointer
	vertical_speed_ui = get_node("%VerticalSpeedUI") # Initialize vertical speed UI text node pointer
	astro_cam = get_node("%AstroCam") # Initialize astrocam pointer
	player_stats_ui = get_node("%PlayerStats") # Initialize vertical speed UI text node pointer
	alive = true
	last_vertical_speed = 0
	second_to_last_vertical_speed = 0
	camera_zoom = 3
	launching = true
	dead_reason = 0
	
	astronaut_quantity_pink_crystal = 0
	astronaut_quantity_blue_crystal = 0
	astronaut_quantity_green_crystal = 0
	quantity_green_crystal_left = 0	
	quantity_pink_crystal_left = 5
	quantity_blue_crystal_left = 5
	quantity_green_crystal_left = 5
	update_stats()
	
func update_stats():
	var parent = get_parent()
	
	gravity = parent.game_data["settings"]["gravity"]
	astronaut_max_inventory = parent.game_data["settings"]["astronaut_max_inventory"]	
	astronaut_quantity_pink_crystal = parent.game_data["inventory"]["pink_crystals"]	
	astronaut_quantity_blue_crystal = parent.game_data["inventory"]["blue_crystals"]	
	astronaut_quantity_green_crystal = parent.game_data["inventory"]["green_crystals"]	
	fuel_cost = .25 - (parent.game_data["upgrades"]["fuel_efficiency_upgrade"] * .05)
	max_fuel = (parent.game_data["upgrades"]["fuel_capacity_upgrade"] * 25) + 100
	thrust_velocity = -3.0 - (parent.game_data["upgrades"]["thrust_upgrade"] * 25)
	
	print("astonaut stats updated:")
	print("test: " + str(parent.game_data["upgrades"]["fuel_capacity_upgrade"]))
	print("fuel_cost: ", str(fuel_cost))
	print("max_fuel: ", str(max_fuel))
	print("thrust velocity: ", str(thrust_velocity))

func useFuel():	
	fuel -= fuel_cost
	fuelChanged.emit(fuel)
	
func _physics_process(delta: float) -> void:
	
	if (alive):
		second_to_last_vertical_speed = last_vertical_speed
		last_vertical_speed = velocity.y * -1 / 4
		velocity.y += gravity * delta # Add the gravity.
	
	#print ("velocity_y: " + str(velocity.y) + ", last_v_speed: " + str(last_vertical_speed))
		
		camera_zoom = (abs(position.y) / 452) * 3
		if camera_zoom < 1:
			camera_zoom = 1
		elif camera_zoom > 3:
			camera_zoom = 3
		astro_cam.zoom.x = camera_zoom
		astro_cam.zoom.y = camera_zoom
		
		#print ("current_zoom: " + str(camera_zoom))
	
	if (second_to_last_vertical_speed <= -30 ):
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
				velocity.y = thrust_velocity + velocity.y
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
		
		#print ("Direction:" + str(direction))
		
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
				#print("123")
				velocity.x = direction * SPEED + velocity.x
			#else:
			#	velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			if(launching):
				launching = false
			else:
				velocity.x = 0
							
		move_and_slide()
		

func died(reason):
	#This function handles the player dieing
	pass
	#$HUD/DeadLabel.text = "You died. " + reasons[dead_reason]
	#$DeadLabel.Show()
	#$HUD/RetryButton.Show()
	
func updateStats():
	#This function handles updating the HUD with Player stats
	var LabelText = "[center][color=#989858]Inventory Capacity " + str(astronaut_max_inventory) + "\n \
	Thrust Power " + str(-1.0*thrust_velocity) + "[/color] \n \
	 [color=#ec2dca]Pink Crystals  " + str(astronaut_quantity_pink_crystal) + " [/color] \n\
	 [color=#01a7c0]Blue Crystals  " + str(astronaut_quantity_blue_crystal) + " [/color] \n\
	 [color=#00bf43]Green Crystals  " + str(astronaut_quantity_green_crystal) + " [/color][/center]"
	player_stats_ui.bbcode_text = LabelText
	

# Triggers when astronaut lands on pink crystal. Tries to harvest pink crystal, but checks conditions
func _on_pink_crystal_body_entered(body):
	#This function handles the player entering the pink crystal
	if is_on_floor() && alive:
		if quantity_pink_crystal_left > 0 && astronaut_max_inventory > (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal):
			print ("Player has landed and picked up " + str(astronaut_max_inventory) + " Pink Crystal(s)")
			astronaut_quantity_pink_crystal = astronaut_max_inventory
			updateStats()
		elif quantity_pink_crystal_left <= 0:
			print ("There are no Pink Crystals left")
		elif (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal) >= astronaut_max_inventory:
			print ("You have no space left to hold additional crystals. Try Selling some back at the shop.")

# useful other commands may need
	# is_action_just_pressed (handles only first occurence of press of key)
	# is_on_floor()	
	# .position.x    ,    global_position.x

# Triggers when astronaut lands on green crystal. Tries to harvest green crystal, but checks conditions
func _on_green_crystal_body_entered(body):
	if is_on_floor() && alive:
		if quantity_green_crystal_left > 0 && astronaut_max_inventory > (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal):
			print ("Player has landed and picked up " + str(astronaut_max_inventory) + " Green Crystal(s)")
			astronaut_quantity_green_crystal = astronaut_max_inventory
			updateStats()
		elif quantity_green_crystal_left <= 0:
			print ("There are no Green Crystals left")
		elif (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal) >= astronaut_max_inventory:
			print ("You have no space left to hold additional crystals. Try Selling some back at the shop.")
		

# Triggers when astronaut lands on blue crystal. Tries to harvest blue crystal, but checks conditions
func _on_blue_crystal_body_entered(body):
	if is_on_floor() && alive:
		if quantity_blue_crystal_left > 0 && astronaut_max_inventory > (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal):
			print ("Player has landed and picked up " + str(astronaut_max_inventory) + " Blue Crystal(s)")
			astronaut_quantity_blue_crystal = astronaut_max_inventory
			updateStats()
		elif quantity_blue_crystal_left <= 0:
			print ("There are no Blue Crystals left")
		elif (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal) >= astronaut_max_inventory:
			print ("You have no space left to hold additional crystals. Try Selling some back at the shop.")
		

func _on_platform_area_body_exited(body):
	is_on_platform = false
	
func _on_platform_area_body_entered(body):
	# When landing on the platform need to sell crystals and open shop
	if alive:
		is_on_platform = true
		if (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal) > 0:
			print("Sold crystals at the Shop. Time to buy")
			astronaut_quantity_pink_crystal = 0
			astronaut_quantity_blue_crystal = 0
			astronaut_quantity_green_crystal = 0
			fuel = max_fuel
			updateStats()
			fuelChanged.emit(fuel)	
