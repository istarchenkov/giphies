//
//  GPCollectionViewController.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit

class GPCollectionViewController: UICollectionViewController , CHTCollectionViewDelegateWaterfallLayout {

    // MARK: - Properties
    
    /// array of cell models presented in collection view
    var contentArray : [GPGif] = []

    // MARK: - UIViewController
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // stop content download if view did disappear
        GPDownloader.shared.invalidate()
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ReuseIdentifier, forIndexPath: indexPath) as! GPCollectionViewCell
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {                
        return CGSizeMake(contentArray[indexPath.item].contentWidth, contentArray[indexPath.item].contentHeight)
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // if cell going to be displayed set content object from content array
        (cell as! GPCollectionViewCell).contentObject = contentArray[indexPath.item]        
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // if cell end display set nil to content object
        (cell as! GPCollectionViewCell).contentObject = nil
    }
    
    // MARK: - Purge invisible downloaded data in case of memory warning
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // generate array of visible cell models
        let visibleCells = collectionView?.visibleCells() as! [GPCollectionViewCell]
        var visibleContent = [String]()
        for visibleCell in visibleCells {
            visibleContent.append(visibleCell.contentObject!.contentUrlStirng)
        }
        // send purge message to all invisible cell models
        for contentPiece in contentArray {
            if !contains(visibleContent, contentPiece.contentUrlStirng) {
                contentPiece.purge()
            }
        }
    }
}
