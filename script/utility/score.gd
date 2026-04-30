extends RichTextLabel

# This tracks the points added by eating food
var count : int = 0
var font_path = "res://ui/fonts/Archivo-VariableFont_wdth,wght.ttf"

# Called every frame to update the visual display
func _process(_delta: float) -> void:
	# We calculate the total score (42 + gathered points) right before displaying it
	var total_score = count
	
	# Update the label text with the live calculation
	text = "[font=\"%s\"][outline_size=12][outline_color=red][font_size=32][color=white]SCORE    %s[/color][/font_size][/outline_color][/outline_size][/font]" % [font_path, str(total_score)]
