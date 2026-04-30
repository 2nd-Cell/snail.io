extends Node2D

@export_group("Spawning Settings")
@export var spawn_scene: PackedScene
@export var spawn_interval: float = 1.0
@export var max_tries_per_attempt: int = 15

@export_group("Spawn Area")
@export var spawn_area: Rect2 = Rect2(0, 0, 1000, 1000)
@export var use_relative_position: bool = true

@onready var shape_cast: ShapeCast2D = $ShapeCast2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	randomize()

	if not spawn_scene:
		push_error("Spawner: No spawn_scene assigned!")
		set_process(false)
		timer.stop()
		return

	shape_cast.target_position = Vector2.ZERO

	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_timeout() -> void:
	attempt_spawn()


func attempt_spawn() -> void:

	var origin: Vector2 = global_position if use_relative_position else Vector2.ZERO

	var min_pos: Vector2 = origin + spawn_area.position
	var max_pos: Vector2 = origin + spawn_area.end

	for i in max_tries_per_attempt:

		var target_pos := Vector2(
			randf_range(min_pos.x, max_pos.x),
			randf_range(min_pos.y, max_pos.y)
		)

		shape_cast.global_position = target_pos
		shape_cast.force_shapecast_update()

		if not shape_cast.is_colliding():
			spawn_object(target_pos)
			return

	print("Spawner: Map too crowded, skipping spawn cycle.")


func spawn_object(pos: Vector2) -> void:

	var obj = spawn_scene.instantiate()

	get_tree().current_scene.add_child(obj)

	obj.global_position = pos
