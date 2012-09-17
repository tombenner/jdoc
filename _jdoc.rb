# Due to how Jekyll includes plugin files, this file needs to begin with an underscore
# for it to be loaded before the "documentation" directory's files.

plugin_path = "#{File.dirname(__FILE__)}/jdoc/"
require "#{plugin_path}exceptions"
require "#{plugin_path}helper"
require "#{plugin_path}documentation_file"
require "#{plugin_path}convertible"
require "#{plugin_path}link"
require "#{plugin_path}menu"
require "#{plugin_path}children"

module Jekyll::JDoc
end