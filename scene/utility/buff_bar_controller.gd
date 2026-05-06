extends TextureProgressBar
var game := true
var energy_reduction_rate = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if value > 0:
		value -= energy_reduction_rate * delta

func setup_bar(max_timer: int):
	max_value = max_timer
	energy_reduction_rate = 1
	value = max_timer
	min_value = 0
