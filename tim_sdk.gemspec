require_relative 'lib/tim_sdk/version'

Gem::Specification.new do |spec|
  spec.name    = 'tim_sdk'
  spec.version = TimSdk::VERSION
  spec.authors = ['JiangYongKang']
  spec.email   = ['vincent4502237@gmail.com']

  spec.summary               = 'tencent tim sdk for ruby'
  spec.description           = 'a ruby program to facilitate accessing tim service'
  spec.homepage              = 'https://github.com/JiangYongKang/tim_sdk'
  spec.license               = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/JiangYongKang/tim_sdk'
  spec.metadata['changelog_uri']   = 'https://github.com/JiangYongKang/tim_sdk'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
