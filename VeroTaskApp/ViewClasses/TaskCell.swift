//
//  TaskCell.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 28/05/24.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var lblTask:UILabel?
    @IBOutlet weak var lblTitle : UILabel?
    @IBOutlet weak var lblDesc : UILabel?
    @IBOutlet weak var colorView : UIView?
    @IBOutlet weak var colorFillView : UIView?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
