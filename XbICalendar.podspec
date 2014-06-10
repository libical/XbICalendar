Pod::Spec.new do |spec|
  spec.name         = "XbICalendar"
  spec.version      = "0.1.3"
  spec.summary      = "XbICalendar is a easy-to-use, framework for iOS that wraps libical."
  spec.homepage     = "https://github.com/ahalls/XbICalendar"
  spec.license      = 'MIT'
  spec.authors      = { "Andrew Halls" => "andrew@galtsoft.com" }
  
  spec.source       = { :git => "https://github.com/ahalls/XbICalendar.git", :tag => spec.version.to_s }
  
  spec.requires_arc = true
  
  spec.source_files = 'XbICalendar', 'XbICalendar/XBICalendar/**/*.{h,m}'
  spec.libraries    = 'z'
  
  spec.ios.deployment_target  = '6.0'
  spec.ios.framework          = 'CFNetwork'
  spec.ios.vendored_libraries = 'libical/lib/libical.a'
  spec.ios.source_files       = 'libical', 'libical/src/**/*.h'
  
end
