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
signal title_screen_requested(should_fade_out)
signal game_over_screen_requested
signal game_won_screen_requested
signal change_visibility(node_name)
signal sound_start_requested(sound_name)
signal sound_stop_requested(sound_name)
signal touch_box_toggled
signal help_update_requested(help_name)
signal confirmation_requested
signal yes_pressed
signal no_pressed
signal show_settings
signal level_save_requested(level_name, solved, solve_num, solved_optimal)
signal level_load_requested(level_name)
signal level_status_requested(level_name, level_hub_name, level_link)
signal dialogue_opened(scene_name)
signal evaluation_requested(best_value, value)
signal dialog_finished

