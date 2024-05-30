//
//  APIManagerClass.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 28/05/24.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManagerClass{    
    
    static func get_Token_Data(information: [String : Any], completion:@escaping (String?) -> Void){
        let headers: HTTPHeaders = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]
        
        AF.request(NetWorkingConstants.loginURL, method: .post, parameters: information, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("Json response : \(json)")
                let access_token = json["oauth"]["access_token"].stringValue
                completion(access_token)
            case .failure(let error):
                
                if  error.localizedDescription == "The Internet connection appears to be offline."
                {
                    print("Please check your internet : \(error)")
                }else{
                    print("Please check this error : \(error)")
                }
                completion("")
            }
        }
    }
    
    static func get_Task_Data(token: String?, completion: @escaping ([VeroModelClass]?) -> Void) {
        guard let token = token, !token.isEmpty else {
            print("Invalid or missing token.")
            completion(nil)
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(NetWorkingConstants.resourcesURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON response: \(json)")
                var jsonData = [VeroModelClass]()
                for (_, subJson) in json {
                    let data = VeroModelClass(json: subJson)
                    jsonData.append(data)
                }
                completion(jsonData)
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
}



