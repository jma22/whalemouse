class_name UpgradeTag extends RefCounted

const EBB = &"ebb"
const EBB_SOURCE = &"ebb_source"

const GENERIC = &"generic"
const ONETIME = &"onetime"

const STACKABLE = &"stackable"
const NEEDS_MARK = &"needs_mark"
const MARK_SOURCE = &"mark_source"

const NEEDS_POISON = &"needs_poison"
const POISON_SOURCE = &"poison_source"

const NEEDS_BOMB = &"needs_bomb"
const BOMB_SOURCE = &"bomb_source"

const BELUGA = &"beluga"
const DASH = &"dash"

const BELUGA_SOURCE = &"beluga_source"
const DASH_SOURCE = &"dash_source"

const SOURCE = &"source"
const DROPS_ORBS = &"drops_orbs"

const BIG_CURSE = &"big_curse"
const DECAY = &"decay"

const SPAWNS_BERSERK   = &"spawns_berserk"
const SPAWNS_CURSED    = &"spawns_cursed"
const SPAWNS_SLIPPERY  = &"spawns_slippery"
const SPAWNS_SPIKEY    = &"spawns_spikey"
const SPAWNS_WITHER    = &"spawns_wither"
const SPAWNS_SHIELDED  = &"spawns_shielded"
const SPAWNS_INFESTED  = &"spawns_infested"
const SPAWNS_POISONED  = &"spawns_poisoned"
const SPAWNS_MARKED    = &"spawns_marked"
const SPAWNS_EBBY      = &"spawns_ebby"


static func get_description_for_tag(tag: StringName) -> String:
	match tag:
		EBB, EBB_SOURCE:
			return Keywords.apply("Ebb : Slow the curse by %d%%." % int(SlowEffect.TIME_MULTIPLIER * 100))
		MARK_SOURCE, NEEDS_MARK, SPAWNS_MARKED:
			return Keywords.apply("Mark: The next attack consumes all marks to deal +1 damage per stack, up to a maximum of 5 stacks.")
		POISON_SOURCE, NEEDS_POISON, SPAWNS_POISONED:
			return Keywords.apply("Poison: Deal 1 damage after 3 seconds. Stacks are used one after another.")
		BOMB_SOURCE, NEEDS_BOMB:
			return Keywords.apply("Bomb: Deal %d damage in an area. Deals %d damage to you." % [BombExplosion.BASE_BOMB_DAMAGE, BombExplosion.BASE_BOMB_FRIENDLY_FIRE_DAMAGE])
		DECAY:
			return Keywords.apply("Decay: Curse ticks at double speed for one second.")
		SPAWNS_BERSERK:
			return Keywords.apply("Berserk: Enemies attack and move faster.")
		SPAWNS_CURSED:
			return Keywords.apply("Cursed: Enemies does not drop orbs on death.")
		SPAWNS_SLIPPERY:
			return Keywords.apply("Slippery: Enemies move faster.")
		SPAWNS_SPIKEY:
			return Keywords.apply("Spikey: Enemies deal double damage.")
		SPAWNS_WITHER:
			return Keywords.apply("Withering: Enemies spawn with 1 hp.")
		SPAWNS_SHIELDED:
			return Keywords.apply("Shielded: Enemies absorb one hit.")
		SPAWNS_INFESTED:
			return Keywords.apply("Infested: Enemies spawn parasites when killed.")
		SPAWNS_EBBY:
			return Keywords.apply("Ebby: Enemies release ebb when killed.")
	return ""
