# ##
# File: ./main/services/commands/receive_file.rb
#
#
# cmd = Services::Commands::ReceiveFile.new
# ##
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
  module Commands

    class ReceiveFile

      attr_reader :filename, :tempfile, :filesize

      def initialize(request_params)
        @filename  = request_params["qqfilename"]
        @tempfile  = request_params["qqfile"][:tempfile]
        @filesize  = request_params["qqtotalfilesize"].to_i
        SknApp.logger.debug "#{self.class.name}.#{__method__} File: #{@filename} ~> #{@filesize}"
      end

      def valid?
        tempfile.size > 0
      end

    end

  end
end
