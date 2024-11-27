extends Control

@onready var park_bar: Label = $"AspectRatioContainer/PanelContainer/HSplitContainer/VBoxContainer/MarginContainer3/park bar"
@onready var park_progress: ProgressBar = $"AspectRatioContainer/PanelContainer/HSplitContainer/VBoxContainer2/Control/Park progress"
@onready var parktimer: Timer = $Parktimer

@onready var rotation_brake: Label = $"AspectRatioContainer/PanelContainer/HSplitContainer/VBoxContainer/MarginContainer4/Rotation Brake"
@onready var thrust_brake: Label = $"AspectRatioContainer/PanelContainer/HSplitContainer/VBoxContainer/MarginContainer5/Thrust Brake"

var parking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Engage_Park"):
		parktimer.start()
		park_bar.show()
		park_progress.show()
		park_progress.value = 0
		park_progress.max_value = parktimer.wait_time
		parking = true
	if parking:
		animatepark()
	
	if Input.is_action_just_pressed("Thrust_Brake_Toggle"):
		if thrust_brake.visible == false:
			thrust_brake.show()
		else:
			thrust_brake.hide()
	
	if Input.is_action_just_pressed("Zero_Rotation_Toggle"):
		if rotation_brake.visible == false:
			rotation_brake.show()
		else:
			rotation_brake.hide()

func animatepark():
	park_progress.value = parktimer.time_left

func _on_parktimer_timeout() -> void:
	parking = false
	park_progress.value = 0
	#blinks the park bar (hopefully)
	for n in 4:
		park_bar.hide()
		park_progress.hide()
		await get_tree().create_timer(0.2).timeout
		park_bar.show()
		park_progress.show()
		await get_tree().create_timer(0.2).timeout
	park_bar.hide()
	park_progress.hide()
