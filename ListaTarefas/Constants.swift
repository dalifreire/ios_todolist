//
//  Constants.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 06/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let kHttpEndpoint = "http://localhost:8000/api"
    static let TOKEN_LOGADO = "TOKEN_LOGADO"
}

class Utils {
    
    static func showMessage(_ view:UIViewController, _ msg:String) {
        
        let myalert = UIAlertController(title: "Mensagem", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            myalert.dismiss(animated: true)
        })
        view.present(myalert, animated: true)
        print("Mensagem: \(msg)")
    }
    
    static func getUsuarioLogado() -> String {
        return UserDefaults().object(forKey: Constants.TOKEN_LOGADO) as! String
    }
    
    static func convertToString(_ dt:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formatter.string(from: dt)
    }
    
    static func convertToString(_ pattern:String, _ dt:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: dt)
    }
    
    static func convertToString(_ pattern:String, _ dt:Date?) -> String {
        if dt != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = pattern
            return formatter.string(from: dt!)
        }
        return ""
    }
    
    static func convertToDate(_ dt:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dt)!
    }
    
}

enum I18n {
    static let msgLoginInvalido = I18n.tr("Localizable", "login.invalido")
    static let msgSenhaInvalida = I18n.tr("Localizable", "senha.invalida")
    static let msgLoginSenhaInvalidos = I18n.tr("Localizable", "login.ou.senha.invalidos")
    static let msgTituloInvalido = I18n.tr("Localizable", "titulo.invalido")
    static let msgDescricaoInvalida = I18n.tr("Localizable", "descricao.invalida")
    static let msgTarefaCadastradaComSucesso = I18n.tr("Localizable", "tarefa.cadastrada.com.sucesso")
    static let msgTarefaAlteradaComSucesso = I18n.tr("Localizable", "tarefa.alterada.com.sucesso")
    static let msgTarefaRemovidaComSucesso = I18n.tr("Localizable", "tarefa.removida.com.sucesso")
}

extension I18n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}
