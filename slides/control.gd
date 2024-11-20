extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Label.position = Vector2(50,300)
	#$Label.text = "code test"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var textplace = $Label.position
	if textplace.y > -1420:
		textplace.y = textplace.y - (100 * delta)
	else:
		textplace.y = 650
		
	$Label.set_position(textplace)
	
	pass
