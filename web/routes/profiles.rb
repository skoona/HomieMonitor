# ##
# File ./web/routes/profiles.rb
#

class SknWeb

  route('profiles') do |r|

    set_view_subdir 'profiles'

    r.get "devices" do
      wrap_html_response(registry_service.content_devices, :devices)
    end

    r.get 'manage' do
      wrap_html_response(registry_service.content_management, :manage)
    end
    r.post "manage" do
      wrap_json_response(registry_service.content_message_transport)
    end

    r.get "details", String do |device_name|
      wrap_html_response(registry_service.content_details(device_name), :details)
    end
    r.post "details", String do |device_name|
      wrap_json_response(registry_service.content_message_transport)
    end

  end
end
