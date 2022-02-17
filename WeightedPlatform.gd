extends Node2D
export var recChannel = 0
export var initHeight = 0
var targetHeight = 0
var startHeight = 0
var height: int = 64
const SPEED = 2.0
var array = []
var bodies
var activated = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	targetHeight = initHeight - getWeight()
	if targetHeight < 0: targetHeight = 0
	
	bodies = $MovingPart/Area2D.get_overlapping_bodies()
	if initHeight <= targetHeight:
		if height < targetHeight * 64:#Input.is_action_pressed("ui_up"):
			$MovingPart.translate(Vector2(0,-SPEED))
			for body in bodies:
				if body is KinematicBody2D: 
					body.move_and_collide(Vector2(0,-SPEED))
			$posts.translate(Vector2(0,-SPEED)) 
			height += SPEED
			updateHeight()
	else:
		if height >= targetHeight * 64:
			$MovingPart.translate(Vector2(0,SPEED)) 
			for body in bodies:
				if body is KinematicBody2D: 
					body.move_and_collide(Vector2(0,SPEED))
			$posts.translate(Vector2(0,SPEED)) 
			height -= SPEED
			updateHeight()

func getWeight():
	var weight = 0
	for body in $MovingPart/Area2D.get_overlapping_bodies():
		weight += 1
	return weight
	
func updateHeight():
	if height / 64 > array.size():
		cloneDown()
	elif height / 64 < array.size():
		cloneUp()
	elif height == 0:
		cloneUp()

func cloneDown():
	array.append(preload("res://PlatformPost.tscn").instance())
	$posts.add_child(array.back())
	array.back().translate(Vector2(0,(array.size() -1) * 16))
	
func cloneUp():
	if array.size() != 0:
		$posts.remove_child(array.back())
		array.pop_back()

func getInfo():
	return {
		"direction":"weighted",
		"initHeight":initHeight,
		"targetHeight":targetHeight,
		"xPos":position.x,
		"yPos":position.y
	}
func setInfo(data):
	initHeight = data.initHeight
	targetHeight = data.targetHeight
	position.x = data.xPos
	position.y = data.yPos
	ready()

func ready():
	startHeight = initHeight
	#for buttons in get_parent().get_parent().get_child(1).get_children():
	#	buttons.connect("wireless", self, "wireless_signal")
	height *= startHeight
	if height > 0:
		$MovingPart.translate(Vector2(0,-height))
		$posts.translate(Vector2(0,-height))
		for i in startHeight:
			array.append(preload("res://PlatformPost.tscn").instance())
			$posts.add_child(array.back())
			array.back().translate(Vector2(0,(i) * 16))
