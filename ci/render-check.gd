extends SceneTree

func _initialize()->void:
	call_deferred("run_check")

func run_check()->void:
	change_scene_to_file("res://stages/runaway_train/runaway_train.tscn")
	for frame in range(120):
		await process_frame
	var players:=get_nodes_in_group("arena_players")
	assert(players.size()==4,"Expected four visible player characters")
	var player=players[0]
	var start:Vector3=player.global_position
	Input.action_press("p1_up")
	for frame in range(20):
		await physics_frame
	Input.action_release("p1_up")
	assert(player.global_position.distance_to(start)>0.2,"Movement input did not move player one")
	player.global_position.y=-20
	for frame in range(5):
		await physics_frame
	assert(player.global_position.y>0,"Falling player did not respawn")
	for frame in range(60):
		await process_frame
	if DisplayServer.get_name()!="headless":
		await RenderingServer.frame_post_draw
		var image:=root.get_texture().get_image()
		assert(not image.is_empty(),"No rendered frame")
		var path:="/tmp/project-stone-preview.png"
		for arg in OS.get_cmdline_user_args():
			if arg.begins_with("--capture="):path=arg.trim_prefix("--capture=")
		assert(image.save_png(path)==OK,"Could not save rendered frame")
		print("RENDER_CAPTURE: ",path)
	print("SCENE_CHECK: four players, movement and fall recovery passed")
	quit()
