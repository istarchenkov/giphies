//
//  GPDownloadOperation.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit
import Foundation

class GPDownloadOperation: NSOperation, NSURLConnectionDataDelegate {
    
    // MARK: - Types
    
    enum State {
        case Ready, Executing, Finished
        func keyPath() -> String {
            switch self {
            case Ready:
                return "isReady"
            case Executing:
                return "isExecuting"
            case Finished:
                return "isFinished"
            }
        }
    }
    
    // MARK: - Properties
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath())
            willChangeValueForKey(state.keyPath())
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath())
            didChangeValueForKey(state.keyPath())
        }
    }
    
    // MARK: - NSOperation
    
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    /// cell model object which wait for data
    let contentObject : GPGif

    /// private content vars
    private var downloadedData : NSMutableData?
    private var totalBytes = 0
    private var ownedBytes = 0 {
        didSet {
            contentObject.contentDownloadProgress = operationProgress
        }
    }
    
    /// download operation progress (0 -> 100)
    private var operationProgress : Double {
        return Double(ownedBytes) / Double(totalBytes)
    }
    
    /**
    Initialize operation from cell model object
    
    :param: content cell model object
    */
    init(content : GPGif) {
        contentObject = content
    }
    
    // MARK: - Task
    
    override func start() {
        if cancelled {
            state = .Finished
            return
        }
        main()
        state = .Executing
    }
    
    override func main() {
        let request = NSURLRequest(URL: NSURL(string: contentObject.contentUrlStirng)!)
        let connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode:NSRunLoopCommonModes)
        connection?.start()
    }
    
    // MARK: - NSURLConnectionDataDelegate
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        let httpResponse = response as! NSHTTPURLResponse
        let dict = httpResponse.allHeaderFields
        let lengthString = dict["Content-Length"] as! String
        let length = NSNumberFormatter().numberFromString(lengthString)
        totalBytes = length!.unsignedIntegerValue
        downloadedData = NSMutableData(capacity: totalBytes)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if cancelled {
            connection.cancel()
            state = .Finished
            return
        }
        downloadedData!.appendData(data)
        ownedBytes += data.length
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        contentObject.contentData = downloadedData
        state = .Finished
    }

    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Download operation did fail with error \(error)")
        state = .Finished
    }
}