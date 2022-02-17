extends Node2D
export var recChannel = 0
export var initHeight = 0
export var targetHeight = 0
var startHeight = 0
const POSTHEIGHT = 192
var height: int = POSTHEIGHT
const SPEED = 3.0
var array = []
var bodies
var activated = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func connectMe(buttons):
	for button in buttons:
		button.connect("wireless", self, "wireless_signal")
		
func ready():
	startHeight = initHeight
	#for buttons in get_parent().get_parent().get_child(1).get_children():
	#	buttons.connect("wireless", self, "wireless_signal")
	height *= startHeight
	if height > 0:
		$MovingPart.translate(Vector2(-height, 0))
		$posts.translate(Vector2(-height, 0))
		for i in startHeight:
			array.append(preload("res://PlatformTop.tscn").instance())
			$posts.add_child(array.back())
			array.back().translate(Vector2((i) * 48, 0))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	
	#bodies = $MovingPart/Area2D.get_overlapping_bodies()
	if initHeight < targetHeight:
		if activated and height < targetHeight * POSTHEIGHT:#Input.is_action_pressed("ui_up"):
			$MovingPart.translate(Vector2(-SPEED, 0))
			#for body in bodies:
			#	if body is KinematicBody2D: 
			#		body.move_and_collide(Vector2(-SPEED, 0))
			$posts.translate(Vector2(-SPEED, 0)) 
			height += SPEED
			updateHeight()
		elif !activated and height > initHeight * POSTHEIGHT:
			$MovingPart.translate(Vector2(SPEED, 0)) 
			#for body in bodies:
			#	if body is KinematicBody2D: 
			#		body.move_and_collide(Vector2(SPEED, 0))
			$posts.translate(Vector2(SPEED, 0)) 
			height -= SPEED
			updateHeight()
	else:
		if !activated and height < initHeight * POSTHEIGHT:
			$MovingPart.translate(Vector2(-SPEED, 0))
			#for body in bodies:
			#	if body is KinematicBody2D: 
			#		body.move_and_collide(Vector2(-SPEED, 0))
			$posts.translate(Vector2(-SPEED, 0)) 
			height += SPEED
			updateHeight()
		elif activated and height > targetHeight * POSTHEIGHT:
			$MovingPart.translate(Vector2(SPEED, 0)) 
			#for body in bodies:
			#	if body is KinematicBody2D: 
			#		body.move_and_collide(Vector2(SPEED, 0))
			$posts.translate(Vector2(SPEED, 0)) 
			height -= SPEED
			updateHeight()
		
func updateHeight():
	if height / POSTHEIGHT > array.size()-1 && height != POSTHEIGHT * targetHeight:
		cloneDown()
	elif height / POSTHEIGHT < array.size()-1:
		cloneUp()
	elif height == 0:
		cloneUp()

func wireless_signal(channel, value):
	if recChannel == channel:
		activated = value

func cloneDown():
	array.append(preload("res://PlatformTop.tscn").instance())
	$posts.add_child(array.back())
	array.back().translate(Vector2((array.size() -1) * 48, 0))
	
func cloneUp():
	if array.size() != 0:
		$posts.remove_child(array.back())
		array.pop_back()
		
func getInfo():
	return {
		"direction":"horizontal",
		"recChannel":recChannel,
		"initHeight":initHeight,
		"targetHeight":targetHeight,
		"xPos":position.x,
		"yPos":position.y
	}
func setInfo(data):
	recChannel = data.recChannel
	initHeight = data.initHeight
	targetHeight = data.targetHeight
	position.x = data.xPos
	position.y = data.yPos
	ready()
	

