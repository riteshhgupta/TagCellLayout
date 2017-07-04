#TagCellLayout (Swift-3.0)

[![Build Status](https://travis-ci.org/riteshhgupta/TagCellLayout.svg)](https://travis-ci.org/riteshhgupta/TagCellLayout)
[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/TagCellLayout/badge.png)](https://cocoapods.org/pods/TagCellLayout)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/TagCellLayout/badge.svg)](https://cocoapods.org/pods/TagCellLayout)
[![License MIT](http://img.shields.io/:license-mit-blue.svg)](https://opensource.org/licenses/MIT)

##About

Its an ui-collection-view LAYOUT class that takes care of all the logic behind making tags like layout using UICollectionView. It also allows you to adjust the alignment of your layout i.e Left || Centre || Right. Now you just have to take care of your tag view and nothing else. 

##Installation
To integrate TagCellLayout into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TagCellLayout', :git => 'https://github.com/riteshhgupta/TagCellLayout.git', :branch => 'swift3.0'
```
## Screenshots

![Center Alignment](/TagCellLayout/Readme_Resources/tag_cc.png)
![Left Alignment](/TagCellLayout/Readme_Resources/tag_ll.png)
![Right Alignment](/TagCellLayout/Readme_Resources/tag_rr.png)

##Usage

- Init Method:

```
import TagCellLayout

let tagCellLayout = TagCellLayout(tagAlignmentType: .Center, delegate: self)
collectionView.collectionViewLayout = tagCellLayout
```

- Tag Alignment:

```tagAlignmentType``` can be Left or Center or Right. If its nil then by default Left alignment will be applied.

- Helper methods:

`- func textWidth(text: String, font: UIFont) -> CGFloat`

It calculates the width of a tag string.


## Delegate Methods
- Protocol to conform - `TagCellLayoutDelegate`


- Methods


```
- func tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index:Int) -> CGFloat
- func tagCellLayoutTagFixHeight(layout: TagCellLayout) -> CGFloat
```

## Architecture
- ```tagCellLayoutTagFixHeight(layout: TagCellLayout)``` 

is only called once as all tags have one fixed height that will be defined by this method.

- ```tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index:Int)``` 

is called for every tag where you will calculate their width and pass it on to TagCellLayout class for further calculations.

- ```collectionView.numberOfItemsInSection(0)```

internally the number of tags is calculated by the above method.

## Contributing

Open an issue or send pull request [here](https://github.com/riteshhgupta/TagCellLayout/issues/new).

## Licence

TagCellLayout is available under the MIT license. See the LICENSE file for more info.