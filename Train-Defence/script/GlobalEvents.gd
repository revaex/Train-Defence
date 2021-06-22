extends Node

# From other scripts: 
# GlobalEvents.connect("signal_name", self, "_on_GlobalEvents_signal_name")
# GlobalEvents.emit_signal("signal_name", param1, param2)

# warning-ignore:unused_signal
signal game_over

# warning-ignore:unused_signal
signal enemy_dead(enemy)

# warning-ignore:unused_signal
signal car_despawned(car)

# warning-ignore:unused_signal
signal train_connector_broken(index)

# warning-ignore:unused_signal
signal item_picked_up(item)
