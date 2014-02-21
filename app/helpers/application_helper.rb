module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}
  end
  
  def arrow(column)
    direction = sort_direction == "desc" ? "down" : "up"
    icon = column == sort_column ? "glyphicon-chevron-#{direction}" : nil
    arrow = '<i class="glyphicon ' << "#{icon}" << '"></i>'
    arrow = raw(arrow)
  end
end
