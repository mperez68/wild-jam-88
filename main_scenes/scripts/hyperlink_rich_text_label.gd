class_name HyperlinkRichTextLabel extends RichTextLabel


# ENGINE
func _ready():
	pass


# PUBLIC


# PRIVATE


# SIGNALS
func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
