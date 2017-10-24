Digipolitan fastlane-ios-framework
================

Create framework lanes used by Digipolitan repositories

## Installation
To install fastlane, simply use gem:

```
[sudo] gem install fastlane
```

# Available Fastlane Lanes
All lanes available are described [here](fastlane/README.md)

# Available Fastlane actions

## [podspec_lint](fastlane/actions/podspec_lint.rb)

Validate your podspec file

```Ruby
podspec_lint(
  path: "/example/test.podspec",
  verbose: true
)
```

# Protected Fastlane actions

## [clean_xcodeproj_configuration](fastlane/actions/clean_xcodeproj_configuration.rb)

Clean unused targets and schemes from the Xcode project

```Ruby
clean_xcodeproj_configuration(
  xcodeproj: "example.xcodeproj",
  osx_available: false
)
```
This action will remove all OSX scheme and target from `sample.xcodeproj`

## [clean_xcworkspace_configuration](fastlane/actions/clean_xcworkspace_configuration.rb)

Clean unused sample project from the Xcode workspace

```Ruby
clean_xcworkspace_configuration(
  xcworkspace: "example.xcworkspace",
  osx_available: false
)
```
This action will remove the OSX sample project from `example.xcworkspace`

## [podfile_init](fastlane/actions/podfile_init.rb)

Initialize the Podfile to fit with your framework

```Ruby
podfile_init(
  xcodeproj: "example.xcodeproj",
  ios_deployment_target: '9.0',
  tvos_deployment_target: '10.0'
)
```
This action will add to the Podfile iOS 9.0 and tvOS 10.0

## [podspec_init](fastlane/actions/podspec_init.rb)

Create the podspec using your configuration

```Ruby
podspec_init(
  pod_name: "SampleExample",
  version: "4.3.1",
  git_url: "http://sample/example.git",
  ios_deployment_target: '9.0',
  watchos_deployment_target: '2.0'
)
```
This action will generate the podspec file, with an iOS and watchOS deployment
