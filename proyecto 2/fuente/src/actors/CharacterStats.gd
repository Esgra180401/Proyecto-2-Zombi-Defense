extends Area2D

class_name CharacterStats

export var health: int
export var strenght: int
export var level: int
export var noiseLVL: int
export var MaxNoise: int
export var inventario: int
export var maxH: int
export var life: bool
export var habilidad: bool

func alive():
	if health == 0:
		life = false
func heal(player):
	if player.inventario > 0:
		player.health += (player.maxH)/4
		player.inventario -= 1
		player.turnos -= 1
		if player.health > player.maxH:
			player.health = 0 + player.maxH
			
func pick_up(item):
	if item == "LVL":
		level += 1
		if level==3:
			habilidad=true
		maxH += maxH/10
		health = 0+maxH
	elif item == "KIT":
		inventario += 1
	else:
		strenght += 10
		
func damage(pwr,target):
	target.health -= pwr
	if target.health < 0 :
		target.health = 0
	if target.health == 0 :
		target.dead()
		

func dead():
	life=false
	get_node("Sprite").set_visible(false)
	

