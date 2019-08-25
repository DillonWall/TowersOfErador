extends Node

var _max_health
var _max_mana
var _base_attack_power
var _base_defense
var _base_magic_power
var _base_magic_defense
var _base_attack_speed
var _base_movement_speed

var _health
var _mana
var _attack_power
var _defense
var _magic_power
var _magic_defense
var _attack_speed
var _movement_speed

var _is_player

func _init(health, mana, attack_power, defense, magic_power, magic_defense, attack_speed, movement_speed, is_player):
	_max_health = health
	_health = health
	_max_mana = mana
	_mana = mana
	_base_attack_power = attack_power
	_attack_power = attack_power
	_base_defense = defense
	_defense = defense
	_base_magic_power = magic_power
	_magic_power = magic_power
	_base_magic_defense = magic_defense
	_magic_defense = magic_defense
	_base_attack_speed = attack_speed
	_attack_speed = attack_speed
	_base_movement_speed = movement_speed
	_movement_speed = movement_speed
	_is_player = is_player

func update():
	if _is_player:
		#print("emitting signals")
		SignalManager.emit_signal("player_max_health_changed", _max_health)
		SignalManager.emit_signal("player_health_changed", _health)
		SignalManager.emit_signal("player_max_mana_changed", _max_mana)
		SignalManager.emit_signal("player_mana_changed", _mana)

func take_physical_damage(amount):
	if _defense >= amount:
		_health -= 1
	else:
		_health -= amount - _defense
	if _is_player:
		SignalManager.emit_signal("player_health_changed", _health)

func take_magical_damage(amount):
	if _magic_defense >= amount:
		_health -= 1
	else:
		_health -= amount - _magic_defense
	if _is_player:
		SignalManager.emit_signal("player_health_changed", _health)

func get_attack_power():
	return _attack_power

func get_magic_power():
	return _magic_power
	
func get_attack_speed():
	return _attack_speed
	
func get_movement_speed():
	return _movement_speed
	
func is_dead():
	return _health <= 0
	
func increase_max_health(amount):
	_max_health += amount
	_health += amount
	if _is_player:
		SignalManager.emit_signal("player_max_health_changed", _max_health)
		SignalManager.emit_signal("player_health_changed", _health)

func increase_max_mana(amount):
	_max_mana += amount
	_mana += amount
	if _is_player:
		SignalManager.emit_signal("player_max_mana_changed", _max_mana)
		SignalManager.emit_signal("player_mana_changed", _mana)

func set_base_attack_power(amount):
	_attack_power += amount - _base_attack_power
	_base_attack_power = amount
	
func set_base_defense(amount):
	_defense += amount - _base_defense
	_base_defense = amount
	
func set_base_magic_power(amount):
	_magic_power += amount - _base_magic_power
	_base_magic_power = amount
	
func set_base_magic_defense(amount):
	_magic_defense += amount - _base_magic_defense
	_base_magic_defense = amount
	
func set_base_attack_speed(amount):
	_attack_speed += amount - _base_attack_speed
	_base_attack_speed = amount
	
func set_base_movement_speed(amount):
	_movement_speed += amount - _base_movement_speed
	_base_movement_speed = amount
	
func increase_health(amount):
	_health += amount
	if _health > _max_health:
		_health = _max_health
	if _is_player:
		SignalManager.emit_signal("player_health_changed", _health)

func increase_mana(amount):
	_mana += amount
	if _mana > _max_mana:
		_mana = _max_mana
	if _is_player:
		SignalManager.emit_signal("player_mana_changed", _mana)

func increase_attack_power(amount):
	_attack_power += amount
	
func increase_defense(amount):
	_defense += amount
	
func increase_magic_power(amount):
	_magic_power += amount
	
func increase_magic_defense(amount):
	_magic_defense += amount
	
func increase_attack_speed(amount):
	_attack_speed += amount
	
func increase_movement_speed(amount):
	_movement_speed += amount