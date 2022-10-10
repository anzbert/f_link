# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint f_link.podspec` to validate before publishing.

Pod::Spec.new do |s|
  s.name             = 'f_link'
  s.version          = '0.1.0'
  s.summary          = 'Ableton Link Compilation Pod for MacOS'
  s.description      = <<-DESC
  Compilation instructions for the Ableton Link library, which exposes abl_link.h, its C Header Extension.
                       DESC
  s.homepage         = 'https://pub.dev/packages/f_link'
  s.license          = { :file => 'link/LICENSE.md', :type => 'GPL2' }
  s.author           = { 'Andreas Mueller' => 'anzbert@gmail.com' }
  s.platform = :osx, '10.11' # This is a MacOS specific .podspec file
  s.swift_version = '5.0'
  s.dependency 'FlutterMacOS'

  # s.source = { :git => 'https://github.com/ableton/link.git', :commit => '1f12bcb' } # testing git support

  s.source = { :path => '.' } # using Ableton Link from local folder
  s.source_files = ['link/extensions/abl_link/src/*.cpp', 'link/extensions/abl_link/include/*.h', 'link/include/**/{*.hpp,*.ipp}', 'link/modules/asio-standalone/asio/include/**/{*.hpp,*.ipp,*.c,*.h}']
  s.private_header_files = 'link/include/**/*.hpp'
  s.public_header_files = 'link/extensions/include/abl_link.h'
  
  # These directory and search path settings are very fickle but necessary to allow dependencies to be found by each other. Seems to work for now, but could likely be tweaked:
  s.header_mappings_dir = 'link'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES', 'HEADER_SEARCH_PATHS' => ["\"" + __dir__ + "/link/include\"" , "\"" + __dir__ + "/link/modules/asio-standalone/asio/include\""]
   }
   s.xcconfig = {
    'HEADER_SEARCH_PATHS' => ["\"${PODS_ROOT}/link/include\"" , "\"${PODS_ROOT}/link/modules/asio-standalone/asio/include\""]
   }

  # First flag for Link's conditional compilation / Second to suppress code documentation warnings:
  s.compiler_flags = '-DLINK_PLATFORM_MACOSX=1', '-Wno-documentation' 
end
