# A better way to say it
module Skn
  class Version
    MAJOR = 0
    MINOR = 6
    PATCH = 5

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end


  VERSION = Version.to_s
end