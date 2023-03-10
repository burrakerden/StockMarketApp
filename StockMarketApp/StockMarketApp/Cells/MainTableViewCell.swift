//
//  MainTableViewCell.swift
//  StockMarketApp
//
//  Created by Burak Erden on 30.01.2023.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinShortName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinChange: UILabel!
    
    var viewModel = ViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell(model: Coin) {
        guard let price = Double(model.price ?? "1.11") else {return}
        coinName.text = model.name
        coinShortName.text = model.symbol
        coinPrice.text = viewModel.priceFormatter(price: price, max10To1000: 2, min10To1000: 2, max1To10: 3, min1To10: 3, max001To1: 4, max000001To001: 5)
        viewModel.changeColor(model: model, change: coinChange)

        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
        if let url = model.iconURL {
            coinImage.sd_setImage(with: URL(string: url))
        }
    }
    
}
