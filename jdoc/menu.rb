module Jekyll::JDoc
  class Menu < Liquid::Tag
    include Helper
  
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      @current_path = DocumentationFile.current_path(context)
      html = ""
      html << content_tag("ul", :id => "sections", :class => "doc-nav") do
        render_directory(DocumentationFile.documentation_directory, :show_directory => false)
      end
      html
    end

    private

    def render_directory(path, options={})
      defaults = {
        :show_directory => true
      }
      options = defaults.merge(options)
      sorted_children_paths = DocumentationFile.sorted_children_paths(path)
      if options[:show_directory]
        content_tag("li", attributes_for_li(path)) do
          html = content_tag("a", DocumentationFile.file_title(path), {:href => DocumentationFile.file_url(path)})
          if !sorted_children_paths.nil? && !sorted_children_paths.empty?
            html << content_tag("ul", attributes_for_ul(path)) do
              render_directory_pages(path, sorted_children_paths)
            end
          end
          html
        end
      else
        render_directory_pages(path, sorted_children_paths)
      end
    end

    def render_directory_pages(directory_path, sorted_file_paths)
      sorted_file_paths.collect do |file_path|
        DocError.new("#{file_path} does not exist") if !File.exists?(file_path)
        slug = DocumentationFile.path_to_slug(file_path)
        if File.directory?(slug)
          render_directory(slug)
        else
          render_file(file_path)
        end
      end.join("")
    end

    def render_file(path)
      path = DocumentationFile.slug_to_path(path)
      DocError.new("#{path} does not exist") if path.nil? || !File.exists?(path)
      content_tag("li", attributes_for_li(path)) do
        content_tag "a", DocumentationFile.file_title(path), {:href => DocumentationFile.file_url(path)}
      end
    end

    def attributes_for_ul(path)
      attributes = {}
      attributes[:class] = []
      if ul_is_in_current_tree?(path)
        attributes[:class] << "in-active-tree"
      end
      attributes.delete(:class) if attributes[:class].empty?
      attributes
    end

    def attributes_for_li(path)
      attributes = {}
      attributes[:class] = []
      if is_current_path?(path)
        attributes[:class] << "active"
      end
      if li_is_in_current_tree?(path)
        attributes[:class] << "in-active-tree"
      end
      attributes.delete(:class) if attributes[:class].empty?
      attributes
    end

    def ul_is_in_current_tree?(path)
      current_path_slug = DocumentationFile.path_to_slug(@current_path)
      path_slug = DocumentationFile.path_to_slug(path)
      current_path_slug.include?(path_slug)
    end

    def li_is_in_current_tree?(path)
      current_path_slug = DocumentationFile.path_to_slug(@current_path)
      path_slug = DocumentationFile.path_to_slug(path)
      parent_path_slug = DocumentationFile.parent_path(path_slug)
      current_parent_path_slug = DocumentationFile.parent_path(current_path_slug)
      return true if current_path_slug.include?(path_slug)
      return true if [current_path_slug, current_parent_path_slug].include?(parent_path_slug)
      return true if slug_is_child_of_ancestor?(path_slug, current_path_slug)
      false
    end

    def slug_is_child_of_ancestor?(slug, second_slug)
      second_slug_split = second_slug.split("/")
      slug_length = slug.split("/").length
      (1..(second_slug_split.length)).to_a.reverse.each do |ancestor_slug_length|
        ancestor_slug = second_slug_split[0..(ancestor_slug_length-1)].join("/")
        return true if (slug_length - ancestor_slug_length == 1) && slug.include?(ancestor_slug)
      end
      false
    end

    def is_current_path?(path)
      DocumentationFile.path_to_slug(path) == DocumentationFile.path_to_slug(@current_path)
    end
  end
end

Liquid::Template.register_tag('doc_menu', Jekyll::JDoc::Menu)