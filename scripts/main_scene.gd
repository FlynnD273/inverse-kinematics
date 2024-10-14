extends Node2D

var points: Array[Control]
@export var point_count: float = 3
@export var joint_length: float = 50
@export var iteration_count: int = 2


func _ready() -> void:
	var dot_scene: PackedScene = load("res://scenes/dot.tscn")
	points = []
	for i in range(point_count):
		var dot: Control = dot_scene.instantiate()
		dot.position = Vector2(randi_range(20, 600), randi_range(20, 600))
		$Dots.add_child(dot)
		points.append(dot)


func _process(_delta: float) -> void:
	if ($End.position - $Start.position).length() > (points.size() - 1) * joint_length:
		if $End.is_dragging:
			$Start.position = (
				$End.position
				+ (
					($Start.position - $End.position).normalized()
					* joint_length
					* (points.size() - 1)
				)
			)
		else:
			$End.position = (
				$Start.position
				+ (
					($End.position - $Start.position).normalized()
					* joint_length
					* (points.size() - 1)
				)
			)
	points[0].hide()
	points[-1].hide()
	points[0].position = $Start.position

	var offset: Vector2 = ($Pole.position - $Start.position).normalized() * joint_length
	for i in range(1, points.size()):
		points[i].position = points[i - 1].position + offset

	for _iter in range(iteration_count):
		points[-1].position = $End.position
		for i in range(points.size() - 2, -1, -1):
			points[i].position = (
				points[i + 1].position
				+ (points[i].position - points[i + 1].position).normalized() * joint_length
			)

		points[0].position = $Start.position
		for i in range(1, points.size()):
			points[i].position = (
				points[i - 1].position
				+ (points[i].position - points[i - 1].position).normalized() * joint_length
			)

	var lines: Line2D = $Lines
	lines.points = points.map(func(p): return p.position)
