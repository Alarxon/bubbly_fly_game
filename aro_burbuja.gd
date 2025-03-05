extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if($Bubble1.get_playback_position() >= 1):
	#	$Bubble1.stop()
	#if($Bubble2.get_playback_position() >= 1):
	#	$Bubble2.stop()
	#if($Bubble3.get_playback_position() >= 1):
	#	$Bubble3.stop()
	

func _on_body_entered(body: Node3D) -> void:
	if(body.name == "Bubble"):
		Global.childrenPlayer = Global.childrenPlayer + 1
		var playN = randi_range(1, 3)
		if(playN == 1):
			$Bubble1.play()
		elif(playN == 2):
			$Bubble2.play()
		elif(playN == 3):
			$Bubble3.play()
		position = Vector3(-10,0, 0)
