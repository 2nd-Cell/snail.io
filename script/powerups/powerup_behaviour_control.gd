extends Node2D
enum Powerup_type{
	Score=1,
	Speed=2,
	Endurance=3
}
@export var type:Powerup_type = Powerup_type.Score

func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	match(type):
		Powerup_type.Score:
			if body.get_meta("IsPlayer", false):
				body._set_powerup("ScoreBuff")
		Powerup_type.Speed:
			if body.get_meta("IsPlayer", false):
				body._set_powerup("SpeedBuff")
		Powerup_type.Endurance:
			if body.get_meta("IsPlayer", false):
				body._set_powerup("EnduranceBuff")
	
	print(type)
	$".".queue_free()
