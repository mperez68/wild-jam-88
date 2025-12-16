class_name ParContainer extends VBoxContainer

const CLEARED_ATLAS: Rect2 = Rect2(16.0, 0.0, 16.0 ,16.0)
const NOT_CLEARED_ATLAS: Rect2 = Rect2(0.0, 0.0, 16.0 ,16.0)

@onready var par_label: Label = %ParLabel
@onready var star_texture_rect: TextureRect = %StarTextureRect


# ENGINE


# PUBLIC
func set_content(par: int, cleared: bool):
	par_label.text = str(par)
	star_texture_rect.texture.region = CLEARED_ATLAS if cleared else NOT_CLEARED_ATLAS


# PRIVATE


# SIGNALS
