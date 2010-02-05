class PorkSandwichMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "pork_sandwich_migration"
    end
  end
end