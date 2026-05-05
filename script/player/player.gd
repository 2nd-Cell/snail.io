extends CharacterBody2D

@export var healthbar: Control
@export var score_scene: RichTextLabel
@export var v_joystick: VirtualJoystick


# BOOSTS
var speed_boost := 0
var score_boost := 0

# BOOST_PRESETS
@export var speed_boost_value:= 500
@export var score_boost_value:= 1
@export var energy_reduction_value := 0.05

# POWERUP Utilities
@export var powerup_growth_rate:= 0.005
var powerup_timer: Timer

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	var is_mobile = false
	match OS.get_name():
		"Android", "iOS":
			is_mobile = true
	if not is_mobile:
		v_joystick.disabled = true
		v_joystick.visible = false

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	#velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	move_and_slide()

func _process(delta: float) -> void:
	speed_boost_value += powerup_growth_rate * delta
	score_boost_value += powerup_growth_rate * delta

func _add_energy(qty):
	#print("Adding Energy: "+str(qty))
	if healthbar.get_node("TextureProgressBar").Energy < 100:
		healthbar.get_node("TextureProgressBar").Energy += qty

func _add_score(score):
	score_scene.count += score + int(score_boost)

func _ready():
	powerup_timer = $powerup_duration_timer

func _set_powerup(effect: String):
	# RESET BOOSTS and TIMER
	speed_boost = 0
	score_boost = 0
	healthbar.get_node("TextureProgressBar").energy_reduction_rate = energy_reduction_value
	if not powerup_timer.is_stopped():
		powerup_timer.stop()
		
	# Start timer
	powerup_timer.start(60)
	match(effect):
		"ScoreBuff":
			score_boost = score_boost_value
		"SpeedBuff":
			speed_boost = speed_boost_value
		"EnduranceBuff":
			healthbar.get_node("TextureProgressBar").energy_reduction_rate = 0
		_:
			pass
	healthbar.get_node("buff_circle")._set_powerup(effect)
	healthbar.get_node("BuffBar").setup_bar(60)
func _on_powerup_duration_timer_timeout() -> void:
	speed_boost = 0
	score_boost = 0
	healthbar.get_node("TextureProgressBar").energy_reduction_rate = energy_reduction_value
	healthbar.get_node("buff_circle")._reset_powerup()
