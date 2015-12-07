//
//  TagCellLayout.swift
//  TagCellLayout
//
//  Created by Ritesh-Gupta on 20/11/15.
//  Copyright © 2015 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public class TagCellLayout: UICollectionViewLayout {
  
  var layoutInfoList = Array<TagCellLayoutInfo>()
  var lastTagPosition = CGPointZero
  var tagAlignmentType = TagAlignmentType.Left
  
  var numberOfTagsInCurrentRow = 0
  var tagsCount = 0
  var collectionViewWidth = Float(0)
  
  weak var delegate:TagCellLayoutDelegate?
  
  //MARK: - Init Methods
  
  public init(tagAlignmentType: TagAlignmentType = .Left, delegate: TagCellLayoutDelegate?) {
    super.init()
    self.delegate = delegate
    self.tagAlignmentType = tagAlignmentType
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override convenience init() {
    self.init(delegate: nil)
  }
  
  //MARK: - Override Methods
  
  override public func prepareLayout() {
    
    // reset inital values
    resetLayoutState()
    
    // delegate and collectionview shouldn't be nil
    if let _ = delegate, _ = collectionView {
      
      // setting up layout once we have delegate and collectionView both
      setupTagCellLayout()
      
    } else {
      // otherwise thorwing an error
      handleErrorState()
    }
  }
  
  override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    if layoutInfoList.count > indexPath.row {
      return layoutInfoList[indexPath.row].layoutAttribute
    }
    
    return nil
  }
  
  override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    if layoutInfoList.count > 0 {
      let visibleLayoutAttributes = layoutInfoList.map{someAttribute($0.layoutAttribute)}.filter {
        CGRectIntersectsRect(rect, $0.frame)
      }
      return visibleLayoutAttributes
    }
    return nil
  }
  
  override public func collectionViewContentSize() -> CGSize {
    var collectionSize = CGSizeMake(0, 0)
    if let delegate = delegate, collectionView = collectionView where collectionView.numberOfItemsInSection(0) > 0 {
      
      let tagHeight = lastTagPosition.y + delegate.tagCellLayoutTagFixHeight(self).cgValue()
      collectionSize = CGSizeMake(collectionView.frame.size.width, tagHeight)
    }
    return collectionSize
  }
}

//MARK: - Private Methods

private extension TagCellLayout {
  
  func setupTagCellLayout() {
    
    // basic layout setup which is independent of TagAlignment type
    basicLayoutSetup()
    
    // handle if TagAlignment is other than Left
    handleTagAlignment(tagAlignmentType)
  }
  
  func basicLayoutSetup() {
    if let delegate = delegate, collectionView = collectionView {
      tagsCount = collectionView.numberOfItemsInSection(0)
      collectionViewWidth = collectionView.frame.size.width.floatValue()
      
      // asking the client for a fixed tag height
      let tagHeight = delegate.tagCellLayoutTagFixHeight(self)
      
      // iterating over every tag and constructing its layout attribute
      for (var tagIndex=0; tagIndex<tagsCount; tagIndex++) {
        
        // creating layout and adding it to the dataSource
        let layoutInfo = createLayoutAttributes(tagIndex, tagHeight: tagHeight)
        
        // configuring white space info || this is later used for .Right or .Center alignment
        configureWhiteSpace(tagIndex, layoutInfo: layoutInfo)
        
        // processing info for next tag || setting up the coordinates for next tag
        processingForNextTag(tagIndex, layoutInfo: layoutInfo)
        
        // handling tha layout for last row separately
        handleForLastRowTags(tagIndex)
      }
    }
  }
  
  func createLayoutAttributes(tagIndex: Int, tagHeight: Float) -> UICollectionViewLayoutAttributes? {
    if let delegate = delegate {
      
      // calculating tag-size
      let tagWidth = delegate.tagCellLayoutTagWidth(self, atIndex: tagIndex)
      let tagSize = CGSizeMake(tagWidth.cgValue(), tagHeight.cgValue())
      
      let layoutInfo = tagCellLayoutInfo(tagIndex, tagSize: tagSize)
      layoutInfoList.append(layoutInfo)
      
      return layoutInfo.layoutAttribute
    }
    return nil
  }
  
  func tagCellLayoutInfo(tagIndex: Int, tagSize: CGSize) -> TagCellLayoutInfo {
    // local data-structure (TagCellLayoutInfo) that has been used in this library to store attribute and white-space info
    let tagCellLayoutInfo = TagCellLayoutInfo()
    
    var tagFrame = CGRect(origin: lastTagPosition, size: tagSize)
    
    // if next tag goes out of screen then move it to next row
    if moveTagToNextRow(tagSize.width.floatValue()) {
      tagFrame.origin.x = 0
      tagFrame.origin.y += tagSize.height
    }
    
    let attribute = layoutAttribute(tagIndex, tagFrame: tagFrame)
    tagCellLayoutInfo.layoutAttribute = attribute
    
    return tagCellLayoutInfo
  }
  
  func moveTagToNextRow(tagWidth: Float) -> Bool {
    return ((lastTagPosition.x.floatValue() + tagWidth) > collectionViewWidth)
  }
  
  func layoutAttribute(tagIndex: Int, tagFrame: CGRect) -> UICollectionViewLayoutAttributes {
    let indexPath = NSIndexPath(forItem: tagIndex, inSection: 0)
    let layoutAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
    layoutAttribute.frame = tagFrame
    return layoutAttribute
  }
  
  func configureWhiteSpace(currentTagIndex: Int, layoutInfo: UICollectionViewLayoutAttributes?) {
    if let layoutInfo = layoutInfo {
      let tagWidth = layoutInfo.frame.size.width
      let moveTag = moveTagToNextRow(tagWidth.floatValue())
      
      if moveTag {
        applyWhiteSpace(startingIndex: (currentTagIndex-1))
      }
    }
  }
  
  func applyWhiteSpace(startingIndex startingIndex: Int) {
    let lastIndex = startingIndex - numberOfTagsInCurrentRow
    let whiteSpace = calculateWhiteSpace(startingIndex)
    
    for (var tagIndex=startingIndex; tagIndex>lastIndex; tagIndex--) {
      insertWhiteSpace(tagIndex, whiteSpace: whiteSpace)
    }
  }
  
  func calculateWhiteSpace(tagIndex: Int) -> Float {
    let tagFrame = tagFrameForIndex(tagIndex)
    let whiteSpace = collectionViewWidth - (tagFrame.origin.x + tagFrame.size.width).floatValue()
    return whiteSpace
  }
  
  func insertWhiteSpace(tagIndex: Int, whiteSpace: Float) {
    let info = layoutInfoList[tagIndex]
    let factor = distributionFactor()
    info.whiteSpace = whiteSpace/factor
  }
  
  func distributionFactor() -> Float {
    var factor = Float(1.0)
    factor = tagAlignmentType.distributionFactor
    return factor
  }
  
  func tagFrameForIndex(tagIndex: Int) -> CGRect {
    var tagFrame = CGRectZero
    if tagIndex > -1 {
      if let layoutAttribute = layoutInfoList[tagIndex].layoutAttribute {
        tagFrame = layoutAttribute.frame
      }
    }
    return tagFrame
  }
  
  func processingForNextTag(tagIndex: Int, layoutInfo: UICollectionViewLayoutAttributes?) {
    if let layoutInfo = layoutInfo {
      let moveTag = moveTagToNextRow(layoutInfo.frame.size.width.floatValue())
      
      if moveTag {
        lastTagPosition.y += layoutInfo.frame.size.height
        lastTagPosition.x = 0
      }
      
      numberOfTagsInCurrentRow = moveTag ? 1 : ++numberOfTagsInCurrentRow
      lastTagPosition.x += layoutInfo.frame.size.width
    }
  }
  
  func handleTagAlignment(tagAlignmentType: TagAlignmentType?) {
    if let tagAlignmentType = tagAlignmentType, collectionView = collectionView where tagAlignmentType != .Left {
      let tagsCount = collectionView.numberOfItemsInSection(0)
      
      for (var tagIndex=0; tagIndex<tagsCount; tagIndex++) {
        if var tagFrame = layoutInfoList[tagIndex].layoutAttribute?.frame, let whiteSpace = layoutInfoList[tagIndex].whiteSpace {
          tagFrame.origin.x += whiteSpace.cgValue()
          
          let tagAttribute = layoutAttribute(tagIndex, tagFrame: tagFrame)
          layoutInfoList[tagIndex].layoutAttribute = tagAttribute
        }
      }
    }
  }
  
  func handleForLastRowTags(tagIndex: Int) {
    if tagIndex == (tagsCount - 1) {
      applyWhiteSpace(startingIndex: (tagsCount-1))
    }
  }
  
  func someAttribute(maybeAttribute: UICollectionViewLayoutAttributes?) -> UICollectionViewLayoutAttributes {
    if let someAttribute = maybeAttribute {
      return someAttribute
    }
    return layoutAttribute(0, tagFrame: CGRectZero)
  }
  
  func handleErrorState() {
    print("TagCollectionViewCellLayout is not properly configured")
  }
  
  func resetLayoutState() {
    layoutInfoList = Array<TagCellLayoutInfo>()
    lastTagPosition = CGPointZero
    numberOfTagsInCurrentRow = 0
  }
  
}