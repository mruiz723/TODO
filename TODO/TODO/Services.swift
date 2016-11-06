//
//  Services.swift
//  TODO
//
//  Created by Luis F Ruiz Arroyave on 11/3/16.
//  Copyright © 2016 UdeM. All rights reserved.
//

import Foundation
import Alamofire


typealias CompletionHandler = (success:Bool, response:[String: AnyObject]) -> ()


struct Services {
    
    static func tasks(completionHandler:CompletionHandler) {
        
        let urlString = kBaseUrl + kAppIDKenvey + ktasks
        
        Alamofire.request(.GET, urlString, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                         completionHandler(success:true, response: ["response": value])
                    }
                    
                case .Failure(let error):
                    completionHandler(success:false, response: ["error": error])
                }
        }
    }
    
    static func save(task:[String: AnyObject], completionHandler:CompletionHandler) {
        
        let urlString = kBaseUrl + kAppIDKenvey + ktasks
        
        Alamofire.request(.POST, urlString, parameters: task, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        completionHandler(success:true, response: ["response": value])
                    }
                    
                case .Failure(let error):
                    completionHandler(success:false, response: ["error": error])
                }
        }
    }
    
    static func update(task:[String: AnyObject], completionHandler:CompletionHandler) {
        
        let urlString = kBaseUrl + kAppIDKenvey + ktasks + "\(task["_id"])"
        
        Alamofire.request(.PUT, urlString, parameters: task, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        completionHandler(success:true, response: ["response": value])
                    }
                    
                case .Failure(let error):
                    completionHandler(success:false, response: ["error": error])
                }
        }
    }

    static func delete(task:[String: AnyObject], completionHandler:CompletionHandler) {
        
        let urlString = kBaseUrl + kAppIDKenvey + ktasks + "\((task["_id"])!)"
        
        Alamofire.request(.DELETE, urlString, parameters: task, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        completionHandler(success:true, response: ["response": value])
                    }
                    
                case .Failure(let error):
                    completionHandler(success:false, response: ["error": error])
                }
        }
    }
}
