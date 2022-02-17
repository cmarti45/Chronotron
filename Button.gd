extends KinematicBody2D

var falling = false
var bodies = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if falling and position.y < 0:
		translate(Vector2(0,3))
	elif !falling and position.y > -32:
		translate(Vector2(0,-3))


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		falling = true
		if !(body in bodies):
			bodies.append(body)

func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		print(bodies.size())
		for i in range (0, bodies.size()):
			print(i)
			if bodies[i] == body:
				bodies.remove(i)
				break
	if bodies.size() <= 0:
		falling = false
