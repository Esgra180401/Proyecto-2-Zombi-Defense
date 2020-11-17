#Extencion del nodo Area2D
extends Area2D

class_name CharacterStats

#Atributos principales que tanto jugadores
#como enemigos heredan solo que estas se le asignan
#a mano antes de iniciar
export var health: int
export var strenght: int
export var level: int
export var noiseLVL: int
export var MaxNoise: int
export var inventario: int
export var maxH: int
export var life: bool
export var habilidad: bool
export var turnos: int
export var MaxTurnos: int
export var Tipo: String
#A diferencia de las anteriores estas variables vienen pre definidas
#desde el inicio
var moving = false
var new_position
var  tile_size = 37
var last_movement = Vector2(0,0)
var motion_vector = Vector2()
var collider = null

#Esta funcion cura al jugador cuando este lo decida
#siempre y cuando tenga suficientes kits
func heal(player):
	if player.inventario > 0:
		#Esta validacion revisa que si el que se
		#cura es el ranger, este otenga toda su vida
		#devuelta dependiendo de su habilidad
		if player.get_name()=="Ranger":
			if player.habilidad == true:
				player.health = 0 + maxH
			else:
				player.health += (player.maxH)/4
				player.inventario -= 1
		else:
			player.health += (player.maxH)/4
			player.inventario -= 1
		if player.health > player.maxH:
			player.health = 0 + player.maxH

#Esta funcion agrega a los stats del jugador
#el item que se obtuvo
func pick_up(item,player):
	if item == "LVL":
		player.level += 1
		if player.level==3:
			player.habilidad=true
		#Esta validacion revisa que si el que sube
		#nivel es el soldado, este recibe el doble
		#de beneficio dependiendo de su habilidad
		if player.get_name()=="Soldado":
			if player.habilidad==true:
				player.maxH += player.maxH/5
				player.health = 0+player.maxH
			else:
				player.maxH += player.maxH/10
				player.health = 0+player.maxH
		else:
			player.maxH += player.maxH/10
			player.health = 0+player.maxH
	elif item == "KIT":
		player.inventario += 1
	else:
		#Esta validacion revisa que si el que obtiene
		#la mejora de arma es el tanque, este recibira una
		#mejora especial a su arma
		if player.get_name()=="Tanque":
			if player.strenght==250:
				player.get_node("RayCast2D").set_cast_to(Vector2(0,-300))
				player.rango=8
		player.strenght += 10

#Esta funcion hace que el target que fue atacado
#se le disminuya la vida necesaria
func damage(pwr,target):
	#Esta validacion revisa que si el que es atacado
	#es el tanque, este recibira la mitad del golpe
	if target.get_name()=="Tanque":
		if target.habilidad==true:
			target.health -= pwr/2
		else:
			target.health -= pwr
		if target.health < 0 :
			target.health = 0
	else:
		target.health -= pwr
		if target.health < 0 :
			target.health = 0
	#Esta validacion revisa que si la salud del target
	#llega a, 0 este muere y llama a la funcion dead
	if target.health == 0 :
		target.dead()
		
#Esta funcion saca al target muerto del tablero
func dead():
	life=false
	get_node("Sprite").set_visible(false)
	

