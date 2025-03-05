extends CharacterBody3D


var SPEED = 5.0
var JUMP_VELOCITY = 2.8
var GRAVITY = 9


func _process(delta: float) -> void:
	#GJumping and gravity
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		#$JumpAudio.pitch_scale = randf_range(0.9, 1.1)
		$JumpAudio.play()
	else:
		velocity.y -= GRAVITY * delta
	
	rotate_y(deg_to_rad(2))			
	
	move_and_slide()


func _on_fall_zone_body_entered(body: Node3D) -> void:
	Global.gameOver = true

func reset_scene():
	get_tree().change_scene_to_file("res://level.tscn")
