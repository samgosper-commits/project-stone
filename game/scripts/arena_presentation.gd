extends Node3D

const CRATE = preload("res://items/crate.tscn")
const STONE = preload("res://pickups/power_stone.tscn")

func _ready()->void:
	# Visual details have no collision: the existing car roofs remain the arena.
	for z in [-11.0, 0.0, 11.0]:
		_box(Vector3(0,-0.7,z), Vector3(7.4,1.0,9.5), Color("263c53"))
		for x in [-3.8,3.8]:
			_box(Vector3(x,0.29,z),Vector3(0.12,0.08,9.7),Color("ffe1a0"))
			for wheel_z in [-3.5,3.5]:
				var wheel:=MeshInstance3D.new()
				var mesh:=CylinderMesh.new()
				mesh.top_radius=0.65
				mesh.bottom_radius=0.65
				mesh.height=0.35
				wheel.mesh=mesh
				wheel.material_override=_material(Color("142033"))
				wheel.rotation.z=PI/2.0
				wheel.position=Vector3(x,-1.0,z+wheel_z)
				add_child(wheel)
	for x in [-2.9,2.9]:
		_box(Vector3(x,-1.65,0),Vector3(0.2,0.15,160),Color("a8b8bd"))
	for z in range(-70,71,3):
		_box(Vector3(0,-1.8,z),Vector3(7,0.2,0.65),Color("4c3d35"))
	_box(Vector3(0,-2.2,0),Vector3(180,0.5,180),Color("617668"))
	for pos in [Vector3(-2,1,-6),Vector3(2,1,6)]:
		var crate:=CRATE.instantiate()
		crate.position=pos
		add_child(crate)
	for i in range(3):
		_spawn_stone(i)
	var timer:=Timer.new()
	timer.wait_time=18.0
	timer.autostart=true
	timer.timeout.connect(_refill_stones)
	add_child(timer)

func _spawn_stone(index:int)->void:
	var stone:=STONE.instantiate()
	stone.stone_id=index
	stone.position=Vector3(0,1.0,[-8.0,0.0,8.0][index])
	stone.add_to_group("arena_stones")
	var material:=_material([Color("ff5757"),Color("54ddff"),Color("ffe45d")][index])
	material.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
	stone.get_node("Mesh").material_override=material
	add_child(stone)

func _refill_stones()->void:
	for index in range(3):
		var present:=false
		for stone in get_tree().get_nodes_in_group("arena_stones"):
			if stone.stone_id==index:present=true
		if not present:_spawn_stone(index)

func _material(color:Color)->StandardMaterial3D:
	var material:=StandardMaterial3D.new()
	material.albedo_color=color
	material.roughness=0.85
	return material

func _box(pos:Vector3,size:Vector3,color:Color)->void:
	var node:=MeshInstance3D.new()
	var mesh:=BoxMesh.new()
	mesh.size=size
	node.mesh=mesh
	node.material_override=_material(color)
	node.position=pos
	add_child(node)
