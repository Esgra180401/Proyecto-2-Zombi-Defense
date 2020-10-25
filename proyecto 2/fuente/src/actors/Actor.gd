extends KinematicBody2D
class_name Actor

func _physics_process(delta: float) -> void:
	var velocity: = Vector2(0,-50)
	move_and_slide(velocity)
