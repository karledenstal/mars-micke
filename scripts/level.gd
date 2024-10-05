extends Node2D

@export var next_level: PackedScene = null
@export var level_time = 5
@export var is_final_level = false

@onready var start_platform = $Start
@onready var exit_area = $Exit
@onready var deathzone = $Deathzone
@onready var hud = $UI/HUD
@onready var ui_layer = $UI

var player = null

var timer_node = null
var time_left

var win = false

func _ready():
	var traps = get_tree().get_nodes_in_group("traps")
	player = get_tree().get_first_node_in_group("player")
	
	if player != null:
		player.global_position = start_platform.get_spawn_pos()
	
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
		
	exit_area.body_entered.connect(_on_exit_body_entered)
	deathzone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.autostart = true
	timer_node.timeout.connect(_on_level_timer_timeout)
	
	add_child(timer_node)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(body: Node2D) -> void:
	AudioPlayer.play_sfx("hurt")
	reset_player()

func _on_trap_touched_player() -> void:
	AudioPlayer.play_sfx("hurt")
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start_platform.get_spawn_pos()

func _on_level_timer_timeout():
	if !win:
		time_left -= 1
		hud.set_time_label(time_left)
		
		if time_left < 0:
			AudioPlayer.play_sfx("hurt")
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)

func _on_exit_body_entered(body: Node2D) -> void:
	if body is Player:
		exit_area.animate()
		player.active = false
		win = true
		
		ui_layer.show_win_screen(is_final_level)

		if next_level != null:
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_packed(next_level)
