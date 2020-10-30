extends Node

class_name Turnos

var personaje_activo
var new_index = 0

func _ready():
	iniciar()

func iniciar():
	personaje_activo = get_child(0)
	jugar_turno()
	
	
func jugar_turno():
	print(personaje_activo)
	print(new_index)
	new_index=(personaje_activo.get_index()+1)
	personaje_activo=get_child(new_index)
	if new_index==get_child_count():
		pass
	else:
		if new_index!=get_child_count():
			jugar_turno()

