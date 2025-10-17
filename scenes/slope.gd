extends StaticBody2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _process(_delta: float) -> void:
	collision_polygon_2d.disabled= ray_cast_2d.is_colliding()
