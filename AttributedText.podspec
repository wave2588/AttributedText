Pod::Spec.new do |s|
  s.name             = 'AttributedText'
  s.version          = '0.7.0'
  s.summary          = 'A short description of AttributedText.'

  s.homepage         = 'https://github.com/wave2588/AttributedText'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wave2588' => 'q.wavedev@gmail.com' }
  s.source           = { :git => 'https://github.com/wave2588/AttributedText.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'AttributedText/Classes/**/*'

  s.dependency 'SwifterSwift'

end
