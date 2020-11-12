extends "res://src/actors/CharacterStats.gd"

export (NodePath) var target1

export (NodePath) var target2

export (NodePath) var target3

export (NodePath) var target4


export (NodePath) var Resumen
onready var sumary = get_node(Resumen)

export var turnos: int
export var MaxTurnos: int
export var Tipo: String

class_name EnemyMovement


var moving = false
var  tile_size = 37
var last_movement = Vector2(0,0)
var motion_vector = Vector2()
var contar=0
var collider = null
var follow
var actual
var new_position
var sonido1
var sonido2
var sonido3
var string

signal completed

func _ready():
	set_physics_process(false)
	$Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
func _physics_process(delta):

	actual = get_position()
	if !moving:
		sonido1=get_node(target1).noiseLVL
		sonido2=get_node(target2).noiseLVL
		sonido3=get_node(target3).noiseLVL
		
		if sonido1==0 and sonido2==0 and sonido3==0:
			follow = Vector2(408.673,682.429)
		elif sonido1 > sonido2 and sonido1 > sonido3:
			follow = get_node(target1).position
		elif sonido1 < sonido2 and sonido2 > sonido3:
			follow = get_node(target2).position
		else:
			follow = get_node(target3).position
		
		if turnos <= 0:
				turnos = 0+MaxTurnos
				emit_signal("completed")
				set_physics_process(false)
				
		elif $RayCast2D.is_colliding():
					if $RayCast2D.get_collider()==null:
						collider = null
					else:
						$RayCast2D.get_collider().get_node("Blood Splat").set_emitting(true)
						string = Tipo + " ataco a "+$RayCast2D.get_collider().get_name() +"\n"+$RayCast2D.get_collider().get_name()+" perdio " + str(strenght)+"HP"
						sumary.set_text(string)
						damage(strenght,$RayCast2D.get_collider())
						get_node("Attack").set_emitting(true)
						turnos=0
		else:
			if actual[0]<follow[0]-30:
				motion_vector = Vector2( 1, 0)
				rotation_degrees = 90
				tile_size = 39
				turnos-=1
			elif actual[0]>follow[0]+30:
				motion_vector = Vector2( -1, 0)
				rotation_degrees = 270
				tile_size = 39
				turnos-=1
			elif actual[1]<follow[1]-30:
				motion_vector = Vector2( 0, 1)
				rotation_degrees = 180
				tile_size = 37
				turnos-=1
			elif actual[1]>follow[1]+30:
				motion_vector = Vector2( 0, -1)
				rotation_degrees = 0
				tile_size = 37
				turnos-=1
			else:
				motion_vector = Vector2(0,0)
				turnos-=1
			if motion_vector != Vector2():
				if $RayCast2D.is_colliding():
					if $RayCast2D.get_collider()==null:
						collider = null
					else:
						string = Tipo + " ataco a "+$RayCast2D.get_collider().get_name() +"\n"+$RayCast2D.get_collider().get_name()+" perdio " + strenght+"HP"
						sumary.set_text(string)
						damage(strenght,$RayCast2D.get_collider())
						get_node("Attack").set_emitting(true)
						turnos=0
				else:		
					last_movement=motion_vector
					new_position = position + motion_vector * tile_size
					$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					$Tween.start()
					moving = true
					motion_vector=Vector2()
		
#This function is connected to the tween node's tween_completed signal.
func _on_Tween_tween_completed(object, key):
	moving = false
