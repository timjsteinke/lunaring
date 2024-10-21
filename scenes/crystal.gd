@tool

extends Area2D

@export_enum("Green", "Blue", "Pink") var crystal_color = "Green"

var astronaut
var scene
var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (active):
		$AnimatedSprite2D.play(crystal_color)
	astronaut = get_node("%Astronaut")
	scene =  get_node("%Background").get_parent() #get_tree().root.get_children(false)[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Astronaut"):
		astronaut.mine_crystal(self,crystal_color)

func deactivate():
	active = false
	scene.deactivate_crystal(name)
	$AnimatedSprite2D.play(crystal_color + " Mined")
	$CollisionShape2D.disabled = true
	print(name + " deactivated")
	

func finished_mining():
	deactivate()
