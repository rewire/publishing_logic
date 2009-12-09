class PublishingLogicGenerator < Rails::Generator::NamedBase
  def initialize(args, options)
    super(args, options)
  end

  def manifest
    record do |m|
      m.migration_template 'publishing_logic_fields.rb', 'db/migrate', :assigns => {
        :migration_name => "AddPublishingLogicFieldsTo#{class_name.pluralize.gsub(/::/, '')}"
      }, :migration_file_name => "add_publishing_logic_field_to_#{file_path.gsub(/\//, '_').pluralize}"
    end
  end
end
