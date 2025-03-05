extends CharacterBody3D


const JUMP_VELOCITY = 0.5
var GRAVITY = 10
var offsetGravity = 0.02

var time_start_gravity = 0
var time_now_gravity = 0

var is_active = false

func _process(delta: float) -> void:
	#GJumping and gravity
	if(is_active):
		var time_elapsed_gravity = time_now_gravity - time_start_gravity

			
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			offsetGravity = 0.02
			time_start_gravity = Time.get_ticks_msec()
		else:
			time_now_gravity  = Time.get_ticks_msec()
			velocity.y -= (GRAVITY * delta) - (offsetGravity if velocity.y < 0 else 0)
			if(time_elapsed_gravity >= 2500):
				offsetGravity = offsetGravity + 0.01
				time_start_gravity = Time.get_ticks_msec()
					
		move_and_slide()
