extends Control

@export var page_container: Control

var all_pages: Array = []
var current_page_index: int = 0

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

	clear_page_container(page_container)

	show_single_page(current_page_index, page_container)


func clear_page_container(target_page_container: Control) -> void:
	for child: Node in target_page_container.get_children():
		child.queue_free()


func show_single_page(index: int, target_page_container: Control) -> void:

	if index < 0 or index >= all_pages.size():
		return

	var page_data: Dictionary = all_pages[index]

	var page_scene: PackedScene

	match page_data["type"]:
		"chapter":
			page_scene = CHAPTER_PAGE

		"enemies":
			page_scene = ENEMY_PAGE

		_:
			return

	var page := page_scene.instantiate() as BookPage
	target_page_container.add_child(page)
	page.set_page_number(current_page_index)
	match page_data["type"]:
		"chapter":
			page.setup(page_data)

		"enemies":
			page.setup(page_data["data"])


func jump_to_chapter(chapter_name: String) -> void:
	for i: int in range(all_pages.size()):

		var page: Dictionary = all_pages[i]

		if page["type"] == "chapter" and page["title"] == chapter_name:

			current_page_index = i
			show_page()
			return

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
