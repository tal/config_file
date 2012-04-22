module ConfigFile
  class File < BlankSlate
    attr_writer :raise_on_missing_key

    def initialize file
      @file = file
      @raise_on_missing_key = false
    end

    def method_missing(key,*args)
      @data = nil if ConfigFile.dev?
      if val = (data[key] || data[key.to_s])
        val
      else
        @raise_on_missing_key ? raise(UnknownKey, "#{key} couldn't be found in #{@file}") : nil
      end
    end

    def __data__
      @data ||= begin
        d = nil
        ::File.open(@file) do |f|
          d = YAML.load ERB.new(f.read).result
        end
        d = d[ConfigFile.env] if d.has_key? ConfigFile.env
        d
      end
    end
    alias data __data__

  end
end