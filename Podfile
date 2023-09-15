# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MISSQ' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'Socket.IO-Client-Swift'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'GooglePlacesSearchController'
  pod 'Alamofire', '~> 4.5'
  pod 'SwiftyJSON'
  pod 'SDWebImage'
  pod 'RSKImageCropper'
  pod 'IDMPhotoBrowser'
  pod 'DateToolsSwift'
  pod 'IQKeyboardManagerSwift'
  pod 'Toast-Swift'
  pod 'FSCalendar'
  pod 'Cosmos'
  pod 'RangeSeekSlider'
  pod 'TagListView'
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod 'Stripe'
  pod 'Shuffle-iOS'
  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit'
  pod 'SKCountryPicker'
  pod 'OTPFieldView'
  pod 'Localize-Swift', '~> 3.2'
  # Pods for MISSQ

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
