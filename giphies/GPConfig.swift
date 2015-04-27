//
//  GPConfig.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

struct Config {
    /// max number of concurrent operations (threads) in downloader queue
    static let NumberOfThreads = 10
}

struct Constants {
    /// cell identifier (defined in storyboard as well)
    static let ReuseIdentifier = "GifCell"
    /// error domain
    static let ErrorDomain = "GPErrorDomain"
    /// (search -> result collection view) segue identifier
    static let ResultSegueIdentifier = "Show Result"
    /// download queue identifier
    static let QueueIdentifier = "Downloading Queue"    
}