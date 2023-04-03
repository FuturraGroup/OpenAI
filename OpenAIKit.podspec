#
# Be sure to run `pod lib lint OpenAIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OpenAIKit'
  s.version          = '1.3.0'
  s.summary          = 'OpenAI is a community-maintained repository containing Swift implementation over OpenAI public API.'

  s.description      = <<-DESC
The OpenAI API can be applied to virtually any task that involves understanding or generating natural language or code. We offer a spectrum of models with different levels of power suitable for different tasks, as well as the ability to fine-tune your own custom models. These models can be used for everything from content generation to semantic search and classification.
                       DESC

  s.homepage         = 'https://github.com/FuturraGroup/OpenAI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kyrylo Mukha' => 'kirill.mukha@icloud.com' }
  s.source           = { :git => 'https://github.com/FuturraGroup/OpenAI.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = "5.5"

  s.source_files = 'Sources/OpenAIKit/**/*.{swift}'
  
end
