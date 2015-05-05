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
    
    /// content download progress
    @IBOutlet weak var progressView: CircleProgressView!
    
    /// animated image
    private var animatedImage : FLAnimatedImage?
    /// animated image view to show animated image
    private var animatedImageView : FLAnimatedImageView?
    /// KVO context
    private var myContext = 0
    
    /// content object to
    var contentObject : GPGif? {
        didSet {
            if contentObject != nil {
                // show progress view at actual progress
                progressView.hidden = false
                progressView.progress = contentObject!.contentDownloadProgress
                // listen model for download progress via KVO
                contentObject!.addObserver(self, forKeyPath: "contentDownloadProgress", options: .New, context: &myContext)
                // mark as high expected content
                contentObject!.markAsHighPriorityContent()
                // set data recieve handler
                contentObject!.contentRecieveHandler = {[weak self] (contentUrlString , contentData) in
                    // content data callback should be executed in main thread to update ui
                    dispatch_async(dispatch_get_main_queue()) {
                        // hide progress view
                        self?.progressView.hidden = true
                        // add animated image
                        self?.addAnimatedImageFrom(contentData)
                    }
                }
            } else {
                // remove self from progress observing via KVO
                oldValue?.removeObserver(self, forKeyPath: "contentDownloadProgress", context: &myContext)
                // cell did end display, so clear it and mark as low expected content
                oldValue?.markAsLowPriorityContent()
                // set data recieve closure in old content object to nil
                oldValue?.contentRecieveHandler = nil
                // clear cell from animated image
                clearCell()
            }
        }
    }
    
    // MARK: - KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if keyPath == "contentDownloadProgress" {
                progressView.progress = change[NSKeyValueChangeNewKey] as! Double
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
        animatedImageView!.frame = contentView.frame
        contentView.addSubview(animatedImageView!)
    }
}
