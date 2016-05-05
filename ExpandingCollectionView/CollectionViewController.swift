//
//  CollectionViewController.swift
//  ExpandingCollectionView
//
//  Created by Andrew Copp on 5/4/16.
//  Copyright © 2016 Andrew Copp. All rights reserved.
//

import UIKit

let CollectionViewControllerEditingOffset: CGFloat = 100.0

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var items: [CollectionItem] = [.Color(UIColor.redColor()), .Color(UIColor.orangeColor()), .Text(question: "Would you rather...?", answer: "Yes"), .Color(UIColor.yellowColor()), .Color(UIColor.greenColor()), .Text(question: "What's your favorite neighborhood?", answer: "West Village"), .Color(UIColor.blueColor()), .Color(UIColor.purpleColor())]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.allowsMultipleSelection = true
        
        collectionView.contentInset.top = 200.0
        collectionView.contentInset.bottom = 200.0
    }

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch items[indexPath.row] {
        case .Color(let color):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ColorCellIdentifier, forIndexPath: indexPath)
            cell.backgroundColor = color
            return cell
        case .Text(let question, _):
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextCellIdentifier, forIndexPath: indexPath) as? TextCell else {
                fatalError()
            }
            cell.backgroundColor = UIColor.whiteColor()
            cell.questionLabel.text = question
            return cell
        case .EditingText(let question, let answer):
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EditingTextCellIdentifier, forIndexPath: indexPath) as? EditingTextCell else {
                fatalError()
            }
            cell.backgroundColor = UIColor.whiteColor()
            cell.questionLabel.text = question
            cell.answerTextView.text = answer
            return cell
        }
        
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        guard case .Text(let question, let answer) = items[indexPath.row] else {
            return
        }
        
        collectionView.scrollEnabled = false
        
        items[indexPath.row] = CollectionItem.EditingText(question: question, answer: answer)
        
        let updates = {
            collectionView.deleteItemsAtIndexPaths([indexPath])
            collectionView.insertItemsAtIndexPaths([indexPath])
        }
        
        if let frame = collectionView.cellForItemAtIndexPath(indexPath)?.frame {
            let verticalOffset = CGRectGetMinY(frame) - CollectionViewControllerEditingOffset - collectionView.contentInset.top - collectionView.contentInset.bottom
            let scrollRect = CGRect(origin: CGPoint(x: 0.0, y: verticalOffset), size: collectionView.bounds.size)
            collectionView.scrollRectToVisible(scrollRect, animated: true)
        }
        
        collectionView.performBatchUpdates(updates) { finished in
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let editingTextCell = collectionView.cellForItemAtIndexPath(indexPath) as? EditingTextCell else {
            return
        }
        
        if let question = editingTextCell.questionLabel.text, let answer = editingTextCell.answerTextView.text {
            items[indexPath.row] = CollectionItem.Text(question: question, answer: answer)
        }
        
        let updates = {
            collectionView.deleteItemsAtIndexPaths([indexPath])
            collectionView.insertItemsAtIndexPaths([indexPath])
        }
        
        collectionView.performBatchUpdates(updates) { finished in
            collectionView.scrollEnabled = true
        }
    }

    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        switch items[indexPath.row] {
        case .Color(_):
            return false
        case .Text(_):
            return true
        case .EditingText(_):
            return true
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch items[indexPath.row] {
        case .Color(_):
            return CGSize(width: CGRectGetWidth(collectionView.bounds), height: CGRectGetWidth(collectionView.bounds))
        case .Text(_):
            return CGSize(width: CGRectGetWidth(collectionView.bounds) * 3.0 / 4.0, height: CGRectGetWidth(collectionView.bounds) / 2.0)
        case .EditingText(_):
            return CGSize(width: CGRectGetWidth(collectionView.bounds), height: CGRectGetWidth(collectionView.bounds) * 3.0 / 4.0)
        }
    }

}
