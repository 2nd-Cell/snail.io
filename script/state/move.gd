extends state
class_name move

@export var next_state : state

@onready var AnimPlayer: = $"../../snail_ui"

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
	mouse_position = $"../..".to_local($"../..".get_global_mouse_position())
	var bar = $"../..".healthbar.get_node("TextureProgressBar")
	if bar != null:
		bar._update_health( move_energy_multiplier * delta )
	
func physics_update(delta: float):
	super(delta)
	
	if mouse_position.length() <= 50:
		transitioned.emit(self, next_state)
	
	if mouse_position.x < 0:
		if $"../../snail_ui".scale.x < 0 :
			$"../../snail_ui".scale.x*=-1

	else:
		if $"../../snail_ui".scale.x > 0 :
			$"../../snail_ui".scale.x*=-1
	
	#print(direction)
	$"../..".velocity = mouse_position.normalized() * SPEED
#
	$"../..".move_and_slide()
