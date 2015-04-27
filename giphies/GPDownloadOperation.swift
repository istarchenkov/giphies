//
//  GPDownloadOperation.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit
import Foundation

/// Operation to download data from network
class GPDownloadOperation: NSOperation {
   
    /// cell model object which wait for data
    let contentObject : GPGif
    
    /**
        Initialize operation from cell model object
    
        :param: content cell model object
    */
    init(content : GPGif) {
        contentObject = content
    }
    
    // MARK: - Operation task
    
    override func main() {
        if cancelled {
            return
        }
        // start download data
        let data = NSData(contentsOfURL: NSURL(string: contentObject.contentUrlStirng)!)
        if cancelled {
            return
        }
        // set downloaded data to cell model object
        contentObject.contentData = data
    }
}
