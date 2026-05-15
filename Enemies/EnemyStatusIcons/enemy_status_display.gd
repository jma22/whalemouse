extends Node3D

class_name EnemyStatusDisplay

enum FillDirection { TOP_DOWN, BOTTOM_UP }

@export var fill_direction: FillDirection = FillDirection.TOP_DOWN
@export var box_half_width: float = 0.2
@export var pair_spacing: float = 0.15
@export var row_spacing: float = 0.3
@export var icon_scale: float = 0.8
@export_range(0, 8) var debug_icon_count: int = 0
@export var pixel_size: float = 0.001

const TEXTURES: Dictionary = {
	StatusEffectNames.BERSERK:  preload("res://Enemies/EnemyStatusIcons/berserk_icon.png"),
	StatusEffectNames.CURSED:   preload("res://Enemies/EnemyStatusIcons/cursed_icon.png"),
	StatusEffectNames.EBBY:     preload("res://Enemies/EnemyStatusIcons/ebby_icon.png"),
	StatusEffectNames.INFESTED: preload("res://Enemies/EnemyStatusIcons/infested_icon.png"),
	StatusEffectNames.SLIPPERY: preload("res://Enemies/EnemyStatusIcons/slippery_icon.png"),
	StatusEffectNames.SPIKEY:   preload("res://Enemies/EnemyStatusIcons/spikey_icon.png"),
	StatusEffectNames.WITHER:   preload("res://Enemies/EnemyStatusIcons/wither_icon.png"),
}

const POISON_TEXTURES: Array = [
	null,
	preload("res://Enemies/EnemyStatusIcons/poison_1_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/poison_2_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/poison_3_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/poison_4_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/poison_5_icon.png"),
]

const MARK_TEXTURES: Array = [
	null,
	preload("res://Enemies/EnemyStatusIcons/mark_1_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/mark_2_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/mark_3_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/mark_4_icon.png"),
	preload("res://Enemies/EnemyStatusIcons/mark_5_icon.png"),
]


var _status_manager: StatusEffectManager = null
var _sprites: Dictionary = {}
var _target_world_height: float = -1.0


func setup(manager: StatusEffectManager, sprite_manager: SpriteManager) -> void:
	_status_manager = manager
	# if sprite_manager and sprite_manager.texture:
	# 	_target_world_height = sprite_manager.texture.get_height() * sprite_manager.pixel_size


func _process(_delta: float) -> void:
	if debug_icon_count > 0:
		_update_debug_display()
	elif _status_manager:
		_update_display()


func _update_display() -> void:
	var active_effects: Array[StatusEffectBase] = _status_manager.get_deduped_list()

	var displayable: Array[StatusEffectBase] = []
	for effect: StatusEffectBase in active_effects:
		if _get_texture(effect) != null:
			displayable.append(effect)

	var active_names: Array[StringName] = []
	for effect: StatusEffectBase in displayable:
		active_names.append(effect.name)

	for effect_name: StringName in _sprites.keys():
		if effect_name not in active_names:
			_sprites[effect_name].queue_free()
			_sprites.erase(effect_name)

	for effect: StatusEffectBase in displayable:
		var tex: Texture2D = _get_texture(effect)
		if effect.name not in _sprites:
			_sprites[effect.name] = _make_sprite()
		_apply_texture(_sprites[effect.name], tex)

	_layout_keys(active_names)


func _update_debug_display() -> void:
	var all_textures: Array = TEXTURES.values()
	var desired: int = debug_icon_count

	while _sprites.size() > desired:
		var key: StringName = _sprites.keys()[-1]
		_sprites[key].queue_free()
		_sprites.erase(key)

	var current_count: int = _sprites.size()
	for i: int in range(current_count, desired):
		var sprite: Sprite3D = _make_sprite()
		_apply_texture(sprite, all_textures[i % all_textures.size()])
		_sprites[StringName("debug_%d" % i)] = sprite

	_layout_keys(_sprites.keys())


func _make_sprite() -> Sprite3D:
	var sprite := Sprite3D.new()
	sprite.pixel_size = pixel_size

	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.scale = Vector3.ONE * icon_scale
	add_child(sprite)
	return sprite


func _apply_texture(sprite: Sprite3D, tex: Texture2D) -> void:
	sprite.texture = tex



func _layout_keys(keys: Array) -> void:
	var count: int = keys.size()
	if count == 0:
		return
	var rows: Array[int] = _get_row_split(count)
	var row_count: int = rows.size()
	var idx: int = 0
	for row: int in range(row_count):
		var n: int = rows[row]
		var y: float = (row_count - 1 - row) * row_spacing
		for col: int in range(n):
			_sprites[keys[idx]].position = Vector3(_row_x(col, n), y, 0.0)
			idx += 1


func _row_x(col: int, n: int) -> float:
	if n == 1:
		return 0.0
	if n == 2:
		return -pair_spacing * 0.5 + col * pair_spacing
	return -box_half_width + col * (box_half_width * 2.0 / (n - 1))


func _get_row_split(count: int) -> Array[int]:
	if count <= 3:
		return [count]
	if fill_direction == FillDirection.TOP_DOWN:
		return [(count + 1) >> 1, count >> 1]
	return [count >> 1, (count + 1) >> 1]


func _get_texture(effect: StatusEffectBase) -> Texture2D:
	if effect.name == StatusEffectNames.POISON:
		return POISON_TEXTURES[clampi(effect.stacks, 1, 5)]
	if effect.name == StatusEffectNames.MARK:
		return MARK_TEXTURES[clampi(effect.stacks, 1, 5)]
	return TEXTURES.get(effect.name, null)


func reset() -> void:
	for sprite: Sprite3D in _sprites.values():
		sprite.queue_free()
	_sprites.clear()
