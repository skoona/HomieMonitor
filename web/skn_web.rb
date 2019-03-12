# ##
# File: ./main/skn_web.rb
#
# - Main Web Interface Entry

require 'roda/session_middleware'

class SknWeb < Roda

  opts[:root] = SknApp.root
  opts[:env]  = SknApp.env

  use Rack::CommonLogger
  use Rack::Reloader

  use Rack::Cookies
  use RodaSessionMiddleware, {
      secure: true,
      sessions_convert_symbols: true,
      secret: SknSettings.skn_base.secret,
      key: SknSettings.skn_base.session_key,
      domain: SknSettings.skn_base.session_domain
  }

  # Enables Capybara's Session Access
  use RackSessionAccess::Middleware if opts[:env].test?

  use Rack::MethodOverride

  use Rack::Protection unless opts[:env].test?

  use Rack::ShowExceptions
  use Rack::NestedParams

  plugin :all_verbs
  unless opts[:env].test?
    plugin :route_csrf, { raise: true,
                    csrf_failure: :clear_session,
                    check_request_methods: 'POST',
                    skip_if: lambda { |request|
                      ['HTTP_AUTHORIZATION', 'X-HTTP_AUTHORIZATION',
                       'X_HTTP_AUTHORIZATION', 'REDIRECT_X_HTTP_AUTHORIZATION'].any? {|k|
                        request.env.key?(k) }
                  }}
  end

  # ERB support in SCSS, already present for JS
  Tilt.pipeline('scss.erb')

  plugin :assets, {
      css_dir: 'stylesheets',
      js_dir: 'javascript',
      css: ['skn.scss.erb' ],
      js: ['jquery-3.2.1.js', 'bootstrap-3.3.7.js', 'jquery.matchHeight.js', 'bootstrap-select.js', 'jquery.fine-uploader.js', 'skn.custom.js.erb'],
      dependencies: {'_bootstrap.scss' => Dir['assets/stylesheets/**/*.scss', 'assets/stylesheets/*.scss']}
  }

  plugin :render, {
      engine: 'html.erb',
      escape: false,
      views: "#{opts[:root]}/web/views",
      allowed_paths: ['/', '/layouts', '/profiles'],
      layout: '/application',
      layout_opts: {views: "#{opts[:root]}/web/views/layouts"}
  }

  plugin :not_found do # Path Not Found Handle
    view :http_404, path: File.expand_path('web/views/http_404.html.erb', opts[:root])
  end

  plugin :error_handler do |uncaught_exception|  # Uncaught Exception Handler
    view :unknown, locals: {exception: uncaught_exception }, path: File.expand_path('web/views/unknown.html.erb', opts[:root])
  end

  compile_assets if opts[:env].production?


  plugin :view_options
  plugin :symbol_views
  plugin :symbol_status
  plugin :content_for
  plugin :forme
  plugin :tag_helpers        # includes :tag plugin, for HTML generation: https://github.com/kematzy/roda-tags/
  plugin :json
  plugin :i18n, :locale => ['en']   # i18n.fallbacks = [I18n.default_locale]
  plugin :flash
  plugin :public             #replaces plugin :static, %w[/images /fonts]
  plugin :head
  plugin :halt
  plugin :drop_body

  plugin :multi_route

  # ##
  # Routing Table
  # ##
  route do |r|

    r.assets unless opts[:env].production?

    r.public

    r.multi_route

    r.root do
      # view(:homepage)
      # flash_message(:info, ['Banner Art from: <strong><a href="http://apod.nasa.gov/" target="_blank">NASA Astronomy Picture of the Day</a></strong>.'], true)
      flash_message(:success, ['Welcome to HomieMonitor! Administrative Controller as specified by <strong><a href="https://homieiot.github.io" target="_blank">Homie: An MQTT Convention for IoT/M2M</a></strong>.'], true)

      wrap_html_response(registry_service.content_broadcasts, :homepage)
    end

  end # End Routing Tree

end # end class


