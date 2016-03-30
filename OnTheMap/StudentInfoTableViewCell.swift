//
//  StudentInfoTableViewCell.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/30/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit

class StudentInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentUrl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
