extends ProgressBar

@export var astronaut: Astronaut

func update(fuel):
	# TODO: Fix this - it is getting the correct fuel #, but the progress bar is only updating every 25% or so
	await get_tree().process_frame
	value = fuel
	print ("Val Fuel:" + str(value))

func _ready():
	astronaut.fuelChanged.connect(update)
	update(100)
