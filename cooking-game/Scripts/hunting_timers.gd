extends Node2D

# For hunting minigame, so it can run when minigame is closed
@onready var fishTimer : Timer = $FishTimer
var fish_timer_active = false
@onready var cowTimer : Timer = $CowTimer
var cow_timer_active = false
var cow_total
var fish_total

func _process(delta: float) -> void:
	if !fish_timer_active && fish_total < 3:
		fishTimer.start(10)
		fish_timer_active = true
		
	if !cow_timer_active && cow_total < 3:
		cowTimer.start(10)
		cow_timer_active = true


func _cow_total_spawned(t: Variant) -> void:
	cow_total = t
	print(t)

func _fish_total_spawned(t: Variant) -> void:
	fish_total = t
	print(t)


func _on_fish_timer_timeout() -> void:
	fish_timer_active = false

func _on_cow_timer_timeout() -> void:
	cow_timer_active = false
