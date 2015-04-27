//
//  GPTypes.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import Foundation

/**
    Search callback closure

    :param: response Parsed from search json response array of cell model objects
    :param: error Error occured while searching
*/
typealias SearchCallback = (response : [GPGif]? , error : NSError?) -> ()

/**
    Data download callback closure

    :param: contentUrlString String url of callback data
    :param: contentData Data recieved from url
*/
typealias ContentRecieved = (contentUrlString : String , contentData : NSData) -> ()
