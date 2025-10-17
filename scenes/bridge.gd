extends RigidBody2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var basic_factor: float
@export var velocity_factor: float


func _ready() -> void:
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	collision_shape_2d.one_way_collision = true
	add_to_group("fall_through_platforms")

func _on_area_2d_body_entered(body: CharacterBody2D):
	var impulse_direction := (global_position - body.global_position).normalized()
	var impulse := (basic_factor + velocity_factor * body.velocity.y) * impulse_direction
	
	apply_impulse(impulse, Vector2.ZERO)
