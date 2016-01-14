class UpdateConfigurationKeys < ActiveRecord::Migration
  def self.up
    Widget.all.each do |widget|
      if widget.category == 'ci_widget'
        current_config = JSON.parse(widget.configuration).with_indifferent_access
        if current_config[:travis_auth_key]
          travis_uri = URI.parse(current_config[:travis_url])
          server_url = travis_uri.scheme + '//' + travis_uri.host

          widget.update(server_type: 'travis_ci',
                        server_url: server_url,
                        project_name: widget.title,
                        auth_key: current_config[:travis_auth_key])
        end
      end
    end
  end
end
