extends Spatial


func _ready():
	$HUD/Enemy/HealthBar.max_value = $Enemy.health
	$HUD/Player/HealthBar.max_value = $Player.health
	update_health()


func update_health():
	$HUD/Enemy/HealthBar.value = $Enemy.health
	$HUD/Player/HealthBar.value = $Player.health


func _on_damage(): if $HUD/Player/HealthBar and $HUD/Enemy/HealthBar:
	update_health()


func _on_Enemy_die():
	$InterpolatedCamera.set_target($Player/Anchor/Spring/Camera)
	$HUD/Enemy/HealthBar.queue_free()
	$HUD/Enemy/Name.text = "You   Win !!"
	$Enemy.queue_free()


func _on_Player_die():
	$InterpolatedCamera.set_target($Enemy/Anchor/Spring/Camera)
	$HUD/Player/HealthBar.queue_free()
	$HUD/Player/Name.text = "You   Lose !!"
	$Player.queue_free()
