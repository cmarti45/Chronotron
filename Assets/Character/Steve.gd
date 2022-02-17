extends KinematicBody2D

var times = []
var currTimes = []
var inputs = []
var currInputs = []
var active = true
var time = 0
var velocity = Vector2(0,0)
var coins = 0
var id = 1

var actions = {
	"down": false,
	"jump": false,
	"left": false,
	"right": false
}

const SPEED = 300
const GRAVITY = 30
const JUMPFORCE = -800
const snap = Vector2.DOWN * 8


# warning-ignore:unused_argument
func _physics_process(delta):
	time += delta
	if active: 
		recordInput()
	else:
		playbackInput()
	controls()
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
func playbackInput():
	if currTimes.size() > 0 and currInputs.size() > 0:
		if time >= currTimes.front():
			if currInputs.front() == "down_down":
				actions.down = true
			if currInputs.front() == "down_up":
				actions.down = false
			if currInputs.front() == "jump_down":
				actions.jump = true
			if currInputs.front() == "jump_up":
				actions.jump = false
			if currInputs.front() == "left_down":
				actions.left = true
			if currInputs.front() == "left_up":
				actions.left = false
			if currInputs.front() == "right_down":
				actions.right = true
			if currInputs.front() == "right_up":
				actions.right = false
			currTimes.pop_front()
			currInputs.pop_front()
	else:
		actions.down = false
		actions.jump = false
		actions.left = false
		actions.right = false

func recordInput():
	if Input.is_action_just_pressed("left"):
		inputs.append("left_down")
		times.append(time)
		actions.left = true
	if Input.is_action_just_pressed("jump"):
		inputs.append("jump_down")
		times.append(time)
		actions.jump = true
	if Input.is_action_just_pressed("right"):
		inputs.append("right_down")
		times.append(time)
		actions.right = true
	if Input.is_action_just_pressed("down"):
		inputs.append("down_down")
		times.append(time)
		actions.down = true
	if Input.is_action_just_released("left"):
		inputs.append("left_up")
		times.append(time)
		actions.left = false
	if Input.is_action_just_released("jump"):
		inputs.append("jump_up")
		times.append(time)
		actions.jump = false
	if Input.is_action_just_released("right"):
		inputs.append("right_up")
		times.append(time)
		actions.right = false
	if Input.is_action_just_released("down"):
		inputs.append("down_up")
		times.append(time)
		actions.down = false
	
	
func controls():
	if is_on_ceiling():
		if is_on_floor():
			pass
		else:
			translate(Vector2(0,20))
	if actions.right:
		$Sprite.play("walk")
		$Sprite.flip_h = false
		velocity.x=SPEED
	elif actions.left:
		$Sprite.play("walk")
		$Sprite.flip_h = true
		velocity.x=-SPEED
	else:
		$Sprite.play("idle")
		velocity.x = lerp(velocity.x, 0, 0.2)
		
	velocity.y += GRAVITY
	if !is_on_floor():
		$Sprite.play("air")
	if actions.jump and is_on_floor():
		velocity.y = JUMPFORCE
	
	
func bounce():
	velocity.y = JUMPFORCE * 0.7
 
func ouch():
	self.hide()
	
func getInputs():
	return inputs + []
	
func getTimes():
	return times + []
	
func setInputs(var nInputs):
	inputs = nInputs
	currInputs = inputs + []
	
func setTimes(var nTimes):
	times = nTimes
	currTimes = times + []

func deactivate():
	active = false
	
func reset():
	if active:
		times = []
		inputs = []
	actions.down = false
	actions.jump = false
	actions.left = false
	actions.right = false
	currTimes = times + []
	currInputs = inputs + []
	time = 0
