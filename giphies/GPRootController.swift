//
//  GPRootController.swift
//  giphies
//
//  Created by Ivan Starchenkov on 23/04/15.
//  Copyright (c) 2015 Ivan Starchenkov. All rights reserved.
//

import UIKit

class GPRootController: UIViewController , UITextFieldDelegate {
    
    // text field outlet with delegate set on didSet
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }
    
    // catch return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search(textField.text)
        return true
    }
        
    // private search func
    private func search(_query : String) {
        println("SEARCH FOR : \(_query) ON GIPHY.COM")
        searchField.resignFirstResponder()
        
        //GPSearch.shared.searchFor(_query)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
