extends Area2D
class_name HurtArea

signal damage_taken(damage)


func _on_HurtArea_area_entered(area: HitArea):
	emit_signal("damage_taken", area.hit_damage)
