//
//  PostService.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 06/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import Foundation
import EasyRest

class RESTService: Service<RESTRoute> {
    
    override var base: String { return Constants.kHttpEndpoint }
    
    override var interceptors: [Interceptor]? {
        get {
            return [AuthInterceptor()]
        }
    }
    
    func login(username:String, password:String, onSuccess: @escaping (Response<Token>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.login(username: username, password: password), type: Token.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func listTasks(onSuccess: @escaping (Response<Task>?) -> Void,
                 onError: @escaping (RestError?) -> Void,
                 always: @escaping () -> Void) {
        try! call(.listTasks(), type: Task.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func deleteTask(id: String,onSuccess: @escaping (Response<Task>?) -> Void,
                onError: @escaping (RestError?) -> Void,
                always: @escaping () -> Void) {
        try! call(.deleteTask(id: id), type: Task.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func updateTask(id: String,title:String, descriptionTask:String, expirationTask:String, isComplete:Bool, onSuccess: @escaping (Response<TaskItem>?) -> Void,
        onError: @escaping (RestError?) -> Void,
        always: @escaping () -> Void) {
        
        try! call(.updateTask(id:id, title:title, descriptionTask:descriptionTask, expirationTask:expirationTask, isComplete:isComplete), type: TaskItem.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func createTask(title:String, descriptionTask:String, expirationTask:String, isComplete:Bool, onSuccess: @escaping (Response<TaskItem>?) -> Void,
                    onError: @escaping (RestError?) -> Void,
                    always: @escaping () -> Void) {
        
        try! call(.createTask(title:title, descriptionTask:descriptionTask, expirationTask:expirationTask, isComplete:isComplete), type: TaskItem.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
}

