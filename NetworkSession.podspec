Pod::Spec.new do |spec|
  spec.platform = :ios
  spec.ios.deployment_target = '11.0'
  spec.name         = "NetworkSession"
  spec.version      = "1.2.1"
  spec.summary      = "This is network abstraction layer written in Swift"
  spec.homepage     = "https://github.com/danielrsousa/NetworkSession"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "" => "danielrochadesousa@gmail.com" }
  spec.source       = { :git => "https://github.com/danielrsousa/NetworkSession.git", :tag => "#{spec.version}" }
  spec.source_files  = "NetworkSession/**/*.{swift}"
  spec.swift_version = "5.0"
  spec.vendored_frameworks = 'NetworkSession.framework'
end