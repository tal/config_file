require "config_file/version"
require 'yaml'
require 'pathname'
require 'erb'

class ConfigFile < BlankSlate
  class UnknownConfigFile < ArgumentError; end
  class UnknownKey < StandardError; end
  attr_writer :raise_on_missing_key

  def initialize file
    @file = file
    @raise_on_missing_key = false
  end

  def method_missing(key,*args)
    @data = nil if ConfigFile.dev?
    if data.has_key?(key)
      data[key]
    elsif data.has_key?(key.to_s)
      data[key.to_s]
    else
      @raise_on_missing_key ? raise(UnknownKey, "#{key} couldn't be found in #{@file}") : nil
    end
  end

  def __data__
    @data ||= begin
      d = nil
      File.open(@file) do |f|
        d = YAML.load ERB.new(f.read).result
      end
      d = d[ConfigFile.env] if d.has_key? ConfigFile.env
      d
    end
  end
  alias data __data__

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
        Pathname.new(File.expand_path('.'))
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
        new(file)
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
        File.exist?(f)
      end
    end
  end
end
