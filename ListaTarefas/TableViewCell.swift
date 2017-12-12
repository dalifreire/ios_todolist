//
//  TableViewCell.swift
//  ListaTarefas
//
//  Created by ALOC SP08156 on 07/12/2017.
//  Copyright © 2017 ALOC SP08156. All rights reserved.
//
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgOval: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

