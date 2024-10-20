extends ProgressBar

@export var astronaut: Astronaut

func update(health):	
	await get_tree().process_frame
	value = health

func _ready():
	astronaut.healthChanged.connect(update)
	update(astronaut.health)
