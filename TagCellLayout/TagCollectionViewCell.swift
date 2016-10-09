//
//  TagCollectionViewCell.swift
//  TagCellLayout
//
//  Created by Ritesh-Gupta on 20/11/15.
//  Copyright © 2015 Ritesh. All rights reserved.
//

import Foundation
import UIKit

class TagCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var tagView: UILabel?
  
  override func awakeFromNib() {
    if let tagView = tagView {
      tagView.layer.cornerRadius = tagView.frame.size.height/2 - 2
      tagView.layer.borderColor = UIColor.blue.cgColor
      tagView.layer.borderWidth = 3.0
    }
  }
  
}
