class Site < ActiveRecord::Base
  validates_uniqueness_of :fqdn

  def domain_layout
    super || self.fqdn
  end

  def asset_safe_domain_layout
    self.domain_layout.tr('.', '_')
  end

  def css_class
    self.asset_safe_domain_layout
  end

  def css_filename
    "#{self.asset_safe_domain_layout}.css"
  end

  def google_domain
    super || self.fqdn
  end

  def self.default
    new.tap do
      # setup the default site
    end
  end
end
