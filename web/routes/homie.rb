
# ##
# File ./web/routes/homie.rb
#

class SknWeb

  route('homie') do |r|

    set_view_subdir 'homie'

    r.post "uploads" do
      wrap_json_response(registry_service.firmware_receive(request.params))
    end

    r.post "delete_firmware" do
      wrap_json_response(registry_service.firmware_delete(request.params))
    end

    r.post "delete_schedule_entry" do
      wrap_json_response(registry_service.schedule_entry_delete(request.params))
    end

    r.post "subscribe" do
      wrap_json_response(registry_service.schedule_entry_add(request.params))
    end

    r.post "device_delete" do
      wrap_json_response(registry_service.device_delete(request.params))
    end

    r.get 'settings' do
      wrap_html_response(registry_service.monitor_settings, :settings)
    end
    r.put "config_update" do
      wrap_json_response(registry_service.update_configuration(request.params))
    end
  end
end
