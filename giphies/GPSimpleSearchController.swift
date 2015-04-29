//
//  GPSimpleSearchController.swift
//  giphies
//
//  Created by Ivan Starchenkov on 27/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit

/// Search view controller
class GPSimpleSearchController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IB & properties
    
    /// Search status label
    @IBOutlet weak var statusLabel: UILabel!
    /// Search loading indicator
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    /// Search text field
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }

    /// Search model instance to perform search queries
    private lazy var searchInstance = GPSearch()

    // MARK: - UIViewControllerDelegate
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // text field become first responder to show keyboard
        searchTextField.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        statusLabel.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !textField.text.isEmpty {
            // hide keyboard
            textField.resignFirstResponder()
            // perform search
            search(textField.text)
            return true
        }
        return false
    }
        
    // MARK: - Search
    
    /**
        Perform search query, setup search callback inside to processed search response
    
        :param: query String of url query
    */
    private func search(query : String) {
        // disable text field from user interaction
        searchTextField.userInteractionEnabled = false
        // start loader animation
        loadingIndicator.startAnimating()
        // set status label
        statusLabel.text = "Loading..."
        // perform query on search instance with callback closure
        searchInstance.searchFor(query) { [weak self] (response , error) in
            if let strongSelf = self {
                // perform ui interaction in main queue
                dispatch_async(dispatch_get_main_queue()) {
                    // enable text field for user interaction
                    strongSelf.searchTextField.userInteractionEnabled = true
                    // stop loader animation
                    strongSelf.loadingIndicator.stopAnimating()
                    if error != nil {
                        // if error occured update search status label with description
                        strongSelf.statusLabel.text = (error!.userInfo as! [String : String])[NSLocalizedDescriptionKey]
                        println("Search did fail with error : \(error!)")
                    } else {
                        // clear search status label
                        strongSelf.statusLabel.text = ""
                        // performing segue in case of search instance return content array
                        strongSelf.performSegueWithIdentifier(Constants.ResultSegueIdentifier, sender: response!)
                    }
                }
            }
        }
    }
        
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ResultSegueIdentifier {
            // set search callback closure response as content array in destination collection view
            (segue.destinationViewController as! GPCollectionViewController).contentArray = sender as! [GPGif]
            // set search query string as destination controller title
            (segue.destinationViewController as! GPCollectionViewController).title = searchTextField.text
        }
    }
}
