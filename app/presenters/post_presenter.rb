class PostPresenter
  def inistialize(post)
    @post = post
  end

  def content_as_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    markdown.render(@post.content)
  end
end
