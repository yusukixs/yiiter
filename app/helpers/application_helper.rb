module ApplicationHelper
  IMAGE_TYPES = { "image/jpeg" => "jpg", "image/gif" => "gif", "image/png" => "png" }
  
  def extension(content_type)
    IMAGE_TYPES[content_type]
  end
  
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
      path = user_path(user, format: extension(user.image.content_type))
      link_to(image_tag(path, { alt: user.full_name }.merge(options)), user_path(user))
    else
      ""
    end
  end
  
  def comment_user_image(comment, options = {})
    if comment
      path = user_path(comment.user_id, format: extension(comment.content_type))
      link_to(image_tag(path, { alt: comment.full_name }.merge(options)), user_path(comment.user_id))
    else
      ""
    end
  end
  
  @@markdown = Redcarpet::Markdown.new Redcarpet::Render::HTML,
    autolink: true,
    space_after_headers: true,
    no_intra_emphasis: true,
    fenced_code_blocks: true,
    tables: true,
    hard_wrap: true,
    xhtml: true,
    lax_html_blocks: true,
    strikethrough: true
  
  def markdown(text)
    @@markdown.render(text).html_safe
  end
end
