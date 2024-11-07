extends Label

var slider: Slider
var prefix: String = ""


func _ready() -> void:
  var children := get_parent().get_children()
  slider = children[children.find(self) - 1]
  prefix = text
  slider.value_changed.connect(value_changed)
  value_changed(slider.value)


func value_changed(val: float) -> void:
  text = prefix + str(val)
