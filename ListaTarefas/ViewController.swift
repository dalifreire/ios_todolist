//
//  ViewController.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 06/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var textLogin: UITextField!
    @IBOutlet weak var textSenha: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var token:Token?
    var loginRealizado:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = UserDefaults().object(forKey: Constants.TOKEN_LOGADO)  {
            print("Usario ja logado: \(token)")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "navLogin", sender: self)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLogin(_ sender: Any) {
        if validarCamposLogin() {
            
            self.loginRealizado = false
            RESTService().login(username: self.textLogin.text!, password: self.textSenha.text!, onSuccess: { response in
                self.token = response?.body
                
                print("Login do usuario '\(String(describing: self.textLogin.text))' realizado com sucesso")
                print("Token: \(String(describing: self.token))")
                UserDefaults.standard.set(self.token?.accessToken, forKey: Constants.TOKEN_LOGADO)
                UserDefaults.standard.synchronize()
                self.loginRealizado = true
                
                self.performSegue(withIdentifier: "navLogin", sender: self.token)
                
            }, onError: { _ in
                
                Utils.showMessage(self, I18n.msgLoginSenhaInvalidos)
                
            }, always: {
                //hide loading
            })
            
        }
    }
    
    func validarCamposLogin() -> Bool {
        if textLogin.text == "" {
            Utils.showMessage(self, I18n.msgLoginInvalido)
            return false
        }
        if textSenha.text ==  "" {
            Utils.showMessage(self, I18n.msgSenhaInvalida)
            return false
        }
        return true
    }
    
}

