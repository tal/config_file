module ConfigFile
  module ClassMethods
    attr_reader :config_file

    def config_file_name=file
      @config_file = ConfigFile.send(file)
      __setup_config_methods__
      @config_file
    rescue UnknownConfigFile
      @config_file
    end

    def __setup_config_methods__
      @config_file.__data__.each do |k,v|
        instance_eval <<-RUBY
        def #{k}
          @config_file.#{k}
        end
        RUBY
      end
    end

  end

  module InstanceMethods
  end

  def self.included(receiver)
    word = receiver.to_s
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!

    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.config_file_name = word
  end
end