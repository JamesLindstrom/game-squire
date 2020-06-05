module ApplicationHelper
  def grouped_creatures
    [
      OpenStruct.new({ name: 'Players', creatures: current_user.players }),
      OpenStruct.new({ name: 'NPCs', creatures: current_user.npcs }),
      OpenStruct.new({ name: 'Events', creatures: current_user.events })
    ]
  end

  def render_error_messages(record, field)
    return if record.errors[field].none?

    error_string = ''
    record.errors[field].each do |error|
      error_string += "#{field.to_s.humanize.titleize} #{error}. "
    end
    content_tag(:error, error_string)
  end
end
