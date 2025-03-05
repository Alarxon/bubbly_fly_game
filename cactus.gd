extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if( (body.name == "Bubble" || body.name == "Tail1" || body.name == "Tail2"
		|| body.name == "Tail3" || body.name == "Tail4") && monitorable):
		Global.childrenPlayer = Global.childrenPlayer - 1
	if(Global.childrenPlayer < 0):
		Global.deathSound.play()
		Global.gameOver = true
	monitorable = false
