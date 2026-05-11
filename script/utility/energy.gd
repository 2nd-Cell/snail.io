extends TextureProgressBar
signal HealthDepletion

var game := true
var Energy : float = 100.0
var energy_reduction_rate = 0.05
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Energy > 0:
		Energy -= energy_reduction_rate
	else:
		HealthDepletion.emit()
	value = Energy
