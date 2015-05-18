require "bengt/version"
require 'require_all'
require 'faraday'
require 'virtus'
require 'json'

require 'bengt/configuration'
require 'bengt/models/post'
require 'bengt/filter'

autoload_all File.dirname(__FILE__) + "/bengt"

module Bengt
end
