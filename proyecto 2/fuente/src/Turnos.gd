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

export (NodePath) var pwr1

export (NodePath) var pwr2

export (NodePath) var pwr3

export (NodePath) var rng1

export (NodePath) var rng2

export (NodePath) var rng3

export (NodePath) var Resumen

export (NodePath) var Rounds

export (NodePath) var Bandera

var enemy1 = preload("res://src/actors/Zombie.tscn")
var enemy2= preload("res://src/actors/Zombie Tanque.tscn")
var enemy3 = preload("res://src/actors/Trepador.tscn")
var item1 = preload("res://src/LVL UP.tscn")
var item2 = preload("res://src/KIT UP.tscn")
var item3 = preload("res://src/WPN UP.tscn")

var ItemOptions = [item1,item2,item3]
var EOptions1 = [enemy1,enemy1,enemy1,enemy1,enemy2,enemy3,enemy3]
var EOptions2 = [enemy1,enemy1,enemy2,enemy3,enemy3,enemy3,enemy3]
var EOptions3 = [enemy1,enemy1,enemy2,enemy2,enemy2,enemy2,enemy2,enemy3,enemy3]

var spawned
var sItem

var personaje_activo
var new_index = 0
var ronda = 0

onready var timer = get_node("Timer")
signal timer_end

func _ready():
	timer.connect("timeout",self,"_emit_timer_end_signal")
	preparacion()
	
func preparacion():
	actualizar_labels()
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
	if personaje_activo.get_name()=="Timer":
		pass
	elif personaje_activo.Tipo=="Item":
		pass
	elif personaje_activo.life==false:
		pass
	else:
		personaje_activo.set_physics_process(true)
		yield(personaje_activo,"completed")
		apagar_btn()
		if personaje_activo.get_index()<3:
			esperar(0.8)
		else:
			esperar(0.4)
		yield(self, "timer_end")
	if personaje_activo.get_index()<=2:
		encender_btn()
	actualizar_labels()
	limpiar_zombie()
	limpiar_item()
	is_dead()
	new_index=(personaje_activo.get_index()+1)
	if new_index>2:
		apagar_btn()
	if new_index>=get_child_count():
		if get_node(Bandera).get_node("RayCast2D").get_collider()!=null:
			game_over()
		elif get_child(0).life==false and get_child(1).life==false and get_child(2).life==false:
			game_over()
		else:
			get_child(0).noiseLVL=0
			get_child(1).noiseLVL=0
			get_child(2).noiseLVL=0
			veneno()
			ronda+=1
			actualizar_labels()
			activar_spawns(ronda)
			new_index = 0
			personaje_activo=get_child(new_index)
			encender_btn()
			jugar_turno()
		
	else:
		if get_node(Bandera).get_node("RayCast2D").get_collider()!=null:
			game_over()
		elif get_child(0).life==false and get_child(1).life==false and get_child(2).life==false:
			game_over()
		else:
			personaje_activo=get_child(new_index)
			actualizar_labels()
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
	
	get_node(pwr1).set_text("Poder:"+str(get_child(0).strenght))
	get_node(pwr2).set_text("Poder:"+str(get_child(1).strenght))
	get_node(pwr3).set_text("Poder:"+str(get_child(2).strenght))
	
	get_node(rng1).set_text("Rango:"+str(get_child(0).rango))
	get_node(rng2).set_text("Rango:"+str(get_child(1).rango))
	get_node(rng3).set_text("Rango:"+str(get_child(2).rango))
	
	get_node(Rounds).set_text("Ronda "+str(ronda))
	
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
		
func is_dead():
	if get_child(0).life==false:
		get_child(0).get_node("Collision").set_disabled(true)
	if get_child(1).life==false:
		get_child(1).get_node("Collision").set_disabled(true)
	if get_child(2).life==false:
		get_child(2).get_node("Collision").set_disabled(true)
		
func limpiar_zombie():
	for i in range(get_child_count()):
		if i == 0 or i == 1 or i == 2 or i == 3:
			pass
		elif i >= get_child_count():
			pass
		elif get_child(i).Tipo=="Item":
			pass
		else:
			if get_child(i).life==false:
				drop_item(get_child(i).position)
				remove_child(get_child(i))
				
func limpiar_item():
	for i in range(get_child_count()):
		if i == 0 or i == 1 or i == 2 or i == 3:
			pass
		elif i >= get_child_count():
			pass
		elif get_child(i).Tipo=="Item" and get_child(i).picked==true:
			remove_child(get_child(i))
		else:
			pass
				
func drop_item(pos):
	sItem=ItemOptions[randi() % ItemOptions.size()].instance()
	sItem.position=pos
	add_child(sItem)
				
func esperar(tiempo):
	timer.set_wait_time(tiempo)
	timer.set_timer_process_mode(0)
	timer.start()
func _emit_timer_end_signal():
	emit_signal("timer_end")
	
func pick_up():
	for i in range(get_child_count()):
		if i == 0 or i == 1 or i == 2 or i == 3:
			pass
		elif i >= get_child_count():
			pass
		elif get_child(i).Tipo=="Item":
			if get_child(i).get_collider()!=null:
				print(get_child(i).get_collider())

func apagar_btn():
	BtnAtk.set_disabled(true)
	BtnCur.set_disabled(true)
	
func encender_btn():
	BtnAtk.set_disabled(false)
	BtnCur.set_disabled(false)
	
func veneno():
	if get_child(0).habilidad==false:
		if get_child(0).poison==true:
			if get_child(0).life==true:
				get_child(0).get_node("Blood Splat").set_emitting(true)
				get_child(0).damage(15,get_child(0))
				get_child(0).poison=false
	if get_child(1).poison==true:
		if get_child(1).life==true:
			get_child(1).get_node("Blood Splat").set_emitting(true)
			get_child(1).damage(15,get_child(1))
			get_child(1).poison=false
	if get_child(2).poison==true:
		if get_child(2).life==true:
			get_child(2).get_node("Blood Splat").set_emitting(true)
			get_child(2).damage(15,get_child(2))
			get_child(2).poison=false
