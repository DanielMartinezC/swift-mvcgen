MVC Module Generator
======================

## :warning: This project is currently on development and it must be used before project starts, otherwise it will override some of your files.

Gem to generate MVC starting modules to use them in your Swift projects
The implementation scheme returned by this generator is hardly inspired in the example and post of vipergen, https://rubygems.org/gems/vipergen/versions/0.2.6 .

- [Features](#features)
- [MVC files structure](#mvc-files-structure)
- [How to install mvcgen](#how-to-install-mvcgen)
- [How to generate a MVC module with a given name?](#how-to-generate-a-MVC-module-with-a-given-name?)
- [Developer tips](#developer-tips)
  - [Update the gem](#update-the-gem)
  - [Add a new template](#add-a-new-template)
- [Resources](#resources)

## Features
- Generates the module in Swift, including required podfile
- Ready to be installed as a gem https://rubygems.org/gems/mvcgen

<!-- ### Changelog 0.1.1 -->

## MVC files structure
```bash
.swift
+-- Helper
|   +-- Utils.swift
|   +-- AWSManager.swift
|   +-- FilesManager.swift
|   +-- APIManager.swift
|   +-- APIRequestBody.swift
|   +-- S3Manager.swift
|   +-- APIHelper.swift
+-- Controllers
|   +-- Login
|   |   +-- LoginVC.swift
|   |   +-- RegisterVC.swift
|   |   +-- ForgetPasswordVC.swift
|   +-- Notifications
|   |   +-- NotificationsVC.swift
|   |   +-- Cells
|   |   |   +-- NotificationsCell.swift
|   +-- Profile
|   |   +-- ProfileContainerVC.swift
|   |   +-- AboutUsVC.swift
|   |   +-- ProfileTVC.swift
|   |   +-- Cells
|   |   |   +-- ImagesCollectionViewCell.swift
|   |   |   +-- DescriptionCell.swift
|   |   |   +-- DestinationCellView.xib
|   |   |   +-- DestinationCell.swift
|   |   |   +-- FavoriteCollectionCell.swift
|   |   |   +-- AboutUsImageCell.swift
|   +-- OtherLogin
|   |   +-- SelectLanguageCell.swift
|   |   +-- OtherRegisterVC.swift
|   |   +-- ForgetPasswordTVC.swift
|   |   +-- LoginTVC.swift
|   |   +-- SelectLanguageVC.swift
|   |   +-- TermsAndConditionsVC.swift
|   +-- Tutorial
|   |   +-- TutorialVC.swift
+-- Extensions
|   +-- UIColorExtensions.swift
|   +-- GradientView.swift
|   +-- ArrayDuplicates.swift
|   +-- Images.swift
|   +-- HideKeyboard.swift
|   +-- InnerShadowExtension.swift
|   +-- CustomCamera.swift
|   +-- TableViewEmptyView.swift
|   +-- Buttons.swift
|   +-- TapEffectExtension.swift
|   +-- UnderlinedWithIconTextField.swift
|   +-- UnderlinedTextView.swift
+-- Models
|   +-- Notif.swift
|   +-- Country.swift
|   +-- User.swift
|   +-- Responeses
|   |   +-- UserResponse.swift
|   |   +-- NotificationResponse.swift
|   |   +-- BaseResponse.swift
|   |   +-- UserSingupResponse.swift
|   +-- Managers
|   |   +-- UserManager.swift
+-- Config
|   +-- Config.plist
|   +-- Config.swift
+-- UI
|   +-- Views
|   |   +-- EmptyTableView
|   |   |   +-- EmptyTableLabelView.swift
|   |   |   +-- NoNotificationView.swift
|   |   |   +-- Xibs
|   |   |   |   +-- EmptyTableLabelView.xib
|   |   |   |   +-- NoNotificationsView.xib
|   +-- Storyboards
|   |   +-- Login.storyboard
|   |   +-- OtherLogin.storyboard
|   |   +-- Home.storyboard
+-- Info.plist
+-- Assets.xcassets
+-- AppDelegate.swift
.podfile
+-- Podfile
|   +-- podfile
```
## How to install mvcgen ?
You can install it easily as using the gem. With ruby installed in your OSX execute:
```bash
sudo gem install mvcgen
```
If everything were right, you should have now the mvcgen command available in your system console

## How to generate a MVC module with a given name?
You have just to execute the following command standing on your project root folder
```bash
mvcgen generate YourProjectName --path=./
```
And then the files structure will be automatically created and added to the project. Don't forget to run pod install after that

## Developer tips
### Update the gem 
When the gem is updated it has to be reported to the gem repository. I followed this tutorial http://amaras-tech.co.uk/article/43/Creating_executable_gems that basically says that once you have your gem ready execute:
```bash
gem build mvcgen.gemspec
gem install mvcgen-0.1.gem
gem push mvcgen-0.1.gem
```
Then you'll be asked for your credentials in order to make the update in the repo (http://guides.rubygems.org/publishing/)

### Add a new template
Are you interested in this project and you would like to contribute by adding new templates? Feel free to do it. It's pretty easy. You've just to:
- Create a folder inside `templates` with the name of your template
- You'll have to create inside the templates a swift folder with your files (get inspired from existing templates)
- Use the word MVCGEN where you want the name to be replaced in.
- Remember to add the file mvcspec.yml with the description of your template as below:
```yaml
author: pepito
author_email: pepito@test.com
template_description: Default template with..
updated_at: 2018-08-01
```
- Report it as a PR in this repo updating the gem version in Gemspec.

## Resources
- Rspec documentation: http://rubydoc.info/gems/rspec-expectations/frames
- XCode Plugins: http://nshipster.com/xcode-plugins/
- XCodeProj gem (to modify project groups structure): https://github.com/CocoaPods/Xcodeproj
- Thor, powerful Ruby library for command line: http://whatisthor.com/
