class_name RegimentBattle
extends Node2D

enum ATTACK_ANGLE { FRONT = 0, FLANK = 1, REAR = 2}
var attacker : FactionRegiment
var defender : FactionRegiment
var battle_position : Vector2
var angle_of_attack : ATTACK_ANGLE


func setup(att : FactionRegiment, def : FactionRegiment, position : Vector2, attack_angle : ATTACK_ANGLE):
	attacker = attacker
	defender = def
	battle_position = position
	angle_of_attack = attack_angle
	
