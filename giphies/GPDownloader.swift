//
//  GPDownloader.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import Foundation

/// singleton provider
private let _shared = GPDownloader()

/// Download data from network provider (Singleton)
class GPDownloader : NSObject {
    
    // MARK: - Singleton 
    
    class var shared : GPDownloader {
        return _shared
    }
    
    // MARK: - Init
    
    /// use KVO observing of queue.operationCount to encapsulate status bar network indicator behavior inside of model
    
    private var myContext = 0
    
    override init() {
        super.init()
        downloadQueue.addObserver(self, forKeyPath: "operationCount", options: .New, context: &myContext)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &myContext {            
            if keyPath == "operationCount" {
                if change[NSKeyValueChangeNewKey] as! Int == 0 {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                }
            }
        }
    }
    
    // MARK: - Properties
    
    /// download queue lazy property
    private var downloadQueue : NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = Constants.QueueIdentifier
        queue.maxConcurrentOperationCount = Config.NumberOfThreads
        return queue
    }()
        
    // MARK: - Download mgmt
    
    /**
        Add download operation for model object
    
        :param: contentObject cell model object
    */
    func addDownloadOperationFor(contentObject : GPGif) {
        // check if operation for that content exist in queue already
        for op in downloadQueue.operations {
            if (op as! GPDownloadOperation).contentObject.contentUrlStirng == contentObject.contentUrlStirng {
                // exit if operation for model found
                return
            }
        }
        // if not - create operation and add it in queue
        let contentDownloadOperation = GPDownloadOperation(content: contentObject)
        // UserInitiated QOS
        contentDownloadOperation.qualityOfService = NSQualityOfService.UserInitiated
        // high priority because adding operation means that cell just displayed
        contentDownloadOperation.queuePriority = .High
        // add in queue
        downloadQueue.addOperation(contentDownloadOperation)
    }
    
    // MARK: - Download priority
    
    /** 
        Change priority for given cell model on given priority
        
        :param: contentObject cell model object
        :param: priority new priority
    */
    func changePriorityFor(contentObject : GPGif, to priority : NSOperationQueuePriority) {
        // looking for operation in queue for given cell model object
        for op in downloadQueue.operations {
            if (op as! GPDownloadOperation).contentObject.contentUrlStirng == contentObject.contentUrlStirng {
                // change priority and exit because only one operation for cell model object may exist in queue
                (op as! GPDownloadOperation).queuePriority = priority
                return
            }
        }
    }
    
    // MARK: - Queue control
    
    /**
        Invalidate all operations in download queue
    */
    func invalidate() {        
        downloadQueue.cancelAllOperations()
    }
    
    /**
        Pause all operations (which are not start yet) in download queue
    */
    func pause() {
        downloadQueue.suspended = true
    }
    
    /**
        resume all operations in download queue
    */
    func resume() {
        downloadQueue.suspended = false
    }
}