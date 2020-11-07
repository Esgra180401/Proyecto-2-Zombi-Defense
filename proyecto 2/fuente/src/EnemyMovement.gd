extends "res://src/actors/CharacterStats.gd"

export (NodePath) var target1

export (NodePath) var target2

export (NodePath) var target3

export (NodePath) var target4

export (NodePath) var posicion

class_name EnemyMovement


var moving = false
var  tile_size = 37
var last_movement = Vector2(0,0)
var motion_vector = Vector2()
var turnos = 5
var contar=0
var collider = null
var follow
var actual
var new_position
var sonido1
var sonido2
var sonido3

signal completed

func _ready():
	$Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
	connect("body_entered",self,"go_back")
func _physics_process(delta):
	print("procesing")
	actual = get_node(posicion).get_position()
	if !moving:
		print(get_node(posicion))
		print("moving")
		if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider()==null:
					collider = null
				else:
					damage(get_node(posicion).strenght,$RayCast2D.get_collider())
					turnos=0
		sonido1=get_node(target1).noiseLVL
		sonido2=get_node(target2).noiseLVL
		sonido3=get_node(target3).noiseLVL
		
		if sonido1==0 and sonido2==0 and sonido3==0:
			follow = get_node(target4)
		elif sonido1 > sonido2 and sonido1 > sonido3:
			follow = get_node(target1)
		elif sonido1 < sonido2 and sonido2 > sonido3:
			follow = get_node(target2)
		else:
			follow = get_node(target3)
		
		if turnos <= 0:
				turnos = 5
				emit_signal("completed")
				set_physics_process(false)
		else:
			
			if actual[0]<(follow.get_position())[0]-30:
				motion_vector = Vector2( 1, 0)
				rotation_degrees = 90
				tile_size = 39
				turnos-=1
			elif actual[0]>(follow.get_position())[0]+30:
				motion_vector = Vector2( -1, 0)
				rotation_degrees = 270
				tile_size = 39
				turnos-=1
			elif actual[1]<(follow.get_position())[0]-30:
				motion_vector = Vector2( 0, 1)
				rotation_degrees = 180
				tile_size = 37
				turnos-=1
			elif actual[1]>(follow.get_position())[0]+30:
				motion_vector = Vector2( 0, -1)
				rotation_degrees = 0
				tile_size = 37
				turnos-=1
			if motion_vector != Vector2():
				last_movement=motion_vector
				new_position = position + motion_vector * tile_size
				$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				moving = true
				motion_vector=Vector2()
			
		
func go_back(object):
	pass
		
#This function is connected to the tween node's tween_completed signal.
func _on_Tween_tween_completed(object, key):
	moving = false
