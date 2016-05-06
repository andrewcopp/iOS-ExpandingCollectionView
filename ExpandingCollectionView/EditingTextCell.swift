//
//  EditingTextCell.swift
//  ExpandingCollectionView
//
//  Created by Andrew Copp on 5/4/16.
//  Copyright © 2016 Andrew Copp. All rights reserved.
//

import UIKit

let EditingTextCellIdentifier = "EditingTextCell"

class EditingTextCell: UICollectionViewCell, Dimmable {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    var overlayView = UIView()
}
