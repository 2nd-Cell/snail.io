extends CharacterBody2D

const SPEED: float = 500.0
@export var healthbar: Control
@export var score_scene: RichTextLabel

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	#velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED

	move_and_slide()

func _add_energy(qty):
	#print("Adding Energy: "+str(qty))
	if healthbar.get_node("TextureProgressBar").Energy < 100:
		healthbar.get_node("TextureProgressBar").Energy += qty

func _add_score(score):
	#print("Adding Score: "+str(score))
	score_scene.count+=score
