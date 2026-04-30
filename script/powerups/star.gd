extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("spin_enter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$Sprite2D/AnimationPlayer.play("twinkle")
	$Sprite2D2/AnimationPlayer.play("twinkle")
