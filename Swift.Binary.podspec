Pod::Spec.new do |spec|

    spec.name                   = 'Swift.Binary'
    spec.version                = '1.1.2'
    spec.summary                = 'Binary auto-[encoder/decoder] for Swift 3.2 and 4.'

    spec.homepage               = 'https://github.com/andersonlucasg3/Swift.Binary'
    spec.license                = { :type => 'MIT' }
    spec.authors                = { 'Anderson Lucas C. Ramos' => 'andersonlucas3d@gmail.com' }
    spec.source                 = { :git => 'https://github.com/andersonlucasg3/Swift.Binary.git', :tag => spec.version.to_s }

    spec.ios.deployment_target  = '8.0'
    spec.osx.deployment_target  = '10.10'
    spec.tvos.deployment_target = '9.0'

    spec.source_files           = 'Sources/**/*.swift'

end
