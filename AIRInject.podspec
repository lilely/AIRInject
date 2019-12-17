#
#  Be sure to run `pod spec lint AIRInject.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = 'AIRInject'
  spec.version      = '0.0.1'
  spec.summary      = 'A light weight DI framework for Object-C.'


  spec.description  = <<-DESC
This is a lightweight Dependency Inject framework of Object-C.Dependency injection is a softwaire pattern that implements Inversion of Control (IoC) for resolving dependencies.In this pattern AIRInject helps your app split into loosely-coupled components, which can be developed, tested and maintained more easily.
                   DESC

  spec.homepage     = 'https://github.com/lilely/AIRInject'
  spec.license      = 'MIT'
  spec.author       = { 'Stanley' => 'lilely@163.com' }

  spec.source       = { :git => 'https://github.com/lilely/AIRInject.git', :tag => spec.version }
  spec.requires_arc = true

  spec.source_files  = 'AIRInject/*.{h,m}'
  spec.public_header_files = 'AIRInject/AIRInject.h'


end
