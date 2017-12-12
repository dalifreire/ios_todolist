//
//  AuthInterceptor.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 07/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import Foundation
import EasyRest
import Alamofire
import Genome

class AuthInterceptor: Interceptor {
    
    required init() {}
    
    func requestInterceptor<T: NodeInitializable>(_ api: API<T>) {
        if let token = UserDefaults().object(forKey: Constants.TOKEN_LOGADO)  {
            api.headers["Authorization"] = "Bearer \(token)"
        }
    }
    
    func responseInterceptor<T>(_ api: API<T>, response: DataResponse<Any>) where T : NodeInitializable {
        
    }
    
    
}

