extends CharacterBody2D

const SPEED: float = 500.0
@export var healthbar: Control
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	#velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	move_and_slide()

func _add_energy(qty):
	print("Adding Energy: "+str(qty))
	healthbar.get_node("TextureProgressBar")._update_health( qty )
