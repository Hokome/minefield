extends PanelContainer
class_name PlayerStatusUI

const icon_atlas: Texture = preload("res://ui/status_icons.png")
const icon_size := 16

signal kick_pressed()

@export var name_label: Label
@export var self_icon: TextureRect
@export var kick_button: Button
@export var status_display: TextureRect

func _ready() -> void:
	kick_button.pressed.connect(func(): kick_pressed.emit())
	set_status(0)

func set_player_name(pname: String):
	name_label.text = pname

func set_status(status: int):
	var texture := AtlasTexture.new()
	texture.atlas = icon_atlas
	texture.region = Rect2(status * icon_size, 0, icon_size, icon_size)
	status_display.texture = texture

func set_local(value: bool):
	self_icon.visible = value
