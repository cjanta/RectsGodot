# open with editor Godot v4.2.2.stable.official.15073afe3 
https://godotengine.org
Godot_confiq:
	Project -> General -> Textures -> Default Texture Filter: nearest
	Project -> General -> Display -> Window -> Stretch: Mode: viewport , Scale Mode: integer
# MEILENSTEIN 0
> grundlegende Struktur des Objekt Modells des Spiels. Bootsequenz
> grundlegende Steurung der Einheiten. DragnDrop Bewegung und Rotation
> Angriff initieren, Kampfberechnung und Verlust eines Regiments
> Ende der Demo durch Verlust aller Regimente

# MEILENSTEIN 1
> komplette Revision von Meilenstein 0
> Klassennamen: konsistene camleCase verwenden
> Kapselung: Funktionalitäten kapseln wo es möglich ist
> Generalisierung und Typisierung der Fraktionen, Regimenter, Einheiten
> Struktur des Filesystems, Ordnerstruktur
> Grundlegende GUI: 
	- Session anzeige Mitte/Oben
	- Einheitenauswahl Freund und Feind Mitte/Rechts
	- eine Aktionsleiste Unten/Rechts
	- Protokoll Unten/links
> Festlegung der Sprites: size 64px entspricht 1 Zoll
> Sprites als sprite_scene (head,chest, left,right, feet etc.)

## Erste Spielregeln aka RULES
> RULE: Rundensequenz: Angriffe deklarieren, Bewegungen und Aktionen, Kampf
> RULE: Mögliche Angriffe erkennen und Angriff deklarieren
> RULE: Bewegung und Rotation gem. Aktionspunkten
> RULE: Kampfberechnung
