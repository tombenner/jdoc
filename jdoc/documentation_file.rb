module Jekyll::JDoc
  class DocumentationFile
    def self.file_title(path)
      path = full_path(path)
      verify_file_existence(path)
      if is_directory?(path)
        index_slug = "#{path}/index"
        index_path = first_file_with_any_extension(index_slug)
        verify_file_existence(index_path, index_slug)
        name_from_file(index_path)
      else
        name_from_file(path)
      end
    end

    def self.file_url(path)
      base_url = Jekyll.configuration({})['baseurl'] || ""
      path = full_path(path)
      "#{base_url}/"+path.gsub(file_extension_regex, ".html")
    end

    def self.is_directory?(path)
      File.directory?(path)
    end

    def self.first_file_with_any_extension(path)
      Dir["#{path}.*"].first
    end

    def self.sorted_children_slugs(path)
      slug = path_to_slug(path)
      sort_path = "#{slug}/_sort.yml"
      if File.file?(sort_path)
        sort_file = File.read(sort_path)
        sorted_slugs = sort_file.lines.collect{|l| l.strip }
      else
        sorted_slugs = Dir["#{slug}/*"].collect{|p| p.split("/").last.gsub(file_extension_regex, "") }.reject{|p| ["_sort", "index"].include?(p) }.sort
      end
      sorted_slugs.reject {|slug| slug.nil? || slug.empty?}
    end

    def self.sorted_children_paths(path)
      slug = path_to_slug(path)
      paths = sorted_children_slugs(path).collect do |child_slug|
        slug_to_path("#{slug}/#{child_slug}")
      end
      paths
    end

    def self.documentation_directory
      "documentation"
    end

    def self.current_path(context)
      current_url = context.environments.first["page"]["url"]
      current_url.gsub(/^\//, "").gsub(/\.html$/, "")
    end

    def self.current_slug(context)
      path_to_slug(current_path(context))
    end

    def self.path_to_slug(path)
      path.gsub(file_extension_regex, "").gsub(/\/$/, "").gsub(/\/index/, "")
    end

    def self.slug_to_path(slug)
      return slug if slug =~ file_extension_regex
      path = first_file_with_any_extension(slug)
      if path.nil?
        path = first_file_with_any_extension("#{slug}/index")
      end
      path
    end

    def self.page_content(path)
      content = read_file(path)
      if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        return $POSTMATCH
      elsif content =~ /^(---\s*\n.*?\n?)/m
        return $POSTMATCH
      end
      content
    end

    def self.read_file(path)
      verify_file_existence(path)
      File.open(path, "rb").read
    end

    def self.parent_path(path)
      path.split('/')[0..-2].join("/")
    end

    private

    def self.file_extension_regex
      /\.[\w_]+$/
    end

    def self.full_path(path)
      if !File.exists?(path)
        if File.exists?("#{documentation_directory}/#{path}")
          path = "#{documentation_directory}/#{path}"
        end
        if !File.exists?(path)
          path_with_extension = first_file_with_any_extension(path)
          if !path_with_extension.nil?
            path = first_file_with_any_extension(path)
          else
            path_with_extension = first_file_with_any_extension("#{documentation_directory}/#{path}")
            if !path_with_extension.nil?
              path = path_with_extension
            end
          end
        end
      end
      verify_file_existence(path)
      path
    end

    def self.name_from_file(path)
      path = full_path(path)
      content = read_file(path)
      title_match = content.match(/^title:\s+(.*)/)
      title_match ? title_match[1] : titleize(path_to_slug(path).split("/").last)
    end

    def self.verify_file_existence(path, displayed_path=nil)
      displayed_path ||= path
      DocError.new("#{displayed_path} doesn't exist") if path.nil? || !File.exists?(path)
    end

    def self.titleize(string)
      string = string.split("_").map(&:capitalize).join(" ")
      ["The", "A", "And"].each do |word|
        string.gsub!(" #{word} ", " #{word.downcase} ")
      end
      string
    end
  end
end
