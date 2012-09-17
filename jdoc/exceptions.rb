module Jekyll::JDoc
  class DocError < StandardError
    def initialize(msg)
      raise msg + "<div class='doc-error'>" + caller.join("<br />") + "</div>"
    end
  end
end