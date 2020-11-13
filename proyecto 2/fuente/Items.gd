extends RayCast2D

export var Tipo: String
export var item: String
export var picked: bool

export (NodePath) var Resumen
onready var Summary = get_node(Resumen)

export (NodePath) var turn
onready var turns = get_node(turn)

var string

class_name Items

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if get_collider()==null:
		pass
	else:
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
		
