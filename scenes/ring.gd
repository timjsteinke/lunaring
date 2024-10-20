extends Area2D

var activated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	activated = false
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!activated):
		$AnimatedSprite2D.play("idle")

func activate():
	if (!activated):
		$AnimatedSprite2D.play("player_activated")
		activated = true
		print("ACTIVATED")
	
