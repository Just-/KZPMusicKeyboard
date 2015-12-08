Pod::Spec.new do |s|
  s.name         = "KZPMusicKeyboard"
  s.version      = "0.1.0"
  s.summary      = "A piano keyboard widget for musical data entry in iOS (iPad)"
  s.homepage     = "https://github.com/kazoompah/KZPMusicKeyboard"
  s.author       = { "Matt Rankin" => "kazoompah@gmail.com" }
  s.source       = { :git => "https://github.com/kazoompah/KZPMusicKeyboard.git" } 
  s.source_files = 'Source/*.{h,m}'
  s.resources    = 'Source/*.xib', 'Source/Images/*.{png,jpg,jpeg}', 'Source/Soundfonts/*.{sf2,plist}'
  s.ios.deployment_target = "7.1"
  s.requires_arc = true
  s.dependency 'TheAmazingAudioEngine'
  s.dependency 'AGWindowView'
end
