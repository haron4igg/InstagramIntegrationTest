//
//  InstagramResponseModels.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/23/15.
//  Copyright © 2015 IT. All rights reserved.
//

import Foundation
import ObjectMapper

class InstagramBaseResponse : NSObject, Mappable {
    var statusCode: Int?
    var statusMessage: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        statusCode <- map["meta.code"]
        statusMessage <- map["meta.error_message"]
    }
}


class InstagramSearchUserResponce : InstagramBaseResponse {
    
    var users: Array<InstagramUser>?
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        users <- map["data"]
    }
}


class InstagramLoadMediaResponce : InstagramBaseResponse {
    
    var media: Array<InstagramMedia>?
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        media <- map["data"]
    }
}
