Pod::Spec.new do |spec|
  spec.name = 'ObjCZMQ'
  spec.version = '1.0'
  spec.summary = 'Objective-C binding for ZeroMQ'
  spec.description = <<-DESC
    Bundled with ZeroMQ library.
    This is an Objective-C version of the reference ZeroMQ object-oriented C API. It follows the guidelines laid out by the official "Guidelines for ZeroMQ bindings".
    DESC
  spec.homepage = "https://github.com/aklobanov/ObjCZMQ"
  spec.license = 'MIT'
  spec.author = { 'Alexey Lobanov' => 'aklobanov@gmail.com' }
  spec.social_media_url = 'https://www.facebook.com/aklobanov'
  spec.source = { :git => 'https://github.com/aklobanov/ObjCZMQ.git', :tag => s.version }
  spec.source_files = 'ObjCZMQ/*.{h,m,pch}'
  spec.public_header_files = 'ObjCZMQ/*.{h,hpp}'
  spec.platform = :ios, '8.0', :osx, '10.9'
  spec.requires_arc = true
  spec.osx.deployment_target = '10.9'
  spec.ios.deployment_target = '8.0'
  spec.frameworks = 'Foundation'
#  spec.resources = "ObjCZMQ/ObjCZMQResources.bundle"
  spec.osx.vendored_frameworks = "ObjCZMQ/ObjCZMQ.framework"
  spec.ios.vendored_frameworks = "ObjCZMQ/ObjCZMQiOS.framework"
end
