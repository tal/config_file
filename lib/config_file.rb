require "config_file/version"
require 'yaml'
require 'pathname'
require 'erb'
require 'blankslate'

require 'config_file/file'
require 'config_file/include'

module ConfigFile
  class UnknownConfigFile < ArgumentError; end
  class UnknownKey < StandardError; end

  ALL = {}
  class << self
    attr_writer :env, :root, :config_dirs
    def env
      @env ||= case
      when defined?(ENVIRONMENT)
        ENVIRONMENT
      when defined?(Rails)
        Rails.env
      else
        ENV['RACK_ENV'] || ENV['RAILS_ENV'] || ENV['ENVIRONMENT']
      end
    end

    def root
      @root ||= case
      when defined?(Rails)
        Rails.root
      else
        ::Pathname.new(File.expand_path('.'))
      end
    end

    def dev?
      @dev ||= env == 'development'
    end

    def config_dirs
      @config_dirs ||= %w{config .}
    end

    def method_missing(name,*args)
      ALL[name] ||= if file = find_file(name)
        File.new(file)
      else
        raise UnknownConfigFile, "couldn't find file at 'config/#{name}.yml'"
      end
    end

    private

    def find_file name
      files = []
      config_dirs.each do |dir|
        files << root+"#{dir}/#{name}.yml"
        files << root+"#{dir}/#{name}.yaml"
      end
      files.find do |f|
        ::File.exist?(f)
      end
    end
  end
end
