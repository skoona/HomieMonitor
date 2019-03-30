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

  use Rack::ShowExceptions
  use Rack::NestedParams

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


  plugin :all_verbs
  plugin :json_parser
  plugin :halt
  plugin :json
  plugin :head
  plugin :flash
  plugin :public             #replaces plugin :static, %w[/images /fonts]

  plugin :assets, {
      css_dir: 'stylesheets',
      js_dir: 'javascript',
      css: ['skn.scss.erb' ],
      js: ['jquery-3.2.1.js', 'bootstrap-3.3.7.js', 'jquery.matchHeight.js', 'jquery.fine-uploader.js', 'skn.custom.js.erb'],
      # js_compressor: :yui, # :uglifier,
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

  plugin :view_options
  plugin :symbol_views
  plugin :symbol_status
  plugin :content_for
  plugin :forme
  plugin :tag_helpers        # includes :tag plugin, for HTML generation: https://github.com/kematzy/roda-tags/
  plugin :i18n, :locale => ['en']   # i18n.fallbacks = [I18n.default_locale]
  plugin :drop_body

  plugin :multi_route

  compile_assets if opts[:env].production?

  # ##
  # Routing Table
  # ##
  route do |r|

    SknApp.logger.debug("Params: #{request.params}")

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


