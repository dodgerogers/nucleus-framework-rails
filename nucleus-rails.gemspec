require_relative "lib/nucleus-rails/version"

Gem::Specification.new do |spec|
  spec.name = "nucleus-rails"
  spec.version = NucleusRails::VERSION
  spec.authors = ["dodgerogers"]
  spec.email = ["dodgerogers@hotmail.com"]
  spec.summary = "A Rails wrapper for the `nucleus-rails` gem"
  spec.homepage = "https://github.com/dodgerogers/nucleus-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/dodgerogers/nucleus-rails/issues",
    "changelog_uri" => "https://github.com/dodgerogers/nucleus-rails/releases",
    "source_code_uri" => "https://github.com/dodgerogers/nucleus-rails",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nucleus-framework", '>= 0.2.0'

  spec.add_development_dependency "rails", '~> 5.2.2'
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "minitest-ci", "~> 3.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "1.43.0"
  spec.add_development_dependency "rubocop-minitest", "0.26.1"
  spec.add_development_dependency "rubocop-packaging", "0.5.2"
  spec.add_development_dependency "rubocop-performance", "1.15.2"
  spec.add_development_dependency "rubocop-rake", "0.6.0"
end
