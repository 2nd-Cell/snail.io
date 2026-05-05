extends Sprite2D
var endurance_sprite:Sprite2D
var score_sprite:Sprite2D
var speed_sprite:Sprite2D

func _ready():
	endurance_sprite = $endurance_sprite
	score_sprite = $score_sprite
	speed_sprite = $speed_sprite
	
	
	endurance_sprite.visible = false
	score_sprite.visible = false
	speed_sprite.visible = false

func _set_powerup(powerup):
	endurance_sprite.visible = false
	score_sprite.visible = false
	speed_sprite.visible = false
	
	match(powerup):
		"ScoreBuff":
			score_sprite.visible = true
		"SpeedBuff":
			speed_sprite.visible = true
		"EnduranceBuff":
			endurance_sprite.visible = true
		_:
			pass
func _reset_powerup():
	endurance_sprite.visible = false
	score_sprite.visible = false
	speed_sprite.visible = false
