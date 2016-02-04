Pod::Spec.new do |s|
  s.name = 'ObjCZMQ'
  s.version = '1.0'
  s.summary = 'Objective-C binding for ZeroMQ'
  s.description  = <<-DESC
    Bundled with ZeroMQ library.
    This is an Objective-C version of the reference ZeroMQ object-oriented C API. It follows the guidelines laid out by the official "Guidelines for ZeroMQ bindings".
    DESC
  s.homepage     = "https://github.com/aklobanov/ObjCZMQ"
  s.license = 'MIT'
  s.author = { 'Alexey Lobanov' => 'aklobanov@gmail.com' }
  s.social_media_url = 'https://www.facebook.com/aklobanov'
  s.source = { :git => 'https://github.com/aklobanov/ObjCZMQ.git', :tag => s.version }
  s.source_files = 'ObjCZMQ/ObjCZMQ/*.{h,m,pch,map}', 'ObjCZMQ/Dependencies/libzmq/*.h'
  s.public_header_files = 'ObjCZMQ/ObjCZMQ/*.{h,hpp}'
  s.platform     = :ios, '8.0', :osx, '10.9'
  s.requires_arc = true
  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '8.0'
  s.frameworks = 'Foundation'
  s.libraries = 'libc++'
  s.prepare_command = <<-CMD
    ObjCZMQ/Dependencies/libzmq/pull_compile_libzmq_git.sh
  CMD
  s.ios.vendored_library = 'ObjCZMQ/Dependencies/libzmq/libzmq-ios.a'
  s.osx.vendored_library = 'ObjCZMQ/Dependencies/libzmq/libzmq-osx.a'
end
