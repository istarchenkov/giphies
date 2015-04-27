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
        // convert plain string
        if let requestUrl = urlForQuery(query) {
            // check if network unreachable
            if AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus == AFNetworkReachabilityStatus.NotReachable {
                // throw network error in callback closure
                handler(response: nil, error: GPError(code: .NetworkUnreachable))
            } else {
                // else perform async urlrequest via nssession
                NSURLSession.sharedSession().dataTaskWithURL(requestUrl) { [weak self] (data, response, error)  in
                    // check if error occured
                    if error != nil {
                        // throw it to callback closure
                        handler(response: nil, error: error)
                    } else {
                        // else try to serialize json response in NSDictionary
                        if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                            // if success check if self still exist
                            if let strongSelf = self {
                                // parse response into content array
                                if let contentArray = strongSelf.parseDictToContentArray(jsonObject) {
                                    // and throw it to callback closure
                                    handler(response: contentArray, error: nil)
                                } else {
                                    // nil means empty response, throw no result found error in callback closure
                                    handler(response: nil, error: GPError(code: .NoSearchResultFound))
                                }
                            } else {
                                // self not exist, this not going to happen actually
                                handler(response: nil , error: GPError(code: .UnexpectedBehavior))
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
        Parse json response as NSDictionary in array of cell model objects
    
        :param: dict NSDictionary respond from searh query
        :returns: Array of cell model objects or nil if array have no members
    */
    private func parseDictToContentArray(dict : NSDictionary) -> [GPGif]? {
        var contentArray = [GPGif]()
        let arrayOfData = dict["data"] as! NSArray
        for obj in arrayOfData {
            let contentDict = (obj["images"] as! NSDictionary)["fixed_width"] as! NSDictionary
            let contentObject = GPGif()
            contentObject.contentUrlStirng = contentDict["url"] as! String
            contentObject.contentHeight = CGFloat( (contentDict["height"] as! NSString).integerValue )
            contentObject.contentWidth = CGFloat( (contentDict["width"] as! NSString).integerValue )
            contentArray.append(contentObject)
        }
        if contentArray.count > 0 {
            return contentArray
        }
        return nil
    }
        
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