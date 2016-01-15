class Widget < ActiveRecord::Base
  include ClassyEnum::ActiveRecord
  classy_enum_attr :category

  belongs_to :dashboard

  validates_presence_of :category
  validates_presence_of :title
  validates_length_of :title, maximum: 60

  scope :active, ->{ where(active: true) }

  before_create :setup_uuid
  before_save :update_configuration

  after_initialize :setup_local_configurations

  def method_missing(method, *args, &block)
    # getter
    return @local_configuration[method] if category.fields.keys.include?(method)

    # setter
    if setter_field = category.fields.keys.find{|k| "#{k}=".to_sym == method }
      return @local_configuration[setter_field] = args[0]
    end

    raise 'Unknown field'
  end

  def travis_url
    server_url + '/repos/' + project_name
  end

  private
  def setup_local_configurations
    @local_configuration = self.configuration.try(:with_indifferent_access) || {}
  end


  def update_configuration
    self.configuration = @local_configuration
  end

  def setup_uuid
    self.uuid = SecureRandom.uuid
  end
end
