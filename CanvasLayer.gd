extends CanvasLayer

onready var nav_2d: Navigation2D = $Navigation2D

var hero;

func _ready():
	hero = load("res://Hero.tscn").instance();
	
	hero.set_position(Vector2(64, 64));
	
	add_child(hero);

func _input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
		
	var new_path : = nav_2d.get_simple_path(hero.global_position, get_parent().get_global_mouse_position())
	
	hero.path = new_path
	
