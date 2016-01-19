class Widget < ActiveRecord::Base
  include ClassyEnum::ActiveRecord
  classy_enum_attr :category

  belongs_to :dashboard

  validates_presence_of :category
  validates_presence_of :title
  validates_length_of :title, maximum: 60

  validates_numericality_of :height,
    only_integer: true,
    greater_than_or_equal_to: DashboardConfig::MIN_WIDGET_HEIGHT,
    less_than_or_equal_to: DashboardConfig::MAX_WIDGET_HEIGHT,
    allow_nil: true

  validates_numericality_of :width,
    only_integer: true,
    greater_than_or_equal_to: DashboardConfig::MIN_WIDGET_WIDTH,
    less_than_or_equal_to: DashboardConfig::MAX_WIDGET_WIDTH,
    allow_nil: true

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

  def size
    valid_width = width || DashboardConfig::DEFAULT_WIDGET_WIDTH
    valid_height = height || DashboardConfig::DEFAULT_WIDGET_HEIGHT
    {width: valid_width, height: valid_height}
  end

  private
  def setup_local_configurations
    @local_configuration = self.configuration.try(:with_indifferent_access) || {}
  end


  def update_configuration
    self.configuration = @local_configuration
  end

  def valid_config_fields
    category.fields
  end

  def setup_uuid
    self.uuid = SecureRandom.uuid
  end
end
