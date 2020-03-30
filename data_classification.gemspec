require_relative 'lib/data_classification/version'

Gem::Specification.new do |spec|
  spec.name          = "data_classification"
  spec.version       = DataClassification::VERSION
  spec.authors       = ["HackerOne Open Source", "Ben Willis"]
  spec.email         = ["opensource+data_classification@hackerone.com", "ben@hackerone.com"]

  spec.summary       = %q{
    DataClassification helps you tag your database columns with smart comments in order to classify your data.
  }
  spec.description   = %q{
    By leveraging smart comments in your schema, you can easily use this data throughout your app
    and make better decisions when logging data, exposing data through endpoints, monitoring data sent elsewhere,
    or allowing other systems accessing your database to consume the classifications.
  }
  spec.homepage      = "https://github.com/Hacker0x01/data_classification"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.add_dependency('activerecord', '> 5.0')
  spec.add_dependency('railties', '> 5.0')
  spec.add_development_dependency('pry')

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Hacker0x01/data_classification"
  spec.metadata["changelog_uri"] = "https://github.com/Hacker0x01/data_classification/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
