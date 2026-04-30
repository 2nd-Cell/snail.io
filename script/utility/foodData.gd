extends Area2D

@export var score: int
@export var energy_given: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.get_meta("IsPlayer", false):
		body._add_score(score)
		body._add_energy(energy_given)
	queue_free()
