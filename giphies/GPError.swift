//
//  GPError.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import Foundation

// MARK: - Error Codes & Descriptions

/**
    -JSONSerializationError: serialization error
    -URLForQueryError: URL conversion error
    -NoSearchResultFound: no result found
    -UnexpectedBehavior: unspecify error
    -NetworkUnreachable: network unreachable
*/
enum Error : Int {
    case JSONSerializationError = 400
    case URLForQueryError = 401
    case NoSearchResultFound = 402
    case UnexpectedBehavior = 403
    case NetworkUnreachable = 404
    
    /**
        Get error description from code
    
        :returns: Dict with description as value and NSLocalizedDescriptionKey as a key
    */
    func description() -> [NSObject : AnyObject] {
        var desc = ""
        switch self {
        case .JSONSerializationError:
            desc = "Error occured while json serialization"
        case .NoSearchResultFound:
            desc = "No result found"
        case .URLForQueryError:
            desc = "Generated url for query is nil for some reason"
        case .UnexpectedBehavior:
            desc = "Unexpected behavior"
        case .NetworkUnreachable:
            desc = "No internet connection"
        }
        var errorDescription : [NSObject : AnyObject] = [NSLocalizedDescriptionKey : desc]
        return errorDescription
    }
}

// MARK: - GPError

/// Wrap on NSError
class GPError : NSError {
    
    /**
        Initialize error from Error enum
    
        :param: code Error enum reason 
        :returns: error with code and description
    */
    init(code : Error) {
        super.init(domain: Constants.ErrorDomain, code: code.rawValue, userInfo:  code.description())
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
