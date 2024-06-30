extends MenuManager
class_name Menu

@export var player_status_scene: PackedScene

@export var player_list: Control
@export var room_buttons: Control
@export var start_button: Button
@export var ready_button: CheckButton
@export var connection_menu: Control

@export_category("fields")
@export var name_field: LineEdit
@export var ip_field: LineEdit

func get_player_name() -> String: return name_field.text

func add_player_status(player: Player) -> PlayerStatusUI:
	var status: PlayerStatusUI = player_status_scene.instantiate()
	player_list.add_child(status)
	player.status_ui = status
	connection_menu.visible = false
	return status

func _on_ready() -> void:
	name_field.text = "debug%s" % randi_range(0, 9999)
	get_tree().root.get_node("empty").queue_free()
	start_button.visible = false
	ready_button.visible = false

func _on_host_pressed() -> void:
	var net_name := name_field.text
	if net_name.is_empty(): return
	
	network.host()
	start_button.visible = true
	ready_button.visible = true

func _on_join_pressed() -> void:
	var net_name := name_field.text
	if net_name.is_empty(): return
	
	var ip := ip_field.text
	if ip.is_empty():
		ip = "localhost"
	
	network.join(ip)

func _on_ready_toggled(toggled_on: bool) -> void:
	var status := Player.PREPARING
	if toggled_on: status = Player.READY
	
	if network.is_host:
		room.send_status_down.rpc(1, status)
	else:
		room.send_status_up.rpc_id(1, status)

func _on_start_game_pressed() -> void:
	room.start_game.rpc()
