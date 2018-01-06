# TagCellLayout

[![Build Status](https://travis-ci.org/riteshhgupta/TagCellLayout.svg)](https://travis-ci.org/riteshhgupta/TagCellLayout)
[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/TagCellLayout/badge.png)](https://cocoapods.org/pods/TagCellLayout)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/TagCellLayout/badge.svg)](https://cocoapods.org/pods/TagCellLayout)
[![License MIT](http://img.shields.io/:license-mit-blue.svg)](https://opensource.org/licenses/MIT)

## About

Its an ui-collection-view LAYOUT class that takes care of all the logic behind making tags like layout using UICollectionView. It also allows you to adjust the alignment of your layout i.e Left || Centre || Right. Now you just have to take care of your tag view and nothing else. Aaaand it also supports **multi-line** tags 🚀

## Screenshots

![Center Alignment](/TagCellLayout/Readme_Resources/tag_cc.png)
![Left Alignment](/TagCellLayout/Readme_Resources/tag_ll.png)
![Right Alignment](/TagCellLayout/Readme_Resources/tag_rr.png)

## Usage

- Init Method:

```swift
import TagCellLayout

let tagCellLayout = TagCellLayout(alignment: .center, delegate: self)
collectionView.collectionViewLayout = tagCellLayout
```

- Tag Alignment:

```alignment``` can be Left or Center or Right. If its nil then by default Left alignment will be applied.


## Delegate Methods
- Protocol to conform - `TagCellLayoutDelegate`


- Methods


```swift
- 	func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index:Int) -> CGSize
```

## Architecture

- ```func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index:Int) -> CGSize``` 

is called for every tag where you will calculate their size and pass it on to TagCellLayout class for further calculations.

- ```collectionView.numberOfItemsInSection(0)```

internally the number of tags is calculated by the above method.

## Installation
To integrate TagCellLayout into your Xcode project using CocoaPods, specify it in your Podfile:

`Swift-4.0`

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TagCellLayout', :git => 'https://github.com/riteshhgupta/TagCellLayout.git'
```

`Swift-3.2`

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TagCellLayout', :git => 'https://github.com/riteshhgupta/TagCellLayout.git', :branch => 'swift3.2'
```

`Swift-3.0`

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TagCellLayout', :git => 'https://github.com/riteshhgupta/TagCellLayout.git', :branch => 'swift3.0'
```

`Swift-2.3`

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TagCellLayout', :git => 'https://github.com/riteshhgupta/TagCellLayout.git', :branch => 'swift2.3'
```

`Swift-2.2`

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TagCellLayout', '~> 0.3'
```

## Contributing

Open an issue or send pull request [here](https://github.com/riteshhgupta/TagCellLayout/issues/new).

## Licence

TagCellLayout is available under the MIT license. See the LICENSE file for more info.
