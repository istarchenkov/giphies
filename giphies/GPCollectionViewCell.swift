//
//  GPCollectionViewCell.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit

class GPCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IB & properties
    
    /// conten loading indicator
    @IBOutlet weak var cellContentLoading: UIActivityIndicatorView!

    /// animated image
    private var animatedImage : FLAnimatedImage?
    /// animated image view to show animated image
    private var animatedImageView : FLAnimatedImageView?
    
    /// content object to
    var contentObject : GPGif? {
        didSet {
            if contentObject != nil {
                // cell will display, animate loader
                cellContentLoading.startAnimating()
                // mark as high expected content
                contentObject!.markAsHighPriorityContent()
                // set data recieve handler
                contentObject!.contentRecieveHandler = {[weak self] (contentUrlString , contentData) in
                    // content data callback should be executed in main thread to update ui
                    dispatch_async(dispatch_get_main_queue()) {
                        // stop loader
                        self?.cellContentLoading.stopAnimating()
                        // add animated image
                        self?.addAnimatedImageFrom(contentData)
                    }
                }
            } else {
                // cell did end display, so clear it and mark as low expected content
                oldValue?.markAsLowPriorityContent()
                // set data recieve closure in old content object to nil
                oldValue?.contentRecieveHandler = nil
                // clear cell from animated image
                clearCell()
            }
        }
    }
    
    // MARK: - Mgmt animated content
    
    /**
        Clear cell animated image view
    */
    private func clearCell() {
        animatedImageView?.removeFromSuperview()
        animatedImageView = nil
        animatedImage = nil
    }
    
    /**
        Add animated image view from NSData
        
        :param: content data
    */
    private func addAnimatedImageFrom(data : NSData) {
        animatedImage = FLAnimatedImage(animatedGIFData: data)
        animatedImageView = FLAnimatedImageView()
        animatedImageView!.animatedImage = animatedImage!
        // set image view frame from cell model size
        animatedImageView!.frame = CGRectMake(0, 0, contentObject!.contentWidth, contentObject!.contentHeight)
        contentView.addSubview(animatedImageView!)
    }
}
