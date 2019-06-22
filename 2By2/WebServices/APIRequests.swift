//
//  APIRequests.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class APIRequests: UIViewController {
    
    
    class func sendRequest(method: HTTPMethod, url: String, params: [String: Any]?, object: UIViewController , completion: @escaping (_ success: [String: JSON], _ error: Bool) -> ()) {
        
        if !NetworkReachabilityManager()!.isReachable {
            
            // NO INTERNET ACCESS
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.noInternet, object: object, actionType: .cancel)
            
        } else {
            // THERE'S INTERNET SEND THE REQUEST PLEASE
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(), nil)
            Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil)
                
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success(let data) :
                        
                        let json = JSON(data)
                        
                        if var returned = json["Data"].dictionary {
                            
                            if let message = json[Constants.status][Constants.Message].string {
                                returned[Constants.Message] = JSON(message)
                            }else {
                                returned[Constants.Message] = JSON("")
                            }
                            
                            if json[Constants.status][Constants.Id].int == 1 {
                                completion(returned, false)
                            }else {
                                completion(returned, true)
                            }
                            
                        } else if var _ = json["Data"].int {
                            
                            if json[Constants.status][Constants.Id].int == 1 {
                                completion([:], false)
                            } else {
                                completion([:], true)
                            }
                            
                        }  else if var _ = json["Data"].bool {
                            
                            if json[Constants.status][Constants.Id].bool == true {
                                completion([:], false)
                            }else {
                                completion([:], true)
                            }
                            
                        }else if var _ = json["Data"].string {
                            if json[Constants.status][Constants.Id].int == 1 {
                                completion(["Data": json["Data"]], false)
                            }else {
                                completion([:], true)
                            }
                        }
                        
                    case .failure(let noData) :
                        print("Error found \(noData)")
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        //Alerts.DisplayActionSheetAlert(title: "", message: "", object: object, actionType: .default)
                    } // END OF THE SWITCH CASE
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    
            } // END OF THE COMPLETION
            
        } // END OF THE NETWORK AVALIABLE CHECK
        
        
    } // END OF THE REQUEST ITSELF    
    
    
    static func uploadImage(toUrl: String, parameters: [String: String], selectedImage: UIImage, completion: @escaping (_ status: Bool, _ data: String?) -> () ) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let imageData = selectedImage.jpegData(compressionQuality: 0.75)
            multipartFormData.append(imageData!, withName: "ImgFile", fileName: "ImgFile", mimeType: "image/*")
            multipartFormData.append(parameters["Id"]!.data(using: .utf8)!, withName: "Id")
            
        }, to: toUrl )
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let json = response.result.value {
                        print(json)
                        if let json = json as? [String: Any] {
                            completion(true, json["Data"] as! String)
                        }
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                //Alerts.DisplayActionSheetAlert(title: "", message: "", object: object, actionType: .default)
                
            }
            
        }
        
    }
    
    
    
    // ARRAY BACK
    
    class func sendRequestArrayBack(method: HTTPMethod, url: String, params: [String: Any]?, object: UIViewController , completion: @escaping (_ success: JSON?, _ error: Bool) -> ()) {
        
        if !NetworkReachabilityManager()!.isReachable {
            
            // NO INTERNET ACCESS
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.noInternet, object: object, actionType: .cancel)
            
        } else {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(), nil)
            // THERE'S INTERNET SEND THE REQUEST PLEASE
            Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success(let data) :
                        let json = JSON(data)
                        
                        if let status = json[Constants.status].int, status == 1 {
                           completion(json, true)
                        }else {
                           completion(json, false)
                        }
                        
                    case .failure(let noData) :
                        print("Error found \(noData)")
                    } // END OF THE SWITCH CASE
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            } // END OF THE COMPLETION
            
        } // END OF THE NETWORK AVALIABLE CHECK
        
        
    } // END OF THE REQUEST ITSELF
    
    
    
    class func sendJSONRequest(method: HTTPMethod, url: String, params: [String: Any]?, object: UIViewController , completion: @escaping (_ success: JSON?, _ error: Bool) -> ()) {
        
        if !NetworkReachabilityManager()!.isReachable {
            
            // NO INTERNET ACCESS
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.noInternet, object: object, actionType: .cancel)
            
        } else {
            
            // THERE'S INTERNET SEND THE REQUEST PLEASE
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(), nil)
            Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success(let data) :
                        let json = JSON(data)
                        completion(json, false)
                    case .failure(let noData) :
                        print(noData)
                        completion(nil, true)
                    } // END OF THE SWITCH CASE
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            } // END OF THE COMPLETION
            
        } // END OF THE NETWORK AVALIABLE CHECK
        
        
    } // END OF THE REQUEST ITSELF
    
    
    // PAYMENT REQUEST
    
    class func sendPaymentRequest(method: HTTPMethod, url: String, params: [String: Any]?, object: UIViewController , completion: @escaping (_ success: String?, _ error: Bool) -> ()) {
        
        if !NetworkReachabilityManager()!.isReachable {
            
            // NO INTERNET ACCESS
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.noInternet, object: object, actionType: .cancel)
            
        } else {
            
            // THERE'S INTERNET SEND THE REQUEST PLEASE
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(), nil)
            Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success(let data) :
                        let json = JSON(data)
                        
                        if let token = json["Data"].string {
                            
                            if json[Constants.status][Constants.Id].int == 1 {
                                completion(token, false)
                            }else {
                                completion(nil, true)
                            }
                            
                        }
                        
                    case .failure(let noData) :
                        print("Error found \(noData)")
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        //Alerts.DisplayActionSheetAlert(title: "", message: "", object: object, actionType: .default)
                    } // END OF THE SWITCH CASE
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            } // END OF THE COMPLETION
            
        } // END OF THE NETWORK AVALIABLE CHECK
        
        
    } // END OF THE REQUEST ITSELF
    
    
    class func sendPaymentBackRequest(method: HTTPMethod, url: String, params: [String: Any]?, object: UIViewController , completion: @escaping (_ success: JSON?, _ error: Bool) -> ()) {
        
        if !NetworkReachabilityManager()!.isReachable {
            
            // NO INTERNET ACCESS
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.noInternet, object: object, actionType: .cancel)
            
        } else {
            
            // THERE'S INTERNET SEND THE REQUEST PLEASE
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(), nil)
            Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success(let data) :
                        let json = JSON(data)
                        completion(json, false)
                    case .failure(let noData) :
                        completion(nil, true)
                        print("Error found \(noData)")
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        //Alerts.DisplayActionSheetAlert(title: "", message: "", object: object, actionType: .default)
                    } // END OF THE SWITCH CASE
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            } // END OF THE COMPLETION
            
        } // END OF THE NETWORK AVALIABLE CHECK
        
        
    } // END OF THE REQUEST ITSELF
    
    
    
    
    class func sendPhoneRequest(method: HTTPMethod, url: String, params: [String: Any]?, object: UIViewController , completion: @escaping (_ success: [String: JSON], _ error: Bool) -> ()) {
        
        if !NetworkReachabilityManager()!.isReachable {
            
            // NO INTERNET ACCESS
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.noInternet, object: object, actionType: .cancel)
            
        } else {
            
            // THERE'S INTERNET SEND THE REQUEST PLEASE
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(), nil)
            Alamofire.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success(let data) :
                        let json = JSON(data)
                        
                        if let returned = json["Data"].bool, returned == true  {
                            
                            if json[Constants.status][Constants.Id].int == 0 {
                                completion([:], true)
                            }else {
                                completion([:], false)
                            }
                        }
                        
                    case .failure(let noData) :
                        print("Error found \(noData)")
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        //Alerts.DisplayActionSheetAlert(title: "", message: "", object: object, actionType: .default)
                    } // END OF THE SWITCH CASE
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            } // END OF THE COMPLETION
            
        } // END OF THE NETWORK AVALIABLE CHECK
        
        
    } // END OF THE REQUEST ITSELF
    
    
}
