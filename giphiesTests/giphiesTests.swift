//
//  giphiesTests.swift
//  giphiesTests
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit
import XCTest

import giphies

class giphiesTests: XCTestCase {
    
    /// test parse "no result found" dict case
    func testParseEmptyDict() {
        let dict = ["data" : [] ]
        let parsedArray = GPParser.parseDictToModeArray(dict)
        XCTAssertNil(parsedArray, "Parsing empty dict test passed")
    }

    /// test parsing no empty dict case
    func testParseDict() {

        // example dict
        let imageMetaDict1 = NSDictionary(objects: ["http://media3.giphy.com/media/NFo6yazDq7q9y/200w.gif","136","200"], forKeys: ["url","height","width"])
        let imageDict1 = NSDictionary(object:NSDictionary(object:imageMetaDict1, forKey: "fixed_width"), forKey: "images")
        let imageMetaDict2 = NSDictionary(objects: ["http://media0.giphy.com/media/NFo6yazDq7q9y/200w.gif","133","200"], forKeys: ["url","height","width"])
        let imageDict2 = NSDictionary(object:NSDictionary(object:imageMetaDict1, forKey: "fixed_width"), forKey: "images")
        let imageMetaDict3 = NSDictionary(objects: ["http://media1.giphy.com/media/NFo6yazDq7q9y/200w.gif","139","200"], forKeys: ["url","height","width"])
        let imageDict3 = NSDictionary(object:NSDictionary(object:imageMetaDict1, forKey: "fixed_width"), forKey: "images")
        
        let dict = ["data" : [ imageDict1, imageDict2, imageDict3 ]]
        if let parsedArray = GPParser.parseDictToModeArray(dict) {
            XCTAssertEqual(parsedArray.count, 3, "Parsed dict should have 3 members")
            XCTAssertEqual(parsedArray[0].contentWidth, 200, "Model at index 0 should have width 200")
            XCTAssertEqual(parsedArray[0].contentHeight, 136, "Model at index 0 should have height 136")
            XCTAssertEqual(parsedArray[0].contentUrlStirng, "http://media3.giphy.com/media/NFo6yazDq7q9y/200w.gif", "Model at index 0 should have url string http://media3.giphy.com/media/NFo6yazDq7q9y/200w.gif")
        } else {
            XCTFail("Parsed dict should not be nil")
        }
    }
}
