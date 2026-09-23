class_name StoneHazard
extends Area3D
@export var damage:=18.0
@export var knockback:=11.0
@export var direction:=Vector3(0,0,1)
func _ready():body_entered.connect(_hit)
func _hit(body):
	if body.has_method("receive_hit"):body.receive_hit(damage,direction,knockback)
