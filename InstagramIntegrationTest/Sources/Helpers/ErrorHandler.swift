//
//  ErrorHandler.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/25/15.
//  Copyright © 2015 IT. All rights reserved.
//

import UIKit


class ErrorHandler {
    
    static func handleError(sender : UIViewController,error : NSError) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)

        //Present the AlertController
        sender.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
}