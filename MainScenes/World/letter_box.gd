extends Control
class_name LetterBox

@onready var top_bar: ColorRect = $TopBar
@onready var bottom_bar: ColorRect = $BottomBar

const SLIDE_TIME := 0.8
const BAR_HEIGHT_PCT := 0.1  # 10% of viewport height per bar


var _top_shown_y: float
var _bottom_shown_y: float
var _top_hidden_y: float
var _bottom_hidden_y: float

var tween : Tween

func _ready() -> void:
	# Capture the editor-configured "shown" positions as the source of truth.
	_top_shown_y = top_bar.position.y
	_bottom_shown_y = bottom_bar.position.y
	_top_hidden_y = _top_shown_y - top_bar.size.y
	_bottom_hidden_y = _bottom_shown_y + bottom_bar.size.y
	_recompute()
	_hide_instant()

func _recompute() -> void:
	var viewport_h := get_viewport().get_visible_rect().size.y
	var bar_h := viewport_h * BAR_HEIGHT_PCT

	top_bar.size.y = bar_h
	bottom_bar.size.y = bar_h

	_top_shown_y = 0.0
	_bottom_shown_y = viewport_h - bar_h
	_top_hidden_y = -bar_h
	_bottom_hidden_y = viewport_h

func _hide_instant() -> void:
	top_bar.position.y = _top_hidden_y
	bottom_bar.position.y = _bottom_hidden_y

func show_letter_box() -> void:
	tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(top_bar, "position:y", _top_shown_y, SLIDE_TIME)
	tween.tween_property(bottom_bar, "position:y", _bottom_shown_y, SLIDE_TIME)

func hide_letter_box() -> void:
	tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(top_bar, "position:y", _top_hidden_y, SLIDE_TIME)
	tween.tween_property(bottom_bar, "position:y", _bottom_hidden_y, SLIDE_TIME)