extends Area2D

var active = true
var astronaut
var scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astronaut = get_node("%Astronaut")
	if (active):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("deactivated")
	scene =  get_node("%Background").get_parent()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (active):
		$AnimatedSprite2D.play("idle")

func player_activate():
	if (active):
		$AnimatedSprite2D.play("player_activated")
		active = false
		print("ACTIVATED")
		astronaut.collect_ring(name)
		
func deactivate():
	active = false
	#scene.deactivate_crystal(name)
	$AnimatedSprite2D.play("deactivated")
	$CollisionShape2D.disabled = true
	print(name + " deactivated")
