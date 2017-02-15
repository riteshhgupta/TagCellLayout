//
//  TagCellLayout.swift
//  TagCellLayout
//
//  Created by Ritesh-Gupta on 20/11/15.
//  Copyright © 2015 Ritesh. All rights reserved.
//
//	Swift 3.0

import Foundation
import UIKit

public protocol TagCellLayoutDelegate: NSObjectProtocol {
	func tagCellLayoutTagWidth(_ layout: TagCellLayout, atIndex index:Int) -> CGFloat
	func tagCellLayoutTagFixHeight(_ layout: TagCellLayout) -> CGFloat
}

public enum TagAlignmentType: Int {
	case left
	case center
	case right
	
	var distributionFactor: CGFloat {
		var factor: CGFloat
		switch self {
		case .center:
			factor = 2
		default:
			factor = 1
		}
		return factor
	}
}

open class TagCellLayout: UICollectionViewLayout {
	
	struct TagCellLayoutInfo {
		var layoutAttribute: UICollectionViewLayoutAttributes
		var whiteSpace: CGFloat
		
		init(layoutAttribute: UICollectionViewLayoutAttributes) {
			self.layoutAttribute = layoutAttribute
			self.whiteSpace = 0
		}
	}
	
	var layoutInfoList = Array<TagCellLayoutInfo>()
	var tagAlignmentType = TagAlignmentType.left
	var numberOfTagsInCurrentRow = 0
	var currentTagIndex: Int = 0
	var lineNumber = 1
	weak var delegate: TagCellLayoutDelegate?

	var currentTagPosition: CGPoint {
		if let info = currentTagLayoutInfo?.layoutAttribute {
			var position = info.frame.origin
			position.x += info.bounds.width
			return position
		}
		return CGPoint.zero
	}
	
	var currentTagLayoutInfo: TagCellLayoutInfo? {
		let index = max(0, currentTagIndex - 1)
		if layoutInfoList.count > index {
			return layoutInfoList[index]
		}
		return nil
	}
	
	var tagsCount: Int {
		return collectionView?.numberOfItems(inSection: 0) ?? 0
	}
	
	var collectionViewWidth: CGFloat {
		return collectionView?.frame.size.width ?? 0
	}
	
	var isLastRow: Bool {
		return currentTagIndex == (tagsCount - 1)
	}
	
	//MARK: - Init Methods
	
	public init(tagAlignmentType: TagAlignmentType = .left, delegate: TagCellLayoutDelegate?) {
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
	
	override open func prepare() {
		resetLayoutState()
		setupTagCellLayout()
	}
	
	override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		if layoutInfoList.count > (indexPath as NSIndexPath).row {
			return layoutInfoList[(indexPath as NSIndexPath).row].layoutAttribute
		}
		
		return nil
	}
	
	override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		if layoutInfoList.count > 0 {
			let visibleLayoutAttributes = layoutInfoList
				.map { $0.layoutAttribute }
				.filter { rect.intersects($0.frame) }
			return visibleLayoutAttributes
		}
		return nil
	}
	
	override open var collectionViewContentSize : CGSize {
		if let
			heightPerLine = delegate?.tagCellLayoutTagFixHeight(self),
			let width = collectionView?.frame.size.width
		{
			let height = heightPerLine*CGFloat(lineNumber)
			return CGSize(width: width, height: height)
		}
		return CGSize.zero
	}
	
	open class func textWidth(_ text: String, font: UIFont) -> CGFloat {
		let padding: CGFloat = 4 // this number is independent of font and is required to compensate the inaccuracy of sizeToFit calculation!
		let label = UILabel()
		label.text = text
		label.font = font
		label.sizeToFit()
		let frame = label.frame
		return (frame.width + padding)
	}
}

//MARK: - Private Methods

private extension TagCellLayout {
	
	func setupTagCellLayout() {
		// delegate and collectionview shouldn't be nil
		if let delegate = delegate , collectionView != nil {
			// basic layout setup which is independent of TagAlignment type
			basicLayoutSetup(delegate)
			
			// handle if TagAlignment is other than Left
			handleTagAlignment()
			
		} else {
			// otherwise thorwing an error
			handleErrorState()
		}
	}
	
	func basicLayoutSetup(_ delegate: TagCellLayoutDelegate) {
		// asking the client for a fixed tag height
		
		// iterating over every tag and constructing its layout attribute
		for tagIndex in 0 ..< tagsCount {
			currentTagIndex = tagIndex
	
			// creating layout and adding it to the dataSource
			createLayoutAttributes()
		}
        
        for tagIndex in 0 ..< tagsCount {
            currentTagIndex = tagIndex
            
            // configuring white space info || this is later used for .Right or .Center alignment
            configureWhiteSpace()
            
            // processing info for next tag || setting up the coordinates for next tag
            configurePositionForNextTag()
            
            // handling tha layout for last row separately
            handleWhiteSpaceForLastRow()
        }
	}
	
	func createLayoutAttributes() {
		if let delegate = delegate {
			// calculating tag-size
			let tagHeight = delegate.tagCellLayoutTagFixHeight(self)
			let tagWidth = delegate.tagCellLayoutTagWidth(self, atIndex: currentTagIndex)
			let tagSize = CGSize(width: tagWidth, height: tagHeight)
			
			let layoutInfo = tagCellLayoutInfo(currentTagIndex, tagSize: tagSize)
			layoutInfoList.append(layoutInfo)
		}
	}
	
	func tagCellLayoutInfo(_ tagIndex: Int, tagSize: CGSize) -> TagCellLayoutInfo {
		// local data-structure (TagCellLayoutInfo) that has been used in this library to store attribute and white-space info
		var tagFrame = CGRect(origin: currentTagPosition, size: tagSize)
		
		// if next tag goes out of screen then move it to next row
		if shouldMoveTagToNextRow(tagSize.width) {
			tagFrame.origin.x = 0
			tagFrame.origin.y += tagSize.height
		}
		let attribute = layoutAttribute(tagIndex, tagFrame: tagFrame)
		let info = TagCellLayoutInfo(layoutAttribute: attribute)
		return info
	}
	
	func shouldMoveTagToNextRow(_ tagWidth: CGFloat) -> Bool {
		return ((currentTagPosition.x + tagWidth) > collectionViewWidth)
	}
	
	func layoutAttribute(_ tagIndex: Int, tagFrame: CGRect) -> UICollectionViewLayoutAttributes {
		let indexPath = IndexPath(item: tagIndex, section: 0)
		let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		layoutAttribute.frame = tagFrame
		return layoutAttribute
	}
	
	func configureWhiteSpace() {
        guard currentTagIndex + 1 < tagsCount else {
            return
        }
        
		let layoutInfo = layoutInfoList[currentTagIndex+1].layoutAttribute
		let tagWidth = layoutInfo.frame.size.width
		if shouldMoveTagToNextRow(tagWidth) {
            lineNumber += 1
			applyWhiteSpace(startingIndex: (currentTagIndex - 1))
		}
	}
	
	func applyWhiteSpace(startingIndex: Int) {
		let lastIndex = startingIndex - numberOfTagsInCurrentRow
		let whiteSpace = calculateWhiteSpace(startingIndex)
		
		for tagIndex in (lastIndex+1) ..< (startingIndex+1) {
			insertWhiteSpace(tagIndex, whiteSpace: whiteSpace)
		}
	}
	
	func calculateWhiteSpace(_ tagIndex: Int) -> CGFloat {
		let tagFrame = tagFrameForIndex(tagIndex)
		let whiteSpace = collectionViewWidth - (tagFrame.origin.x + tagFrame.size.width)
		return whiteSpace
	}
	
	func insertWhiteSpace(_ tagIndex: Int, whiteSpace: CGFloat) {
		var info = layoutInfoList[tagIndex]
		let factor = tagAlignmentType.distributionFactor
		info.whiteSpace = whiteSpace/factor
		layoutInfoList[tagIndex] = info
	}
	
	func tagFrameForIndex(_ tagIndex: Int) -> CGRect {
		let tagFrame =  tagIndex > -1 ? layoutInfoList[tagIndex].layoutAttribute.frame : CGRect.zero
		return tagFrame
	}
	
	func configurePositionForNextTag() {
		let layoutInfo = layoutInfoList[currentTagIndex].layoutAttribute
		let moveTag = shouldMoveTagToNextRow(layoutInfo.frame.size.width)
		numberOfTagsInCurrentRow = moveTag ? 1 : (numberOfTagsInCurrentRow + 1)
	}
	
	func handleTagAlignment() {
		if let collectionView = collectionView , tagAlignmentType != .left {
			let tagsCount = collectionView.numberOfItems(inSection: 0)
			for tagIndex in 0 ..< tagsCount {
				var tagFrame = layoutInfoList[tagIndex].layoutAttribute.frame
				let whiteSpace = layoutInfoList[tagIndex].whiteSpace
				tagFrame.origin.x += whiteSpace
				let tagAttribute = layoutAttribute(tagIndex, tagFrame: tagFrame)
				layoutInfoList[tagIndex].layoutAttribute = tagAttribute
			}
		}
	}
	
	func handleWhiteSpaceForLastRow() {
		if isLastRow {
			applyWhiteSpace(startingIndex: (tagsCount-1))
		}
	}
	
	func handleErrorState() {
		print("TagCollectionViewCellLayout is not properly configured")
	}
	
	func resetLayoutState() {
		layoutInfoList = Array<TagCellLayoutInfo>()
		numberOfTagsInCurrentRow = 0
		lineNumber = 1
	}
	
}
