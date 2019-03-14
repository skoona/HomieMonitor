# ##
#
# Handle Temporary File Response
# Services::Handlers::ReceiveFile
#
# Three File Types Expected: SPIFFS, Homie-Code, Ardunio-Code
# - Need a MD5 Hash and Homie Version Extractor
#

# File Params
# {
#   "qquuid"=>"43636118-c89e-48bc-a354-c52799628757",
#   "qqfilename"=>"Butterfly_HubbleVargas_5075.jpg",
#   "qqtotalfilesize"=>"981840",
#   "qqfile"=>{
#       :filename=>"Butterfly_HubbleVargas_5075.jpg",
#       :type=>"image/jpeg",
#       :name=>"qqfile",
#       :tempfile=>#<Tempfile:/var/folders/gm/6hf5xns52cddrgnqz6zz48bxyht1rq/T/RackMultipart20190308-29136-w5rdv7.jpg>,
#       :head=>"Content-Disposition: form-data; name=\"qqfile\"; filename=\"Butterfly_HubbleVargas_5075.jpg\"\r\nContent-Type: image/jpeg\r\n"
#     }
# }

module Services
  module Handlers

    class ReceiveFile
      def self.call(fname, fsize, tfile)
        self.new.call(fname, fsize, tfile)
      end

      def initialize()
        @_temp_path = SknSettings.content_service.firmware_path
      end

      def call(fname, fsize, tfile)
        fpath = "#{@_temp_path}#{fname}"
        written = save_file(fpath, tfile)

        msg = "#{self.class.name}##{__method__} Processed(#{fpath}): bytesWritten=#{written} vs bytesDownloaded=#{fsize}"
        SknApp.logger.debug msg
        SknSuccess.call({success: true,
                         error: "",
                         payload: Homie::Component::Firmware.new(fpath).to_hash,
                         reset: false
                        },
                        msg
        )
        
      rescue => ex
        msg = "#{self.class.name}##{__method__} Failure: klass=#{ex.class.name}, cause=#{ex.message}, Backtrace=#{ex.backtrace[0..8]}"
        SknApp.logger.error msg
        SknFailure.("", msg)
      end

      def save_file(filename, tfile)
        FileUtils.cp(tfile.path, filename)
        tfile.close!
        File.size(filename)
      end

    end # end class
  end
end
