//
//  AppDelegate.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 06/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        synchronize();
        return true
    }
    
    func synchronize() {
        
        RESTService().listTasks(onSuccess: { response in
            
            let listTask = (response?.body?.results)!
            let dbTasks = Repository.findAll()
            
            var deleteRest = [String]()
            var updateRest = [Tarefa]()
            var insertRest = [Tarefa]()
            
            // verifica os itens a serem removidos/atualizados no backend
            for restTask in listTask {
                var existeNaBase = false
                for dbTask in dbTasks {
                    if restTask.id == dbTask.id {
                        existeNaBase = true
                        
                        let t = Tarefa()
                        t.id = dbTask.id
                        t.title = dbTask.title
                        t.text = dbTask.text
                        t.isComplete = dbTask.isComplete
                        t.expirationDate = dbTask.expirationDate
                        updateRest.append(t)
                        break
                    }
                }
                if !existeNaBase {
                    deleteRest.append(restTask.id!)
                }
            }
            for dbTask in dbTasks {
                var existeNoBackend = false
                for restTask in listTask {
                    if restTask.id == dbTask.id {
                        existeNoBackend = true
                        break
                    }
                }
                if !existeNoBackend {
                    let t = Tarefa()
                    t.id = dbTask.id
                    t.title = dbTask.title
                    t.text = dbTask.text
                    t.isComplete = dbTask.isComplete
                    t.expirationDate = dbTask.expirationDate
                    insertRest.append(t)
                }
            }
            
            // remove os itens do backend
            self.deleteBackend(deleteRest)
            
            // atualiza os itens no backend
            self.updateBackend(updateRest)
            
            // insere os itens no backend
            self.insertBackend(insertRest)
            
        }, onError: { _ in
            
        }, always: {
            
        })
        
    }
    
    func deleteBackend(_ deleteItens:[String]) {
        for i in deleteItens {
            
            RESTService().deleteTask(id: i, onSuccess: { response in
                
            }, onError: { _ in
                
            }, always: {
                
            })
            
        }
    }
    
    func updateBackend(_ updateItens:[Tarefa]) {
        for i in updateItens {
            
            RESTService().updateTask(id: i.id!, title: i.title!, descriptionTask: i.text!, expirationTask: i.expirationDate!, isComplete: i.isComplete , onSuccess: { response in
                
            }, onError: { _ in
                
            }, always: {
                
            })
        }
    }
    
    func insertBackend(_ insertItens:[Tarefa]) {
        for i in insertItens {
            
            RESTService().createTask(title: i.title!, descriptionTask: i.text!, expirationTask: i.expirationDate!, isComplete: i.isComplete , onSuccess: { response in
                
                let task:TaskItem = (response?.body)!
                let tarefa:Tarefa = Tarefa()
                tarefa.id = task.id
                tarefa.title = task.title
                tarefa.text = task.descriptionTask
                tarefa.isComplete = task.isComplete
                tarefa.expirationDate = task.expirationDate
                
                Repository.delete(i.id!)
                Repository.save(tarefa)
                
            }, onError: { _ in
                
            }, always: {
                
            })
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

