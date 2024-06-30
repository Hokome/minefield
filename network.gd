extends Node
class_name Network

var peer: ENetMultiplayerPeer

const PORT := 2562
var is_host: bool

func host():
	is_host = true
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	room.local_player = room.add_player(1, menu.get_player_name())
	room.local_player.status = Player.PREPARING
	room.local_player.local = true
	
	peer.peer_connected.connect(guest_peer_connected)
	peer.peer_disconnected.connect(player_disconnected)
	
	multiplayer.multiplayer_peer = peer

func join(ip: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	
	multiplayer.connected_to_server.connect(connected_to_host, CONNECT_ONE_SHOT)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.server_disconnected.connect(disconnected_from_server)

func guest_peer_connected(id: int):
	room.send_players.call_deferred(id)
	
	room.add_player(id, "...")

func player_disconnected(id: int):
	room.remove_player.rpc.call_deferred(id)

func connected_to_host():
	print("connected")
	menu.ready_button.visible = true

func disconnected_from_server():
	print("disconnected")
