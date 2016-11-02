//
//  MainItemTableViewCell.swift
//  SwiftLearning
//
//  Created by qky on 16/11/1.
//  Copyright © 2016年 boostfield. All rights reserved.
//

import UIKit

class MainItemTableViewCell: UITableViewCell, CellInterface {
    typealias  DataType =  String
    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(data: String) {
        labelTitle.text = data
    }
    
}
