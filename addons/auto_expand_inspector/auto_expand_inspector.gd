@tool
extends EditorPlugin

const WAIT_INTERVAL: float = 0.1

var eds: EditorSelection = null

var node_inspector = null
var timer: Timer = null


#----------------------------------------------------------------------------------------


func _enter_tree() -> void:
	timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = WAIT_INTERVAL
	timer.timeout.connect(on_timeout)
	
	add_child(timer)
	
	eds = get_editor_interface().get_selection()
	eds.selection_changed.connect(on_selection_changed)
	
	find_inspector()


func _exit_tree() -> void:
	eds.selection_changed.disconnect(on_selection_changed)
	
	if timer:
		remove_child(timer)


#----------------------------------------------------------------------------------------


func on_selection_changed() -> void:
	if node_inspector:
		timer.start()


#----------------------------------------------------------------------------------------


func find_inspector() -> void:
	find_inspector_on_childs(get_tree().root.get_child(0))


func find_inspector_on_childs(node: Node) -> void:
	if node_inspector == null:
		var childs: Array = node.get_children()
		
		for child in childs:
			if node_inspector == null:
				if child.has_method("_menu_expandall"):
					node_inspector = child
				else:
					find_inspector_on_childs(child)


func on_timeout() -> void:
	if node_inspector:
		node_inspector._menu_expandall()
