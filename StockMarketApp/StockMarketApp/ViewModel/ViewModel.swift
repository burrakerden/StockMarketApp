//
//  ViewModel.swift
//  StockMarketApp
//
//  Created by Burak Erden on 31.01.2023.
//

import Foundation
import UIKit

    

class ViewModel {
        
    var currencyData: [Coin]?
    let currencyFormatter = NumberFormatter()
    
    //MARK: - Fetch data
    
    func getCurrencyData(mainTableView: UITableView, navigationController: UINavigationController, navigationItem: UINavigationItem) {
        Service().getCurrencyData() { result in
            guard let result1 = result?.data?.coins else {return}
            self.currencyData = result1
            self.setupUI(mainTableView: mainTableView, navigationController: navigationController, navigationItem: navigationItem)
        } onError: { error in
            print(error)
        }
    }
    
    //MARK: - Config

    func setupUI(mainTableView: UITableView, navigationController: UINavigationController, navigationItem: UINavigationItem) {
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        mainTableView.sectionHeaderHeight = 0
        mainTableView.reloadData()
        navigationItem.backButtonTitle = " "
        navigationController.navigationBar.tintColor = .black
    }
    
    //MARK: - Sorting
    
    func setSortButton(mainTableView: UITableView, sortButton: UIButton) {
        let sortByMarketCap = {(action: UIAction) in
            self.sortByMarketCap(mainTableView: mainTableView)}
        
        let sortByPrice = {(action: UIAction) in
            self.sortByPrice(mainTableView: mainTableView)}
        
        let sortBy24hVolume = {(action: UIAction) in
            self.sortBy24hVolume(mainTableView: mainTableView)}
        
        let sortByChange = {(action: UIAction) in
            self.sortByChange(mainTableView: mainTableView)}
        
        let sortByListedAt = {(action: UIAction) in
            self.sortByListedAt(mainTableView: mainTableView)}
        
        sortButton.menu = UIMenu(children : [
            UIAction(title: "Market Cap", state: .on, handler: sortByMarketCap),
            UIAction(title: "Price", handler: sortByPrice),
            UIAction(title: "24h Vol", handler: sortBy24hVolume),
            UIAction(title: "Change", handler: sortByChange),
            UIAction(title: "Listed At", handler: sortByListedAt)])
        
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
    }

    func sortByPrice(mainTableView: UITableView) {
        currencyData = currencyData?.sorted() { Double($0.price!)! > Double($1.price!)! }
        mainTableView.reloadData()
    }
    
    func sortByMarketCap(mainTableView: UITableView) {
        currencyData = currencyData?.sorted() { Int($0.marketCap!)! > Int($1.marketCap!)! }
        mainTableView.reloadData()
    }
    
    func sortBy24hVolume(mainTableView: UITableView) {
        currencyData = currencyData?.sorted() { Int($0.the24HVolume!)! > Int($1.the24HVolume!)! }
        mainTableView.reloadData()
    }
    
    func sortByChange(mainTableView: UITableView) {
        currencyData = currencyData?.sorted() { Double($0.change!)! > Double($1.change!)! }
        mainTableView.reloadData()
    }
    
    func sortByListedAt(mainTableView: UITableView) {
        currencyData = currencyData?.sorted() { Int(exactly: $0.listedAt!)! > Int(exactly: $1.listedAt!)! }
        mainTableView.reloadData()
    }
    
    //MARK: - Currency Formatter
    
    func priceFormatter(price: Double, max10To1000: Int, min10To1000: Int, max1To10: Int, min1To10: Int, max001To1: Int, max000001To001: Int) -> String {
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        switch price {
        case 10.0...:
            currencyFormatter.maximumFractionDigits = max10To1000
            currencyFormatter.minimumFractionDigits = min10To1000
        case 1.0...10.0:
            currencyFormatter.maximumFractionDigits = max1To10
            currencyFormatter.minimumFractionDigits = min1To10
        case 0.01...1.0:
            currencyFormatter.maximumFractionDigits = max001To1
        case 0.00001...0.01:
            currencyFormatter.maximumFractionDigits = max000001To001
        default:
            print("error")
        }
        return currencyFormatter.string(from: NSNumber(value: price)) ?? "00000"
    }
    
    func changeColor(model: Coin, change: UILabel) {
        if Double(model.change!)! < 0 {
            change.textColor = .systemRed
            change.text = (model.change ?? "0") + "%"
        } else {
            change.textColor = .systemGreen
            change.text = "+" + (model.change ?? "0") + "%"
        }
    }
}

