//
//  TaskCell.swift
//  Productivity
//
//  Created by Quentin on 20/01/2024.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var CheckMark: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    var buttonPressed : (() -> ()) = {}
    @IBAction func CheckButton(_ sender: Any) {
        buttonPressed()
    }
    
}
