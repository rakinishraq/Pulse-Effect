extends Spatial
# scene/resources/packed_scene.cpp:147 - Node 'Drum Set/Hi-Hat/MeshInstance2' was modified from inside an instance, but it has vanished.
# bug when renaming a child in a node with editable children

export var VR_mode = true
const drums = ["Hi-Hat", "Crash2", "Snare", "HighTom", "MidTom", "Ride", "Crash", "FloorTom", "Bass"]
const tolerance = 0.1
onready var PlayerVR = preload("res://addons/gui_in_vr/player/player.tscn")
onready var Drum = preload("res://DrumDisk.tscn")
onready var Cymbal = preload("res://CymbalDisk.tscn")
onready var DiskMat = preload("res://materials/DiskMat.tres")
var disks = []
var song = [
	[3.5, 0],
	[3, 2],
	[2.5, 0],
	[2, 8],
	[1.5, 0],
	[1, 2],
	[0.5, 0],
	[0, 8]
]
var bpm = 90
var prog = -1
var distance = 20

func _ready():
	if VR_mode:
		$Camera.current = false
		add_child(PlayerVR.instance())
	$Timer.wait_time = 60.0/bpm


func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	$WorldEnvironment.environment.background_sky_rotation_degrees.y += delta
	while song and song[-1][0] <= prog:
		create_disk(drums[song.pop_back()[1]])
	prog += delta


func _on_Timer_timeout():
	#create_disk("Hi-Hat")
	pass

func create_disk(type):
	var disk = Drum.instance()
	add_child(disk)
	disk.add_to_group("disks")
	disk.type = type
	disk.global_transform = get_node("Drum Set/"+type+"/Mesh").global_transform
	if type != "Bass":
		disk.translate(Vector3(0, 0.1, 0))
		disk.move_vec = Vector3.BACK
		disk.distance = distance
	else:
		disk.move_vec = Vector3.UP
		disk.distance = distance / disk.scale.y / 2
	disk.material_override = DiskMat.duplicate(true)
	disk.translate(disk.move_vec * -disk.distance)
	disks.append(disk)
