class_name StonePlayerController
extends CharacterBody3D
signal health_changed(value:float)
signal stones_changed(count:int)
signal transformed_changed(active:bool)
enum State { FREE, ATTACK, HIT, DODGE, DOWN, COUNTER }
@export var player_index:=0
@export var move_speed:=8.5
@export var acceleration:=34.0
@export var air_control:=0.55
@export var jump_velocity:=9.0
@export var gravity:=24.0
@export var rotation_speed:=16.0
@export var max_health:=100.0
@export var attack_damage:=10.0
@export var attack_range:=2.1
@export var action_radius:=2.0
@export var dodge_speed:=13.0
@export var dodge_duration:=0.25
@export var perfect_dodge_window:=0.09
@export var counter_window:=0.42
@export var transformation_duration:=12.0
var input_prefix:="p1"
var health:=100.0
var power_stones:Array[int]=[]
var transformed:=false
var held_object:StoneInteractable
var state:=State.FREE
var state_timer:=0.0
var combo_step:=0
var combo_timer:=0.0
var transform_timer:=0.0
var dodge_elapsed:=0.0
var counter_ready:=false
@onready var hold_socket:Node3D=$HoldSocket

func _ready():
 input_prefix="p%d"%(player_index+1);health=max_health;add_to_group("arena_players")
func _physics_process(delta):
 if combo_timer>0:combo_timer-=delta
 if combo_timer<=0:combo_step=0
 if transformed:
  transform_timer-=delta
  if transform_timer<=0:_end_transform()
 if state_timer>0:
  state_timer-=delta
  if state_timer<=0:_finish_state()
 if state==State.DODGE:dodge_elapsed+=delta
 if not is_on_floor():velocity.y-=gravity*delta
 if state in [State.HIT,State.DOWN,State.ATTACK,State.COUNTER]:
  move_and_slide();return
 var v:=Input.get_vector(input_prefix+"_left",input_prefix+"_right",input_prefix+"_up",input_prefix+"_down")
 var dir:=Vector3(v.x,0,v.y)
 if state==State.DODGE:move_and_slide();return
 var resonance:=1.0+0.035*power_stones.size() if not transformed else 1.0
 var target:=dir*move_speed*resonance
 var ctl:=1.0 if is_on_floor() else air_control
 velocity.x=move_toward(velocity.x,target.x,acceleration*ctl*delta);velocity.z=move_toward(velocity.z,target.z,acceleration*ctl*delta)
 if is_on_floor() and Input.is_action_just_pressed(input_prefix+"_jump"):velocity.y=jump_velocity
 if dir.length_squared()>0.01:rotation.y=lerp_angle(rotation.y,atan2(dir.x,dir.z),rotation_speed*delta)
 if Input.is_action_just_pressed(input_prefix+"_attack"):_attack()
 elif Input.is_action_just_pressed(input_prefix+"_action"):_action()
 elif Input.is_action_just_pressed(input_prefix+"_evade"):_dodge(dir)
 elif Input.is_action_just_pressed(input_prefix+"_power"):_power()
 move_and_slide()

func _set_state(s:State,t:float=0):state=s;state_timer=t
func _finish_state():
 if state==State.DOWN:velocity=Vector3.ZERO
 state=State.FREE;counter_ready=false

func _attack():
 if counter_ready:_counter();return
 combo_step=(combo_step%3)+1;combo_timer=.7
 var startup=[.08,.10,.14][combo_step-1];_set_state(State.ATTACK,startup+.16)
 await get_tree().create_timer(startup).timeout
 if state!=State.ATTACK:return
 var t:=_target(2.1+(combo_step-1)*.12,75)
 if t:
  var d:Vector3=(t.global_position-global_position).normalized();rotation.y=atan2(d.x,d.z)
  t.receive_hit(attack_damage*(1+.18*(combo_step-1))*(1.6 if transformed else 1),d,5.5+combo_step*1.1)

func _counter():
 counter_ready=false;_set_state(State.COUNTER,.25)
 var t:=_target(2.5,130)
 if t:
  var d:Vector3=(t.global_position-global_position).normalized();t.receive_hit(15,d,11)

func _action():
 if held_object:held_object.throw_from(-global_transform.basis.z);held_object=null;return
 var best:StoneInteractable;var dist:=action_radius
 for n in get_tree().get_nodes_in_group("interactables"):
  if n is StoneInteractable and n.can_interact(self):
   var d:=global_position.distance_to(n.global_position)
   if d<dist:dist=d;best=n
 if best:held_object=best;best.pickup(self,hold_socket);return
 var t:=_target(1.45,110)
 if t:
  var d:Vector3=(t.global_position-global_position).normalized();t.receive_hit(7,d,9.5)

func _dodge(dir:Vector3):
 var d:=dir if dir.length_squared()>.01 else -global_transform.basis.z
 velocity=Vector3(d.normalized().x*dodge_speed,velocity.y,d.normalized().z*dodge_speed)
 dodge_elapsed=0;_set_state(State.DODGE,dodge_duration)

func receive_hit(damage:float,direction:Vector3,knockback:float):
 if state==State.DODGE:
  if dodge_elapsed<=perfect_dodge_window:
   counter_ready=true;state=State.FREE;state_timer=counter_window;return
  return
 if state==State.COUNTER:return
 health=maxf(0,health-damage);health_changed.emit(health);velocity=direction.normalized()*knockback+Vector3.UP*2.8
 if power_stones.size()>0 and damage>=12:_lose_stone()
 if health<=0:_set_state(State.DOWN,999)
 elif knockback>=9:_set_state(State.DOWN,.75)
 else:_set_state(State.HIT,.24)

func _target(radius:float,arc:float)->StonePlayerController:
 var best:StonePlayerController;var bs:=INF;var forward:=-global_transform.basis.z
 for n in get_tree().get_nodes_in_group("arena_players"):
  if n==self or not n is StonePlayerController:continue
  var dv:Vector3=n.global_position-global_position;var ds:=dv.length()
  if ds>radius:continue
  var a:=rad_to_deg(acos(clamp(forward.dot(dv.normalized()),-1,1)))
  if a>arc:continue
  var sc:=ds+a*.014
  if sc<bs:bs=sc;best=n
 return best

func collect_power_stone(id:int)->bool:
 if transformed or power_stones.has(id):return false
 power_stones.append(id);stones_changed.emit(power_stones.size())
 if power_stones.size()>=3:_begin_transform()
 return true
func _lose_stone():
 if power_stones.is_empty():return
 power_stones.pop_back();stones_changed.emit(power_stones.size())
func _stone_burst():
 if power_stones.is_empty():return
 _lose_stone()
 for n in get_tree().get_nodes_in_group("arena_players"):
  if n==self or not n is StonePlayerController:continue
  var dv:Vector3=n.global_position-global_position
  if dv.length()<3.2:n.receive_hit(5,dv.normalized(),12)
func _begin_transform():transformed=true;transform_timer=transformation_duration;transformed_changed.emit(true)
func _end_transform():transformed=false;power_stones.clear();stones_changed.emit(0);transformed_changed.emit(false)
func _power():
 if not transformed:_stone_burst();return
 var t:=_target(4,115)
 if t:
  var d:Vector3=(t.global_position-global_position).normalized();t.receive_hit(24,d,13);transform_timer=maxf(0,transform_timer-2.5)
