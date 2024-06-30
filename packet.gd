class_name Packet

const GUEST_ANNOUNCE := "guest_announce"
const HOST_WELCOME := "host_welcome"

static var data := PackedStringArray()

static func guest_announce_send():
	init_packet(GUEST_ANNOUNCE)
	write_arg(network.local_name)
	send()

static func guest_announce_receive():
	print("guest")
	network.room.add_guest(data[1])

static func init_packet(code: String):
	data.clear()
	write_arg(code)

static func write_arg(arg: String):
	data.append(arg)
	data.append(" ")

static func send():
	var packet := "".join(data)
	network.host_connection.put_string(packet)

static func decrypt(packet: String, source: int):
	data = packet.split(" ")
	match data[0]:
		GUEST_ANNOUNCE: guest_announce_receive()
		_: print("code invalid")
