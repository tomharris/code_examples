module MultiSite
  module Helpers
    extend ActiveSupport::Concern

    included do
      helper_method :site_name
      helper_method :site_fqdn
      helper_method :site_domain_layout
      helper_method :site_asset_safe_domain_layout
      helper_method :site_css_class
      helper_method :site_css_filename
      helper_method :site_use_custom_stylesheet?
      helper_method :multi_site!
    end

    protected

    def site_name
      @site.name
    end

    def site_fqdn
      @current_fqdn
    end

    def site_domain_layout
      @site.domain_layout
    end

    def site_asset_safe_domain_layout
      @site.asset_safe_domain_layout
    end

    def site_css_class
      @site.css_class
    end

    def site_css_filename
      @site.css_filename
    end

    def site_use_custom_stylesheet?
      @site.use_custom_stylesheet?
    end

    def multi_site!(domain, override_views = false)
      @current_fqdn = domain
      @site = Site.find_by_fqdn(@current_fqdn) || Site.default
      ::Rails.logger.debug("Using site name: #{@site.name}, domain layout: #{@site.domain_layout}, for host: #{@current_fqdn}")

      if override_views
        # app/sites/example.com/users/index.html.erb will now be used instead of app/views/users/index.html.erb
        self.view_paths.unshift("#{::Rails.root.to_s}/app/sites/#{@site.domain_layout}")
      end
    end
  end
end
