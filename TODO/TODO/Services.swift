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
let headers = [
    "Authorization": "Basic a2lkX0h5NUI1WUZleDo3NzRlN2JkYzZiNTc0MTAzOWM0NzkxYjY4ZTIxOWVkYw==",
    "Content-Type": "application/x-www-form-urlencoded"
]

struct Services {
    
    static func tasks(completionHandler:CompletionHandler) {
        
        let urlString = kBaseUrl + kAppIDKenvey + ktasks
        let headers = [
            "Authorization": "Basic a2lkX0h5NUI1WUZleDo3NzRlN2JkYzZiNTc0MTAzOWM0NzkxYjY4ZTIxOWVkYw==",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        
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
    
}
