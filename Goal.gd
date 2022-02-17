extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal collected()
func _on_Area2D_body_entered(body):
	emit_signal("collected")
	hide()
	 # Replace with function body.
	
	
func getInfo():
	return {
		"xPos":position.x,
		"yPos":position.y
	}
	
func setInfo(data):
	position.x = data.xPos
	position.y = data.yPos
