module Jekyll::JDoc
  class Children < Liquid::Tag
    include Helper

    def render(context)
      site = context.registers[:site]
      info = { :filters => [Jekyll::Filters], :registers => { :site => site } }
      payload = site.site_payload
      
      current_slug = DocumentationFile.current_slug(context)
      children_paths = DocumentationFile.sorted_children_paths(current_slug)
      
      children_paths.collect do |child_path|
        render_child(child_path, payload, info)
      end.join("")
    end

    private

    def render_child(path, payload, info)
      content = DocumentationFile.page_content(path)
      render_child_header(path) +
      Liquid::Template.parse(content).render(payload, info)
    end

    def render_child_header(path)
      content_tag "div", :class => "doc-child-header" do
        content_tag("a", "View alone", :href => DocumentationFile.file_url(path), :class => "doc-child-link") +
        content_tag("h3", DocumentationFile.file_title(path))
      end
    end
  end
end

Liquid::Template.register_tag('doc_children', Jekyll::JDoc::Children)