# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'bankify-hackathon' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire'
  pod 'Kingfisher', '4.9.0'
  pod 'NVActivityIndicatorView'
  pod 'IBAnimatable'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Hero'
  pod 'SnapKit'
  pod 'Realm'
  pod 'RealmSwift'
  pod 'Arrow'
  pod 'LUNSegmentedControl'
  # Pods for bankify-hackathon

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = '-DDebug'
                else
                config.build_settings['OTHER_SWIFT_FLAGS'] = ''
            end
        end
    end
end
