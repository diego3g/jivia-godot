extends Control

onready var emptyBar: = $EmptyBar
onready var fullBar: = $FullBar
onready var max_bar_width: int = emptyBar.rect_size.x

var max_health: = 0

func _ready():
	var hero = get_tree().root.get_node("Root/YSort/Hero")
	
	max_health = hero.stats.max_health
	
	hero.connect("health_changed", self, "_on_player_health_changed")

func _on_player_health_changed(health: int):
	print (health, max_health)
	fullBar.rect_size.x = (max_bar_width / max_health) * health
