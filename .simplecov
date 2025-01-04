require "simplecov"
require "simplecov-cobertura"

if ENV["MINIMUM_COVERAGE"]
  SimpleCov.minimum_coverage ENV["MINIMUM_COVERAGE"].to_i
end

SimpleCov.start "test_frameworks" do
  add_filter %r{^/config/}
  add_filter %r{components/.*/config/}
  add_filter %r{^/db/}
  add_filter %r{components/.*/db/}
  add_filter %r{^/app/channels/}
  add_filter "/lib/tasks"
  add_filter "/vendor"
  add_filter "/Rakefile"
  add_filter "/scripts"
  add_filter "components/component/template.rb"

  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Mailers", "app/mailers"
  add_group "Helpers", "app/helpers"
  add_group "Jobs", %w[app/jobs app/workers]
  add_group "Libraries", "lib/"
  add_group "Services", "app/services"

  track_files "**/*.rb"

  coverage_dir ENV["CI_COVERAGEREPORTS"] || "coverage"

  if ENV["CI"]
    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::CoberturaFormatter,
      SimpleCov::Formatter::SimpleFormatter,
      SimpleCov::Formatter::HTMLFormatter
    ])
  end
end
