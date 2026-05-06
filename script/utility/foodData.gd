extends Area2D

@export var score: int
@export var energy_given: float
@export var tmr:Timer
# half degrade, full degrade, despawn times
@export var stageIntervals: Array[int] = [5,5,10]
var current_Stage = 0
@export var max_stages = 2 # stage_0 -> stage_1 -> stage_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tmr = $Timer
	max_stages = 2
	# check if stageInterval Array exceeds maximum max_stages limit
	if len(stageIntervals) > (max_stages + 1):
		print("[WARN]: STAGE INTERVAL LENGTH ", len(stageIntervals), " EXEEDS MAX NUMBER OF STAGES ", max_stages, ", PROCEEDING STAGES WILL BE IGNORED")
	
	# set current state as Fresh
	tmr.start(stageIntervals[current_Stage])
	$SpriteFresh.visible = true
	$SpriteHalf.visible = false
	$SpriteDegraded.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.get_meta("IsPlayer", false):
		body._add_score(score)
		# add energy according to current state
		# FOOD_STATE.FRESH gives full energy
		# FOOD_STATE.RUSTY gives damage
		# FOOD_STATE.DEAD increases damage rate
		match(current_Stage):
			0:
				body._add_energy(energy_given)
			1:
				if randf_range(0, 1) > 0.5:
					body._add_energy(energy_given/2)
				else:
					body._add_energy(-energy_given/2)
			2:
				body._add_energy(-energy_given)
				
				#if randf() > 0.1:
					#body.add_depletion_rate(energy_given/1000)
			_:
				print("[WARN] YOU FUCKED UP")
	queue_free()


func _on_timer_timeout() -> void:
	# increase stage and reset timer
	current_Stage += 1;
	print(current_Stage)
	
	# DEBUG ONLY
	match(current_Stage):
		1:
			$SpriteFresh.visible = false
			$SpriteHalf.visible = true
			$SpriteDegraded.visible = false
		2:
			$SpriteFresh.visible = false
			$SpriteHalf.visible = false
			$SpriteDegraded.visible = true
	
	if current_Stage > max_stages: # delete the food item if it goes too bad
		queue_free()
	else:
		tmr.start(stageIntervals[current_Stage])
