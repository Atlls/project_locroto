extends Area2D

@export var item: Item

func collect(inventory: Inventory):
	inventory.insert(item)
	queue_free()
