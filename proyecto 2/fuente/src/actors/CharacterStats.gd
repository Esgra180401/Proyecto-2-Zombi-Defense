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
		if player.get_name()=="Ranger":
			if player.habilidad == true:
				player.health = 0 + maxH
			else:
				player.health += (player.maxH)/4
				player.inventario -= 1
		else:
			player.health += (player.maxH)/4
			player.inventario -= 1
		if player.health > player.maxH:
			player.health = 0 + player.maxH
			
func pick_up(item,player):
	if item == "LVL":
		player.level += 1
		if player.level==3:
			player.habilidad=true
		if player.get_name()=="Soldado":
			if player.habilidad==true:
				player.maxH += player.maxH/5
				player.health = 0+player.maxH
			else:
				player.maxH += player.maxH/10
				player.health = 0+player.maxH
		else:
			player.maxH += player.maxH/10
			player.health = 0+player.maxH
	elif item == "KIT":
		player.inventario += 1
	else:
		if player.get_name()=="Tanque":
			if player.strenght==250:
				player.get_node("RayCast2D").set_cast_to(Vector2(0,-300))
				player.rango=8
		player.strenght += 10
		
func damage(pwr,target):
	if target.get_name()=="Tanque":
		if target.habilidad==true:
			target.health -= pwr/2
		else:
			target.health -= pwr
			if target.health < 0 :
				target.health = 0
	else:
		target.health -= pwr
		if target.health < 0 :
			target.health = 0
	if target.health == 0 :
		target.dead()
		

func dead():
	life=false
	get_node("Sprite").set_visible(false)
	

