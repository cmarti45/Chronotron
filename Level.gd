extends Node2D
export var levelNum = 0
var levelData = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$SceneLayer/Players/goalbox.connect("timeWarp", self, "softReset")
	saveLevel()
	clearLevel(true, true, true, true)
	loadLevel(true, true, true, true)
	pass # Replace with function body.

func saveLevel():
	for layers in get_children():
		if layers.get_name() == "SceneLayer":
			for nodes in layers.get_children():
				if nodes.get_name() == "Platforms":
					for platforms in nodes.get_children():
						levelData.append(
						{
							"type":"platform",
							"name":platforms.get_name(),
							"data":platforms.getInfo()
						})
				if nodes.get_name() == "Buttons":
					for buttons in nodes.get_children():
						levelData.append(
						{
							"type":"button",
							"name":buttons.get_name(),
							"data":buttons.getInfo()
						})
				if nodes.get_name() == "Players":
					for players in nodes.get_children():
						levelData.append(
						{
							"type":"player",
							"name":players.get_name(),
							"data":players.getInfo()
						})
				if nodes.get_name() == "Items":
					for items in nodes.get_children():
						levelData.append(
						{
							"type":"item",
							"name":items.get_name(),
							"data":items.getInfo()
						})
	for data in levelData:
		pass#print(data)
		
func clearLevel(clearPlatforms, clearButtons, clearPlayers, clearItems):
	for layers in get_children():
		if layers.get_name() == "SceneLayer":
			for nodes in layers.get_children():
				if nodes.get_name() == "Platforms" and clearPlatforms:
					for platforms in nodes.get_children():
						platforms.queue_free()
				if nodes.get_name() == "Buttons" and clearButtons:
					for buttons in nodes.get_children():
						buttons.queue_free()
				if nodes.get_name() == "Players" and clearPlayers:
					for players in nodes.get_children():
						players.queue_free()
				if nodes.get_name() == "Items" and clearItems:
					for items in nodes.get_children():
						items.queue_free()
	

func loadLevel(loadPlatforms, loadButtons, loadPlayers, loadItems):
	for levelElement in levelData:
		#print(levelElement)
		if levelElement.type == "platform" and loadPlatforms:
			if levelElement.data.direction == "vertical":
				$SceneLayer/Platforms.add_child(preload("res://MovingPlatform.tscn").instance())
				$SceneLayer/Platforms.get_children()[-1].setInfo(levelElement.data)
			elif levelElement.data.direction == "horizontal":
				$SceneLayer/Platforms.add_child(preload("res://HorizontalMovingPlatform.tscn").instance())
				$SceneLayer/Platforms.get_children()[-1].setInfo(levelElement.data)
			elif levelElement.data.direction == "weighted":
				$SceneLayer/Platforms.add_child(preload("res://WeightedPlatform.tscn").instance())
				$SceneLayer/Platforms.get_children()[-1].setInfo(levelElement.data)
		elif levelElement.type == "button" and loadButtons:
				$SceneLayer/Buttons.add_child(preload("res://PressurePlatform.tscn").instance())
				$SceneLayer/Buttons.get_children()[-1].setInfo(levelElement.data)
		elif levelElement.type == "player" and loadPlayers:
				print("loadedplayer")
				$SceneLayer/Players.add_child(preload("res://goalbox.tscn").instance())
				$SceneLayer/Players.get_children()[-1].setInfo(levelElement.data)
				$SceneLayer/Players.get_children()[-1].onLoad()
		elif levelElement.type == "item" and loadItems:
				$SceneLayer/Items.add_child(preload("res://Goal.tscn").instance())
				$SceneLayer/Items.get_children()[-1].setInfo(levelElement.data)
				
	#signals
	
	$SceneLayer/Players.get_children()[0].connectMe($SceneLayer/Items.get_children()[0])
	for platforms in $SceneLayer/Platforms.get_children():
		if platforms.getInfo().direction != "weighted":
			platforms.connectMe($SceneLayer/Buttons.get_children())
	for item in $SceneLayer/Items.get_children():
		$SceneLayer/Players.get_children()[0].connectMe(item)
	
func softReset():
	print("test")
	clearLevel(true, true, true, true)
	loadLevel(true, true, true, true)
