extends CanvasLayer

func _ready()->void:
	if not OS.has_feature("mobile") and "--touch-preview" not in OS.get_cmdline_user_args():
		return
	var normal:=_circle(Color(0.04,0.09,0.15,0.75))
	var pressed:=_circle(Color(0.15,0.7,0.9,0.9))
	var size:=get_viewport().get_visible_rect().size
	for data in [
		["left","LEFT",Vector2(45,size.y-205)],
		["right","RIGHT",Vector2(275,size.y-205)],
		["up","UP",Vector2(160,size.y-320)],
		["down","DOWN",Vector2(160,size.y-90)],
		["jump","JUMP",Vector2(size.x-175,size.y-210)],
		["attack","HIT",Vector2(size.x-320,size.y-110)],
		["action","GRAB",Vector2(size.x-465,size.y-210)],
		["evade","DODGE",Vector2(size.x-320,size.y-320)],
		["power","POWER",Vector2(size.x-175,size.y-435)]
	]:
		var button:=TouchScreenButton.new()
		button.action="p1_"+data[0]
		button.texture_normal=normal
		button.texture_pressed=pressed
		button.position=data[2]-Vector2(0,64)
		var shape:=CircleShape2D.new()
		shape.radius=64
		button.shape=shape
		add_child(button)
		var label:=Label.new()
		label.text=data[1]
		label.size=Vector2(128,128)
		label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size",22)
		label.mouse_filter=Control.MOUSE_FILTER_IGNORE
		button.add_child(label)

func _circle(color:Color)->ImageTexture:
	var image:=Image.create(128,128,false,Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	for y in range(128):
		for x in range(128):
			if Vector2(x-64,y-64).length()<63:
				image.set_pixel(x,y,color)
	return ImageTexture.create_from_image(image)
