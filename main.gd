extends Node2D

var time = 0
var count_time = 1
var minutes_label = 00
var seconds_label = 00
var decimal_label = 00
var started = false
var full = 0

# Called when the node enters the scene tree for the first second.
func _ready():
	full = $progressbar.size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	minutes_label = time / (60*100)
	seconds_label = (time - (minutes_label * 60 * 100))/100
	decimal_label = time - (minutes_label * 60 * 100) - (seconds_label * 100)
	
	#$start_stop.disabled = true if time == 0 else false
	if Input.is_action_pressed("Start") and time != 0:
		$start_stop.text = 'Stop'
		$reset.disabled = true
		#$bell.disabled = true
		$min4.disabled = true
		$min5.disabled = true
		$bell_sound.play()
		$timer.start()
		started = true
	if Input.is_action_pressed("Bell"):
		$bell_sound.play()
	if Input.is_action_pressed("min4"):
		_on_4_minutes_pressed()
	if Input.is_action_pressed("min5"): 
		_on_5_minutes_pressed()
	if Input.is_action_pressed("zero"): 
		_on_reset_pressed()
	
	if Input.is_action_pressed("hide"): 
		$start_stop.visible = false
		$reset.visible = false
		$bell.visible = false
		$min4.visible = false
		$min5.visible = false
		
	if Input.is_action_pressed("show"): 
		$start_stop.visible = true
		$reset.visible = true
		$bell.visible = true
		$min4.visible = true
		$min5.visible = true
		
	if seconds_label < 10 and decimal_label < 10: 
		$Label.text = str("0", minutes_label, " : 0", seconds_label,)
	elif seconds_label < 10: 
		$Label.text = str("0", minutes_label, " : 0", seconds_label)
	elif decimal_label < 10: 
		$Label.text = str("0", minutes_label, " : ", seconds_label)
	else:
		$Label.text = str("0", minutes_label, " : ", seconds_label)

func _on_start_stop_pressed():
	if started:
		$start_stop.text = 'Start'
		$reset.disabled = false
		#$bell.disabled = false
		$min4.disabled = false
		$min5.disabled = false 
		$timer.stop()
		started = not started
	elif not started and time != 0: 
		$start_stop.text = 'Stop'
		$reset.disabled = true
		#$bell.disabled = true
		$min4.disabled = true
		$min5.disabled = true
		$bell_sound.play()
		$timer.start()
		started = not started

func _on_timer_timeout():
	time -= 5
	if time == 0:
		$bell_sound.play()
		$timer.stop()
		$start_stop.text = 'Start'
		$start_stop.disabled = true
		$reset.disabled = false
		#$bell.disabled = false
		$min4.disabled = false
		$min5.disabled = false
		started = not started
	if time == 30*100 and count_time == 4 * 60 * 100:
		$bell_sound.play()
	if time == 60*100 and count_time == 5 * 60 * 100:
		$bell_sound.play()
	$progressbar.size.x = (full*time)/count_time
	#print((full*time)/count_time)

func _on_reset_pressed():
	if not started:
		time = 0
		$start_stop.disabled = true

func _on_bell_pressed():
	$bell_sound.play()

func _on_4_minutes_pressed():
	if not started:
		$start_stop.disabled = false
		time = 4 * 60 * 100
		count_time = time

func _on_5_minutes_pressed():
	if not started:
		$start_stop.disabled = false
		time = 5 * 60 * 100
		count_time = time

func _on_button_mouse_entered():
	$ColorRect2.visible = true
	$Label2.visible = true


func _on_button_mouse_exited():
	$ColorRect2.visible = false
	$Label2.visible = false
