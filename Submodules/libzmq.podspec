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
  s.source_files = 'src/*.{h,hpp,c,cc,cpp}', 'include/*.h', '**/*'
  s.public_header_files = 'include/*.h'
  s.platform     = :ios, '8.0', :osx, '10.9'
  s.requires_arc = false
  s.osx.deployment_target = '10.9'
  s.ios.deployment_target = '8.0'
  s.libraries = 'c++'
  s.prepare_command = <<-CMD
        CURRENT_DIR="${PWD}"
        echo "Save current dir=${CURRENT_DIR}" > 2
        cd Submodules/libzmq
        echo "Change dir to=${PWD}" > 2
        echo "Running autogen.sh" > 2
        ./autogen.sh
        cd "${CURRENT_DIR}"
        echo "Change dir to=${PWD}" > 2
  CMD
end
