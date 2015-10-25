//
//  ITDetailViewController.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/24/15.
//  Copyright © 2015 IT. All rights reserved.
//


import UIKit
import Haneke

class ITDetailViewController: UITableViewController {
    
    
    @IBOutlet weak var imageView : UIImageView?
    
    var media: Media? {
        didSet {
            if self.isViewLoaded() {
                reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 81.0
        
        var size = self.tableView.frame.size
        size.height -= self.navigationController!.navigationBarHidden ? 0 : self.navigationController!.navigationBar.frame.height
        
        self.imageView?.frame = CGRect(origin: CGPointZero, size: size)
        let placeHolder = UIImage(named: "no_image")
        self.imageView?.image = placeHolder
        
        if self.media != nil {
            reloadData()
        }
    }
    
   
    func reloadData() {
        
        self.title = self.media!.name
        //AppDelegate.networkActivityIndicatorVisible = true
        self.imageView?.hnk_setImageFromURL(NSURL(string: self.media!.imageBig!)!, placeholder: self.imageView!.image, format: nil,
        failure: { (error: NSError?) -> Void in
            //AppDelegate.networkActivityIndicatorVisible = false
        }, success: { (image: UIImage) -> Void in
                self.imageView?.image = image
                //AppDelegate.networkActivityIndicatorVisible = false
        })
        
        self.tableView.reloadData()
    }
    
    // table view delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.media != nil && self.media!.comments != nil ? (self.media!.comments!.count) : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ITCommentCell
        
        
        let comment = self.media!.comments![indexPath.row] as! Comment
        
        var userName = comment.author!.fullName
        
        if userName == nil || userName!.isEmpty {
            userName = comment.author!.name
        }
        
        cell.userNameLabel!.text = userName
        
        let placeHolder = UIImage(named: "no_image")
        cell.profileImageView?.image = placeHolder
        
        if cell.profileImageView?.frame.width <= 0 {
            cell.profileImageView?.sizeToFit()
        }
        
        cell.commentLabel?.text = comment.text
        
        cell.profileImageView?.hnk_setImageFromURL(NSURL(string: comment.author!.profileImage!)!, placeholder: placeHolder, format: nil, failure: {
            (error: NSError?) -> Void in
            print("Load failed \(error)")
        })
        
        return cell
    }
 
    
}
