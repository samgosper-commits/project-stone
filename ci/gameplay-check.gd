extends SceneTree

var failures:=0
func _initialize()->void:
	call_deferred("run_check")
func check(condition:bool,message:String)->void:
	if not condition:
		failures+=1
		push_error(message)
func ticks(count:int)->void:
	for frame in count:await physics_frame
func run_check()->void:
	change_scene_to_file("res://stages/runaway_train/runaway_train.tscn")
	await ticks(120)
	var players:=get_nodes_in_group("arena_players")
	var player=players[0]
	var target=players[1]
	# Keep the real stage but isolate this test from pickups and other fighters.
	for stone in get_nodes_in_group("arena_stones"):stone.queue_free()
	for i in range(1,players.size()):players[i].global_position=Vector3(2.5,1.3,10+i)
	player.power_stones.clear()
	player.global_position=Vector3(-2,1.3,3)
	player.velocity=Vector3.ZERO
	await ticks(30)
	check(player.is_on_floor(),"Player did not settle onto the train collider")
	var floor_y:float=player.global_position.y
	await ticks(30)
	check(absf(player.global_position.y-floor_y)<0.03,"Standing player drifted vertically")
	var input_setup=root.get_node("PrototypeInputSetup")
	var stick=load("res://scripts/virtual_stick.gd").new()
	current_scene.add_child(stick)
	for i in range(8):
		var direction:=Vector2.from_angle(i*PI/4.0)
		var touch:=InputEventScreenTouch.new()
		touch.index=0;touch.pressed=true;touch.position=direction*100
		stick._input(touch)
		check(input_setup.touch_move_vector.distance_to(direction)<0.001,"Thumbstick missed direction %d"%i)
		var other:=InputEventScreenTouch.new()
		other.index=1;other.pressed=false
		stick._input(other)
		check(input_setup.touch_move_vector.length()>0.99,"Other finger released movement")
		touch.pressed=false;stick._input(touch)
		check(input_setup.touch_move_vector==Vector2.ZERO,"Thumbstick stuck after release")
	stick._set_vector(Vector2(100,-100))
	await ticks(18)
	check(player.velocity.x>4 and player.velocity.z< -4,"Diagonal input failed to move on both axes")
	check(Vector2(player.velocity.x,player.velocity.z).length()<=player.move_speed*1.01,"Diagonal movement boosted run speed")
	check(player.facing_direction.dot(Vector3(1,0,-1).normalized())>0.99,"Facing does not follow movement")
	stick._release();stick.queue_free()
	# Throw a real rigid body at a real character, then wait for its contact signal.
	player.global_position=Vector3(0,1.3,3)
	player.velocity=Vector3.ZERO
	target.global_position=Vector3(0,1.3,-1)
	target.velocity=Vector3.ZERO
	await ticks(30)
	var crate=load("res://items/crate.tscn").instantiate()
	current_scene.add_child(crate)
	crate.global_position=player.global_position+Vector3(0,0,-1)
	player.facing_direction=Vector3.FORWARD
	crate.pickup(player,player.hold_socket)
	player.held_object=crate
	check(crate.freeze and crate.collision_layer==0,"Held crate still collides")
	var before:float=target.health
	player._attack()
	check(player.held_object==null and not crate.freeze,"Attack did not release held crate")
	check(crate.linear_velocity.z< -10 and crate.linear_velocity.y>0,"Throw launched in the wrong direction or without an arc")
	await ticks(45)
	check(target.health<before,"Thrown crate failed to damage the target through physics contact")
	check(player.health==player.max_health,"Throw damaged its owner during release")
	print("GAMEPLAY_CHECK: ",failures," failures; floor stability, eight directions, multitouch, diagonal speed, facing, pickup and physical throw impact")
	quit(1 if failures else 0)
