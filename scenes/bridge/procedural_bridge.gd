extends Node2D

const BRIDGE_START = preload("uid://dout5j222w1fi")
const BRIDGE_MIDDLE = preload("uid://tqluu64lqphx")
const BRIDGE_END = preload("uid://70ysmamilagu")

const BRIDGE_MIDDLE_LENGTH := 48
const BRIDGE_SOFTNESS := 0.2

#@export var length:int = 3 :
	#set(v):
		#length = v
		#init(v)

var length := 5

var bridge_nodes: Array[RigidBody2D] = []


func _ready() -> void:
	init(length)

func init(length: int) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	var new_start: RigidBody2D = BRIDGE_START.instantiate()
	new_start.freeze = true
	bridge_nodes.append(new_start)
	add_child(new_start)
	new_start.position = Vector2.ZERO
	
	for i in length:
		var new_middle: RigidBody2D = BRIDGE_MIDDLE.instantiate()
		bridge_nodes.append(new_middle)
		add_child(new_middle)
		new_middle.position.x = (i + 0.5) * BRIDGE_MIDDLE_LENGTH
		new_middle.position.y = 0
		
		@warning_ignore("confusable_local_declaration")
		var pin_joint := PinJoint2D.new()
		new_middle.add_child(pin_joint)
		pin_joint.position.x = - BRIDGE_MIDDLE_LENGTH * 0.5
		
		pin_joint.softness = BRIDGE_SOFTNESS
		
		pin_joint.node_a = bridge_nodes[i].get_path()
		pin_joint.node_b = bridge_nodes[i + 1].get_path()
	
	var new_end: RigidBody2D = BRIDGE_END.instantiate()
	new_end.freeze = true
	bridge_nodes.append(new_end)
	add_child(new_end)
	new_end.position = Vector2(length * BRIDGE_MIDDLE_LENGTH, 0)

	var pin_joint := PinJoint2D.new()
	new_end.add_child(pin_joint)
	pin_joint.position = Vector2.ZERO
	
	pin_joint.softness = BRIDGE_SOFTNESS
	pin_joint.node_a = bridge_nodes[-2].get_path()
	pin_joint.node_b = bridge_nodes[-1].get_path()

	print(bridge_nodes)
