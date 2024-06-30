extends RefCounted
class_name Player

var id: int
var name: String:
	set(val):
		name = val
		if status_ui:
			status_ui.set_player_name(name)
var status := 0:
	set(val):
		status = val
		if status_ui:
			status_ui.set_status(status)
var local := false:
	set(val):
		local = val
		status_ui.set_local(val)

const CONNECTING := 0
const PREPARING := 1
const READY := 2

var status_ui: PlayerStatusUI:
	set(val):
		status_ui = val
		status_ui.set_player_name(name)

func remove():
	status_ui.queue_free()
