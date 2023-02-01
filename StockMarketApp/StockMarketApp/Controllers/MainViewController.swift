//
//  MainViewController.swift
//  StockMarketApp
//
//  Created by Burak Erden on 30.01.2023.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    var viewModel = ViewModel()
    let currencyFormatter = NumberFormatter()

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
        setupUI()
        getDetailData()
    }
    
    
    func getDetailData() {
        viewModel.getCurrencyData(mainTableView: mainTableView, navigationController: navigationController!)
    }
    
    func setupUI() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    func setButton() {
        viewModel.setSortButton(mainTableView: mainTableView, sortButton: sortButton)
    }

}

//MARK: - Table View

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.currencyData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MainTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        guard let currencyData = viewModel.currencyData?[indexPath.section] else {return UITableViewCell()}
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        let price = Double(currencyData.price ?? "1.11")
        switch price! {
        case 10.0...:
            currencyFormatter.maximumFractionDigits = 2
            currencyFormatter.minimumFractionDigits = 2
        case 1.0...10.0:
            currencyFormatter.maximumFractionDigits = 3
            currencyFormatter.minimumFractionDigits = 3
        case 0.01...1.0:
            currencyFormatter.maximumFractionDigits = 4
        case 0.00001...0.01:
            currencyFormatter.maximumFractionDigits = 5
        default:
            print("\(currencyData.name ?? "error")")
        }
        
        cell.coinName.text = currencyData.name
        if Double(currencyData.change!)! < 0 {
            cell.coinChange.textColor = .systemRed
            cell.coinChange.text = (currencyData.change ?? "0") + "%"
        } else {
            cell.coinChange.textColor = .systemGreen
            cell.coinChange.text = "+" + (currencyData.change ?? "0") + "%"
        }
        
        cell.coinShortName.text = currencyData.symbol
        cell.coinPrice.text = currencyFormatter.string(from: NSNumber(value: price!))
        cell.coinImage.kf.setImage(with: URL(string: currencyData.iconURL ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    

    
    
}
