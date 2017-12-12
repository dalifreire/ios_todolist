//
//  PostRoute.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 06/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import Foundation
import EasyRest

enum RESTRoute: Routable {
    
    case login(username: String, password:String),
         listTasks(),
         deleteTask(id:String),
         updateTask(id:String, title:String, descriptionTask:String, expirationTask:String, isComplete:Bool),
         createTask(title:String, descriptionTask:String, expirationTask:String, isComplete:Bool)
    
    var rule: Rule {
        switch self {
        case let .login(username, password):
            return Rule(method: .post, path: "/oauth/token/", isAuthenticable: true, parameters: [.query:
                [
                    "client_id": "0dPMuGirPRXawSu2lblvwg6NR5GZXZVqVnLDr1bD",
                    "client_secret": "15HSw6m8bDuQngF5OTy1WnDqk2gxui9vK5ZOlpR4SDtIcbhfGmGGMuiH11aiGmcnFkEMAzd4RUeVNWzkiBsXk6JWE7mSnYAVYr2U03qQFsDbusr2Z2Rk40BNlAPxi2j6",
                    "grant_type": "password",
                    "username": username,
                    "password": password
                ]
            ])
            
        case .listTasks():
            return Rule(method: .get,  path: "/v1/tasks/", isAuthenticable: true, parameters: [:])
            
        case let .deleteTask(id):
            return Rule(method: .delete,  path: "/v1/tasks/" + id + "/", isAuthenticable: true, parameters: [:])
            
        case .updateTask(let id, let title, let descriptionTask, let expirationTask, let isComplete):
            return Rule(method: .put, path: "/v1/tasks/" + id + "/",  isAuthenticable: true, parameters: [.body:
                [
                    "expiration_date": expirationTask,
                    "title": title,
                    "description": descriptionTask,
                    "is_complete": isComplete
                ]
            ])
        case .createTask(let title, let descriptionTask, let expirationTask, let isComplete):
            return Rule(method: .post, path: "/v1/tasks/",  isAuthenticable: true, parameters: [.body:
                [
                    "expiration_date": expirationTask,
                    "title": title,
                    "description": descriptionTask,
                    "is_complete": isComplete
                ]
            ])
        }
    }
    
}
