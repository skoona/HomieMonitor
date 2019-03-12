# ##
# File: ./web/views/helpers/html_helpers.rb
#

class SknWeb


  def menu_active?(item_path)
    request.path.eql?(item_path) ? 'active' : ''
  end

  def attempted_page_name
    attempted_page&.empty? ? '' : attempted_page.split('/').last
  end
  def attempted_page
    session['skn.attempted.page'] || ""
  end

  def current_environment_test?
    SknApp.env.test?
  end
  def current_environment_production?
    SknApp.env.production?
  end
  def current_environment_name
    SknApp.env
  end

  def current_route_name # currently one-level-routes
    current_page_name
  end
  def current_action_name
    elements = current_page.split('/')
    elements[2] || elements[1]
  end

  def current_page_name_include?(page_action)
    current_page_name&.include?(page_action)
  end

  def current_page_name
    current_page&.empty? ? '' : current_page.split('/').last
  end
  def current_page
    request.path
  end

  def release_name_and_version
    release_name + release_version
  end
  def release_name
    SknSettings.Packaging.pgmName
  end
  def release_version
    " Version #{SknSettings.Packaging.releaseVersion}"
  end

  # Rails should have a 'number_to_human_size()' in some version ???
  def human_filesize(value)
    {
        'B'  => 1024,
        'KB' => 1024 * 1024,
        'MB' => 1024 * 1024 * 1024,
        'GB' => 1024 * 1024 * 1024 * 1024,
        'TB' => 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair { |e, s| return "#{(value.to_f / (s / 1024)).round(1)} #{e}" if value.to_i < s }
  end


  def flash_message(rtype, text, now=false)
    type = [:success, :info, :warning, :danger].include?(rtype.to_sym) ? rtype.to_sym : :info
    if text.is_a?(Array)
      text.flatten.each do |val|
        now ? flash_message_now(type, val) : flash_message_next(type, val)
      end
    else
      now ? flash_message_now(type, text) : flash_message_next(type, text)
    end
  end


  def flash_message_next(type, text)
    if flash[type] and flash[type].is_a?(Array)
      flash[type].push( text )
    elsif flash[type] and flash[type].is_a?(String)
      flash[type] = [flash[type], text]
    else
      flash[type] = [text]
    end
  end

  def flash_message_now(type, text)
    if flash.now[type] and flash.now[type].is_a?(Array)
      flash.now[type].push( text )
    elsif flash.now[type] and flash.now[type].is_a?(String)
      flash.now[type] = [flash.now[type], text]
    else
      flash.now[type] = [text]
    end
  end


end
