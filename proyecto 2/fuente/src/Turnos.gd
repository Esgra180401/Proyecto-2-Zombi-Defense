extends Node

class_name Turnos

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
	print(personaje_activo)
	personaje_activo.set_physics_process(true)
	
	yield(personaje_activo,"completed")
	
	personaje_activo.set_physics_process(false)
	new_index=(personaje_activo.get_index()+1)
	if new_index==get_child_count():
		new_index = 0
		personaje_activo=get_child(new_index)
		jugar_turno()
	else:
		
		personaje_activo=get_child(new_index)
		jugar_turno()

