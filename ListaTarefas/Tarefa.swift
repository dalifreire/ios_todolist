//
//  Tarefa.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 08/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import Foundation
import RealmSwift

class Tarefa:Object {
    
    @objc dynamic var id:String?
    @objc dynamic var expirationDate:String?
    @objc dynamic var title:String?
    @objc dynamic var text:String?
    @objc dynamic var isComplete:Bool = false
    @objc dynamic var owner:String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /*{
     "id":"a737d87d-847c-40da-b720-369421dd82f1",
     "expiration_date":"2017-12-08",
     "title":"Comprar pão",
     "description":"Descrição da tarefa",
     "is_complete":false,
     "owner":"ff01ea63-062b-4e9c-9933-0f200d127ce1"
     }*/
    
}
