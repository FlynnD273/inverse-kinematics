extends Control

@export var point_count: float = 3
@export var joint_length: float = 50
@export var iteration_count: int = 2
var dot_scene: PackedScene = preload("res://scenes/dot.tscn")


func _ready() -> void:
  for i in range(point_count):
    var dot: Control = dot_scene.instantiate()
    dot.position = Vector2(randi_range(20, 600), randi_range(20, 600))
    $Dots.add_child(dot)


func _process(_delta: float) -> void:
  var points := $Dots.get_children()
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
  points[0].position = $Start.position

  var offset: Vector2 = ($Pole.position - $Start.position).normalized() * joint_length
  for i in range(1, points.size()):
    points[i].position = points[i - 1].position + offset
    points[i].show()
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
  points[0].hide()
  points[-1].hide()


func _on_length_slider_value_changed(value: float) -> void:
  joint_length = value


func _on_iterations_slider_value_changed(value: float) -> void:
  iteration_count = int(value)


func _on_segment_count_slider_value_changed(value: float) -> void:
  var new_count = int(value)
  if new_count > point_count:
    for i in range(new_count - point_count):
      var dot: Control = dot_scene.instantiate()
      dot.position = Vector2(randi_range(20, 600), randi_range(20, 600))
      $Dots.add_child(dot)
  else:
    var points := $Dots.get_children()
    for i in range(point_count - new_count):
      points.pop_back().queue_free()
  point_count = new_count
