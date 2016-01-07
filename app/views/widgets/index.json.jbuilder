json.array!(@widgets) do |widget|
  json.extract! widget, :id, :title, :type, :active
  json.url widget_url(widget, format: :json)
end
