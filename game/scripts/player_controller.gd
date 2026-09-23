class_name StonePlayerController
extends CharacterBody3D

signal health_changed(value: float)
signal stones_changed(count: int)
signal transformed_changed(active: bool)

@export var player_index := 0
@export var move_speed := 8.5
@export var acceleration := 34.0
@export var air_control := 0.55
@export var jump_velocity := 9.0
@export var gravity := 24.0
@export var rotation_speed := 16.0
@export var max_health := 100.0
@export var attack_damage := 10.0
@export var attack_range := 2.1
@export var attack_arc_degrees := 70.0
@export var attack_cooldown := 0.38
@export var action_radius := 2.0
@export var dodge_speed := 13.0
@export var dodge_duration := 0.22
@export var transformation_duration := 12.0

var input_prefix := "p1"
var health := 100.0
var power_stones: Array[int] = []
var transformed := false
var held_object: StoneInteractable
var attack_timer := 0.0
var dodge_timer := 0.0
var transform_timer := 0.0

@onready var hold_socket: Node3D = $HoldSocket

func _ready() -> void:
	input_prefix = "p%d" % (player_index + 1)
	health = max_health
	add_to_group("arena_players")

func _physics_process(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	if transformed:
		transform_timer -= delta
		if transform_timer <= 0.0:
			_end_transformation()

	if dodge_timer > 0.0:
		dodge_timer -= delta
		move_and_slide()
		return

	var input_vec := Input.get_vector(input_prefix+"_left",input_prefix+"_right",input_prefix+"_up",input_prefix+"_down")
	var move_dir := Vector3(input_vec.x,0.0,input_vec.y)
	var control := 1.0 if is_on_floor() else air_control
	var target := move_dir * move_speed
	velocity.x = move_toward(velocity.x,target.x,acceleration*control*delta)
	velocity.z = move_toward(velocity.z,target.z,acceleration*control*delta)
	if not is_on_floor(): velocity.y -= gravity*delta
	elif Input.is_action_just_pressed(input_prefix+"_jump"): velocity.y = jump_velocity
	if move_dir.length_squared() > 0.01:
		rotation.y = lerp_angle(rotation.y,atan2(move_dir.x,move_dir.z),rotation_speed*delta)

	if Input.is_action_just_pressed(input_prefix+"_attack"): _attack()
	if Input.is_action_just_pressed(input_prefix+"_action"): _action()
	if Input.is_action_just_pressed(input_prefix+"_evade"): _dodge(move_dir)
	if Input.is_action_just_pressed(input_prefix+"_power"): _power_action()
	move_and_slide()

func _attack() -> void:
	if attack_timer > 0.0: return
	attack_timer = attack_cooldown
	if held_object:
		held_object.throw_from(-global_transform.basis.z)
		held_object = null
		return
	var target := _best_target(attack_range,attack_arc_degrees)
	if target:
		var dir: Vector3 = (target.global_position-global_position).normalized()
		rotation.y = atan2(dir.x,dir.z)
		target.receive_hit(attack_damage*(1.6 if transformed else 1.0),dir,6.0)

func _action() -> void:
	if held_object:
		held_object.throw_from(-global_transform.basis.z)
		held_object = null
		return
	var nearest: StoneInteractable
	var best := action_radius
	for node in get_tree().get_nodes_in_group("interactables"):
		if node is StoneInteractable and node.can_interact(self):
			var d := global_position.distance_to(node.global_position)
			if d < best: best=d; nearest=node
	if nearest:
		held_object=nearest
		nearest.pickup(self,hold_socket)
		return
	var target := _best_target(1.45,100.0)
	if target:
		var dir: Vector3=(target.global_position-global_position).normalized()
		target.receive_hit(7.0,dir,9.0)

func _dodge(move_dir: Vector3) -> void:
	var dir := move_dir if move_dir.length_squared()>0.01 else -global_transform.basis.z
	velocity.x=dir.normalized().x*dodge_speed
	velocity.z=dir.normalized().z*dodge_speed
	dodge_timer=dodge_duration

func _best_target(radius: float, arc_degrees: float) -> StonePlayerController:
	var best: StonePlayerController
	var best_score := INF
	var forward := -global_transform.basis.z
	for node in get_tree().get_nodes_in_group("arena_players"):
		if node==self or not node is StonePlayerController: continue
		var delta: Vector3=node.global_position-global_position
		var dist:=delta.length()
		if dist>radius: continue
		var angle:=rad_to_deg(acos(clamp(forward.dot(delta.normalized()),-1.0,1.0)))
		if angle>arc_degrees: continue
		var score:=dist+angle*0.015
		if score<best_score: best_score=score; best=node
	return best

func receive_hit(damage: float, direction: Vector3, knockback: float) -> void:
	health=maxf(0.0,health-damage)
	velocity += direction.normalized()*knockback+Vector3.UP*2.5
	health_changed.emit(health)
	if power_stones.size()>0 and damage>=12.0:
		power_stones.pop_back()
		stones_changed.emit(power_stones.size())
	if health<=0.0: set_physics_process(false)

func collect_power_stone(stone_id: int) -> void:
	if transformed or power_stones.has(stone_id): return
	power_stones.append(stone_id)
	stones_changed.emit(power_stones.size())
	if power_stones.size()>=3: _begin_transformation()

func _begin_transformation() -> void:
	transformed=true
	transform_timer=transformation_duration
	transformed_changed.emit(true)

func _end_transformation() -> void:
	transformed=false
	power_stones.clear()
	stones_changed.emit(0)
	transformed_changed.emit(false)

func _power_action() -> void:
	if not transformed: return
	var target:=_best_target(4.0,100.0)
	if target:
		var dir: Vector3=(target.global_position-global_position).normalized()
		target.receive_hit(24.0,dir,13.0)
		transform_timer=maxf(0.0,transform_timer-2.5)
