//
//  MainViewController.swift
//  StockMarketApp
//
//  Created by Burak Erden on 30.01.2023.
//

import UIKit
import Kingfisher
import SDWebImage
import SDWebImageSVGCoder


class MainViewController: UIViewController {
    
    var viewModel = ViewModel()
    let currencyFormatter = NumberFormatter()

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        getDetailData()
        setupUI()
        setButton()
    }
    
    func getDetailData() {
        viewModel.getCurrencyData(mainTableView: mainTableView, navigationController: navigationController!, navigationItem: navigationItem)
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
        cell.prepareCell(model: currencyData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currencyData = viewModel.currencyData?[indexPath.section] else {return}
        let vc = DetailViewController()
        vc.currencyData = currencyData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }

}
