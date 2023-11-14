module FixtureHelpers
  def fixture(file_name, key)
    YAML.load_file(Rails.root.join("spec/fixtures/#{file_name}.yml"))[key]
  end
end
