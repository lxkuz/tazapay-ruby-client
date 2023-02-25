# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tazapay/version"

Gem::Specification.new do |spec|
  spec.name = "tazapay"
  spec.version = Tazapay::VERSION
  spec.authors = ["Alexey Kuznetsov"]
  spec.email = ["m2lxkuz@gmail.com"]

  spec.summary = "Tazapay payments API ruby client"
  spec.description = "Tazapay payments API ruby client"
  spec.homepage = "https://github.com/lxkuz/tazapay-ruby-client"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "faraday", "~> 1.0"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "vcr", "~> 5.1"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.metadata["rubygems_mfa_required"] = "true"
end
