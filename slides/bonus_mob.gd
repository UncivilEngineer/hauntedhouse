extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bonus1.animation = "ShootingBonus"
	print("bonus initated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func kill_mobs( ):
	queue_free()
