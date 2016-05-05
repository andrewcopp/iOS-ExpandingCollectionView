//
//  CollectionViewController.swift
//  ExpandingCollectionView
//
//  Created by Andrew Copp on 5/4/16.
//  Copyright © 2016 Andrew Copp. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var items: [CollectionItem] = [.Color(UIColor.redColor()), .Color(UIColor.orangeColor()), .Text("Would you rather...?"), .Color(UIColor.yellowColor()), .Color(UIColor.greenColor()), .Text("What's your favorite neighborhood?"), .Color(UIColor.blueColor()), .Color(UIColor.purpleColor())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.allowsMultipleSelection = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch items[indexPath.row] {
        case .Color(let color):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ColorCellIdentifier, forIndexPath: indexPath)
            cell.backgroundColor = color
            return cell
        case .Text(_):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextCellIdentifier, forIndexPath: indexPath)
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        case .EditingText(_):
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EditTextCellIdentifier, forIndexPath: indexPath)
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }
        
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        guard case .Text(let text) = items[indexPath.row] else {
            return
        }
        
        collectionView.scrollEnabled = false
        
        items[indexPath.row] = CollectionItem.EditingText(text)
        
        let updates = {
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        collectionView.performBatchUpdates(updates) { finished in
            collectionView.reloadItemsAtIndexPaths([indexPath])
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard case .EditingText(let text) = items[indexPath.row] else {
            return
        }
        
        items[indexPath.row] = CollectionItem.Text(text)
        
        let updates = {
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        collectionView.performBatchUpdates(updates) { finished in
            collectionView.reloadItemsAtIndexPaths([indexPath])
            collectionView.scrollEnabled = true
        }
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
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
