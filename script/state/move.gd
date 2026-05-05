extends state
class_name move

@export var next_state : state

#@onready var AnimPlayer: = $"../../snail_ui"

@export var move_energy_multiplier: float = 1.0
@export var SPEED = 500.0
var mouse_position := Vector2(0,0)

func enter():
	super()
	#Globals.player_position = $"../..".position
	
func exit():
	super()

func update(delta: float):
	super(delta)
	match OS.get_name():
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			mouse_position = $"../..".to_local($"../..".get_global_mouse_position())
		"Android", "iOS":
			pass
		"Web":
			pass
		_:
			mouse_position = $"../..".to_local($"../..".get_global_mouse_position())
			
	
	var bar = $"../..".healthbar.get_node("TextureProgressBar")
	#if bar != null:
		#bar._update_health( move_energy_multiplier * delta )
	
func physics_update(delta: float):
	super(delta)
	var is_mobile = false
	var speed = SPEED
	match OS.get_name():
		"Android", "iOS":
			is_mobile = true
	
	speed += $"../..".speed_boost
			
	if not is_mobile:
		if mouse_position.length() > 50:
			$"../..".velocity = mouse_position.normalized() * speed
		else:
			$"../..".velocity = Vector2.ZERO
	else:
		if Vector2($"../..".v_joystick._input_direction).is_zero_approx():
			$"../..".velocity = 0
		else:
			$"../..".velocity += $"../..".v_joystick._input_direction.normalized() * speed
	$"../..".move_and_slide()
