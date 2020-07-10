# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'OrderFile' do
  # Comment the next line if you don't want to use dynamic frameworks
 # use_frameworks!
	
pod 'SSZipArchive'
pod 'YCSymbolTracker'



end


post_install do |installer|
require './Pods/YCSymbolTracker/YCSymbolTracker/symbol_tracker.rb'
symbol_tracker(installer)

end
