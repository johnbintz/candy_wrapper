require "candy_wrapper/version"
require "candy_wrapper/model_wrapper"
require "candy_wrapper/inherited_resources"

if defined?(ActiveAdmin)
  require 'candy_wrapper/active_admin'
end
