extends "res://src/actors/CharacterStats.gd"

class_name player_movement


var moving = false
var  tile_size = 37
var last_movement = Vector2(0,0)
var motion_vector = Vector2()
var turnos = 15
var contar=0
var collider = null
var new_position

export var rango: int
export var Tipo: String

signal completed

func _ready():
	$Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
	connect("body_entered",self,"go_back")
func _physics_process(delta):
	if !moving:
		if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider()==null:
					collider = null
				else:
					collider = $RayCast2D.get_collider()
		else:
			collider = null
				
		if turnos <= 0:
				turnos = 15
				emit_signal("completed")
				set_physics_process(false)
				
				
		else:
			if Input.is_action_pressed("ui_up"):
				motion_vector = Vector2( 0, -1)
				rotation_degrees = 0
				tile_size = 37
				turnos-=1
			if Input.is_action_pressed("ui_down"):
				motion_vector = Vector2( 0, 1)
				rotation_degrees = 180
				tile_size = 37
				turnos-=1
			if Input.is_action_pressed("ui_left"):
				motion_vector = Vector2( -1, 0)
				rotation_degrees = 270
				tile_size = 39
				turnos-=1
			if Input.is_action_pressed("ui_right"):
				motion_vector = Vector2( 1, 0)
				rotation_degrees = 90
				tile_size = 39
				turnos-=1

			if motion_vector != Vector2():
				last_movement=motion_vector
				new_position = position + motion_vector * tile_size
				$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				moving = true
				motion_vector=Vector2()
			
		
func go_back(object):
	if last_movement == Vector2(0,1):
		motion_vector = Vector2( 0, -1)
		tile_size = 13
		turnos+=1
	elif last_movement == Vector2(0,-1):
		motion_vector = Vector2( 0, 1)
		tile_size = 13
		turnos+=1
	elif last_movement == Vector2(-1,0):
		motion_vector = Vector2( 1, 0)
		tile_size = 14
		turnos+=1
	else:
		motion_vector = Vector2( -1, 0)
		tile_size = 14
		turnos+=1
	if turnos>10:
		turnos = 10
	new_position = position + motion_vector * tile_size
	$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	moving = true
	motion_vector=Vector2()
		
#This function is connected to the tween node's tween_completed signal.
func _on_Tween_tween_completed(object, key):
	moving = false
