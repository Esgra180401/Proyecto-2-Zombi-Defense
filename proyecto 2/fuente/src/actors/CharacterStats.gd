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
func heal():
	if inventario > 0:
		health += maxH/4
		if health > maxH:
			health = 0 + maxH
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
func damage(pwr):
	health-=pwr
	if health < 0 :
		health = 0
	

