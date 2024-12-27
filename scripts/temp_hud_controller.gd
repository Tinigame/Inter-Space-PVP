extends Control
@onready var buckle_toast: Label = $"MarginContainer/buckle toast"

func _ready() -> void:
	buckle_toast.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("buckle_toggle"):
		if buckle_toast.visible == false:
			buckle_toast.show()
		elif Globals.safe_unbuckle == true and buckle_toast.visible == true:
			buckle_toast.hide()
