extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D

var hero;

func _ready():
	hero = load("res://Hero.tscn").instance();
	
	hero.set_position(Vector2(64, 64));
	
	add_child(hero);

	
