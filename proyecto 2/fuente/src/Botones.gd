extends Node

class_name GUI

#Variables que heredan un objeto de la interfaz
#Estas llaman al nodo por medio de la posicion
export (NodePath) var turn
onready var turns = get_node(turn)

export (NodePath) var BtnAtk
onready var atacar = get_node(BtnAtk)

export (NodePath) var BtnCure
onready var curar = get_node(BtnCure)

export (NodePath) var Resumen
onready var sumary = get_node(Resumen)

var string 

#Esta funcion se realiza de forma automatica para preparar las
#variables necesarias
func _ready():
	#Estas conexiones hacen que el boton necesario llame a la accion
	atacar.connect("pressed", self, "_button_pressed1")
	curar.connect("pressed", self, "_button_pressed2")

#Esta funcion activa el boton de ataque
#Llamando a la funcion damage del jugador que se 
#encuentre activo en el momento y preguntando si hay alguien en el rango
func _button_pressed1():
	if turns.personaje_activo.collider == null:
		pass
	else:
		turns.personaje_activo.noiseLVL=0+turns.personaje_activo.MaxNoise
		string=turns.personaje_activo.get_name() + " ataco a " + turns.personaje_activo.collider.Tipo+"\n"+turns.personaje_activo.collider.Tipo+" perdio "+str(turns.personaje_activo.strenght)+"HP"
		sumary.set_text(string)
		
		#Esta validacion pregunta quien es el atacante para
		#usar la animacion correcta
		if turns.personaje_activo.get_name() == "Tanque":
			turns.personaje_activo.get_node("Tank Shooting").set_emitting(true)
			turns.personaje_activo.get_node("Smoke").set_emitting(true)
			turns.personaje_activo.get_node("Rocket").set_emitting(true)
			turns.personaje_activo.collider.get_node("Explosion").set_emitting(true)
			turns.personaje_activo.collider.get_node("Smoke").set_emitting(true)
		elif turns.personaje_activo.get_name() == "Ranger":
			turns.personaje_activo.collider.get_node("Blood Splat").set_emitting(true)
			turns.personaje_activo.get_node("Bow Shot").set_emitting(true)
		else:
			turns.personaje_activo.collider.get_node("Blood Splat").set_emitting(true)
			turns.personaje_activo.get_node("Soldier Shooting").set_emitting(true)
		turns.personaje_activo.get_node("AtkSFX").play()
		turns.personaje_activo.damage(turns.personaje_activo.strenght,turns.personaje_activo.collider)
		turns.personaje_activo.turnos = 0

#Esta funcion activa el boton de curar parael jugador
#activo en el momento llamando la funcion heal del este
func _button_pressed2():
	if turns.personaje_activo.inventario > 0:
		turns.personaje_activo.get_node("Cure").set_emitting(true)
		turns.personaje_activo.get_node("Heal").play()
		string=turns.personaje_activo.get_name() + " se ha curado "+str((turns.personaje_activo.maxH)/4)+" HP"
		sumary.set_text(string)
		turns.personaje_activo.get_node("Cure").set_emitting(true)
		turns.personaje_activo.heal(turns.personaje_activo)
		turns.personaje_activo.turnos = 0

