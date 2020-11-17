#Herencia de la clase principal
extends "res://src/actors/CharacterStats.gd"

class_name EnemyMovement

#Variables que heredan un objeto de la interfaz
#Estas llaman al nodo por medio de la posicion
export (NodePath) var target1

export (NodePath) var target2

export (NodePath) var target3

export (NodePath) var target4

export (NodePath) var Resumen
onready var sumary = get_node(Resumen)

#Definicion de variables para poder definirlas durante la funcion
var follow
var actual
var sonido1
var sonido2
var sonido3
var string

signal completed

#Esta funcion se realiza de forma automatica para preparar las
#variables necesarias
func _ready():
	#Empieza deshabilitando la funcion para que no
	#corra de forma automatica y agrega la conexion al tween
	#que es un elemento que facilita la visualizacion del movimiento
	set_physics_process(false)
	$Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
	
#Esta es una funcion default de godot
#lo que hace es estar corriendo en un ciclo constante
#sin hacer un overflow
func _physics_process(delta):
	actual = get_position()
	#En caso de que no se encuentre en movimiento el programa sigue su curso normal
	if !moving:
		#Estas variables son los sonidos actuales para buscar el objetivo
		sonido1=get_node(target1).noiseLVL
		sonido2=get_node(target2).noiseLVL
		sonido3=get_node(target3).noiseLVL
		#Esta validacion busca a quien piensa atacar el enemigo
		#En caso de que los ruidos sean 0 el enemigo busca la base
		if sonido1==0 and sonido2==0 and sonido3==0:
			follow = Vector2(408.673,682.429)
		elif sonido1 > sonido2 and sonido1 > sonido3:
			follow = get_node(target1).position
		elif sonido1 < sonido2 and sonido2 > sonido3:
			follow = get_node(target2).position
		else:
			follow = get_node(target3).position
		#Esta validacion pregunta si el enemigo activo
		#tiene 0 turnos
		if turnos <= 0:
			#Al tener 0 turnos, el programa envia una signal que hace que
			#el turno pase al siguiente en la pila
				turnos = 0+MaxTurnos
				emit_signal("completed")
				set_physics_process(false)
		#Esta validacion pregunta si hay un jugador en rango para
		#que el enemigo lo ataque y le aplique el la disminucion de vida
		elif $RayCast2D.is_colliding():
					#De no haber nada el programa sigue con su curso normal
					if $RayCast2D.get_collider()==null:
						collider = null
					#Si se encuentra algo se llama al colicionador para atacarlo y
					#mostrar lo ocurrido en la pantalla de resumen
					else:
						$RayCast2D.get_collider().get_node("Blood Splat").set_emitting(true)
						string = Tipo + " ataco a "+$RayCast2D.get_collider().get_name() +"\n"+$RayCast2D.get_collider().get_name()+" perdio " + str(strenght)+"HP"
						sumary.set_text(string)
						damage(strenght,$RayCast2D.get_collider())
						#Esta validacion pregunta que si el atacante es un trepador
						#el objetivo termine envenenado
						if Tipo=="Trepador":
							$RayCast2D.get_collider().poison=true
						#Esta parte activa el efecto de sonido
						get_node("AtkSFX").play()
						get_node("Attack").set_emitting(true)
						turnos=0
		#Con base a la posicion del objetivo a seguir, el enemigo
		#toma un curso pre definido primero buscando la X y luego la Y
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
		
#This function is connected to the tween node's tween_completed signal
func _on_Tween_tween_completed(object, key):
	moving = false
