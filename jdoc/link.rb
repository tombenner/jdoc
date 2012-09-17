module Jekyll::JDoc
  class Link < Liquid::Tag
    include Helper
  
    def initialize(tag_name, path_and_text, tokens)
      super
      path_and_text_split = path_and_text.split(" ")
      @path_and_text = path_and_text
      @path = path_and_text_split[0]
      @text = path_and_text_split.length > 1 ? path_and_text_split[1..-1].join(" ") : DocumentationFile.file_title(@path)
    end

    def render(context)
      content_tag("a", @text, :href => DocumentationFile.file_url(@path), :class => "documentation-link")
    end
  end
end

Liquid::Template.register_tag('doc_link', Jekyll::JDoc::Link)