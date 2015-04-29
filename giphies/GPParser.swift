//
//  GPParser.swift
//  giphies
//
//  Created by Ivan Starchenkov on 28/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import Foundation

/// Convert dictionari in content format array
class GPParser {
 
    /**
        Parse json response as NSDictionary to array of cell model objects
    
        :param: dict NSDictionary respond from searh query
        :returns: Array of cell model objects or nil if array have no members
    */
    class func parseDictToModeArray(dict : NSDictionary) -> [GPGif]? {
        var parsedArray = [GPGif]()
        let arrayOfData = dict["data"] as! NSArray
        for obj in arrayOfData {
            let contentDict = (obj["images"] as! NSDictionary)["fixed_width"] as! NSDictionary
            let contentObject = GPGif()
            contentObject.contentUrlStirng = contentDict["url"] as! String
            contentObject.contentHeight = CGFloat( (contentDict["height"] as! NSString).integerValue )
            contentObject.contentWidth = CGFloat( (contentDict["width"] as! NSString).integerValue )
            parsedArray.append(contentObject)
        }
        if parsedArray.count > 0 {
            return parsedArray
        }
        return nil
    }
}