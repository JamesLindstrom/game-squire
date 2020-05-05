module ApplicationHelper
  def render_error_messages(record, field)
    return if record.errors[field].none?

    error_string = ''
    record.errors[field].each do |error|
      error_string += "#{field.to_s.humanize.titleize} #{error}. "
    end
    content_tag(:error, error_string)
  end
end
