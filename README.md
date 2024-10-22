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

# MEILENSTEIN 2
Project verbockt, muss ich leider so hinnehmen.
1. Bootsequenz grottig beim nächsten Versuch es ähnlich wie in Linux angehen gelayert die Objekthierachie hochziehen,
   konfigurieren, anzeigen/visualisieren -> layer0, layer1, layer2 ...
2. Typisierungen der Einheiten und Regimenter und Spieler ok aber Filesystem eher Enitätssystem verwenden
3. **Memo an mich selbst: "Entscheide dich endlich ob 64x zu 1 Zoll oder 32px zu 1 Zoll**


Fazit nur nächsten Revision des Ganzen:
Usecase, Klassen (grob - Assoziationsgeflecht später) und grobes Sequenzdiargramm erstellen.
plan do check act
