//
//  InstagramModels.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/23/15.
//  Copyright © 2015 IT. All rights reserved.
//

import Foundation
import ObjectMapper

class InstagramUser : NSObject, User, Mappable {
    var id: String?
    var name: String?
    var fullName: String?
    var profileImage: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["username"]
        fullName <- map["full_name"]
        profileImage <- map["profile_picture"]
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if object != nil && object as? User != nil {
            return object!.id == self.id
        }
        return false
    }
}


class InstagramComment : NSObject, Comment, Mappable {
    var id: String?
    var text: String?
    var author : User?
    

    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        text <- map["text"]
        
        var nestedAuthor: InstagramUser? = nil
        nestedAuthor <- map["from"]        
        author = nestedAuthor
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if object != nil && object as? Comment != nil {
            return object!.id == self.id
        }
        return false
    }
}


class InstagramMedia : NSObject, Media, Mappable {
    
    var id: String?
    var name: String?
    var type: String?
    var link: String?
    
    var imageLow: String?
    var imageBig: String?
    
    var comments: Array<AnyObject>?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["caption.text"]
        type <- map["type"]
        link <- map["link"]
        imageLow <- map["images.thumbnail.url"]
        imageBig <- map["images.standard_resolution.url"]
        
        var nestedComments : Array<InstagramComment>?
        nestedComments <- map["comments.data"]
        comments = nestedComments
        
        
    }
    
    
    override func isEqual(object: AnyObject?) -> Bool {
        if object != nil && object as? Media != nil {
            return object!.id == self.id
        }
        return false
    }
}


