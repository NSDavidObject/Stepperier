Pod::Spec.new do |s|
  s.name = 'Stepperier'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'An interactive draggable stepper'
  s.homepage = 'https://github.com/NSDavidObject/Stepperier'
  s.social_media_url = 'https://twitter.com/NSDavidObject'
  s.authors = { 'David Elsonbaty' => 'dave@elsonbaty.ca' }
  s.source = { :git => 'https://github.com/NSDavidObject/Stepperier.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.source_files = 'Pod/**/*.swift'

  s.requires_arc = true
end
