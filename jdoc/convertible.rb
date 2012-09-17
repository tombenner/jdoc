module Jekyll
  module Convertible
    alias_method :read_yaml_original, :read_yaml

    # Add in custom processing for files in the documentation directory, primarily to allow them
    # to not have the usual YAML header
    def read_yaml(base, name)
      path = File.join(base, name)
      self.content = File.read(path)
      relative_base = base.gsub(Dir.pwd, "")
      if relative_base.start_with?("/#{JDoc::DocumentationFile.documentation_directory}")
        if self.content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          self.content = $POSTMATCH
          begin
            self.data = YAML.load($1)
          rescue => e
            puts "YAML Exception reading #{name}: #{e.message}"
          end
          self.data["layout"] = "documentation" if self.data["layout"].nil?
          self.data["title"] = JDoc::DocumentationFile.file_title(path) if self.data["title"].nil?
          return
        elsif self.content =~ /^(---\s*\n.*?\n?)/m
          self.content = $POSTMATCH
          self.data = {
            "layout" => "documentation",
            "title" => JDoc::DocumentationFile.file_title(path)
          }
          return
        end
      end

      read_yaml_original(base, name)
    end
  end
end