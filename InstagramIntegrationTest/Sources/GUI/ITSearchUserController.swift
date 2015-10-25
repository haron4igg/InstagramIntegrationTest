//
//  ITSearchUserController.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/23/15.
//  Copyright © 2015 IT. All rights reserved.
//

import UIKit
import Haneke


class ITSearchUserController: UITableViewController, UISearchBarDelegate {
    
    
    internal var searchBar : UISearchBar?
    
    
    private let searchBarMargins : CGFloat = 44
    private let searchBarHeight : CGFloat = 44
    
    private var lastSearchText = ""
    private var fetchTimer : NSTimer?
    
    private var users: Array<AnyObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup search bar
        if self.navigationController != nil {
            let size = CGSize(  width: self.navigationController!.navigationBar.frame.width-self.searchBarMargins*2,
                height: self.searchBarHeight)
            
            let frame = CGRect (origin: CGPoint(x: 0, y: 0), size: size)
            
            self.searchBar = UISearchBar(frame: frame)
            self.searchBar!.placeholder = "Start typing user name..."
            self.searchBar!.delegate = self
            self.navigationItem.titleView = self.searchBar
        }
    }
    
    // Fetch
    
    func fetchUsersWithName( searchString : String ) {
        
        AppDelegate.networkActivityIndicatorVisible = true
        CoreService.sharedInstance.findUsers(searchString) { ( users: Array<AnyObject>?, error: NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                AppDelegate.networkActivityIndicatorVisible = false
                
                if users != nil {
                    self.users = users
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func initiateDelayedSearchWithString(let searchString : String) {
        //
        let finalString = String(searchString)        
        if !finalString.isEmpty {
            fetchUsersWithName( finalString )
        }
        
    }
    
    
    // Search Bar Delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        initiateDelayedSearchWithString(searchText)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        initiateDelayedSearchWithString(searchBar.text!)
    }

    // table view delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users != nil ? self.users!.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
        }
        
        let user = self.users![indexPath.row] as! User
        
        var userName = user.fullName
        
        if userName == nil || userName!.isEmpty {
            userName = user.name
        }

        cell?.textLabel!.text = userName
    
        let placeHolder = UIImage(named: "no_image")
        cell?.imageView?.image = placeHolder
        
        if cell?.imageView?.frame.width <= 0 {
            cell?.imageView?.sizeToFit()
            //cell?.layoutSubviews()
        }

        cell?.imageView?.hnk_setImageFromURL(NSURL(string: user.profileImage!)!, placeholder: placeHolder, format: nil, failure: {
            (error: NSError?) -> Void in
            print("Load failed \(error)")
        })
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mediaFeed", let destination = segue.destinationViewController as? ITMediaDisplayController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                destination.user = (self.users![indexPath.row] as! User)
            }
        }
    }
    
}
