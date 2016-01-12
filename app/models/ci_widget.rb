class CiWidget < Widget
  def self.config_keys
    [ :travis_url, :travis_auth_key ]
  end
end
