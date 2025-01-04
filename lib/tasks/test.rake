require "rails/test_unit/runner"

namespace :test do
  task everything: "test:prepare" do
    $: << "test"

    test_files = FileList[
      "test/**/*_test.rb",
    ]

    Rails::TestUnit::Runner.run_from_rake("test", test_files)
  end
end
