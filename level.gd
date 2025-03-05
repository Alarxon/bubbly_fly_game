extends Node3D

const ARO_VELOCITY = 0.03
var CACTUS_VELOCITY = 0.05
const CUERVO_VELOCITY = 0.2
var BIRD_HEIGHT = 0.04
var ARO_HEIGHT = 0.02

var time_start_aros = 0
var time_now_aros = 0

var time_start_obstacle = 0
var time_now_obstacle = 0

var time_start_bird_1 = 0
var time_now_bird_1 = 0
var time_start_bird_2 = 0
var time_now_bird_2 = 0
var time_start_bird_3 = 0
var time_now_bird_3 = 0

var time_start_bird_start = 0
var time_now_bird_start = 0


var time_start_aro_height = 0
var time_now_aro_height = 0

var time_start_score = 0
var time_now_score = 0

var time_start_multi = 0
var time_now_multi = 0

var children = 0

var lastChildrenN = 0
var points = 0
var arrObstacles = []

var time_start_cactus_start = 0
var time_now_cactus_start = 0

var startEnding = false

var averageSize = 0
var timeCactus = 5000
var timeCuervo = 20000
var timeAroBurbuja = 5000

var typeCuervo = 0
var typeAro = 0

var save_path = "user://score.save"

func load_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		$HUD/Label3.text = str(file.get_var())
	else:
		print("file not found")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background.play()
	load_score()
	
	time_start_aros = Time.get_ticks_msec()
	time_start_obstacle = Time.get_ticks_msec()
	time_start_cactus_start = Time.get_ticks_msec()
	Global.childrenPlayer = 0
	$HUD/Label.text = "0"
	
	$Cactus_Grupo.position.y =  randf_range(-2, -6)
	$Cactus_Grupo2.position.y = randf_range(-2, -6)
	$Cactus_Grupo3.position.y = randf_range(-2, -6)

	startEnding = false

	averageSize = 0
	timeCactus = 5000
	timeCuervo = 20000
	
	time_start_bird_start = Time.get_ticks_msec()
	
	Global.deathSound	= $Bubble/Death
	#$Birds/Bird1.position.y = randf_range(2.5, 3)
	#$Birds/Bird2.position.y = randf_range(2.5, 3)
	#$Birds/Bird3.position.y = randf_range(2.5, 3)
	timeAroBurbuja = 100
	$AroBurbuja.position.y = 2
	$AroBurbuja.position.x = 5

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	  
	if Input.is_action_just_pressed("pause"):
		Global.justPaused = true
		get_tree().paused = true
	if Global.justPaused == false && Global.justUnpaused:
		$Pause.visible = false
		time_start_aros = time_start_aros + Global.pause
		time_start_obstacle = time_start_obstacle + Global.pause
		time_start_cactus_start = time_start_cactus_start + Global.pause
		time_start_bird_start = time_start_bird_start + Global.pause
		Global.justUnpaused = false
	if Global.gameOver:
		get_tree().paused = true
				
	if(Global.childrenPlayer < 0):
		Global.childrenPlayer = 0
			
	if(Global.childrenPlayer >= 4):
		typeAro = 1
	else:
		typeAro = 0
			
	time_now_obstacle = Time.get_ticks_msec()
	var time_elapsed_obstacle = time_now_obstacle - time_start_obstacle
	
	time_now_aros = Time.get_ticks_msec()
	var time_elapsed_aros = time_now_aros - time_start_aros
	
	time_now_bird_1 = Time.get_ticks_msec()
	var time_elapsed_bird_1 = time_now_bird_1 - time_start_bird_1
	time_now_bird_2 = Time.get_ticks_msec()
	var time_elapsed_bird_2 = time_now_bird_2 - time_start_bird_2
	time_now_bird_3 = Time.get_ticks_msec()
	var time_elapsed_bird_3 = time_now_bird_3 - time_start_bird_3
	
	
	
	time_now_bird_start = Time.get_ticks_msec()
	var time_elapsed_bird_start = time_now_bird_start - time_start_bird_start
	
	time_now_aro_height = Time.get_ticks_msec()
	var time_elapsed_aro_height = time_now_aro_height - time_start_aro_height
	
	time_now_score = Time.get_ticks_msec()
	var time_elapsed_score = time_now_score - time_start_score
	
	time_now_multi = Time.get_ticks_msec()
	var time_elapsed_multi = time_now_multi - time_start_multi
	
	
	time_now_cactus_start = Time.get_ticks_msec()
	var time_elapsed_cactus_start = time_now_cactus_start - time_start_cactus_start
	
	if(time_elapsed_cactus_start >= timeCactus):
		cactus()  
	
	if(time_elapsed_bird_start >= timeCuervo - 2000 && time_elapsed_bird_start <= timeCuervo):
		$Cuervo/Cuervo.play()
		if(typeCuervo == 0):
			$Cuervo.position.y = $Cuervo.position.y - 0.01
		else:
			$Cuervo.position.x = $Cuervo.position.x - 0.01
			
	if(time_elapsed_bird_start >= timeCuervo):
		cuervos()
		
	if(time_elapsed_score >= 1000):
		points += 1 * Global.multiplicador
		$Coin.play()
		$HUD/Label.text = str(points)
		Global.localScore = points
		time_start_score = Time.get_ticks_msec()
		
		#print(CACTUS_VELOCITY)
		
		if(points >= 100 && points <= 150):
			if(CACTUS_VELOCITY < 0.10):
				CACTUS_VELOCITY = CACTUS_VELOCITY + 0.5 * delta
			else:
				CACTUS_VELOCITY = 0.10
				$Bubble.JUMP_VELOCITY = 3.2
				$Bubble.GRAVITY = 12
		elif (points > 150 && points <= 200):
			if(CACTUS_VELOCITY < 0.15):
				CACTUS_VELOCITY = CACTUS_VELOCITY + 0.5 * delta
			else:
				CACTUS_VELOCITY = 0.15
				$Bubble.JUMP_VELOCITY = 3.6
				$Bubble.GRAVITY = 15
		elif (points > 200):
			if(CACTUS_VELOCITY < 0.20):
				CACTUS_VELOCITY = CACTUS_VELOCITY + 0.5 * delta
			else:
				CACTUS_VELOCITY = 0.20
				$Bubble.JUMP_VELOCITY = 4.0

			
	if(time_elapsed_multi >= 250):
		$HUD/Label4.text = "+" + str(Global.multiplicador)
		time_start_multi = Time.get_ticks_msec()
		
		#elif(points >= 100):
		#	CACTUS_VELOCITY = 0.15
	
	Global.multiplicador = 1
		
	if(lastChildrenN > Global.childrenPlayer):
		if(lastChildrenN == 1):
			$PlayerTails/Cola/AnimationPlayer.play("blow_tail")
			$PlayerTails/Cola.position = Vector3(-20, 0, 0)
			$PlayerTails/Cola/Drip1.play()
			$PlayerTails/Cola.is_active = false
		if(lastChildrenN == 2):
			$PlayerTails/Cuerpo1/AnimationPlayer.play("blow_tail")
			$PlayerTails/Cuerpo1.position = Vector3(-20, 0, 0)
			$PlayerTails/Cuerpo1/Drip2.play()
			$PlayerTails/Cuerpo1.is_active = false
		if(lastChildrenN == 3):
			$PlayerTails/Cuerpo2/AnimationPlayer.play("blow_tail")
			$PlayerTails/Cuerpo2.position = Vector3(-20, 0, 0)
			$PlayerTails/Cuerpo2/Drip3.play()
			$PlayerTails/Cuerpo2.is_active = false
		if(lastChildrenN == 4):
			$PlayerTails/Cuerpo3/AnimationPlayer.play("blow_tail")
			$PlayerTails/Cuerpo3.position = Vector3(-20, 0, 0)
			$PlayerTails/Cuerpo3/Drip4.play()
			$PlayerTails/Cuerpo3.is_active = false
	
	if(Global.childrenPlayer >= 1 && Global.childrenPlayer < 2):
		Global.multiplicador = 2
		$PlayerTails/Cola.is_active = true
		$PlayerTails/Cola.scale = Vector3(1, 1, 1)
		$PlayerTails/Cola.position = $Bubble.position - Vector3(0.5, 0, 0)	
	if(Global.childrenPlayer >= 2):
		Global.multiplicador = 3
		$PlayerTails/Cola.is_active = true
		$PlayerTails/Cola.scale = Vector3(1, 1, 1)
		$PlayerTails/Cola.GRAVITY = 15
		$PlayerTails/Cola.position = $Bubble.position - Vector3(1.0, 0, 0)
	
		$PlayerTails/Cuerpo1.is_active = true
		$PlayerTails/Cuerpo1.scale = Vector3(1, 1, 1)
		$PlayerTails/Cuerpo1.GRAVITY = 15
		$PlayerTails/Cuerpo1.position = $Bubble.position - Vector3(0.5, 0, 0)
	if(Global.childrenPlayer >= 3):
		Global.multiplicador = 4
		$PlayerTails/Cuerpo1.is_active = true
		$PlayerTails/Cuerpo1.scale = Vector3(1, 1, 1)
		$PlayerTails/Cuerpo1.GRAVITY = 15
		$PlayerTails/Cuerpo1.position = $Bubble.position - Vector3(0.5, 0, 0)
		
		$PlayerTails/Cuerpo2.is_active = true
		$PlayerTails/Cuerpo2.scale = Vector3(1, 1, 1)
		$PlayerTails/Cuerpo2.GRAVITY = 15
		$PlayerTails/Cuerpo2.position = $Bubble.position - Vector3(1.0, 0, 0)
	
		$PlayerTails/Cola.is_active = true
		$PlayerTails/Cola.scale = Vector3(1, 1, 1)
		$PlayerTails/Cola.GRAVITY = 20
		$PlayerTails/Cola.position = $Bubble.position - Vector3(1.5, 0, 0)
	if(Global.childrenPlayer >= 4):
		Global.multiplicador = 5
		$PlayerTails/Cuerpo1.is_active = true
		$PlayerTails/Cuerpo1.scale = Vector3(1, 1, 1)
		$PlayerTails/Cuerpo1.GRAVITY = 15
		$PlayerTails/Cuerpo1.position = $Bubble.position - Vector3(0.5, 0, 0)
		
		$PlayerTails/Cuerpo2.is_active = true
		$PlayerTails/Cuerpo2.scale = Vector3(1, 1, 1)
		$PlayerTails/Cuerpo2.GRAVITY = 15
		$PlayerTails/Cuerpo2.position = $Bubble.position - Vector3(1.0, 0, 0)
		
		
		$PlayerTails/Cuerpo3.is_active = true
		$PlayerTails/Cuerpo3.scale = Vector3(1, 1, 1)
		$PlayerTails/Cuerpo3.GRAVITY = 20
		$PlayerTails/Cuerpo3.position = $Bubble.position - Vector3(1.5, 0, 0)
		
		$PlayerTails/Cola.is_active = true
		$PlayerTails/Cola.scale = Vector3(1, 1, 1)
		$PlayerTails/Cola.GRAVITY = 25
		$PlayerTails/Cola.position = $Bubble.position - Vector3(2.0, 0, 0)
	
	if($AroBurbuja.position <= Vector3(-10, 0, 0)):
		timeAroBurbuja = 1000
		time_start_aros = Time.get_ticks_msec()
		$AroBurbuja.position = Vector3(10,randf_range(0, 3), 0)

	#if($Cactus_Grupo.position <= Vector3(-10, 0, 0)):
	#	$Cactus_Grupo.position = Vector3(14.238, -1.596, 0)
		
	#if($Cactus_Grupo2.position <= Vector3(-10, 0, 0)):
	#	$Cactus_Grupo2.position = Vector3(21.14, -1.596, 0)
		
	if($Cactus_Grupo3.position <= Vector3(-10, 0, 0)):
		time_start_cactus_start = Time.get_ticks_msec()
		timeCactus = 3000
		$Cactus_Grupo.position = Vector3(14.238, -1.596, 0)
		$Cactus_Grupo2.position = Vector3(21.14, -1.596, 0)
		$Cactus_Grupo3.position = Vector3(28.042, -1.596, 0)
		$Cactus_Grupo.position.y =  randf_range(-2, -6)
		$Cactus_Grupo2.position.y = randf_range(-2, -6)
		$Cactus_Grupo3.position.y = randf_range(-2, -6)
		
	#if($Birds/Bird1.position <= Vector3(-10, 0, 0)):
	#	$Birds/Bird1.monitorable = true
	#	time_start_bird_1 = Time.get_ticks_msec()
	#	$Birds/Bird1.position = Vector3(10,randf_range(2.5, 3), 0)
		
	#if($Birds/Bird2.position <= Vector3(-10, 0, 0)):
	#	$Birds/Bird2.monitorable = true
	#	time_start_bird_2 = Time.get_ticks_msec()
	#	$Birds/Bird2.position = Vector3(15,randf_range(2.5, 3), 0)
		
	#if($Birds/Bird3.position <= Vector3(-10, 0, 0)):
	#	$Birds/Bird3.monitorable = true
	#	time_start_bird_3 = Time.get_ticks_msec()
	#	$Birds/Bird3.position = Vector3(20,randf_range(2.5, 3), 0)
		
	if (time_elapsed_aros >= timeAroBurbuja):
		aros()
	
	if($Cuervo.position <= Vector3(-10, 0, 0)):
		Global.colideCuervo = 0
		time_start_bird_start = Time.get_ticks_msec()
		timeCuervo = 10000
		typeCuervo = randi_range(0, 1)
		if(typeCuervo == 0):
			$Cuervo.position = Vector3(5.346, 4.802, 0)
		else:
			$Cuervo.position = Vector3(8, -1.82, 0)
	
	if (time_elapsed_aro_height >= 700):
		ARO_HEIGHT = ARO_HEIGHT * -1
		time_start_aro_height = Time.get_ticks_msec()
	
	#if (time_elapsed_bird_1 >= 3000):
	#	bird1()
	#if (time_elapsed_bird_2 >= 3000):
	#	bird2()
	#if (time_elapsed_bird_3 >= 3000):
	#	bird3()
		   
	lastChildrenN = Global.childrenPlayer

#Generate aros
func aros():
	$AroBurbuja.position += Vector3(-ARO_VELOCITY, ARO_HEIGHT, 0)

func cuervos():
	if($Cuervo.position.y >= -0.694):
		$Cuervo.position  += Vector3(-CUERVO_VELOCITY, -CUERVO_VELOCITY, 0)
	else:
		$Cuervo.position  += Vector3(-CUERVO_VELOCITY, 0, 0)

func cactus():
	$Cactus_Grupo.position += Vector3(-CACTUS_VELOCITY, 0, 0)
	$Cactus_Grupo2.position += Vector3(-CACTUS_VELOCITY, 0, 0)
	$Cactus_Grupo3.position += Vector3(-CACTUS_VELOCITY, 0, 0)
	
#func bird1():
#	$Birds/Bird1.position += Vector3(-BIRD_VELOCITY, BIRD_HEIGHT, 0)
#func bird2():
#	$Birds/Bird2.position += Vector3(-BIRD_VELOCITY, -BIRD_HEIGHT, 0)
#func bird3():
#	$Birds/Bird3.position += Vector3(-BIRD_VELOCITY, BIRD_HEIGHT, 0)

  
func _on_top_zone_body_entered(body: Node3D) -> void:
	body.velocity.y -= $Bubble.GRAVITY


func _on_background_finished() -> void:
	$Background.play()
