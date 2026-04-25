class_name Keywords

# Default (dark background)
const _BELUGA    := "#F4D03F"
const _BOMB      := "#E74C3C"
const _MARK      := "#AF7AC5"
const _POISON    := "#52BE80"
const _EBB       := "#5DADE2"
const _EBBY      := "#40C8FF"
const _DASH      := "#F0B27A"
const _DECAY     := "#AAB7B8"
const _BERSERK   := "#FF6060"
const _CURSED    := "#C080FF"
const _SLIPPERY  := "#60E0FF"
const _SPIKEY    := "#FFE040"
const _WITHER    := "#A0B070"
const _SHIELDED  := "#80B0C0"
const _INFESTED  := "#90C050"

# Day mode (light background) — same hues, pulled darker for readability
const _BELUGA_DAY    := "#AA8020"
const _BOMB_DAY      := "#C02020"
const _MARK_DAY      := "#8040B8"
const _POISON_DAY    := "#2A8B4A"
const _EBB_DAY       := "#2A75C0"
const _EBBY_DAY      := "#2075B0"
const _DASH_DAY      := "#C06520"
const _DECAY_DAY     := "#606870"
const _BERSERK_DAY   := "#C03030"
const _CURSED_DAY    := "#7040C0"
const _SLIPPERY_DAY  := "#1090B0"
const _SPIKEY_DAY    := "#A09020"
const _WITHER_DAY    := "#506030"
const _SHIELDED_DAY  := "#406070"
const _INFESTED_DAY  := "#4A7020"

# Uses word boundaries so e.g. "poisoned" is not matched by the "poison" pattern.
# $1 backreference preserves the original case of the matched word.
static func apply(text: String, day_mode: bool = false) -> String:
	var c := {
		"beluga":   _BELUGA_DAY   if day_mode else _BELUGA,
		"bomb":     _BOMB_DAY     if day_mode else _BOMB,
		"mark":     _MARK_DAY     if day_mode else _MARK,
		"poison":   _POISON_DAY   if day_mode else _POISON,
		"ebb":      _EBB_DAY      if day_mode else _EBB,
		"ebby":     _EBBY_DAY     if day_mode else _EBBY,
		"dash":     _DASH_DAY     if day_mode else _DASH,
		"decay":    _DECAY_DAY    if day_mode else _DECAY,
		"berserk":  _BERSERK_DAY  if day_mode else _BERSERK,
		"cursed":   _CURSED_DAY   if day_mode else _CURSED,
		"slippery": _SLIPPERY_DAY if day_mode else _SLIPPERY,
		"spikey":   _SPIKEY_DAY   if day_mode else _SPIKEY,
		"wither":   _WITHER_DAY   if day_mode else _WITHER,
		"shielded": _SHIELDED_DAY if day_mode else _SHIELDED,
		"infested": _INFESTED_DAY if day_mode else _INFESTED,
	}
	var pairs: Array[Array] = [
		["(?i)\\b(beluga)\\b",     "beluga"],
		["(?i)\\b(bombs?)\\b",     "bomb"],
		["(?i)\\b(marked)\\b",     "mark"],
		["(?i)\\b(marks?)\\b",     "mark"],
		["(?i)\\b(poisoned)\\b",   "poison"],
		["(?i)\\b(poison)\\b",     "poison"],
		["(?i)\\b(ebby)\\b",       "ebby"],
		["(?i)\\b(ebb)\\b",        "ebb"],
		["(?i)\\b(dash)\\b",       "dash"],
		["(?i)\\b(decay)\\b",      "decay"],
		["(?i)\\b(berserk)\\b",    "berserk"],
		["(?i)\\b(cursed)\\b",     "cursed"],
		["(?i)\\b(slippery)\\b",   "slippery"],
		["(?i)\\b(spikey)\\b",     "spikey"],
		["(?i)\\b(withering?)\\b", "wither"],
		["(?i)\\b(shielded)\\b",   "shielded"],
		["(?i)\\b(infested)\\b",   "infested"],
	]
	var regex := RegEx.new()
	for pair in pairs:
		regex.compile(pair[0])
		text = regex.sub(text, "[color=%s][wave amp=5 freq=3]$1[/wave][/color]" % c[pair[1]], true)
	return text
