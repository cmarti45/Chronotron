extends AnimatedSprite
var times = []
var inputs = []
var clones = []
var cloneCount = 1
var activated = false
var LEVEL

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	LEVEL = self.get_parent().get_parent().get_parent()
	
func onLoad():
	$Clones.add_child(preload("res://Assets/Character/Steve.tscn").instance())
	
signal timeWarp()
func connectMe(item):
	item.connect("collected", self, "activate")
func _process(_delta):
	if Input.is_action_just_pressed("down"):
		if $Area2D.get_overlapping_bodies().size() > 0:
			LEVEL.softReset()
			emit_signal("timeWarp")
			play("openclose")
			clones.append(preload("res://Assets/Character/Steve.tscn").instance())
			$Clones.add_child(clones.back())
			$Clones.get_children()[cloneCount].setTimes($Clones/Steve.getTimes())
			$Clones.get_children()[cloneCount].setInputs($Clones/Steve.getInputs())
			$Clones.get_children()[cloneCount].translate(Vector2(0,64))
			$Clones.get_children()[cloneCount].deactivate()
			$Clones.get_children()[cloneCount].id = cloneCount
			
			cloneCount += 1
			for i in range (0, cloneCount):
				$Clones.get_children()[i].reset()
				$Clones.get_children()[i].position = Vector2(0,64)
				for copiesx in $Clones.get_children():
					$Clones.get_children()[i].add_collision_exception_with(copiesx)
func activate():
	$light.play("Green")
	activated = true
func deactivate():
	$light.play("Red")
	activated = false

func _on_goalbox_animation_finished():
	stop()
	
func getInfo():
	return {
		"xPos":position.x,
		"yPos":position.y
	}
	
func setInfo(data):
	position.x = data.xPos
	position.y = data.yPos
