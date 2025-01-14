extends Node

signal achievement_change(name: String)
signal modify_inventory

var item_scene = preload("../objects/item.tscn")
var air = {
	"type": "air",
	"amount": 1
}
var inventory: Array = [
	air, air, air, air, air,
	air, air, air, air, air,
	air, air, air, air, air,
	air, air, air, air, air
] # very empty inventory

var achievements = { # [NAME, DESCRIPTION, COMPLETED?]
	"punch_tree": ["boxer's fracture", "punch a tree", false],
	"friend_spin": ["the duck dance", "make your FRIEND SPIN", false],
	"play_mayo": ["\"is mayonnaise an instrument?\"", "yes, it is. (acquire mayonnaise)", false],
	"wood_sword": ["excalibrrrrr", "craft a wooden sword", false]
}

func achievement(id):
	if(achievements[id][2]): return
	achievements[id][2] = true
	emit_signal("achievement_change", id)

func pick_up(item, amount):
	var open_slot = inventory.find(air)
	var stack_slot = -1
	if(item == "mayo"): achievement("play_mayo")
	for i in inventory:
		if i.type == item:
			stack_slot = inventory.find(i)
	if stack_slot == -1:
		if open_slot == -1:
			return false
		else:
			inventory[open_slot] = {
				"type": item,
				"amount": amount
			}
			emit_signal("modify_inventory")
			return true
	else:
		inventory[stack_slot].amount += amount
		emit_signal("modify_inventory")
		return true

func drop(item, amount, pos):
	var item_instance = item_scene.instantiate()
	item_instance.item = item
	item_instance.amount = amount
	item_instance.position = pos
	get_tree().get_root().get_node("Root/Things").add_child(item_instance)
