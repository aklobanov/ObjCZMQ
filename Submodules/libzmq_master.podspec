Pod::Spec.new do |s|
  s.name = 'libzmq_master'
  s.version = '4.1.4'
  s.summary = 'ZeroMQ'
  s.description  = <<-DESC
    ZeroMQ Core library.
    DESC
  s.homepage = "http://zeromq.org"
  s.license = 'LGPLv3'
  s.author = { '0MQ Developers' => 'zeromq-dev@lists.zeromq.org' }
  s.source = { :git => 'https://github.com/zeromq/libzmq.git', :tag => s.version }
  s.source_files = 'libzmq/src/*.{h,hpp,c,cc,cpp}', 'libzmq/include/*.h'
  s.public_header_files = 'libzmq/include/*.h'
  s.platform     = :ios, '8.0', :osx, '10.9'
  s.requires_arc = false
  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '8.0'
  s.libraries = 'libc++'
  s.prepare_command = <<-CMD
    ./autogen.sh
    ./configure --disable-dependency-tracking --enable-static --disable-shared --host=arm-apple-darwin \
                --prefix="build" \
                --without-libsodium --disable-perf --disable-curve-keygen
  CMD
end
