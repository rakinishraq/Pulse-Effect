extends MeshInstance

var age = 0
var distance = 10
var move_vec = null
var hit = false
var type = null

func _physics_process(delta):
	if move_vec != null:
		if age >= 1 and hit:
			var new_a = material_override.albedo_color.a - delta
			if new_a <= 0:
				queue_free()
			scale += Vector3(0.1, 0, 0.1) * delta * 2
			material_override.albedo_color.a = new_a
		elif age >= 2:
			queue_free()
		else:
			translate(move_vec.normalized() * delta * distance)
			age += delta
