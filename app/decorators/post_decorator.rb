class PostDecorator < Draper::Decorator
  delegate_all

  def content_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    markdown.render(content)
  end
end
