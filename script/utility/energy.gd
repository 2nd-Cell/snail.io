extends TextureProgressBar

@export var energy := 0.5
var game := true
var health = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#while game:
		#value = value + energy - 1
		
func _set_health(new_health):
	var previous_health = health
	health = min(max_value, new_health)
	value = health

func _update_health(val):
	var nh = value + val
	health = min(max_value, nh)
	value = health

func init_health(_health) -> void:
	health = _health
	max_value = health
	value = health
