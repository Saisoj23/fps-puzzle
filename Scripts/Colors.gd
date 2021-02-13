extends Node

enum COLORS {Blue, Orange}

var color_materials = [
	ResourceLoader.load("res://Materials/GlowBlue.tres"),
	ResourceLoader.load("res://Materials/GlowOrange.tres")
]

var burn_material = ResourceLoader.load("res://Materials/Burn.tres")
