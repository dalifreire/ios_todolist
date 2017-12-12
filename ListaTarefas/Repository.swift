//
//  Repository.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 08/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import Foundation
import RealmSwift

class Repository {
    
    static func save(_ t:Tarefa) {
        if t.id == "" || t.id == nil {
            t.id = NSUUID().uuidString
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(t)
        }
    }
    
    static func update(_ t:Tarefa) {
        let item = load(t.id!)
        if item != nil {
            let realm = try! Realm()
            try! realm.write {
                item!.expirationDate = t.expirationDate
                item!.title = t.title
                item!.text = t.text
                item!.isComplete = t.isComplete
                item!.owner = t.owner
            }
        } else {
            Repository.save(t)
        }
    }
    
    static func clear() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    static func delete(_ id:String) {
        let item = load(id)
        if item != nil {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(item!)
            }
        }
    }
    
    static func load(_ id:String) -> Tarefa? {
        let realm = try! Realm()
        let pred = NSPredicate(format: "id == %@", id)
        let item = realm.objects(Tarefa.self).filter(pred).first
        return item
    }
    
    static func findAll() -> Results<Tarefa> {
        let realm = try! Realm()
        return realm.objects(Tarefa.self)
    }
    
}
