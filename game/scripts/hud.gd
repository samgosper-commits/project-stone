extends CanvasLayer
@onready var labels=[$Margin/VBox/P1,$Margin/VBox/P2,$Margin/VBox/P3,$Margin/VBox/P4]
func _ready():
	for label in labels:
		label.add_theme_font_size_override("font_size",24)
		label.add_theme_color_override("font_shadow_color",Color.BLACK)
		label.add_theme_constant_override("shadow_offset_x",2)
		label.add_theme_constant_override("shadow_offset_y",2)
	if OS.has_feature("mobile"):
		$Margin/VBox/Controls.text="Touch controls: P1  |  Connect controllers for P2-P4"
func _process(_delta):
	var ps=get_tree().get_nodes_in_group("arena_players")
	for i in labels.size():
		if i<ps.size():
			var p=ps[i];labels[i].visible=true
			labels[i].modulate=p.player_color
			labels[i].text="P%d  HP %03d   STONES %d%s"%[i+1,int(p.health),p.power_stones.size(),"  POWER!" if p.transformed else ""]
		else:labels[i].visible=false
