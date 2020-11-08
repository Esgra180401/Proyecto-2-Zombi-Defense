extends Area2D

export var health: int
export var strenght: int
export var level: int
export var noiseLVL: int
export var inventario: int
export var maxH: int
export var life: bool

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
func drops(item):
	if item == "lvl":
		level += 1
		maxH += maxH/10
	elif item == "medkit":
		inventario += 1
		if health > maxH:
			health = 0 + maxH
	else:
		strenght += 10
func damage(pwr,target):
	target.health -= pwr
	if target.health < 0 :
		target.health = 0
	

