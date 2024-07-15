extends CharacterBody2D

#Global Variables
var frames = 0

#Ground Variables
var dash_duration = 10

#Air Variables
var landing_frames = 0
var lag_frames = 0
var jump_squat = 3
var fastfall = false

#Onready Variables
@onready var GroundL = get_node('Raycasts/GroundL')
@onready var GroundR = get_node('Raycasts/GroundR')
@onready var states = $State
@onready var anim = $Sprite/AnimationPlayer

#Fox's Main Attributes
var RUNSPEED = 340*2
var DASHSPEED = 390*2
var WALKSPEED = 200*2
var GRAVITY = 1800*2
var JUMPFORCE = 500*2
var MAX_JUMPFORCE = 800*2
var DOUBLEJUMPFORCE = 1000*2
var MAXAIRSPEED = 300*2
var AIR_ACCEL = 25*2
var FALLSPEED = 60*2
var FALLINGSPEED = 900*2
var MAXFALLSPEED = 900*2
var TRACTION = 40*2
var ROLL_DISTANCE = 350*2
var AIR_DODGE_SPEED = 500*2
var UP_B_LAUNCHSPEED = 700*2


func updateframes(_delta):
	frames+=1

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	$Sprite.set_flip_h(direction)

func frame():
	frames = 0

func play_animation(animation_name):
	anim.play(animation_name)

func _ready():
	pass

func _physics_process(_delta):
	pass


