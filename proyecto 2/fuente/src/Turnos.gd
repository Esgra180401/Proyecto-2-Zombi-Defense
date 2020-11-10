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

export (NodePath) var Resumen

export (NodePath) var Bandera

var enemy1 = preload("res://src/actors/Zombie.tscn")
var enemy2= preload("res://src/actors/Zombie Tanque.tscn")
var enemy3 = preload("res://src/actors/Trepador.tscn")

var EOptions1 = [enemy1,enemy1,enemy1,enemy1,enemy2,enemy3,enemy3]
var EOptions2 = [enemy1,enemy1,enemy2,enemy3,enemy3,enemy3,enemy3]
var EOptions3 = [enemy1,enemy1,enemy2,enemy2,enemy2,enemy2,enemy2,enemy3,enemy3]

var spawned

var personaje_activo
var new_index = 0
var ronda = 0

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
	print(get_child(0).life)
	if new_index==get_child_count():
		if get_node(Bandera).get_node("RayCast2D").get_collider()!=null:
			game_over()
		elif get_child(0).life==false and get_child(1).life==false and get_child(2).life==false:
			game_over()
		else:
			get_child(0).noiseLVL=0
			get_child(1).noiseLVL=0
			get_child(2).noiseLVL=0
			ronda+=1
			activar_spawns(ronda)
			new_index = 0
			personaje_activo=get_child(new_index)
			BtnAtk.set_disabled(false)
			BtnCur.set_disabled(false)
			jugar_turno()
		
	else:
		if get_node(Bandera).get_node("RayCast2D").get_collider()!=null:
			game_over()
		elif get_child(0).life==false and get_child(1).life==false and get_child(2).life==false:
			game_over()
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
	
func game_over():
	BtnAtk.set_disabled(true)
	BtnCur.set_disabled(true)
	get_node(Resumen).set_text("Game Over\n"+"Has sobrevivido "+str(ronda)+" rondas")	
	
func activar_spawns(rounds):
	if rounds>=1:
		if rounds==1:
			get_node(Resumen).set_text("Se ha activado un\nnuevo spawn\n\nMas enemigos en camino!!")
		spawned=EOptions1[randi() % EOptions1.size()].instance()
		spawned.position = Vector2(97.328,203.874)
		spawned.rotation_degrees = 90
		add_child(spawned)
	if rounds>=2:
		if rounds==2:
			get_node(Resumen).set_text("Se ha activado un\nnuevo spawn\n\nMas enemigos en camino!!")
		spawned=EOptions1[randi() % EOptions1.size()].instance()
		spawned.position = Vector2(955.642,203.874)
		spawned.rotation_degrees = 270
		add_child(spawned)
	if rounds>=5:
		if rounds==5:
			get_node(Resumen).set_text("Se ha activado un\nnuevo spawn\n\nMas enemigos en camino!!")
		spawned=EOptions2[randi() % EOptions1.size()].instance()
		spawned.position = Vector2(252.672,18.805)
		spawned.rotation_degrees = 180
		add_child(spawned)
	if rounds>=6:
		if rounds==6:
			get_node(Resumen).set_text("Se ha activado un\nnuevo spawn\n\nMas enemigos en camino!!")
		spawned=EOptions2[randi() % EOptions1.size()].instance()
		spawned.position = Vector2(799.901,18.805)
		spawned.rotation_degrees = 180
		add_child(spawned)
	if rounds>=8:
		if rounds==8:
			get_node(Resumen).set_text("Se ha activado un\nnuevo spawn\n\nMas enemigos en camino!!")
		spawned=EOptions3[randi() % EOptions1.size()].instance()
		spawned.position = Vector2(525.5,55.981)
		spawned.rotation_degrees = 180
		add_child(spawned)
