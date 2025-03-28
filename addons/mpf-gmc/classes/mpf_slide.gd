class_name MPFSlide
extends MPFSceneBase
@export var bonus_mob_scene: PackedScene
var _widgets: Control

## A scene root node for creating a Slide that can be added to a display stack using events and the slide_player.

func initialize(n: String, settings: Dictionary, c: String, p: int = 0, kwargs: Dictionary = {}) -> void:
	# The node name attribute is the name of the root node, which could be
	# anything or case-sensitive. Set an explicit key instead, using the name.
	super(n, settings, c, p, kwargs)

func process_widget(widget_name: String, action: String, settings: Dictionary, c: String, p: int = 0, kwargs: Dictionary = {}) -> void:
	if not self._widgets:
		self._widgets = Control.new()
		self._widgets.name = "_%s_widgets" % self.name
		self.add_child(self._widgets)
	self.process_action(widget_name, self._widgets.get_children(), action, settings, c, p, kwargs)

func action_play(widget_name: String, settings: Dictionary, c: String, p: int = 0, kwargs: Dictionary = {}) -> MPFWidget:
	var widget: Node = MPF.media.get_widget_instance(widget_name)
	assert(widget is MPFWidget, "Widget scenes must use (or extend) the MPFWidget script on the root node.")
	widget.initialize(widget_name, settings, c, p, kwargs)
	self._widgets.add_child(widget)
	self._sort_widgets()
	self.register_updater(widget)
	# Copy the original kwargs and remove 'name' before sending active event
	var evt_kwargs = kwargs.duplicate()
	evt_kwargs.erase("name")
	MPF.server.send_event_with_args("widget_%s_active" % widget_name, evt_kwargs)
	return widget

func action_remove(widget: Node, kwargs: Dictionary = {}) -> void:
	self._widgets.remove_child(widget)
	self.remove_updater(widget)
	MPF.server.send_event_with_args("widget_%s_removed" % widget.name, kwargs)
	widget.queue_free()

func clear(context_name: String) -> void:
	if not self._widgets:
		return
	for w in self._widgets.get_children():
		if w.context == context_name:
			self.action_remove(w)

func _sort_widgets() -> void:
	var new_order: Array[Node] = self._widgets.get_children()
	new_order.sort_custom(
		func(a: MPFWidget, b: MPFWidget): return a.priority < b.priority
	)
	for i in range(0, new_order.size()):
		self._widgets.move_child(new_order[i], i)

func _to_string() -> String:
	return "<%s:MPFSlide:pri=%s:%s" % [self.name, self.priority, self.get_instance_id()]
	
	##Bonus Animatiuon Call handler
func bonus_anima(_settings, _kwargs):
	
	#first call an instance of the bonus mob
	var mob = bonus_mob_scene.instantiate()
	#choose random locaiton to spawn
	var mob_spawn_location = $BonusMobPath/BonusMobSpawn
	mob_spawn_location.progress_ratio = randf()
	#set spawn position
	mob.position = mob_spawn_location.position
	#print("mob position is:", mob.position)
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	#set velocity for mob
	var velocity = Vector2(-300,0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	#print("bonus added")
	add_child(mob)
	
	
