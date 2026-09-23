class_name PowerStonePickup
extends Area3D
@export var stone_id:=0
@export var spin_speed:=2.4
@export var bob_height:=0.18
@export var bob_speed:=3.0
var origin_y:=0.0
func _ready():
	origin_y=position.y;body_entered.connect(_on_body_entered)
func _process(delta):
	rotate_y(spin_speed*delta);position.y=origin_y+sin(Time.get_ticks_msec()*0.001*bob_speed)*bob_height
func _on_body_entered(body):
	if body.has_method("collect_power_stone") and body.collect_power_stone(stone_id):queue_free()
