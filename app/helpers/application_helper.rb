module ApplicationHelper
  def page_title
    title = "Yiiter"
    title = @page_title + " | " + title if @page_title
    title
  end
  
  def menu_link_to(text, path)
    link_to_unless_current(text, path) {content_tag(:span, text)}
  end
  
  def user_image_tag(user, options = {})
    if user.image.present?
      path = user_path(user, format: user.image.extension)
      link_to(image_tag(path, { alt: user.full_name }.merge(options)), user_path(user))
    else
      ""
    end
  end
  
  def markdown(text)
    unless @markdown
      renderer = Redcarpet::Render::HTML.new
      @markdown = Redcarpet::Markdown.new(renderer)
    end

    @markdown.render(text).html_safe
  end
end
