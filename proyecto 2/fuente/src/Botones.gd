extends Node
export (NodePath) var turn
onready var turns = get_node(turn)

export (NodePath) var BtnAtk
onready var atacar = get_node(BtnAtk)

export (NodePath) var BtnCure
onready var curar = get_node(BtnCure)

export (NodePath) var Resumen
onready var sumary = get_node(Resumen)

var string 

func _ready():
	atacar.connect("pressed", self, "_button_pressed1")
	curar.connect("pressed", self, "_button_pressed2")
	
func _button_pressed1():
	if turns.personaje_activo.collider == null:
		print("miss")
	else:
		string=turns.personaje_activo.get_name() + " ataco a " + turns.personaje_activo.collider.get_name()+"\n"+turns.personaje_activo.collider.get_name()+" perdio "+str(turns.personaje_activo.strenght)+"HP"
		sumary.set_text(string)
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
		turns.personaje_activo.damage(turns.personaje_activo.strenght,turns.personaje_activo.collider)
		turns.personaje_activo.turnos = 0
	
func _button_pressed2():
	if turns.personaje_activo.inventario > 0:
		string=turns.personaje_activo.get_name() + " se ha curado "+str((turns.personaje_activo.maxH)/4)+" HP"
		sumary.set_text(string)
		turns.personaje_activo.get_node("Cure").set_emitting(true)
		turns.personaje_activo.heal(turns.personaje_activo)
		turns.personaje_activo.turnos = 0

