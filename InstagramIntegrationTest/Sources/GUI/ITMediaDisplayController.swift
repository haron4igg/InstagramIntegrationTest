//
//  ITMediaDisplayController.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/22/15.
//  Copyright © 2015 IT. All rights reserved.
//

import UIKit


class ITMediaDisplayController: UICollectionViewController {
    
    var user : User?
    var userMedia : Array<AnyObject>?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserImages()
        
        var userName = self.user!.fullName
        if userName == nil || userName!.isEmpty {
            userName = self.user!.name
        }
        
        self.title = userName
    }
    
    func fetchUserImages() {
        if self.user != nil {
            AppDelegate.networkActivityIndicatorVisible = true
            CoreService.sharedInstance.fetchUserImages(self.user!) { (images : Array<AnyObject>?, error : NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    AppDelegate.networkActivityIndicatorVisible = false
                    
                    if images != nil {
                        self.userMedia = images
                        self.collectionView?.reloadData() 
                    } else if (error != nil) {
                        ErrorHandler.handleError(self, error: error!)
                    }
                })
            }
        }
    }
    
    // Collection view delegate
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userMedia != nil ? self.userMedia!.count : 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ITImageCell
        
        cell.imageView?.image = UIImage(named: "circle")
        
        let media = self.userMedia![indexPath.row] as! Media
        
        let placeHolder = UIImage(named: "no_image")
        cell.imageView?.image = placeHolder
        
        if cell.imageView?.frame.width <= 0 {
            cell.imageView?.sizeToFit()
        }
        
        
        weak var cellWeak = cell
        cellWeak!.activityIndicator?.startAnimating()
        cell.imageView?.hnk_setImageFromURL(NSURL(string: media.imageLow!)!, placeholder: placeHolder, format: nil, failure: {
            (error: NSError?) -> Void in
            print("Load failed \(error)")
            cellWeak!.activityIndicator?.stopAnimating()
        }, success: { (image: UIImage) -> Void in
            cellWeak!.imageView!.image = image
            cellWeak!.activityIndicator?.stopAnimating()
        })
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullScreen", let destination = segue.destinationViewController as? ITDetailViewController {
            if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView!.indexPathForCell(cell) {
                destination.media = (self.userMedia![indexPath.row] as! Media)
            }
        }
    }
    
}
