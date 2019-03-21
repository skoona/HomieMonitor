# ##
# File: ./web/views/helpers/request_response_wrappers.rb
#

class SknWeb

  def registry_service
    Services::Providers::Registry.new(roda_context: self)
  end

  def generate_standard_json_error_message(identifier, status, additional_detail=nil)
    {
        success: false,
        error: additional_detail,
        status: Rack::Utils.status_code(status),
        code: identifier,
        additional_detail: additional_detail,
        title: t[:en][:errors][identifier][:title],
        detail: t[:en][:errors][identifier][:detail]
    }
  end

  def wrap_send_file_response(service_response, response_status, error_status=:not_found)
    # Generate content for Response
    if service_response.success
      response['Content-Type'] = service_response.payload.content_type
      response['content-disposition'] = service_response.payload.content_disposition
      request.halt response.finish_with_body(IO.binread(service_response.payload.payload))
    else
      http_response = generate_standard_json_error_message( response_status, error_status, "Request: #{env['REQUEST_URI']}, Message: #{service_response.message}")
      response.status = http_response[:status]
      http_response
    end
  end

  def wrap_html_response(service_response, show_path, redirect_path='/')
    flash_message(:warning, service_response.message, true) unless service_response.message.blank?
    # request.redirect(redirect_path) unless service_response.success
    view(show_path, locals: {resources: service_response })
  end

  def wrap_html_and_redirect_response(service_response, redirect_path='/')
    flash_message(:warning, service_response.message, true) unless service_response.message.blank?
    redirect(redirect_path)
  end

  def wrap_json_response(service_response)
    response.status = (service_response.success ? :accepted : :not_acceptable)
    if service_response.success
      service_response.value.to_json
    else
      generate_standard_json_error_message( response.status,
                                            :not_acceptable,
                                            "Request: #{env['REQUEST_URI']}, Message: #{service_response.message}")
    end
  end

end
