extends BookPage

@onready var title_label: TextTemplate = $LeftPage/TitleLabel
@onready var description_label: RichTextLabel = $LeftPage/DescriptionLabel
@onready var chapter_icon: TextureRect = $LeftPage/ChapterIcon
@onready var stat_label: TextTemplate = $RightPage/VBoxContainer/StatLabel

func setup(data: Dictionary) -> void:
	title_label.set_values([data.title])
	description_label.text = data.description

	stat_label.visible = false
	clear_stats()
	var stats := GameData.lifetime_stats
	
	match data["chapter_id"]:
		"enemies":
			add_stat("Total Enemies Defeated", str(stats.enemies_killed))
			add_stat("Waves Completed", str(stats.waves_completed))
			add_stat("Boss Defeats", str(stats.boss_defeats))

			chapter_icon.texture = preload("res://Assets/ui/wave_icons/wave_icon_enemy_encounter.png")

		"blessings":
			add_stat("Blessings Collected", str(stats.blessings_collected))

			chapter_icon.texture = preload("res://Assets/ui/wave_icons/wave_icon_blessing.png")

func add_stat(label_text: String, value: String) -> void:
	var row := stat_label.duplicate() as TextTemplate
	row.visible = true
	stat_label.get_parent().add_child(row)
	row.set_values([label_text, value])

func clear_stats() -> void:
	for child in stat_label.get_parent().get_children():
		if child == stat_label:
			continue
		child.queue_free()
