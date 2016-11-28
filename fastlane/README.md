fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### start_framework_release
```
fastlane start_framework_release
```
Start new framework release version on your git repository

This lane require **git flow** installed in your framework directory check documentation [here](https://github.com/nvie/gitflow)

You will automatically be switched to release/X.X.X branch after this lane and your project/podsec version will be updated

####Example using specific version:

```
fastlane start_framework_release version:4.0.9
```

####Options

 * **version**: The target version number X.X.X

  * **environment_variable**: DG_FRAMEWORK_RELEASE_VERSION

  * **type**: string

  * **optional**: true, **automatically patch** release version to the next number (1.0.0 --> 1.0.1)

* **project**: The project path.

  * **environment_variable**: DG_PROJECT

  * **type**: string

  * **optional**: true

* **podspec_path**: The podspec path if specific.

  * **environment_variable**: DG_PODSPEC_PATH

  * **type**: string

  * **optional**: true


### submit_framework_release
```
fastlane submit_framework_release
```
Submit the framework release version on your git repository and close the branch

This lane require **git flow** installed in your framework directory check documentation [here](https://github.com/nvie/gitflow)

You will automatically be switched to develop branch after this lane

####How to install ?

This lane require the `tests` lane define in [Digipolitan/fastlane-ios-common](https://github.com/Digipolitan/fastlane-ios-common)

```
import_from_git(
  url: 'https://github.com/Digipolitan/fastlane-ios-common'
)
```

####Options

 * **message**: The commit message

  * **type**: string

  * **optional**: true

  * **default_value**: Release version **VERSION**

 * **workspace**: The workspace to use.

  * **environment_variable**: DG_WORKSPACE

  * **type**: string

  * **optional**: true

* **project**: The project path.

  * **environment_variable**: DG_PROJECT

  * **type**: string

  * **optional**: true

* **scheme**: The scheme into the workspace to execute.

  * **environment_variable**: DG_SCHEME

  * **type**: string

  * **optional**: true



----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).
