class Widget < ActiveRecord::Base
  belongs_to :dashboard

  validates_presence_of :title
  validates_length_of :title, maximum: 60

  scope :active, ->{ where(active: true) }

  before_save :setup_uuid
  before_save :persist_configuration

  after_initialize :setup_config_variables

  def config_keys
    []
    # these need to come from a settings file somewhere.
  end

  private

  def setup_config_variables
    current_config = JSON.parse(self.configuration).with_indifferent_access

    config_keys.each do |config_key|
      self.class.send(:attr_accessor, config_key)
      val = instance_variable_set("@#{config_key}".to_sym, current_config.fetch(config_key, nil))
    end
  end

  def config_hash
    Hash[config_keys.map{|key| [key, send(key)]}]
  end

  def persist_configuration
    self.configuration = config_hash.to_json
  end

  def setup_uuid
    self.uuid = SecureRandom.uuid
  end
end
