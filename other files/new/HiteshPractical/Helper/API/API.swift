//
//  API.swift
//  SwiftyJson4.0
//
//  Created by Hitesh.surani on 11/10/17.
//  Copyright © 2017 Brainvire. All rights reserved.

//Alamofire Help Guide: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-validation


import UIKit
import Alamofire
import Reachability
//API
//HKS
//MARK: BASE URL
let strBaseUrl = "https://api.themoviedb.org/3/"
let imagebaseURL = "https://image.tmdb.org/t/p/w500"
let API_Key = "14bc774791d9d20b3a138bb6e26e2579"

//MARK: API METHOD NAME
struct APIConstant {
    static let parseErrorDomain = "ParseError"
    static let parseErrorMessage = "Unable to parse data"
    static let parseErrorCode = Int(UInt8.max)
}

struct APIName {
    static let DiscoverMovie = "discover/movie"
    static let MovieDetails = "movie/"
}

class API: NSObject {
    
    let reachability = Reachability()!
    
    var isInternetAvailable = true
    var isReacheblityIntilise = false
    static let sharedInstance = API()
    
    private override init() {
        
    }
    
    //MARK: - API calling with Model Class response
    func apiRequestWithModalClass<T:Decodable>(modelClass:T.Type?, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (AnyObject) -> Void, FailureBlock:@escaping (Error)-> Void, NoInternetBlock:@escaping (Bool)-> Void) {
        
        if !isReacheblityIntilise{
            reachability.whenReachable = { reachability in
                self.isInternetAvailable = true
            }
            reachability.whenUnreachable = { _ in
                self.isInternetAvailable = false
            }
            
            do {
                try reachability.startNotifier()
                isReacheblityIntilise = true
            } catch {
                print("Unable to start notifier")
            }
        }
        
        
        if self.isInternetAvailable{
            let url = strBaseUrl + apiName
            print("API URL:  \(url)")
            Alamofire.request(url, method: requestType, parameters: paramValues, encoding: URLEncoding.httpBody, headers: headersValues).response { (response) in
                
                if((response.error) != nil){
                    FailureBlock(response.error!)
                }
                else{
                    guard let data = response.data else {
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        return
                    }
                    
                    do {
                        let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                        print(objModalClass)
                        SuccessBlock(objModalClass as AnyObject)
                    } catch let error{ //If model class parsing fail
                        print(error.localizedDescription)
                        if(response.error == nil){
                            FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                        }
                        else{
                            print(error.localizedDescription)
                            FailureBlock(response.error!)
                        }
                    }
                }
            }
        }else{
            NoInternetBlock(false)
        }
    }
    
    
    //MARK: - Supporting Methods
    fileprivate func handleParseError(_ data: Data) -> Error{
        let error = NSError(domain:APIConstant.parseErrorDomain, code:APIConstant.parseErrorCode, userInfo:[ NSLocalizedDescriptionKey: APIConstant.parseErrorMessage])
        print(error.localizedDescription)
        do { //To print response if parsing fail
            let response  = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(response)
        }catch{}
        
        return error
    }
}



