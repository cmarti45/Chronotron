extends KinematicBody2D
export var startHeight = 0
var height: int = 64
const SPEED = 2.0
var array = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	height *= startHeight
	if height > 0:
		translate(Vector2(0,-height))
		$background.translate(Vector2(0,height/4))
		for i in startHeight:
			array.append(preload("res://PlatformPost.tscn").instance())
			$posts.add_child(array.back())
			array.back().translate(Vector2(0,(i) * 16))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		translate(Vector2(0,-SPEED))
		$background.translate(Vector2(0,SPEED/4))
		height += SPEED
		updateHeight()
	elif Input.is_action_pressed("ui_down") and height > 0:
		translate(Vector2(0,SPEED))
		$background.translate(Vector2(0,-SPEED/4))
		height -= SPEED
		updateHeight()
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
	$posts.remove_child(array.back())
	array.pop_back()
