extends Area2D

class_name player_movement

var moving = false
var  tile_size = 37
var last_movement = Vector2(0,0)
var motion_vector = Vector2()

func _ready():
	$Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
	connect("body_entered",self,"go_back")
func _physics_process(delta):
	
	
	if !moving:
		
		if Input.is_action_pressed("ui_up"):
			motion_vector = Vector2( 0, -1)
			#rotation_degrees = 0
			tile_size = 37
		if Input.is_action_pressed("ui_down"):
			motion_vector = Vector2( 0, 1)
			#rotation_degrees = 180
			tile_size = 37
		if Input.is_action_pressed("ui_left"):
			motion_vector = Vector2( -1, 0)
			#rotation_degrees = 260
			tile_size = 39
		if Input.is_action_pressed("ui_right"):
			motion_vector = Vector2( 1, 0)
			#rotation_degrees = 90
			tile_size = 39

		if motion_vector != Vector2():
			last_movement=motion_vector
			var new_position = position + motion_vector * tile_size
			$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			#That last method's fifth property is how long it takes to go from one tile to the other in seconds.
			$Tween.start()
			moving = true
			motion_vector=Vector2()
			
			
	
func go_back(object):
	if last_movement == Vector2(0,1):
		motion_vector = Vector2( 0, -1)
		tile_size = 13
	elif last_movement == Vector2(0,-1):
		motion_vector = Vector2( 0, 1)
		tile_size = 13
	elif last_movement == Vector2(-1,0):
		motion_vector = Vector2( 1, 0)
		tile_size = 14
	else:
		motion_vector = Vector2( -1, 0)
		tile_size = 14
	var new_position = position + motion_vector * tile_size
	$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	moving = true
	motion_vector=Vector2()
		
#This function is connected to the tween node's tween_completed signal.
func _on_Tween_tween_completed(object, key):
	moving = false
