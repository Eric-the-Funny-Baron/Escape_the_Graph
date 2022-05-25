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
signal hint_given
