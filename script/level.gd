extends Node2D

class_name Level

const ToadCorpse = preload("res://scene/ToadCorpse.tscn")
const ToadExplosionParticle = preload("res://scene/ExplosionParticle.tscn")
const Coins = preload("res://scene/Coins.tscn")
const Spikes = preload("res://scene/Spikes.tscn")
const Bottle = preload("res://scene/Bottle.tscn")

signal end_of_level_reached
signal player_hp_changed(amount)
signal coins_picked_up(amount)
signal weapon_equipped(weapon)
signal go_inside_bar()
signal activate_checkpoint(checkpoint_position)
signal return_to_checkpoint()

var saved_player_pos : Vector2

func _ready():
	self.connect("end_of_level_reached", get_parent(), "load_second_level")
	self.connect("player_hp_changed", get_parent(), "update_hp_bar")
	self.connect("coins_picked_up", get_parent(), "add_coins")
	self.connect("weapon_equipped", get_parent(), "update_weapon_display")
	self.connect("go_inside_bar", get_parent(), "load_bar_scene")
	self.connect("activate_checkpoint", get_parent(), "save_checkpoint")
	self.connect("return_to_checkpoint", get_parent(), "restore_checkpoint")
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
	new_weapon.velocity = throwImpulse
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
	call_deferred("add_child", coins)
	return

func spawn_lizard_spikes(lizard_position, lizard_rotation, lizard_attack):
	var spikes = Spikes.instance()
	spikes.position = lizard_position
	spikes.rotation = lizard_rotation
	spikes.damage = lizard_attack
	add_child(spikes)
	return
	
func spawn_thrown_bottle(kanga_position, kanga_rotation, kanga_attack):
	var bottle = Bottle.instance()
	bottle.position = kanga_position
	bottle.rotation = kanga_rotation
	bottle.damage = kanga_attack
	add_child(bottle)
	return

func end_of_level_reached():
	emit_signal("end_of_level_reached")
	return

func player_hp_changed(amount):
	emit_signal("player_hp_changed", amount)
	return
	
func coins_picked_up(amount):
	emit_signal("coins_picked_up", amount)
	return

func weapon_equipped(weapon):
	emit_signal("weapon_equipped", weapon)
	return

func weapon_picked_up():
	var player = get_node("Player")
	get_tree().get_root().get_node("MasterScene/SoundManager/BoomerangPickup").play()
	player.boomerang_carried = true
	player.equip_weapon("Boomerang")
	return

func go_inside_bar():
	emit_signal("go_inside_bar")
	return
	
func activate_checkpoint(checkpoint_position):
	emit_signal("activate_checkpoint", checkpoint_position)
	return

func return_to_checkpoint():
	emit_signal("return_to_checkpoint")
	return
	
func interact():
	pass
