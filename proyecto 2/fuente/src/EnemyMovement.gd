extends "res://src/actors/CharacterStats.gd"

export (NodePath) var target1
onready var objetivo = get_node(target1).get_position()

export (NodePath) var posicion
onready var actual = get_node(posicion).get_position()

class_name EnemyMovement


var moving = false
var  tile_size = 37
var last_movement = Vector2(0,0)
var motion_vector = Vector2()
var turnos = 3
var contar=0
var collider = null

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
				
		if turnos <= 0:
				turnos = 3
				emit_signal("completed")
				
				
		else:
			
			#cambiar el motion vector
			
			turnos-=1
			if motion_vector != Vector2():
				last_movement=motion_vector
				var new_position = position + motion_vector * tile_size
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
	if turnos>3:
		turnos = 3
	var new_position = position + motion_vector * tile_size
	$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	moving = true
	motion_vector=Vector2()
		
#This function is connected to the tween node's tween_completed signal.
func _on_Tween_tween_completed(object, key):
	moving = false
