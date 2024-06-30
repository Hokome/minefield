extends Node
class_name Room

var players: Array[Player]
var player_dict: Dictionary
var local_player: Player

func add_player(id: int, pname: String) -> Player:
	var player := Player.new()
	player.id = id
	player.name = pname
	players.append(player)
	player_dict[id] = player
	menu.add_player_status(player)
	return player

func get_player(id: int) -> Player: return player_dict[id]

func send_players(id: int):
	var names := PackedStringArray()
	var ids := PackedInt32Array()
	var statuses := PackedInt32Array()
	for p in players:
		if !p.status: continue
		names.append(p.name)
		ids.append(p.id)
		statuses.append(p.status)
		
	
	add_existing_players.rpc_id(id, ids, names, statuses)

@rpc("authority", "call_local")
func start_game():
	menu.player_list.visible = false
	menu.room_buttons.visible = false
	game.start()

@rpc("authority", "call_remote")
func add_existing_players(ids: PackedInt32Array, names: PackedStringArray, statuses: PackedInt32Array):
	for i in names.size():
		add_player(ids[i], names[i]).status = statuses[i]
		
	var p := add_player(network.peer.get_unique_id(), menu.get_player_name())
	p.status = Player.PREPARING
	p.local = true
	room.local_player = p
	
	add_new_player_up.rpc_id(1, p.name)

@rpc("any_peer", "call_remote")
func add_new_player_up(pname: String):
	var id := multiplayer.get_remote_sender_id()
	var player := get_player(id)
	player.name = pname
	player.status = Player.PREPARING
	
	for p in players:
		if p.id == 1 or p.id == id: continue
		add_new_player_down.rpc_id(p.id, id, player.name)


@rpc("authority", "call_remote")
func add_new_player_down(id: int, pname: String):
	add_player(id, pname).status = Player.PREPARING

@rpc("authority", "call_local")
func remove_player(id: int):
	var player = get_player(id)
	player.remove()
	players.erase(player)
	player_dict[id] = null

@rpc("any_peer", "call_remote")
func send_status_up(status: int):
	var id := multiplayer.get_remote_sender_id()
	
	for p in players:
		send_status_down.rpc_id(p.id, id, status)

@rpc("authority", "call_local")
func send_status_down(id: int, status: int):
	player_dict[id].status = status
	
	if network.is_host:
		for p in players:
			if p.status < Player.READY: 
				menu.start_button.disabled = true
				return
		menu.start_button.disabled = false 
