extends CanvasLayer
@onready var labels=[$Margin/VBox/P1,$Margin/VBox/P2,$Margin/VBox/P3,$Margin/VBox/P4]
func _process(_delta):
	var ps=get_tree().get_nodes_in_group("arena_players")
	for i in labels.size():
		if i<ps.size():
			var p=ps[i];labels[i].visible=true
			labels[i].text="P%d  HP %03d   STONES %d%s"%[i+1,int(p.health),p.power_stones.size(),"  POWER!" if p.transformed else ""]
		else:labels[i].visible=false
