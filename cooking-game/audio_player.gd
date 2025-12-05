extends AudioStreamPlayer

const all_music = preload("res://Sounds/PeriTune_Alleyway-chosic.com_.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return		
	stream = music
	volume_db = volume
	play()

func play_FX(stream: AudioStream, volume = 0.0):
	var fx = AudioStreamPlayer.new()
	fx.stream = stream
	#name node
	fx.name = "SOUND_FX"
	fx.volume_db = volume
	add_child(fx)
	fx.play()
	await fx.finished
	
	##once switched scene to level then queue free to remove the audio player node
	#if fx.playing == false:
		#fx.play()	
	#
	#var length = fx.stream.get_length()
	#print("sound length: ",length)
	#await get_tree().create_timer(length+.1).timeout
	
	fx.queue_free()
	
func play_music_ui():
	#set_stream_paused(false)
	_play_music(all_music)
