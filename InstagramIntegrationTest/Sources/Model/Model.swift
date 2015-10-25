//
//  Media.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/22/15.
//  Copyright © 2015 IT. All rights reserved.
//

import Foundation


protocol User : NSObjectProtocol {
    var id: String? { get }
    var name: String? { get }
    var fullName: String? { get }
    var profileImage: String? { get }
}


protocol Comment : NSObjectProtocol {
    var id: String? { get }
    var text: String? { get }
    
    var author : User? { get }
}


protocol Media : NSObjectProtocol {

    var id: String? { get }
    var name: String? { get }
    var type: String? { get }
    var link: String? { get }

    var imageLow: String? { get }
    var imageBig: String? { get }
    
    var comments: Array<AnyObject>? { get }
}


