extends Sprite

class_name CharacterStats

export var health: int
export var strenght: int
export var level: int
export var noiseLVL: int
export var atkrange: int

var moving = false
var  tile_size = 37

func _physics_process(delta):
	
	if !moving:
		var motion_vector = Vector2()
		if Input.is_action_pressed("ui_up"):
			motion_vector += Vector2( 0, -1)
			tile_size = 37
		if Input.is_action_pressed("ui_down"):
			motion_vector += Vector2( 0, 1)
			tile_size = 37
		if Input.is_action_pressed("ui_left"):
			motion_vector += Vector2( -1, 0)
			tile_size = 39
		if Input.is_action_pressed("ui_right"):
			motion_vector += Vector2( 1, 0)
			tile_size = 39

		if motion_vector != Vector2():
		
			var new_position = position + motion_vector * tile_size
			
			$Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
			$Tween.interpolate_property ( self, 'position', position, new_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			#That last method's fifth property is how long it takes to go from one tile to the other in seconds.
			$Tween.start()
			moving = true
			
			
	

#This function is connected to the tween node's tween_completed signal.
func _on_Tween_tween_completed(object, key):
	moving = false
	
	

