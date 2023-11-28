extends Spatial

onready var world = get_parent()
var cont = null
onready var tolerance = world.tolerance
onready var controls = [null]+world.drums

func _ready():
	if not Global.VR_Mode:
		queue_free()
	$MeshInstance.visible = false


func _physics_process(_delta):
	if world.VR_mode:
		if cont == null:
			if name[0] == "L":
				cont = world.get_node("PlayerVR/LeftController")
			else:
				cont = world.get_node("PlayerVR/RightController")
		translation = cont.global_transform.origin
		rotation = cont.rotation
		rotate_object_local(Vector3.LEFT, PI/2)
	else:
		if name[0] == "L":
			queue_free()
	if name[0] == "R":
		for i in range(1, len(controls)):
			if Input.is_action_just_pressed("Drum"+str(i)):
				_collided(null, world.get_node("Drum Set/"+controls[i]),
					null, null, controls[i])


func _collided(_body_rid, body, _body_shape_index, _local_shape_index, type=null):
	var audio = body.get_node("AudioStreamPlayer3D")
	if audio != null:
		audio.play()
	if type != null:
		for d in get_tree().get_nodes_in_group("disks"):
			if d.age <= (1+tolerance) and d.age >= (1-tolerance):
				if d.type == type:
					d.age = 1
					d.hit = true
	#if body is KinematicBody: # is cymbal
