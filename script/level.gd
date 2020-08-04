extends Node2D

class_name Level

const ToadCorpse = preload("res://scene/ToadCorpse.tscn")
const ToadExplosionParticle = preload("res://scene/ExplosionParticle.tscn")
const Coins = preload("res://scene/Coins.tscn")

signal end_of_level_reached


func _ready():
	self.connect("end_of_level_reached", get_parent(), "load_next_level")
	return

#func _process(_delta):
	#var path = $Navigation2D.get_simple_path($Explodetoad.position, $Player.position)
	#$PathDebug.points = path
#	return

func spawn_boomerang(weapon, player_position, mouse_position, throw_strength):
	var new_weapon = weapon.instance()
	add_child(new_weapon)
	new_weapon.position = player_position
	var throwImpulse = (mouse_position - new_weapon.global_position).normalized() * throw_strength
	new_weapon.apply_central_impulse(throwImpulse)
	return

func spawn_toad_corpse(original_position):
	var toad_corpse = ToadCorpse.instance()
	toad_corpse.position = original_position
	add_child(toad_corpse)
	return

func spawn_toad_particles(original_position):
	var explosion = ToadExplosionParticle.instance()
	explosion.position = original_position
	explosion.one_shot = true
	add_child(explosion)
	return

func spawn_coins(crate_position):
	var coins = Coins.instance()
	coins.position = crate_position
	add_child(coins)
	return

func end_of_level_reached():
	emit_signal("end_of_level_reached")
	return
