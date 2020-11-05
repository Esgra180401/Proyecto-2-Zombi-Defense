extends Node
export (NodePath) var turn
onready var turns = get_node(turn)

export (NodePath) var BtnAtk
onready var atacar = get_node(BtnAtk)

export (NodePath) var BtnCure
onready var curar = get_node(BtnCure)

func _ready():
	atacar.connect("pressed", self, "_button_pressed1")
	curar.connect("pressed", self, "_button_pressed2")
	
func _button_pressed1():
	if turns.personaje_activo.collider == null:
		print("miss")
	else:
		turns.personaje_activo.damage(turns.personaje_activo.strenght,turns.personaje_activo.collider)
		turns.personaje_activo.turnos -= 1
	
func _button_pressed2():
	turns.personaje_activo.heal(turns.personaje_activo)
	turns.personaje_activo.turnos -= 1
