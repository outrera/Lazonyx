extends Node2D

export var move_speed = Vector2(450, 0)
export var max_horizontal_speed = 600
export var max_vertical_speed = 1050

onready var body    = get_node("body")
onready var hit_box = get_node("hit box")

# 1 = right, -1 = left
var direction = 1

signal entered_goal

#delete this comment
func _ready():
	body.set_pos(Vector2(0,0))
	body.connect("body_enter", self, "_body_enter")
	set_fixed_process(true)
	pass

func _body_enter(other_body):
	if other_body.is_in_group("enemy_direction_switchers"):
		change_direction()
	if other_body.is_in_group("goals"):
		emit_signal("entered_goal", self.body)
	
	
func die():
	get_parent().enemy_died(body.get_global_pos(),body.get_linear_velocity())
	queue_free()

func explode():
	get_parent().enemy_exploded()
	queue_free()

func change_direction():
	direction *= -1

	
func _fixed_process(delta):
	if body.get_global_pos().y > (get_viewport().get_rect().size.y + 100):
		explode()
	setxvel(max_horizontal_speed * direction)
	body.set_rot(0)
	hit_box.set_pos(body.get_pos())
	pass
	
# add x velocity
func addxvel(amount):
	var current_vel = body.get_linear_velocity()
	var current_y_vel = current_vel.y
	var new_vel = current_vel + Vector2(amount,0)
	new_vel.x = clamp(new_vel.x,-max_horizontal_speed, max_horizontal_speed)
	body.set_linear_velocity(new_vel)

# add y velocity
func addyvel(amount):
	var current_vel = body.get_linear_velocity()
	var current_x_vel = current_vel.x
	var new_vel = current_vel + Vector2(0,amount)
	new_vel.y = clamp(new_vel.y,-max_vertical_speed, max_vertical_speed)
	body.set_linear_velocity(new_vel)
	
# set x velocity
func setxvel(amount):
	body.set_linear_velocity(Vector2(amount,body.get_linear_velocity().y))
