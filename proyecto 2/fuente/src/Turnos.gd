extends Node

class_name Turnos

export (NodePath) var Boton_Atk
onready var BtnAtk = get_node(Boton_Atk)

export (NodePath) var Boton_Cur
onready var BtnCur = get_node(Boton_Cur)

export (NodePath) var Vida1

export (NodePath) var Vida2

export (NodePath) var Vida3

export (NodePath) var LVL1

export (NodePath) var LVL2

export (NodePath) var LVL3

export (NodePath) var kits1

export (NodePath) var kits2

export (NodePath) var kits3

var personaje_activo
var new_index = 0

func _ready():
	preparacion()
	
func preparacion():
	personaje_activo = get_child(new_index)
	personaje_activo.set_physics_process(false)
	new_index +=1
	if new_index==get_child_count():
		new_index = 0
		iniciar()
	else: 
		preparacion()
		
func iniciar():
	personaje_activo = get_child(0)
	jugar_turno()
	
func jugar_turno():
	if personaje_activo.get_name() != "EnemyTimer":
		personaje_activo.set_physics_process(true)
		actualizar_labels()
		yield(personaje_activo,"completed")
	new_index=(personaje_activo.get_index()+1)
	if new_index>2:
		BtnAtk.set_disabled(true)
		BtnCur.set_disabled(true)
	if new_index==get_child_count():
		new_index = 0
		personaje_activo=get_child(new_index)
		BtnAtk.set_disabled(false)
		BtnCur.set_disabled(false)
		var enemy = preload("res://src/actors/Zombie.tscn")
		var e = enemy.instance()
		var pos = Vector2(97.328,203.874)
		e.position = pos
		add_child(e)
		jugar_turno()
		
	else:
		personaje_activo=get_child(new_index)
		jugar_turno()

func actualizar_labels():
	get_node(Vida1).set_text("HP:"+str(get_child(0).health))
	get_node(Vida2).set_text("HP:"+str(get_child(1).health))
	get_node(Vida3).set_text("HP:"+str(get_child(2).health))
	
	get_node(LVL1).set_text("LVL:"+str(get_child(0).level))
	get_node(LVL2).set_text("LVL:"+str(get_child(1).level))
	get_node(LVL3).set_text("LVL:"+str(get_child(2).level))
	
	get_node(kits1).set_text("Kits:"+str(get_child(0).inventario))
	get_node(kits2).set_text("Kits:"+str(get_child(1).inventario))
	get_node(kits3).set_text("Kits:"+str(get_child(2).inventario))
	

