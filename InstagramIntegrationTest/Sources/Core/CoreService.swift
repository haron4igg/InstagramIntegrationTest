//
//  CoreService.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/22/15.
//  Copyright © 2015 IT. All rights reserved.
//

import Foundation

typealias ServiceResultHandler = (Array<AnyObject>?, NSError?) -> Void

class CoreService: NSObject {
    static let sharedInstance = CoreService()
    
    
    var remoteManager : RemoteManager?
    
    override init()
    {
        self.remoteManager = InstagramRemoteManager()
    }
    
    func findUsers(searchString : String, completionHandler: ServiceResultHandler) {
        self.remoteManager?.searchUsers(searchString, completionHandler: completionHandler)
    }
    
    func fetchUserImages(user : User, completionHandler: ServiceResultHandler) {
        self.remoteManager?.fetchUserMedia(user.id!, completionHandler: completionHandler)
    }
}
