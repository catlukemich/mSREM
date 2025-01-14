class_name RoadCrossing
extends Node2D

enum Direction { WEN, NSW, WES, NSE}
@export var direction = Direction.WES
var cars : Array = Array()

static var priority_map = {
	Direction.WEN: [2, 6, 4],
	Direction.NSW: [4, 0, 2],
	Direction.WES: [2, 6, 0],
	Direction.NSE: [0, 4, 6],
}

func get_priority() -> Array:
	return priority_map[direction]

# Register car on the crossing
func register_car(car : Car):
	if not has_registered_car(car):
		cars.append(car)

func get_registered_cars() -> Array:
	return cars

func deregister_car(car : Car):
	cars.remove_at(cars.find(car))

func has_registered_car(car : Car):
	return cars.find(car) != -1


