module ApplicationHelper
  def page_title
    title = "Yiiter"
    title = @page_title + " | " + title if @page_title
    title
  end
end
