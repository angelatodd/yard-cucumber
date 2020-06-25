class YARD::Handlers::Ruby::PlaceholderHandler < YARD::Handlers::Ruby::Base
  handles method_call(:placeholder)

  process do
    instance = YARD::CodeObjects::Placeholder.new(step_transform_namespace,placeholder_name) do |o|
      o.source = statement.source
      o.comments = statement.comments
      o.keyword = 'placeholder'
      o.literal_value = statement[1].source
    end
    parse_block(statement.last.last,owner: instance)
    register instance if instance.value
  rescue StandardError => e
    log.warn(e)
  end

  def step_transform_namespace
    YARD::CodeObjects::Cucumber::CUCUMBER_STEPTRANSFORM_NAMESPACE
  end

  def placeholder_name
    "placeholder#{self.class.generate_unique_id}"
  end

  def self.generate_unique_id
    @placeholder_count = @placeholder_count.to_i + 1
  end
end
