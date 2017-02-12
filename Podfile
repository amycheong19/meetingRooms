# Uncomment this line to define a global platform for your project
platform :ios, '9.0'


# Core dependencies
def rx
    pod 'RxSwift'
    pod 'RxCocoa'
end

def firebase
    pod 'Firebase/Storage'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/RemoteConfig'
    pod 'FirebaseUI', '~> 1.0'
    pod 'Firebase/Auth'
end

def main
    rx
    firebase
end

target 'MeetingRooms' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MeetingRooms
  main
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

