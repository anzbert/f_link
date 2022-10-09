#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint f_link.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'f_link'
  s.version          = '0.0.1'
  s.summary          = 'Ableton Link for Flutter.'
  s.description      = <<-DESC
  A plugin which wraps the Ableton Link C Extension for Flutter..
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => './LICENSE.md', :type => 'GPL2' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
 
  s.dependency 'FlutterMacOS'

  s.source           = { :path => '.' } # local folder (for testing only)
  # s.source           = { :git => 'https://github.com/ableton/link.git', :commit => '1f12bcb' }
  
  s.header_mappings_dir = 'link'

  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES', 'HEADER_SEARCH_PATHS' => ["\"" + __dir__ + "/link/include\"" , "\"" + __dir__ + "/link/modules/asio-standalone/asio/include\""]
   }
   s.xcconfig = {
       'HEADER_SEARCH_PATHS' => ["\"${PODS_ROOT}/link/include\"" , "\"${PODS_ROOT}/link/modules/asio-standalone/asio/include\""]
   }
  
  s.source_files     = ['link/extensions/abl_link/src/*.cpp', 'link/extensions/abl_link/include/*.h', 'link/include/**/{*.hpp,*.ipp}', 'link/modules/asio-standalone/asio/include/**/{*.hpp,*.ipp,*.c,*.h}']

#   s.exclude_files =  '*.txt'

  s.public_header_files = 'link/extensions/include/abl_link.h'
  s.private_header_files = 'link/include/**/*.hpp', 
  
  s.compiler_flags = '-DLINK_PLATFORM_MACOSX=1'

  s.platform = :osx, '10.11'
#   s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
  
end
