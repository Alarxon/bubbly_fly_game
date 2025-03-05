extends CanvasLayer

var time_start = 0
var time_now = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_start = Time.get_ticks_msec()
	$Button.pressed.connect(self._button_pressed)

func _button_pressed():
	get_tree().quit()
	
var save_path = "user://score.save"

func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Global.localScore)

var highscore = 0 

func load_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		highscore = file.get_var()
	else:
		print("file not found")
		highscore = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = true
		 
	if (Global.gameOver):
		if(Global.deathPlaySound == false):
			Global.deathSound.play()
			Global.deathPlaySound  = true
			load_score()
			if(Global.localScore > highscore):
				save_score()
		$Label.text = "GAME OVER"
		$Label.position = Vector2(310, 100)
		$Label2.text = "Press SPACE to restart"
		if Input.is_action_just_pressed("jump"):
			Global.deathPlaySound  = false
			Global.gameOver = false
			Global.justPaused = false
			visible = false
			get_tree().paused = false
			call_deferred("reset_scene")
	else:
		if(Global.justPaused):
			Global.justPaused = false
			time_start = Time.get_ticks_msec()
		time_now = Time.get_ticks_msec()
		var time_elapsed = time_now - time_start
		#print(time_elapsed)

		if Input.is_action_just_pressed("jump") && time_elapsed >= 500:
			Global.pause = time_elapsed
			time_start = Time.get_ticks_msec()
			Global.justUnpaused = true
			get_tree().paused = false
			
func reset_scene():
	get_tree().change_scene_to_file("res://level.tscn")
