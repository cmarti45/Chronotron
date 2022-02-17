extends Node2D

export var recChannel = 0
var falling = false
var bodies = []
var activated

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if falling and $MovingPart.position.y < 0:
		$MovingPart.translate(Vector2(0,3))
		if $MovingPart.position.y >= 0:
			emit_signal("wireless", recChannel, true)
			activated = false
	elif !falling and $MovingPart.position.y > -32:
		if !activated:
			emit_signal("wireless", recChannel, false)
			activated = true
		$MovingPart.translate(Vector2(0,-3))
	

signal wireless(channel,value)

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		falling = true
		if !(body in bodies):
			bodies.append(body)

func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		for i in range (0, bodies.size()):
			if bodies[i] == body:
				bodies.remove(i)
				break
	if bodies.size() <= 0:
		falling = false
		
func getInfo():
	return {
		"recChannel":recChannel,
		"xPos":position.x,
		"yPos":position.y
	}
	
func setInfo(data):
	recChannel = data.recChannel
	position.x = data.xPos
	position.y = data.yPos
	
