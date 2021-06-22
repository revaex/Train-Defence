extends Item

class_name Gun

var projectile
var projectile_speed
var damage
var firing_rate # time between each consecutive bullet
var clip_size # How many rounds can be fired before 'reload'
var saved_clip_size = null
var reload_time
var total_ammo # Total rounds fired before you can no longer shoot this gun
