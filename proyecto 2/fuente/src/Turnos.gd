extends Node

class_name Turnos

#Variables que heredan un objeto de la interfaz
#Estas llaman al nodo por medio de la posicion
export (NodePath) var Boton_Atk
onready var BtnAtk = get_node(Boton_Atk)

export (NodePath) var Boton_Cur
onready var BtnCur = get_node(Boton_Cur)

export (NodePath) var turnoA

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

export (NodePath) var stt1

export (NodePath) var stt2

export (NodePath) var stt3

export (NodePath) var Resumen

export (NodePath) var Rounds

export (NodePath) var Bandera

#Esta variables son escenas que se utilizan
#para spawnear los enemigos
var enemy1 = preload("res://src/actors/Zombie.tscn")
var enemy2= preload("res://src/actors/Zombie Tanque.tscn")
var enemy3 = preload("res://src/actors/Trepador.tscn")
var item1 = preload("res://src/LVL UP.tscn")
var item2 = preload("res://src/KIT UP.tscn")
var item3 = preload("res://src/WPN UP.tscn")
#Esta variables son los arrays para tomar de forma aleatoria un enemigo
#para spawnear
var ItemOptions = [item1,item2,item3]
var EOptions1 = [enemy1,enemy1,enemy1,enemy1,enemy2,enemy3,enemy3]
var EOptions2 = [enemy1,enemy1,enemy2,enemy3,enemy3,enemy3,enemy3]
var EOptions3 = [enemy1,enemy1,enemy2,enemy2,enemy2,enemy2,enemy2,enemy3,enemy3]
#Definicion de variables para poder definirlas durante la funcion
var spawned
var sItem
var personaje_activo
var new_index = 0
var ronda = 0
onready var timer = get_node("Timer")
signal timer_end

#Esta funcion se realiza de forma automatica para preparar las
#variables necesarias
func _ready():
	timer.connect("timeout",self,"_emit_timer_end_signal")
	preparacion()

#Esta funcion busca al primer jugador y prepara las variables para empezar
#a recorrer la pila de turnos
func preparacion():
	personaje_activo = get_child(new_index)
	personaje_activo.set_physics_process(false)
	new_index +=1
	if new_index==get_child_count():
		new_index = 0
		iniciar()
	else: 
		preparacion()

#Esta funcion hace las ultimas preparaciones para emepzar
func iniciar():
	personaje_activo = get_child(0)
	actualizar_labels()
	jugar_turno()

#Esta es la funcion principal, esta lleva a cabo los turnos de los personajes
#y enemigos que se encuentren en la pila
func jugar_turno():
	#Esta validacion pregunta que el objeto de la pila no se el timer o un item
	#o si es un jugador muerto
	if personaje_activo.get_name()=="Timer":
		pass
	elif personaje_activo.Tipo=="Item":
		pass
	elif personaje_activo.life==false:
		pass
	else:
		#Al encontrar un objeto disponible para jugar, activa la funcion de movimiento
		#y realiza un stop hasta que el objeto mande un signal de que ya puede continuar
		personaje_activo.set_physics_process(true)
		yield(personaje_activo,"completed")
		apagar_btn()
		#Esto es una espera corta para que todo ocurra de forma ordenada
		if personaje_activo.get_index()<3:
			esperar(0.8)
		else:
			esperar(0.4)
		#Esta parte espera el signal del temporizador para continuar
		yield(self, "timer_end")
	#Esta validacion prende los botones si el jugador es humano
	if personaje_activo.get_index()<=2:
		encender_btn()
	#Aca se llaman las funciones necesarias para limpiar y actualizar la interfaz
	actualizar_labels()
	limpiar_zombie()
	limpiar_item()
	is_dead()
	new_index=(personaje_activo.get_index()+1)
	#Esta validacion apaga los botones si el jugador es zombie
	if new_index>2:
		apagar_btn()
	#Aca se valida que se haya llegado al final de la pila para empezar devuelta
	#el proceso de turnos y resetea los valores, de no ser el caso
	#simplemente continua viajando por la pila
	if new_index>=get_child_count():
		#Estas validaciones verifican que no haya nada en la
		#bandera o que los jugadores sigan vivos
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
			activar_spawns(ronda)
			new_index = 0
			personaje_activo=get_child(new_index)
			actualizar_labels()
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

#Esta funcion actualiza los valores de la interfaz grafica para
#que se de la info de lo que esta ocurriendo y de lo que ha pasado
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
	
	if get_child(0).poison==true:
		get_node(stt1).set_text("ENVENENADO")
	else:
		get_node(stt1).set_text("")
		
	if get_child(1).poison==true:
		get_node(stt2).set_text("ENVENENADO")
	else:
		get_node(stt2).set_text("")
		
	if get_child(2).poison==true:
		get_node(stt3).set_text("ENVENENADO")
	else:
		get_node(stt3).set_text("")
		
	if get_child(0).life!=true:
		get_node(stt1).set_text("")
		
	if get_child(1).life!=true:
		get_node(stt2).set_text("")
		
	if get_child(2).life!=true:
		get_node(stt3).set_text("")
	
	if personaje_activo.get_name()=="Timer":
		pass
	elif personaje_activo.Tipo == "Humano":
		get_node(turnoA).set_text("Turno de:"+str(personaje_activo.get_name()))
	elif personaje_activo.Tipo=="Zombie" or personaje_activo.Tipo=="Trepador" or personaje_activo.Tipo=="Zombie Tanque":
		get_node(turnoA).set_text("Turno de:Zombies")
	
	get_node(Rounds).set_text("Ronda "+str(ronda))

#Esta funcion termina el juego y cierra la pila para que el programa se detenga
func game_over():
	BtnAtk.set_disabled(true)
	BtnCur.set_disabled(true)
	get_node(Resumen).set_text("Game Over\n"+"Has sobrevivido "+str(ronda)+" rondas")	

#Esta funcion activa los spawns al final de cada ronda con un zombie aleatorio
func activar_spawns(rounds):
	#Esto valida el numero de ronda para saber cuantos spawns toca activar
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

#Esta funcion revisa que los jugadores sigan vivos, de no ser el caso les
#desactiva las colisiones para que no se pueda interactuar con ellos
func is_dead():
	if get_child(0).life==false:
		get_child(0).get_node("Collision").set_disabled(true)
	if get_child(1).life==false:
		get_child(1).get_node("Collision").set_disabled(true)
	if get_child(2).life==false:
		get_child(2).get_node("Collision").set_disabled(true)

#Esta funcion limpia los zombies que esten muertos para que la pila
#se mantenga limpia y no se sobrecargue
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

#Esta funcion limpia los items que se han agarrado para que la pila
#se mantenga limpia y no se sobrecargue
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

#Esta funcion hace que el zombie que murio deje un item en su lugar cuando
#este se elimina de la pila			
func drop_item(pos):
	sItem=ItemOptions[randi() % ItemOptions.size()].instance()
	sItem.position=pos
	add_child(sItem)

#Esta funcion activa el timer de espera				
func esperar(tiempo):
	timer.set_wait_time(tiempo)
	timer.set_timer_process_mode(0)
	timer.start()
#Esta funcion emite la signal del timer
func _emit_timer_end_signal():
	emit_signal("timer_end")

#Esta funcion apaga los botones
func apagar_btn():
	BtnAtk.set_disabled(true)
	BtnCur.set_disabled(true)
#Esta funcion enciende los botones
func encender_btn():
	BtnAtk.set_disabled(false)
	BtnCur.set_disabled(false)

#Esta funcion revisa cuales jugadores han sido envenenados para disminuir
#su salud y elimnar el veneno
func veneno():
	#Esta validacion pregunta que si el soldado tiene su habilidad
	#(anti veneno) activa para evitar el golpe
	if get_child(0).habilidad==false:
		if get_child(0).poison==true:
			if get_child(0).life==true:
				get_child(0).get_node("Poison Splat").set_emitting(true)
				get_child(0).damage(15,get_child(0))
				get_child(0).poison=false
	if get_child(1).poison==true:
		if get_child(1).life==true:
			get_child(1).get_node("Poison Splat").set_emitting(true)
			get_child(1).damage(15,get_child(1))
			get_child(1).poison=false
	if get_child(2).poison==true:
		if get_child(2).life==true:
			get_child(2).get_node("Poison Splat").set_emitting(true)
			get_child(2).damage(15,get_child(2))
			get_child(2).poison=false
