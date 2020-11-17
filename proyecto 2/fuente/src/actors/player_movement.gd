#Herencia de la clase principal
extends "res://src/actors/CharacterStats.gd"

class_name player_movement

export var rango: int
export var poison: bool

signal completed

#Esta funcion se realiza de forma automatica para preparar las
#variables necesarias
func _ready():
	#Empieza deshabilitando la funcion para que no
	#corra de forma automatica y agrega la conexion al tween
	#que es un elemento que facilita la visualizacion del movimiento
	#junto a la conexion que recibe si este choca con algo
	set_physics_process(false)
	$Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
	connect("body_entered",self,"go_back")
	
#Esta es una funcion default de godot
#lo que hace es estar corriendo en un ciclo constante
#sin hacer un overflow
func _physics_process(delta):
	#En caso de que no se encuentre en movimiento el programa sigue su curso normal
	if !moving:
		#Estas validaciones modifican el blanco que se encuentra en la mira
		#para cuando el jugador quiera atacar se tenga al objetivo
		if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider()==null:
					collider = null
				else:
					collider = $RayCast2D.get_collider()
		else:
			collider = null
		#Esta validacion pregunta si el jugador activo
		#tiene 0 turnos		
		if turnos <= 0:
				turnos = 0 + MaxTurnos
				emit_signal("completed")
				set_physics_process(false)
				
		#Este proceso recibe las signal de la teclas que el jugador presione
		#para ver la direccion en la que se mueve
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
			#Si no hubo movimiento el programa siguen con su curso
			if motion_vector != Vector2():
				#Esta parte realiza el movimiento modificando la posicion y llamando al tween para
				#que realice su animacion
				last_movement=motion_vector
				new_position = position + motion_vector * tile_size
				$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
				moving = true
				motion_vector=Vector2()
			
#Esta funcion envia al jugador en posicion opuesta en caso de que choque con algo
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
	if turnos>MaxTurnos:
		turnos = 0+MaxTurnos
	new_position = position + motion_vector * tile_size
	$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	moving = true
	motion_vector=Vector2()
		
#This function is connected to the tween node's tween_completed signal.
func _on_Tween_tween_completed(object, key):
	moving = false
