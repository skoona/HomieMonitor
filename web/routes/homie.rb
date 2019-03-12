
# ##
# File ./web/routes/homie.rb
#

class SknWeb

  route('homie') do |r|

    set_view_subdir 'homie'

    r.post "uploads" do
      wrap_json_response(registry_service.firmware_receive(request.params))
    end

  end
end
