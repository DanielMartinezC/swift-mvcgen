//
//  APIManager.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import CryptoSwift
import OneSignal

class APIManager {
    
    // MARK: - Singleton
    static let sharedInstance = APIManager()
    
    lazy var servicesURL = Config.sharedInstance.servicesURL()
    
   let errorMsg = NSLocalizedString("Error connecting to services. Please try again", comment: "")
    
    // MARK: - Endpoints
    
    func login(withParameters parameters: Parameters, completion: @escaping (_ result: VoidResult) -> Void){
        
        Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.login, method: .post, parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: nil).responseObject { (response: DataResponse<UserResponse>) in
                            
                            switch response.result {
                                case .success(_):
                                    if let responseValue = response.result.value {
                                        switch responseValue.result {
                                        case true:
                                            if let user = responseValue.user, let token = responseValue.token {
                                                UserManager.sharedInstance.saveUser(newUser: user, withToken: token)
                                                completion(.success)
                                            } else {
                                                APIHelper.sharedInstance.showErrorMessage(with: responseValue.showMessage, and: "")
                                                completion(.failure)
                                            }
                                            break
                                        case false:
                                            let errorCode = responseValue.errorCode
                                            APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                            APIHelper.sharedInstance.wsResponse(onError: errorCode)
                                            completion(.failure)
                                            break
                                        }
                                    }
                                case .failure(_):
                                    APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                    completion(.failure)
                                    break
                            }
        }
    }

    // If you use Codable instead of mappable:
    //     func login(withParameters parameters: Parameters, completion: @escaping (_ result: VoidResult) -> Void){
        
    //     Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.login, method: .post, parameters: parameters,
    //                       encoding: JSONEncoding.default,
    //                       headers: nil).responseJSON { response in
                            
    //                         switch response.result {
    //                             case .success(_):
    //                                 if let responseValue = response.result.value as? [String:Any]{
    //                                     if responseValue["result"] != nil {
    //                                         let jsonData = try? JSONSerialization.data(withJSONObject: responseValue["result"], options: .prettyPrinted)
    //                                         let reqJSONStr = String(data: jsonData, encoding: .utf8)
    //                                         if let jsonData = reqJSONStr.data(using: .utf8)
    //                                         {
    //                                             let baseResponse = try? JSONDecoder().decode(BaseResponse.self, from: jsonData)
    //                                             switch baseResponse.response {
    //                                             case true:
    //                                                 let jsonData = try? JSONSerialization.data(withJSONObject: responseValue["data"], options: .prettyPrinted)
    //                                                 let reqJSONStr = String(data: jsonData, encoding: .utf8)
    //                                                 if let jsonData = reqJSONStr.data(using: .utf8) {
    //                                                     let userResponse = try? JSONDecoder().decode(User.self, from: jsonData)
    //                                                     UserManager.sharedInstance.saveUser(newUser: userResponse.user, withToken: userResponse.token)
    //                                                     completion(.success)
    //                                                 }else {
    //                                                     APIHelper.sharedInstance.showErrorMessage(with: baseResponse.showMessage, and: "")
    //                                                     completion(.failure)
    //                                                 }
    //                                                 break
    //                                             case false:
    //                                                 let errorCode = responseValue.errorCode
    //                                                 APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
    //                                                 APIHelper.sharedInstance.wsResponse(onError: errorCode)
    //                                                 break
    //                                             }
    //                                         }
    //                                     }
                                        
    //                                 }
    //                             case .failure(_):
    //                                 APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
    //                                 completion(.failure)
    //                                 break
    //                         }
    //     }
    // }
    
    func loginfb(withParameters parameters: Parameters, completion: @escaping (_ result: VoidResult) -> Void){
        
        Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.fbLogin, method: .post, parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: nil).responseObject { (response: DataResponse<UserResponse>) in
                            
                            switch response.result {
                            case .success(_):
                                if let responseValue = response.result.value {
                                    switch responseValue.result {
                                    case true:
                                        if let user = responseValue.user, let token = responseValue.token {
                                            UserManager.sharedInstance.saveUser(newUser: user, withToken: token)
                                            completion(.success)
                                        } else {
                                            APIHelper.sharedInstance.showErrorMessage(with: responseValue.showMessage, and: "")
                                            completion(.failure)
                                        }
                                        break
                                    case false:
                                        let errorCode = responseValue.errorCode
                                        APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                        APIHelper.sharedInstance.wsResponse(onError: errorCode)
                                        completion(.failure)
                                        break
                                    }
                                }
                            case .failure(_):
                                APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                completion(.failure)
                                break
                            }
        }
    }
    
    func logout(completion: @escaping (VoidResult) -> Void) {
        Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.logout, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.sharedInstance.getHeaders()).responseObject { (response: DataResponse<BaseResponse>) in
            
            switch response.result {
            case .success(_):
                
                if let baseResponse = response.result.value {
                    switch baseResponse.result {
                    case true:
                        completion(.success)
                        break
                    case false:
                        let errorCode = baseResponse.errorCode
                        APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                        APIHelper.sharedInstance.wsResponse(onError: errorCode)
                        completion(.failure)
                        break
                    }
                }
            case .failure(_):
                APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                completion(.failure)
                break
            }
        }
    }
    
    func signup(withParameters parameters: Parameters, completion: @escaping (_ result: VoidResult, _ user: User?) -> Void) {
        Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.signup, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<UserSignupResponse>) in
            
            switch response.result {
            case .success(_):
                
                if let baseResponse = response.result.value {
                    switch baseResponse.result {
                    case true:
                        completion(.success,nil)
                        break
                    case false:
                        let errorCode = baseResponse.errorCode
                        APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                        APIHelper.sharedInstance.wsResponse(onError: errorCode)
                        completion(.failure,nil)
                        break
                    }
                }
            case .failure(_):
                APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                completion(.failure,nil)
                break
            }
        }
    }
    
    func forgotPwd(withParameters parameters: Parameters, completion: @escaping (_ result: VoidResult) -> Void) {
        Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.forgotPwd, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<BaseResponse>) in
            
            switch response.result {
            case .success(_):
                
                if let baseResponse = response.result.value {
                    switch baseResponse.result {
                    case true:
                        completion(.success)
                        break
                    case false:
                        let errorCode = baseResponse.errorCode
                        APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                        APIHelper.sharedInstance.wsResponse(onError: errorCode)
                        completion(.failure)
                        break
                    }
                }
            case .failure(_):
                APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                completion(.failure)
                break
            }
        }
    }
    
    // MARK: Notifications
    
    func getNotifications(completion: @escaping(VoidResult, [Notif]) -> Void){
        Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.getNotifications, method: .get, parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: APIHelper.sharedInstance.getHeaders()).responseObject { (response: DataResponse<NotificationResponse>) in
                            switch response.result {
                            case .success(_):
                                
                                if let notificationResponse = response.result.value {
                                    switch notificationResponse.result {
                                    case true:
                                        completion(.success, notificationResponse.data ?? [])
                                    case false:
                                        let errorCode = notificationResponse.errorCode
                                        APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                        APIHelper.sharedInstance.wsResponse(onError: errorCode)
                                        completion(.failure, [])
                                    }
                                }
                                break
                            case .failure(_):
                                APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                completion(.failure, [])
                                break
                            }
        }
    }
    
    func readNotifications(completion: @escaping(VoidResult) -> Void){
        
        var parms: [String : Any] = [:]
        
        // TODO check utc
        parms["date"] = Date().timeIntervalSince1970*1000
        
        Alamofire.request(APIHelper.sharedInstance.servicesURL + Endpoints.readNotifications, method: .post, parameters: parms,
                          encoding: JSONEncoding.default,
                          headers: APIHelper.sharedInstance.getHeaders()).responseObject { (response: DataResponse<BaseResponse>) in
                            switch response.result {
                            case .success(_):
                                
                                if let baseResponse = response.result.value {
                                    switch baseResponse.result {
                                    case true:
                                        completion(.success)
                                    case false:
                                        let errorCode = baseResponse.errorCode
                                        APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                        APIHelper.sharedInstance.wsResponse(onError: errorCode)
                                        completion(.failure)
                                    }
                                }
                                break
                            case .failure(_):
                                APIHelper.sharedInstance.showErrorMessage(with: self.errorMsg, and: "")
                                completion(.failure)
                                break
                            }
        }
    }
}
