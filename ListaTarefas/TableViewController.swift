//
//  TableViewCell.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 07/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//
import UIKit

class TableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var itemSelected: TaskItem?
    var task: Task?
    var searchController: UISearchController!
    public var listTask = [TaskItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTasks()
    }
    
    func listTasks() {
        
        RESTService().listTasks(onSuccess: { response in
            self.task = response?.body
            self.listTask = (self.task?.results)!
        }, onError: { _ in
            
            self.task = Task()
            self.task?.results = [TaskItem]()
            let dbTasks = Repository.findAll()
            for dbTask in dbTasks {
                
                let ti = TaskItem()
                ti.id = dbTask.id
                ti.title = dbTask.title
                ti.descriptionTask = dbTask.text
                ti.isComplete = dbTask.isComplete
                ti.expirationDate = dbTask.expirationDate
                self.listTask.append(ti)
                self.task?.results?.append(ti)
            }
            self.task?.count = self.listTask.count
            
        }, always: {
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.itemSelected = self.task?.results![indexPath.row]
        self.performSegue(withIdentifier: "editTask",  sender: self.itemSelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
        navigationItem.titleView?.tintColor = UIColor.white
        
        
        if segue.identifier == "editTask"{
            
            let page: TaskViewController = segue.destination as! TaskViewController
            page.tarefaSelecionada.id = self.itemSelected?.id
            page.tarefaSelecionada.title = self.itemSelected?.title
            page.tarefaSelecionada.text = self.itemSelected?.descriptionTask
            page.tarefaSelecionada.isComplete = (self.itemSelected?.isComplete)!
            page.tarefaSelecionada.expirationDate = self.itemSelected?.expirationDate
            
         }
        
    }
    
    
    @IBAction func btnSearch(_ sender: UIBarButtonItem) {
        self.searchController = searchControllerWith(searchResultsController: nil)
        self.navItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        self.btnSearch.tintColor = UIColor.clear
        self.btnSearch.isEnabled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
        self.btnSearch.tintColor = UIColor.white
        self.btnSearch.isEnabled = true
        self.navItem.titleView = nil
    }
    
    func cancelBarButtonItemClicked() {
        self.searchBarCancelButtonClicked(self.searchController.searchBar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listTasks()
    }
    
    func searchControllerWith(searchResultsController: UIViewController?) -> UISearchController {
        
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.barTintColor = UIColor.white
        
        return searchController
    }
    
    func delete(_ tableView: UITableView, id: String, indexPath: IndexPath) {
        delete(id)
        self.task?.results?.remove(at: indexPath.row)
        self.task?.count = self.task?.results?.count
        tableView.deleteRows(at: [indexPath], with: .fade)
        Utils.showMessage(self,I18n.msgTarefaRemovidaComSucesso)
    }
    
    func delete(_ id:String) {
        RESTService().deleteTask(id: id, onSuccess: { response in
            
            //Utils.showMessage(self, "Tarefa removida com sucesso")
            
        }, onError: { _ in
            
            //Utils.showMessage(self, "Falha ao remover tarefa")
            
        }, always: {
            
            Repository.delete(id)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (task?.results?.count ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(130)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if task != nil && task?.results != nil {
            cell.imgOval.isHidden = (task?.results![indexPath.row].isComplete)!
            cell.lblTitulo.text = (task?.results![indexPath.row].title)!
            cell.lblDetails.text = (task?.results![indexPath.row].descriptionTask)!
            cell.lblHora.text = (task?.results![indexPath.row].expirationDate)?.split(separator: "-")[2].description
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(tableView, id: (task?.results![indexPath.row].id)!, indexPath: indexPath)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            task?.results = listTask
            self.tableView.reloadData()
        } else {
            
            let filtered = listTask.filter{
                let textToSearch = "\(String(describing: $0.title?.uppercased())) \(String(describing: $0.descriptionTask?.uppercased()))"
                return textToSearch.range(of: searchText.uppercased()) != nil
            }
            task?.results = filtered
        }
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
}

extension String {
    func convertToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if self != nil {
            return formatter.date(from: self)!
        } else  {
            return Date()
        }
        
    }
    
}


extension Date {
    func convertToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        if self != nil {
            return formatter.string(from: self)
        } else  {
            return ""
        }
        
    }
    
}

