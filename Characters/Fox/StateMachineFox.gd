extends StateMachine
@export var id = 1

func _ready():
	add_state('STAND')
	add_state('JUMP_SQUAT')
	add_state('SHORT_HOP')
	add_state('FULL_HOP')
	add_state('DASH')
	add_state('MOONWALK')
	add_state('WALK')
	add_state('CROUCH')
	add_state('AIR')
	add_state('LANDING')
	#add_states('RUN')
	#add_states('TURN')
	call_deferred("set_state",states.STAND)
	
func state_logic(delta):
	parent.updateframes(delta)
	parent._physics_process(delta)

func get_transition(_delta):
	parent.move_and_slide()
	parent.states.text = str(state)
	match state:
		states.STAND:
			if Input.get_action_strength("right_%s" % id) == 1:
				parent.velocity.x = parent.RUNSPEED
				parent.frame()
				parent.turn(false)
				return states.DASH
			if Input.get_action_strength("left_%s" % id) == 1:
				parent.velocity.x = -parent.RUNSPEED
				parent.frame()
				parent.turn(true)
				return states.DASH
			if parent.velocity.x > 0 and state == states.STAND:
				parent.velocity.x += -parent.TRACTION*1
				parent.velocity.x = clampf(parent.velocity.x, parent.velocity.x, 0) 
			elif parent.velocity.x < 0 and state == states.STAND:
				parent.velocity.x += parent.TRACTION*1
				parent.velocity.x = clampf(parent.velocity.x, parent.velocity.x, 0) 
		states.JUMP_SQUAT:
			if parent.frames == parent.jump_squat:
				if not Input.is_action_pressed("jump_%s" % id):
					parent.velocity.x = lerpf(parent.velocity.x,0,0.08)
					parent.frame()
					return states.SHORT_HOP
				else:
					parent.velocity.x = lerpf(parent.velocity.x,0,0.08)
					parent.frame()
					return states.FULL_HOP
					
		states.SHORT_HOP:
			parent.velocity.y = -parent.JUMPFORCE
			parent.frame()
			return states.AIR
			
		states.FULL_HOP:
			parent.velocity.y = -parent.MAX_JUMPFOFCE
			parent.frame()
			return states.AIR
		
		states.DASH:
			if Input.is_action_pressed("left_%s" % id):
				if parent.velocity.x > 0:
					parent.frame()
				parent.velocity.x = -parent.DASHSPEED
			elif Input.is_action_pressed("right_%s" % id):
				if parent.velocity.x < 0:
					parent.frame()
				parent.velocity.x = parent.DASHSPEED
			else:
				if parent.frames >= parent.dash_duration-1:
					return states.STAND
		states.MOONWALK:
			pass
		states.WALK:
			pass
		states.CROUCH:
			pass
		states.AIR:
			AIRMOVEMENT()
		states.LANDING:
			if parent.frame <= parent.landing_frames + parent.lage_frames:
				if parent.frame == 1:
					pass
				if parent.velocity.x > 0:
					parent.velocity.x = parent.velocity.x - parent.TRACTION/2
					parent.velocity.x = clampf(parent.velocity.x,0,parent.velocity.x)
				elif parent.velocity.x < 0:
					parent.velocity.x = parent.velocity.x + parent.TRACTION/2
					parent.velocity.x = clampf(parent.velocity.x,parent.velocity.x,0)
				if Input.is_action_pressed("jump_%s" % id): #and Input.is_action_pressed("shield"):
					parent.frame()
					return states.JUMP_SQUAT
			else:
				if Input.is_action_pressed("down_%s" % id):
					parent.lag_frames = 0
					parent.frame()
					return states.CROUCH
				else:
					parent.frame()
					parent.lag_frames = 0
					return state.STAND
				parent.lag_frames = 0
		#states.RUN:
		#	pass
		#states.TURN:
		#	pass
	

func enter_state(_new_state, _old_state):
	pass

func exit_state(_new_state, _old_state):
	pass

func state_includes(state_array):
	for each_state in state_array:
		if state == each_state:
			return true
	return false

func AIRMOVEMENT():
	if parent.velocity.y < parent.FALLINGSPEED:
		parent.velocity.y += parent.FALLSPEED
	if Input.is_action_pressed("down_%s" % id) and parent.down_buffer == 1 and parent.velocity.y > -150 and not parent.fastfall:
		parent.velocity.y = parent.MAX_FALLSPEED
		parent.fastfall = true
	if parent.fastfall == true:
		parent.set_collision_mask_bit(2,false)
		parent.velocity.y = parent.MAX_FALLSPEED
	
	if abs(parent.velocity.x) >= abs(parent.MAXAIRSPEED):
		if parent.velocity.x > 0:
			if Input.is_action_pressed("left_%s" % id):
				parent.velocity.x += -parent.AIR_ACCEL  
			elif Input.is_action_pressed("right_%s" % id):
				parent.velocity.x = parent.velocity.x
		if parent.velocity.x < 0:
			if Input.is_action_pressed("left_%s" % id):
				parent.velocity.x = parent.velocity.x
			elif Input.is_action_pressed("right_%s" % id):
				parent.velocity.x += parent.AIR_ACCEL
	
	elif abs(parent.velocity.x) < abs(parent.MAXAIRSPEED):
		if Input.is_action_pressed("left_%s" % id):
			parent.velocity.x += -parent.AIR_ACCEL#*2
		if Input.is_action_pressed("right_%s" % id):
			parent.velocity.x += parent.AIR_ACCEL#*2
	
	if not Input.is_action_pressed("left_%s" % id) and not Input.is_action_pressed("right_%s" % id):
		if parent.velocity.x < 0:
			parent.velocity.x += parent.AIR_ACCEL/5
		elif parent.velocity.x > 0:
			parent.velocity.x += -parent.AIR_ACCEL/5
	

func Falling():
	if state_includes([states.RUN,states.WALK,states.STAND,states.CROUCH,states.DASH,states.LANDING,states.TURN,states.JUMP_SQUAT,states.SHORT_HOP,states.FULL_HOP,states.MOONWALK,states.AIR]):
		if not parent.GroundL.is_colliding() and not parent.GroundR.is_colliding():
			return true
