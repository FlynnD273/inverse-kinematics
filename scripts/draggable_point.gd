extends Control

var is_dragging := false
var offset: Vector2 = Vector2.ZERO
var viewport: Viewport


func _ready() -> void:
	viewport = get_viewport()


func _input(event: InputEvent) -> void:
	if is_instance_of(event, InputEventMouseMotion):
		if is_dragging:
			position = event.position + offset
			var rect: Rect2 = viewport.get_visible_rect()
			if position.x > rect.size.x - 25:
				position.x = rect.size.x - 25
			if position.x < 25:
				position.x = 25
			if position.y > rect.size.y - 25:
				position.y = rect.size.y - 25
			if position.y < 25:
				position.y = 25


func _on_mouse_entered() -> void:
	var tween := create_tween()
	(
		tween
		. tween_property(self, "scale", Vector2.ONE * 1.2, 0.5)
		. set_trans(Tween.TRANS_EXPO)
		. set_ease(Tween.EASE_OUT)
	)


func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(
		Tween.EASE_OUT
	)


func _on_gui_input(event: InputEvent) -> void:
	if is_instance_of(event, InputEventMouseButton) and event.button_index == 1:
		is_dragging = event.pressed
		offset = -event.position
