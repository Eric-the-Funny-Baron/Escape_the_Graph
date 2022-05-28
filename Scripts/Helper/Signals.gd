extends Node

##
## Signals Script Handler
##
## @desc:
## This Script should handle more complex signals, which often are 
## between several senders and maybe even several receivers.
## Simply add the signal definition here and connect them in the correct Script
## via Signals.connect(...)
##

signal edge_status_changed # the status of the edge is changed
signal points_taken
signal points_given
signal hint_given # signals a hint was given
signal level_requested(level_name)
signal level_hub_requested(level_hub_name)
signal title_screen_requested
signal game_over_screen_requested
signal start_game
