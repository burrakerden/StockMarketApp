//
//  MainTableViewCell.swift
//  StockMarketApp
//
//  Created by Burak Erden on 30.01.2023.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinShortName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinChange: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
