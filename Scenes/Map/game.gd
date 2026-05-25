extends Node2D

@export var position_affichage: Vector2 = Vector2(532, 64)
@export var espacement_y: float = 64
@export var max: int = 5

@onready var L := preload("res://Entity/Piece/L/L.tscn")
@onready var J := preload("res://Entity/Piece/J/J.tscn")
@onready var I := preload("res://Entity/Piece/I/I.tscn")
@onready var O := preload("res://Entity/Piece/O/O.tscn")
@onready var S := preload("res://Entity/Piece/S/S.tscn")
@onready var T := preload("res://Entity/Piece/T/T.tscn")
@onready var Z := preload("res://Entity/Piece/Z/Z.tscn")

var current_piece
var liste_pieces_suivantes: Array = []
var toutes_les_pieces: Array
var instances_affichage: Array = []
var compteur_pieces: int = 0

func _ready() -> void:
	toutes_les_pieces = [L, J, I, O, S, Z, T]
	
	for i in range(max):
		liste_pieces_suivantes.append(toutes_les_pieces[randi() % toutes_les_pieces.size()])
		
	spawn_piece()

func spawn_piece() -> void:
	if compteur_pieces >= max:
		return
	compteur_pieces += 1
	var scene = liste_pieces_suivantes.pop_front()
	current_piece = scene.instantiate() 
	var positions = {
		L: Vector2(296, 24),
		J: Vector2(312, 24),
		I: Vector2(304, 32),
		O: Vector2(320, 16),
		S: Vector2(312, 24),
		Z: Vector2(312, 24),
		T: Vector2(312, 8),
	}
	current_piece.position = positions[scene] 
	current_piece.end.connect(spawn_piece)
	add_child(current_piece)
	actualiser_affichage_pieces()

func actualiser_affichage_pieces() -> void:
	for instance in instances_affichage:
		instance.queue_free()
	instances_affichage.clear()
	for i in range(liste_pieces_suivantes.size()):
		var scene_a_afficher = liste_pieces_suivantes[i]
		var preview = scene_a_afficher.instantiate()
		preview.process_mode = Node.PROCESS_MODE_DISABLED
		preview.position = position_affichage + Vector2(0, i * espacement_y)
		add_child(preview)
		instances_affichage.append(preview)
