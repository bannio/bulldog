module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(sort: column, direction: direction)
  end
  
  def arrow(column)
    direction = sort_direction == "desc" ? "down" : "up"
    icon = column == sort_column ? "glyphicon-chevron-#{direction}" : nil
    arrow = '<i class="glyphicon ' << "#{icon}" << '"></i>'
    arrow = raw(arrow)
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def flash_normal
   render "layouts/flashes"
  end

  def flash_type_style(type)
   case type
     when :errors   then "alert-error"
     when :alert    then "alert-warning"
     when :error    then "alert-error"
     when :notice   then "alert-success"
     when :success  then "alert-success"
     else "alert-info"
    end
  end
end
