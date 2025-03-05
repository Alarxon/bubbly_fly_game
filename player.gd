extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 2
var GRAVITY = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#GJumping and gravity
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		$JumpAudio.pitch_scale = randf_range(0.9, 1.1)
		$JumpAudio.play()
	else:
		velocity.y -= GRAVITY * delta
				
	move_and_slide()


func _on_fall_zone_body_entered(body: Node3D) -> void:
	Global.gameOver = true
	#call_deferred("reset_scene")

func reset_scene():
	get_tree().change_scene_to_file("res://level.tscn")
