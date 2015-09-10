module ArticlesHelper
  def article_status(article)
    case article.status
    when "public" then
      content_tag :span, "公開", :class => "label label-success"
    when "member_only" then
      content_tag :span, "会員限定", :class => "label label-info"
    when "draft" then
      content_tag :span, "下書き", :class => "label label-warning"
    else
      nil
    end
  end
end
