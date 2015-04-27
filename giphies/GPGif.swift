//
//  GPGif.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit

class GPGif {

    // MARK: - properties
    
    /// cell model url string from search response
    var contentUrlStirng : String = ""
    /// content model width from search response
    var contentWidth : CGFloat = 0
    /// content model height from search response
    var contentHeight : CGFloat = 0
    
    /// content data from downloader
    var contentData : NSData? {
        didSet {
            // if non nil data did set then throw it content handler
            if contentRecieveHandler != nil && contentData != nil  {
                contentRecieveHandler!(contentUrlString : contentUrlStirng , contentData : contentData!)
            }
        }
    }
    
    /// data recieve closure to get callback from downloader when data ready to be displayed in cell
    var contentRecieveHandler : ContentRecieved? {
        didSet {
            // if closure not nil
            if contentRecieveHandler != nil {
                // check if data downloaded already
                if contentData != nil {
                    // if yes throw it back to cell
                    contentRecieveHandler!(contentUrlString : contentUrlStirng , contentData : contentData!)
                } else {
                    // if not add download operation in downloader
                    GPDownloader.shared.addDownloadOperationFor(self)
                }
            }
        }
    }
    
    // MARK: - Priority mgmt
    
    /**
        Set model as low expected content, to low it's priority in download queue. Call in case of cell did end display.
    */
    func markAsLowPriorityContent() {
        priority(.Low)
    }

    /**
        Set model as high expected content, to high it's priority in download queue. Call in case of cell will display.
    */
    func markAsHighPriorityContent() {
        priority(.High)
    }

    /**
        Specify model priority in download queue
    
        :param: priority priority of current model
    */
    private func priority(priority : NSOperationQueuePriority) {
        if contentData == nil {
            GPDownloader.shared.changePriorityFor(self , to: priority)
        }
    }
    
    // MARK: - Memory
    
    /**
        Purge downloaded data if not presented right now
    */
    func purge() {
        if contentData != nil {
            contentData = nil
        }
    }
}
