extends ProgressBar

@export var astronaut: Astronaut

func update(fuel):	
	await get_tree().process_frame
	value = fuel	

func _ready():
	astronaut.fuelChanged.connect(update)
	update(astronaut.max_fuel)
