class Widget < ActiveRecord::Base
  include ClassyEnum::ActiveRecord
  classy_enum_attr :category

  belongs_to :dashboard

  validates_presence_of :title
  validates_length_of :title, maximum: 60
  validates_presence_of :category

  scope :active, ->{ where(active: true) }

  before_create :setup_uuid
  before_save :update_configuration

  def configurations
    @configurations ||= JSON.parse(self.configuration).with_indifferent_access
  end

  def method_missing(method, *args, &block)
    return configurations[method] if category.fields.keys.include?(method)

    if setter_field = category.fields.keys.find{|k| "#{k}=".to_sym == method }
      return configurations[setter_field] = args[0]
    end

    raise 'Unknown field'
  end

  def travis_url
    server_url + '/repos/' + project_name
  end

  private

  def update_configuration
    self.configuration = configurations.to_json
  end

  def setup_uuid
    self.uuid = SecureRandom.uuid
  end
end
