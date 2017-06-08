Pod::Spec.new do |spec|

    spec.name                   = 'Swift.Binary'
    spec.version                = '0.1.2'
    spec.summary                = 'Binary auto-[encoder/decoder] for Swift 3.'

    spec.homepage               = 'https://github.com/andersonlucasg3/Swift.Binary'
    spec.license                = { :type => 'MIT' }
    spec.authors                = { 'Anderson Lucas C. Ramos' => 'andersonlucas3d@gmail.com' }
    spec.source                 = { :git => 'https://github.com/andersonlucasg3/Swift.Binary.git', :tag => spec.version.to_s }

    spec.platform               = 'ios'
    spec.ios.deployment_target  = '8.0'

    spec.source_files           = 'Sources/*.swift'

end
