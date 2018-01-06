//
//  ViewController.swift
//  TagCellLayout
//
//  Created by Ritesh-Gupta on 20/11/15.
//  Copyright © 2015 Ritesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView?
	
	var longString = "start ––– Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ––– end"
	
	var oneLineHeight: CGFloat {
		return 54.0
	}
	
	var longTagIndex: Int {
		return 1
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		defaultSetup()
		
		// THIS IS ALL WHAT IS REQUIRED TO SETUP YOUR TAGS
		
		let tagCellLayout = TagCellLayout(alignment: .center, delegate: self)
		collectionView?.collectionViewLayout = tagCellLayout
	}
	
	//MARK: - Default Methods
	
	func defaultSetup() {
		let nib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
		collectionView?.register(nib, forCellWithReuseIdentifier: "TagCollectionViewCell")
	}
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	//MARK: - UICollectionView Delegate/Datasource Methods
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let identifier = "TagCollectionViewCell"
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
		if indexPath.row == longTagIndex || indexPath.row == (longTagIndex + 3) {
			cell.configure(with: longString)
		} else {
			cell.configure(with: "Tags")
		}
		return cell
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
}

extension ViewController: TagCellLayoutDelegate {
	
	func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
		if index == longTagIndex || index == (longTagIndex + 3) {
			var s = textSize(text: longString, font: UIFont.systemFont(ofSize: 17.0), collectionView: collectionView!)
			s.height += 8.0
			return s
		} else {
			let width = CGFloat(index % 2 == 0 ? 80 : 120)
			return CGSize(width: width, height: oneLineHeight)
		}
	}	
}

extension ViewController {
	
	func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
		var f = collectionView.bounds
		f.size.height = 9999.0
		let label = UILabel()
		label.numberOfLines = 0
		label.text = text
		label.font = font
		var s = label.sizeThatFits(f.size)
		s.height = max(oneLineHeight, s.height)
		return s
	}
}
