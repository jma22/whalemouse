extends Control

@export var page_container: Control

var all_pages: Array = []
var current_page_index: int = 0

const FIRST_PAGE: PackedScene = preload("res://MainScenes/MouseHub/Main/pages/first_page.tscn")
const CHAPTER_PAGE: PackedScene = preload("res://MainScenes/MouseHub/Main/pages/chapter_page.tscn")
const ENEMY_PAGE: PackedScene = preload("res://MainScenes/MouseHub/Main/pages/enemy_page.tscn")

func _ready() -> void:
	build_book()
	show_page()


func build_book() -> void:
	all_pages.clear()

	for chapter_id: String in BookData.chapters.keys():
		var chapter: Dictionary = BookData.chapters[chapter_id]

		# Chapter intro page
		all_pages.append({
			"type": "chapter",
			"chapter_id": chapter_id,
			"title": chapter["title"],
			"description": chapter["description"]
		})

		# Chapter entries
		for entry: Dictionary in chapter["entries"]:
			all_pages.append({
				"type": chapter_id,
				"data": entry
			})


func show_page() -> void:
	for child: Node in page_container.get_children():
		child.queue_free()

	if current_page_index < 0 or current_page_index >= all_pages.size():
		return

	var page_data : Dictionary = all_pages[current_page_index]
	match page_data["type"]:
		"chapter":
			spawn_page(CHAPTER_PAGE, page_data)
		"enemies":
			spawn_page(ENEMY_PAGE, page_data)

func spawn_page(page_template: PackedScene, page_data: Dictionary) -> void:
	var page := page_template.instantiate() as BookPage
	page_container.add_child(page)
	page.set_page_number(current_page_index)
	match page_data["type"]:
		"chapter":
			page.setup(page_data)
		"enemies":
			page.setup(page_data["data"])

func jump_to_chapter(chapter_name: String) -> void:
	for i: int in range(all_pages.size()):
		var page: Dictionary = all_pages[i]
		if page["type"] == "chapter" and page["chapter_id"] == chapter_name:
			current_page_index = i
			print("Jumped to page!")
			show_page()
			return

func _on_chapter_button_characters_pressed() -> void:
	jump_to_chapter("characters")

func _on_chapter_button_enemies_pressed() -> void:
	jump_to_chapter("enemies")

func _on_chapter_button_blessings_pressed() -> void:
	jump_to_chapter("blessings")

func _on_chapter_button_curses_pressed() -> void:
	jump_to_chapter("curses")

func _on_chapter_button_artworks_pressed() -> void:
	jump_to_chapter("artworks")

func _on_close_button_pressed() -> void:
	visible = false

func _on_right_button_pressed() -> void:
	if current_page_index < all_pages.size() - 1:
		current_page_index += 1
		show_page()

func _on_left_button_pressed() -> void:
	if current_page_index > 0:
		current_page_index -= 1
		show_page()
