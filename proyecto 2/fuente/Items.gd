extends RayCast2D

#Variables que se asignan
#a mano antes de iniciar
export var Tipo: String
export var item: String
export var picked: bool

#Variables que heredan un objeto de la interfaz
#Estas llaman al nodo por medio de la posicion
export (NodePath) var Resumen
onready var Summary = get_node(Resumen)

export (NodePath) var turn
onready var turns = get_node(turn)

#A diferencia de las anteriores estas variables vienen pre definidas
#desde el inicio
var string

class_name Items

#Esta funcion se realiza de forma automatica para preparar las
#variables necesarias
func _ready():
	set_physics_process(true)

#Esta es una funcion default de godot
#lo que hace es estar corriendo en un ciclo constante
#sin hacer un overflow
func _physics_process(delta):
	#Esta validacion pregunta si el item tiene un jugador
	#en su area para que este llame a la funcion de tomar items
	if get_collider()==null:
		pass
	else:
		#Si encuentra a un jugador se pregunta cual de los items obtuvo
		#y se le aplica la funcion para cambiar los stats y se menciona en la
		#pantalla de resumen
		if item=="LVL":
			string=(get_collider().get_name())+" ha subido de\nnivel y obtuvo mas vida"
		elif item=="WPN":
			string=(get_collider().get_name())+" ha obtenido una\nmejora para su arma"
		else:
			string=(get_collider().get_name())+" ha conseguido\nun kit de salud"
		get_collider().get_node("PowerUp").play()
		get_collider().get_node("LVL Up").set_emitting(true)
		Summary.set_text(string)
		get_collider().pick_up(item,get_collider())
		set_visible(false)
		set_physics_process(false)
		picked=true
		turns.actualizar_labels()
		
