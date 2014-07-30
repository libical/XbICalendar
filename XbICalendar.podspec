Pod::Spec.new do |spec|
  spec.name         = "XbICalendar"
  spec.version      = "0.2.0"
  spec.summary      = "XbICalendar is a easy-to-use, framework for iOS that wraps libical."
  spec.homepage     = "https://github.com/libical/XbICalendar"
  spec.license      = 'MPL or LGPL'
  spec.authors      = { "Andrew Halls" => "andrew@galtsoft.com" }
  
  spec.source       = { :git => "https://github.com/libical/XbICalendar.git", :tag => spec.version.to_s }
  
  spec.requires_arc = true
  
  spec.source_files = 'XbICalendar', 'XbICalendar/XBICalendar/**/*.{h,m}'
  spec.libraries    = 'z'
  
  spec.ios.deployment_target  = '6.0'
  spec.ios.framework          = 'CFNetwork'
  spec.ios.vendored_libraries = 'libical/lib/libical.a'
  spec.ios.source_files       = 'libical', 'libical/src/**/*.h'
  
end
