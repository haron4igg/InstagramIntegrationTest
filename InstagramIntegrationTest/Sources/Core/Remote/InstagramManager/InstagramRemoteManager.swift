//
//  InstagramRemoteManager.swift
//  InstagramIntegrationTest
//
//  Created by Igor Reshetnikov on 10/22/15.
//  Copyright © 2015 IT. All rights reserved.
//


import Foundation
import ObjectMapper



class InstagramRemoteManager: NSObject, RemoteManager, NSURLSessionDelegate {
    
    static let ErrorDomain = "Core.Remote.InstagramRemoteManager"
    static let BaseURL = "https://api.instagram.com/v1/"
    
    static let UsersMethod = "users"
    static let UsersSearchMethod = UsersMethod + "/search"
    static let UsersMediaRecentMethod = "media/recent"
    
    
    
    private let Client_ID = "8e6788b39659410ebff17136f4282a70"
    
    
    private var taskRegistry : [String: NSURLSessionTask] = [:]
    
    func dropTaskIfNeed(method: String, skipLock: Bool = false) {
        if !skipLock {
            objc_sync_enter(taskRegistry)
        }
        
        if let task = taskRegistry[method] {
            if task.state == NSURLSessionTaskState.Running {
                task.cancel()
            }
            taskRegistry[method] = nil
        }
        if !skipLock {
            objc_sync_exit(taskRegistry)
        }
    }
    
    
    func pushTask(method: String, task: NSURLSessionTask) {
        objc_sync_enter(taskRegistry)
        
        dropTaskIfNeed(method, skipLock: true)
        taskRegistry[method] = task
        
        objc_sync_exit(taskRegistry)
    }
    
    
    func sendGetRequest(url: String, var parameters: [String: AnyObject], completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionTask {
        
        parameters["client_id"] = Client_ID
        
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = NSURL(string:"\(url)?\(parameterString)")!
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        
        print("Reuest: \(request)" )

        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue:  nil)
        
        let task = session.dataTaskWithRequest(request, completionHandler:completionHandler)
        task.resume()
        
        return task
    }
    
    
    func callGetMethod<T: InstagramBaseResponse>(method: String, parameters: [String: AnyObject], completionHandler : (T?, NSError?) -> Void ) {
        dropTaskIfNeed(method)
        
        
        let task = sendGetRequest(InstagramRemoteManager.BaseURL+method, parameters: parameters, completionHandler: { (data: NSData?, response: NSURLResponse?, var error: NSError?) -> Void in
            
            
            print("Response: \(response) Error: \(error)" )
            
            self.dropTaskIfNeed(method)
            
            var result : T? = nil
            
            if error == nil && data != nil {
                let bodyString = String(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(bodyString)" )
                result = Mapper<T>().map(bodyString)
                
                if result == nil {
                    error = NSError(domain: InstagramRemoteManager.ErrorDomain, code: RemoteErrorCode.SerrializationFailure.rawValue, userInfo: [NSLocalizedDescriptionKey : "Unable to parse data."])
                } else if (result!.statusCode != 200) {
                    error = NSError(domain: InstagramRemoteManager.ErrorDomain, code: RemoteErrorCode.ServiceError.rawValue, userInfo: [NSLocalizedDescriptionKey : (result!.statusMessage)!])
                    result = nil
                }
            } else if error?.code == NSURLErrorCancelled {
                error = nil
            } else {
                error = NSError(domain: InstagramRemoteManager.ErrorDomain, code: RemoteErrorCode.NoConnection.rawValue, userInfo: ["originalError":error!, NSLocalizedDescriptionKey : "Some connection problem occured."])
            }
            
            completionHandler(result, error)
        })
        pushTask(method, task: task)
    }
    
    
    func searchUsers(searchString: String, completionHandler: (Array<AnyObject>?, NSError?) -> Void) {
        callGetMethod(InstagramRemoteManager.UsersSearchMethod, parameters: ["q": searchString, "count": 20], completionHandler: {
            (userResponce: InstagramSearchUserResponce?, error: NSError?) in
            completionHandler(userResponce != nil ? userResponce!.users : nil, error)
        })
    }

    
    func fetchUserMedia( userID : String, completionHandler: (Array<AnyObject>?, NSError?) -> Void ) {
        let methodUrl = InstagramRemoteManager.UsersMethod + "/\(userID)/" + InstagramRemoteManager.UsersMediaRecentMethod
        
        callGetMethod(methodUrl, parameters: [:], completionHandler: {
            (mediaResponce: InstagramLoadMediaResponce?, error: NSError?) in
            completionHandler(mediaResponce != nil ? mediaResponce!.media : nil, error)
        })
    }

    // NSURLSession Delegate
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        print("Ivalid: \(error)")
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.protectionSpace.host == "api.instagram.com" {
                let credential = NSURLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
            }
        }
    }


}
