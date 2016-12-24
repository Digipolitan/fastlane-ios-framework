fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### ensure_version_availability
```
fastlane ensure_version_availability
```

### prepare_for_release
```
fastlane prepare_for_release
```

### appfile_init
```
fastlane appfile_init
```

### bootstrap
```
fastlane bootstrap
```

### start_framework_release
```
fastlane start_framework_release
```
Start new framework release version on your git repository

This lane require **git flow** installed in your framework directory check documentation [here](https://github.com/nvie/gitflow)

You will automatically be switched to release/X.X.X branch after this lane and your project/podsec version will be updated

#### How to install ?

This lane require actions define in [Digipolitan/fastlane-common](https://github.com/Digipolitan/fastlane-common)

```
import_from_git(
  url: 'https://github.com/Digipolitan/fastlane-common'
)
```

#### Example using specific version:

```
fastlane start_framework_release version:4.0.9
```

#### Options

* **bump_type**: The type of this version bump. Available: patch, minor, major

  * **environment_variable**: DG_BUMP_TYPE

  * **type**: string

  * **optional**: true

  * **default_value**: patch

* **version**: Change to a specific version. This will replace the bump type value

  * **environment_variable**: DG_RELEASE_VERSION

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

* **product_name**: The framework name

  * **environment_variable**: DG_PRODUCT_NAME

  * **type**: string

  * **optional**: true

* **release_url**: The release url use by the changelog

  * **environment_variable**: DG_RELEASE_URL

  * **type**: string

  * **optional**: true

* **change_log**: The changelog content

  * **environment_variable**: DG_CHANGELOG_CONTENT

  * **type**: string

  * **optional**: true


### publish_framework_release
```
fastlane publish_framework_release
```
Submit the framework release version on your git repository and close the branch

This lane require **git flow** installed in your framework directory check documentation [here](https://github.com/nvie/gitflow)

You will automatically be switched to develop branch after this lane

#### How to install ?

This lane require actions define in [Digipolitan/fastlane-common](https://github.com/Digipolitan/fastlane-common)

```
import_from_git(
  url: 'https://github.com/Digipolitan/fastlane-common'
)
```

#### Options

* **message**: The commit message

  * **environment_variable**: DG_RELEASE_MESSAGE

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

* **scheme**: The scheme into the workspace to test.

  * **environment_variable**: DG_SCHEME

  * **type**: string

  * **optional**: true


### framework_deploy_cocoapods
```
fastlane framework_deploy_cocoapods
```
CocoaPods deployment lane

This lane must be run only on the **master** branch

#### Options

* **podspec_path**: The podspec path

  * **environment_variable**: DG_PODSPEC_PATH

  * **type**: string

  * **optional**: true

#### CI Environment variables

* **COCOAPODS_TRUNK_TOKEN**: The CocoaPods access token use to push the release to CocoaPods, check below how to retrieve CocoaPods token

  * **type**: string

  * **optional**: true

#### Output context variables

* **DG_COCOAPODS_RELEASE_LINK**: The CocoaPods release link

  * **type**: string

#### How to retrieve CocoaPods Trunk Token ?

First setup your CocoaPods trunk [as follow](https://guides.cocoapods.org/making/getting-setup-with-trunk.html)

After that run this command :

```
grep -A2 'trunk.cocoapods.org' ~/.netrc
```

The output sould be something like this :

```
machine trunk.cocoapods.org
  login user@example.com
  password XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

The password `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX` is your CocoaPods trunk token


### framework_deploy_github
```
fastlane framework_deploy_github
```
GitHub deployment lane

This lane must be run only on the **master** branch

#### Options

* **token**: The GitHub access token use to push the release to GitHub, check how to generate access token [here](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)

  * **environment_variable**: GITHUB_TOKEN

  * **type**: string

  * **optional**: false

* **repository_name**: The GitHub repository name such as 'company/project'

  * **environment_variable**: GITHUB_REPOSITORY_NAME

  * **type**: string

  * **optional**: false

* **project**: Your xcodeproj path

  * **environment_variable**: DG_PROJECT

  * **type**: string

  * **optional**: true

* **skip_carthage**: Skip the carthage asset to the GitHub release

  * **type**: boolean

  * **optional**: true

  * **default_value**: false

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).
