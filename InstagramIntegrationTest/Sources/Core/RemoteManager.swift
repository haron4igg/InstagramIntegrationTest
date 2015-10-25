//
//  RemoteManager.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/22/15.
//  Copyright © 2015 IT. All rights reserved.
//

import Foundation



enum RemoteError: ErrorType {
    case RemoteErrorNoConnection
    case RemoteErrorSerrializationFailure
}

protocol RemoteManager {
    
    func searchUsers( searchString : String, completionHandler: ServiceResultHandler )
    
    func fetchUserMedia( userID : String, completionHandler: ServiceResultHandler )
    
}