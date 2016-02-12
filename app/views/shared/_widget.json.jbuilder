json.uuid widget.uuid
json.title widget.title
json.category widget.category
json.layout do 
	json.x widget.position_x
	json.y widget.position_y
	json.h widget.height
	json.w widget.width
end
json.widgetPath api_widget_path(id: widget.id)
