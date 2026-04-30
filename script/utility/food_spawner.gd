extends Node2D

@export var foods: Array[PackedScene] = [
#preload("res://scene/foods/apple.tscn"),
#preload("res://scene/foods/cake.tscn"),
#preload("res://scene/foods/kiwi.tscn"),
#preload("res://scene/foods/swiss_roll.tscn"),
#preload("res://scene/foods/bread.tscn"),
#preload("res://scene/foods/cookie.tscn"),
#preload("res://scene/foods/doughnut.tscn"),
#preload("res://scene/foods/hotdog.tscn"),
#preload("res://scene/foods/pizza.tscn"),
#preload("res://scene/foods/potato_chip.tscn"),
preload("res://scene/foods/candy.tscn")
]

var rng = RandomNumberGenerator.new()
var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	
	var food = foods.pick_random().instantiate()
	var scale = rng.randf_range(0.25,0.5)
	var pos = Vector2(rng.randf_range(0,1000),rng.randf_range(0,1000))

	timer = Timer.new()
	#food.get_node("Area2D").monitoring = false
	#food.get_node("Area2D").monitorable = false

	food.scale = Vector2(scale,scale)
	food.rotate(deg_to_rad(rng.randf_range(0, 359)))
	food.position = pos

	timer.autostart = false
	timer.one_shot = true
	food.add_child(timer)

	add_child(food)

func food_timeout(food, sprite):
	food.get_node("Area2D").collision_layer = 1
	food.remove_child(food.get_node("Timer"))
	sprite.visible = true
