extends Node2D

var rng = RandomNumberGenerator.new()

var timer: Timer = Timer.new()
var sprite: Sprite2D

var energy: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.autostart = false
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	for c in get_node("Area2D").get_children():
		if c is Sprite2D:
			sprite = c
			break
	var temp_energy: float = get_meta("Energy", -INF)
	if temp_energy == -INF:
		print("Energy was not set for this food! Applying default energy of 10")
		temp_energy = 10.0
	energy = temp_energy
	sprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(get_node("Area2D").collision_layer != 2):
		pass
	else:
		timer.start(0.25)
		$".".position = Vector2(rng.randf_range(0,1000),rng.randf_range(0,1000))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_meta("IsPlayer", false):
		body._add_energy(energy)
	queue_free()


func _on_timer_timeout() -> void:
	var area2d: Area2D = get_node("Area2D")
	area2d.collision_layer = 1
	print(area2d.collision_mask)
	area2d.collision_mask = 0b00000001
	remove_child(get_node("Timer"))
	if(get_node("Area2D").collision_layer == 1):
		sprite.visible = true
