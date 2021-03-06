//
//  CollectionItem.swift
//  ExpandingCollectionView
//
//  Created by Andrew Copp on 5/4/16.
//  Copyright © 2016 Andrew Copp. All rights reserved.
//

import UIKit
import Foundation

enum CollectionItem {
    case Color(UIColor)
    case Text(question: String, answer: String)
    case EditingText(question: String, answer: String)
}