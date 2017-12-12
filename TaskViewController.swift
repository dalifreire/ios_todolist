//
//  TaskViewController.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 08/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//

import UIKit
import RealmSwift

class TaskViewController: UIViewController {

    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtDescricao: UITextView!
    @IBOutlet weak var flgCompleto: UISwitch!
    @IBOutlet weak var dtExpiracao: UIDatePicker!
    
    let tarefaSelecionada:Tarefa = Tarefa()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.txtTitulo.text = self.tarefaSelecionada.title
        self.txtDescricao.text = self.tarefaSelecionada.text
        self.flgCompleto.isOn = self.tarefaSelecionada.isComplete
        if (self.tarefaSelecionada.expirationDate != nil) {
            self.dtExpiracao.date = Utils.convertToDate(self.tarefaSelecionada.expirationDate!)
        }
    }
    
    
    @IBAction func saveTask(_ sender: Any) {
        if validateFields() {
            
            tarefaSelecionada.title = txtTitulo.text
            tarefaSelecionada.text = txtDescricao.text
            tarefaSelecionada.isComplete = flgCompleto.isOn
            tarefaSelecionada.expirationDate = Utils.convertToString("yyyy-MM-dd", dtExpiracao.date)
            if tarefaSelecionada.id == "" || tarefaSelecionada.id == nil {
                
                RESTService().createTask(title: self.tarefaSelecionada.title!, descriptionTask: self.tarefaSelecionada.text!, expirationTask: Utils.convertToString("yyyy-MM-dd", self.dtExpiracao.date), isComplete: self.tarefaSelecionada.isComplete , onSuccess: { response in
                    
                    let t:TaskItem = (response?.body)!
                    self.tarefaSelecionada.id = t.id
                    
                }, onError: { _ in
                    
                    //Utils.showMessage(self, "Falha ao criar tarefa")
                    
                }, always: {
                    Repository.save(self.tarefaSelecionada)
                    Utils.showMessage(self, I18n.msgTarefaCadastradaComSucesso)
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                
                RESTService().updateTask(id: self.tarefaSelecionada.id!, title: self.tarefaSelecionada.title!, descriptionTask: self.tarefaSelecionada.text!, expirationTask: Utils.convertToString("yyyy-MM-dd", self.dtExpiracao.date), isComplete: self.tarefaSelecionada.isComplete , onSuccess: { response in
                    
                    let t:TaskItem = (response?.body)!
                    self.tarefaSelecionada.id = t.id
                    
                }, onError: { _ in
                    
                    //Utils.showMessage(self, "Falha ao alterar tarefa")
                    
                }, always: {
                    Repository.update(self.tarefaSelecionada)
                    Utils.showMessage(self, I18n.msgTarefaAlteradaComSucesso)
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
        }
    }
    
    func validateFields() -> Bool {
        if txtTitulo.text == "" {
            Utils.showMessage(self, I18n.msgTituloInvalido)
            return false
        }
        if txtDescricao.text == "" {
            Utils.showMessage(self, I18n.msgDescricaoInvalida)
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
