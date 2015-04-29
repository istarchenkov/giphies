//
//  GPSearch.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import Foundation
import UIKit

/// Search performer
class GPSearch {
    
    // MARK: - Search query func
    
    /**
        Perform search query from plain string, throw response or error in callback closure 
    
        :param: query Plain string url
        :param: handler Callback closure
    */
    func searchFor(query : String , completion handler : SearchCallback) {
        // show status bar network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // convert plain string
        if let requestUrl = urlForQuery(query) {
            // check if network unreachable
            if AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus == AFNetworkReachabilityStatus.NotReachable {
                // throw network error in callback closure
                handler(response: nil, error: GPError(code: .NetworkUnreachable))
            } else {
                // else perform async urlrequest via nssession
                NSURLSession.sharedSession().dataTaskWithURL(requestUrl) { [weak self] (data, response, error)  in
                    // hide status bar network indicator
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // check if error occured
                    if error != nil {
                        // throw it to callback closure
                        handler(response: nil, error: error)
                    } else {
                        // else try to serialize json response in NSDictionary
                        if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                            // parse response into content array
                            if let contentArray = GPParser.parseDictToModeArray(jsonObject) {
                                // and throw it to callback closure
                                handler(response: contentArray, error: nil)
                            } else {
                                // nil means empty response, throw no result found error in callback closure
                                handler(response: nil, error: GPError(code: .NoSearchResultFound))
                            }
                        } else {
                            // if serialization fail - throw error to callback closure
                            handler(response: nil , error: GPError(code: .JSONSerializationError))
                        }
                    }
                }.resume()
            }
        } else {
            // plain string convertion error throw in callback closure
            handler(response: nil , error: GPError(code: .URLForQueryError))
        }        
    }
    
    // MARK: - Routine
        
    /**
        Convert plain String from text field into URL
    
        :param: query Plain String
        :returns: NSURL of query
    */
    private func urlForQuery(query : String) -> NSURL? {
        if let queryForUrl = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            return NSURL(string: "http://api.giphy.com/v1/gifs/search?q=\(queryForUrl)&limit=100&api_key=dc6zaTOxFJmzC")
        }
        return nil
    }    
}