Pod::Spec.new do |s|
  s.name = 'libzmq'
  s.version = '1.0'
  s.summary = 'ZeroMQ'
  s.description  = <<-DESC
    ZeroMQ Core library.
    DESC
  s.homepage = "http://zeromq.org"
  s.license = 'LGPLv3'
  s.author = { '0MQ Developers' => 'zeromq-dev@lists.zeromq.org' }
  s.source = { :git => 'https://github.com/zeromq/libzmq.git', :tag => s.version }
  s.source_files = 'src/*.{h,hpp,c,cc,cpp}', 'include/*.h', './*.*'
  s.public_header_files = 'include/*.h'
  s.platform     = :ios, '8.0', :osx, '10.9'
  s.requires_arc = false
  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '8.0'
  s.libraries = 'c++'
  s.prepare_command = <<-CMD
      cd Submodules/libzmq
      ./autogen.sh
      export CFLAGS="-mios-version-min=8.0"
      export SDK="iphoneos"
#      export SDKROOT=$(xcrun -sdk "${SDK}" --show-sdk-path)
      export CFLAGS="${CFLAGS} -arch ${ARCHS} -fembed-bitcode"
      export CXXFLAGS="${CFLAGS}"
      export CPPFLAGS="${CFLAGS}"
      export LDFLAGS="${CFLAGS}"
      mkdir -p "Submodules/libzmq/lib"
      ./configure --disable-dependency-tracking \
                --enable-static \
                --disable-shared \
                --host=arm-apple-darwin \
                --prefix="${PWD}/lib" \
                --without-libsodium \
                --disable-perf \
                --disable-curve-keygen
      make
      make install
      make clean      
      cd ../..
  CMD
end
