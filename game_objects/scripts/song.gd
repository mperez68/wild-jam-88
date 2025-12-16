class_name Song extends Node

const TOLERANCE: float = 0.01

@onready var intro: AudioStreamPlayer = %Intro
@onready var baseline: AudioStreamPlayer = %Baseline
@onready var overlay: AudioStreamPlayer = %Overlay


# ENGINE
func _ready() -> void:
	if !baseline.stream:
		printerr("No baseline track for %s!" % name)
	if overlay.stream and (baseline.stream.get_length() - overlay.stream.get_length()) > TOLERANCE:
		printerr("Baseline and Overline not synced! %s; %s != %s" % [name, baseline.stream.get_length(), overlay.stream.get_length()])
		overlay.stream = null


# PUBLIC
func play(with_intro: bool = true):
	if !baseline.stream:
		printerr("No baseline track for %s!" % name)
		return
	if intro.playing or baseline.playing:
		return
	if intro.stream and with_intro:
		intro.play()
	else:
		baseline.play()
		if overlay:
			overlay.play()

func stop():
	for player: AudioStreamPlayer in [intro, baseline, overlay]:
		player.stop()

func disable_overlay(disabled: bool):
	overlay.volume_linear = 0.0 if disabled else 1.0


# SIGNALS
func _on_intro_finished() -> void:
	play(false)
