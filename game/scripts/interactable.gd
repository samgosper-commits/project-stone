class_name StoneInteractable
extends RigidBody3D

@export var display_name:="Object"
@export var throwable:=true
@export var throw_speed:=14.0
@export var upward_throw:=4.5
@export var impact_damage:=12.0
var held_by:Node3D
var thrower:PhysicsBody3D
var thrown:=false
var release_grace:=0.0
var previous_velocity:=Vector3.ZERO
var hit_bodies:Dictionary={}
var spawn_position:=Vector3.ZERO

func _ready()->void:
	add_to_group("interactables")
	contact_monitor=true
	max_contacts_reported=8
	continuous_cd=true
	spawn_position=global_position
	body_entered.connect(_impact)

func _physics_process(delta:float)->void:
	previous_velocity=linear_velocity
	if release_grace>0:
		release_grace-=delta
		if release_grace<=0 and is_instance_valid(thrower):
			remove_collision_exception_with(thrower)
	if global_position.y < -10 and held_by==null:
		global_position=spawn_position
		linear_velocity=Vector3.ZERO
		angular_velocity=Vector3.ZERO
		thrown=false

func can_interact(_actor:Node3D)->bool:
	return held_by==null and not (thrown and linear_velocity.length()>5)

func pickup(actor:Node3D,socket:Node3D)->void:
	if not can_interact(actor):return
	if is_instance_valid(thrower):remove_collision_exception_with(thrower)
	held_by=actor
	thrown=false
	freeze=true
	linear_velocity=Vector3.ZERO
	angular_velocity=Vector3.ZERO
	collision_layer=0
	collision_mask=0
	reparent(socket)
	position=Vector3.ZERO
	rotation=Vector3.ZERO

func throw_from(direction:Vector3)->void:
	if not throwable or held_by==null:return
	var actor:=held_by
	var heading:=Vector3(direction.x,0,direction.z).normalized()
	if heading.is_zero_approx():heading=Vector3.FORWARD
	var release_position:Vector3=actor.global_position+Vector3.UP*0.75+heading*1.4
	var actor_velocity:=Vector3.ZERO
	if actor is CharacterBody3D:actor_velocity=actor.velocity*0.35
	reparent(get_tree().current_scene)
	global_position=release_position
	freeze=false
	sleeping=false
	collision_layer=4
	collision_mask=7
	thrower=actor as PhysicsBody3D
	if is_instance_valid(thrower):add_collision_exception_with(thrower)
	release_grace=0.22
	linear_velocity=heading*throw_speed+Vector3.UP*upward_throw+actor_velocity
	previous_velocity=linear_velocity
	angular_velocity=Vector3(heading.z,0,-heading.x)*7.0
	held_by=null
	thrown=true
	hit_bodies.clear()

func _impact(body:Node)->void:
	if not thrown or body==thrower or hit_bodies.has(body.get_instance_id()):return
	var impact_velocity:=previous_velocity
	if linear_velocity.length()>impact_velocity.length():impact_velocity=linear_velocity
	if impact_velocity.length()<5:return
	if body.has_method("receive_hit"):
		hit_bodies[body.get_instance_id()]=true
		var heading:=Vector3(impact_velocity.x,0,impact_velocity.z).normalized()
		body.receive_hit(impact_damage,heading,minf(12.0,impact_velocity.length()*0.7))
	else:
		# A crate resting on the stage must not deal repeated incidental damage.
		thrown=false
