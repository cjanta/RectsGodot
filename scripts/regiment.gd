extends Node2D

var rightClick_selected = false
var selected = false
var selected_Mouse_Position

var rotadetForward
var rotatedBack
var dragVector

@export var regiment_ID = ""
@export var hasBattle = false
@export var isInBattle = false
@export var gui = ""
@export var units : Array[Unit]

@onready var isMoveable = true
@onready var movement_MaxRange = 400
@onready var movement_Amount = 400
var rotation_absolute = 0


@onready var markerIcon = preload("res://scns/marker.tscn").instantiate()
@onready var battleLabel = $BattleLabel
@onready var apLabel = $Area2D_Rotation/Label
@onready var dirLabel = $Area2D_Rotation/Label2
@onready var areaRotation = $Area2D_Rotation
var enemy_regiments = "";

func rotateTo(aGlobalPosition):
	var direction = aGlobalPosition - global_position
	var alpha = Vector2.UP.rotated(rotation).angle_to(direction)
	global_rotation += alpha

func _ready():
	selected_Mouse_Position = get_global_mouse_position()
	add_child(markerIcon)
	markerIcon.visible = false
	
	
func _process(delta):
	update_displays()
	
		
func update_displays():
	if isMoveable:
		apLabel.text = "AP: " + str(int(movement_Amount))
		dirLabel.text = regiment_ID
		areaRotation.visible = true
	else:
		apLabel.text = ""
		dirLabel.text = ""
		areaRotation.visible = false
		
func _physics_process(delta):
	if isMoveable and not isInBattle:
		handleDragnDropMovement(delta)
		handleDragnDropRotation(delta)
	

func handleDragnDropRotation(delta):
	if rightClick_selected and movement_Amount > 0:
		rotate_dragged_object(delta)

func handleDragnDropMovement(delta):
	if selected and movement_Amount > 0:
		movement_Amount -= abs(move_dragged_object(delta))
	
func rotate_dragged_object(delta):
	var direction = get_global_mouse_position() - global_position
	var alpha = Vector2.UP.rotated(rotation).angle_to(direction)
	rotation_absolute += abs(alpha) * 100
	movement_Amount -= abs(alpha) * 100
	global_rotation += alpha
				
func move_dragged_object(delta):
	dragVector = get_global_mouse_position() - selected_Mouse_Position
	rotadetForward = Vector2.UP.rotated(rotation)
	rotatedBack = Vector2.DOWN.rotated(rotation)
	var dot = rotadetForward.dot(dragVector)
		
	if selected and dot > 0:
		global_position += rotadetForward * dot
		selected_Mouse_Position = get_global_mouse_position()
		return dot
	elif selected and dot < 0:
		global_position -= rotatedBack * dot
		selected_Mouse_Position = get_global_mouse_position()
		return dot
	
	return 0
	
func _input(event):
	#selection resets
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if selected:
				if not hasBattle and not isInBattle:
					gui.log(get_rich_regiment_logPrefix() + " hat sich bewegt.")
				selected = false
			if rightClick_selected:
				gui.log(get_rich_regiment_logPrefix() + " hat sich gedreht.")
				rightClick_selected = false						
	elif Input.is_action_just_pressed("Spacebar"):
		movement_Amount = movement_MaxRange
		rotation_absolute = 0

func get_rich_regiment_logPrefix():
	return "\"" + "[color=green]" + regiment_ID + "[/color]" + "\""

func _on_area_2d_input_event(viewport, event, shape_idx):
	# movement draganddrop
	if Input.is_action_just_pressed("left_click"):
		selected = true
		selected_Mouse_Position = get_global_mouse_position()

func _on_area_2d_2_input_event(viewport, event, shape_idx):
	# rotation draganddrop
	if Input.is_action_just_pressed("left_click"):
		rightClick_selected = true
		selected_Mouse_Position = get_global_mouse_position()


func _on_area_2d_enemy_range_area_entered(area):
	enemy_regiments = area.get_parent()
	isInBattle = true
	isMoveable = false
	if enemy_regiments != null and selected or rightClick_selected:
		on_hasBattle(enemy_regiments)
				

func on_hasBattle(defender):
	#modulate = Color(1,1,1,0.5)
	#defender.modulate = Color(1,1,1,0.25)
	defender.rotateTo(global_position)
	rotateTo(defender.global_position)
	var direction = defender.global_position - global_position
	var length = direction.length() / 2
	var battlePos = global_position + direction.normalized() * length
	markerIcon.visible = true
	markerIcon.global_position = battlePos
	markerIcon.global_rotation_degrees = 0
	markerIcon.addRound()
	gui.log(get_rich_regiment_logPrefix() + " attackiert: " + defender.get_rich_regiment_logPrefix())
	gui.log("Der Nahkampf beginnt!\n" + markerIcon.getRoundInfo())	
	gui.log(get_battleRound_logInfo(fight_units(units, defender.units)))
	hasBattle = true

func get_battleRound_logInfo(round_result):
	var att_remaining = get_rich_regiment_logPrefix() + ": Verbleibend: " + get_sum_alive(units) + "\n"
	var att_died = get_rich_regiment_logPrefix() + ": Verluste: " + str(round_result[0]) + "\n"	
	var def_remaining = enemy_regiments.get_rich_regiment_logPrefix() + ": Verbleibend: " + get_sum_alive(enemy_regiments.units) + "\n"
	var def_died = enemy_regiments.get_rich_regiment_logPrefix() + ": Verluste: " + str(round_result[1]) + "\n"
	return  att_remaining + att_died + def_remaining + def_died

func get_sum_alive(units : Array):
	var c = 0;
	for u in units:
		if u.isAlive:
			c += 1
	return str(c)

func update_hasBattle():
	if not hasBattle or enemy_regiments == null:
		return
	gui.log(markerIcon.getRoundInfo())
	gui.log(get_battleRound_logInfo(fight_units(units, enemy_regiments.units)))
	markerIcon.addRound()

func log_misshit(atacker, defender):
	var log = ""
	if atacker != null:
		log += atacker.get_rich_logPrefix()
	log += " verfehlt "
	if defender != null:
		log += defender.get_rich_logPrefix()
	gui.log(log)

func fight_units(atackers, defenders):
	var rand = RandomNumberGenerator.new()
	var attacker_died = 0
	var defender_died = 0
	var deaths = []
	for unit in atackers:
		if unit.isAlive:
			var defender = defenders.pick_random()
			var bias = rand.randf_range(0,1)
			if bias > 0.5 and defender != null:
				deaths.append(defender)
				defender_died += 1
			else:
				log_misshit(unit, defender)
	for unit in defenders:
		if unit.isAlive:
			var attacker = atackers.pick_random()
			var bias = rand.randf_range(0,1)
			if bias > 0.5 and attacker != null:
				deaths.append(attacker)
				attacker_died += 1
			else:
				log_misshit(unit, attacker)
	
	for dead in deaths:
		dead.set_died()
		if dead in defenders :
			gui.log(enemy_regiments.get_rich_regiment_logPrefix() + ": " + dead.get_died_log())
		if dead in atackers:
			gui.log(get_rich_regiment_logPrefix() + ": " + dead.get_died_log())
			
	if hasRegiment_lost_battle(atackers):
		endof_battle_unlock()
		gui.log(get_rich_regiment_logPrefix() + "sind vernichtet.")
		queue_free()
		
	if hasRegiment_lost_battle(defenders):
		endof_battle_unlock()
		gui.log(enemy_regiments.get_rich_regiment_logPrefix() + "sind vernichtet.")		
		enemy_regiments.queue_free()
	
	return [attacker_died, defender_died]

func endof_battle_unlock():
	hasBattle = false
	isInBattle = false
	markerIcon.visible = false
	enemy_regiments.hasBattle = false
	enemy_regiments.isInBattle = false

func hasRegiment_lost_battle(units : Array):
	var count = 0
	for unit in units:
		if unit.isAlive:
			return false
	return true

func _on_area_2d_enemy_range_area_exited(area):
	modulate = Color.WHITE
	enemy_regiments = area.get_parent()
	battleLabel.text = ""
	isInBattle = false
	isMoveable = true
