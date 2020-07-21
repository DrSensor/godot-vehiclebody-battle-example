extends VehicleBody

export var I_HAVE_CONTROL : bool

export var max_damage : int = 200
export var health : float = 1000 setget set_health

onready var max_steering = steering
func _ready(): $CameraPivot.set_as_toplevel(true)

signal die

func _physics_process(delta):
	_player_process()
	_sound_process($RearWheel.get_rpm())


func _player_process(): if I_HAVE_CONTROL:
	$CameraPivot.translation = translation
	$CameraPivot.rotation_degrees.y = rotation_degrees.y
	steering = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * max_steering


func _sound_process(rpm):
	rpm = rpm/engine_force if engine_force else rpm  # get ratio while avoid division by zero
	$SFX/Engine.pitch_scale = abs(lerp(0, 4, rpm)) # abs() to avoid precission errors. See https://github.com/godotengine/godot/pull/21217#discussion_r211759231
	$SFX/Engine.unit_db = lerp(10, 20, rpm)


func set_health(value: float):
	health = value ; if health <= 0: emit_signal("die")


func _on_VehicleBody_body_entered(body: Node): if body is VehicleBody \
											  and not $SFX/Crash.playing:
	var collider_momentum = body.linear_velocity.length() * body.mass
	var self_momentum = self.linear_velocity.length() * self.mass
	var damage = clamp(collider_momentum - self_momentum, 0, max_damage)
	health -= damage

	$SFX/Crash.unit_size = lerp(0, $SFX/Crash.max_db, damage / max_damage)
	$SFX/Crash.play()
