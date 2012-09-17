module Jekyll::JDoc
  module Helper
    def content_tag(name, content_or_options_with_block=nil, options=nil, &block)
      if block_given?
        options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        content_tag_string(name, yield, options)
      else
        content_tag_string(name, content_or_options_with_block, options)
      end
    end

    private

    def content_tag_string(name, content, options)
      tag_options = tag_options(options) if options
      "<#{name}#{tag_options}>#{content}</#{name}>"
    end

    def tag_options(options)
      unless options.nil?
        attrs = []
        options.each_pair do |key, value|
          if !value.nil?
            final_value = value.is_a?(Array) ? value.join(" ") : value
            attrs << %(#{key}="#{final_value}")
          end
        end
        " #{attrs.sort * ' '}" unless attrs.empty?
      end
    end
  end
end
