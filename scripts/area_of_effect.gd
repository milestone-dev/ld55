extends Node2D
class_name AreaOfEffect

@export var spell : Spell
@export var collider: Area2D
@export var look_at_pointer: bool = false
# Startes the system on _ready if this is a one_shot
@export var particle_system: GPUParticles2D

func _ready():
	if particle_system and particle_system.one_shot:
		particle_system.emitting = true
