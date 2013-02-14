class ApplicationController < ActionController::Base
  include MultiSite::Helpers
  protect_from_forgery
  before_filter :lookup_site

  private

  def lookup_site
    logger.debug("Request host is #{request.host}")
    multi_site!(request.host, true)
  end
end
