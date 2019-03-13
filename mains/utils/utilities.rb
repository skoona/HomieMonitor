
module Utils

  class Utilities

    def self.make_utf8(char_string)
      char_string.force_encoding("utf-8")
    end
  end
end