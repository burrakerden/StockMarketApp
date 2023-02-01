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
    
    //MARK: - Fetch data
    
    func getCurrencyData(mainTableView: UITableView, navigationController: UINavigationController) {
        Service().getCurrencyData() { result in
            guard let result1 = result?.data?.coins else {return}
            self.currencyData = result1
            self.setupUI(mainTableView: mainTableView, navigationController: navigationController)
        } onError: { error in
            print(error)
        }
    }
    
    //MARK: - Config

    func setupUI(mainTableView: UITableView, navigationController: UINavigationController) {
        mainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        mainTableView.sectionHeaderHeight = 0
        navigationController.isNavigationBarHidden = true
        mainTableView.reloadData()
    }
    
    //MARK: - Sorting
    
    func setSortButton(mainTableView: UITableView, sortButton: UIButton) {
        let sortByPrice = {(action: UIAction) in
            self.sortByPrice(mainTableView: mainTableView)}
        
        let sortByMarketCap = {(action: UIAction) in
            self.sortByMarketCap(mainTableView: mainTableView)}
        
        let sortBy24hVolume = {(action: UIAction) in
            self.sortBy24hVolume(mainTableView: mainTableView)}
        
        let sortByChange = {(action: UIAction) in
            self.sortByChange(mainTableView: mainTableView)}
        
        let sortByListedAt = {(action: UIAction) in
            self.sortByListedAt(mainTableView: mainTableView)}
        
        sortButton.menu = UIMenu(children : [
            UIAction(title: "Price", state: .on, handler: sortByPrice),
            UIAction(title: "Market Cap", handler: sortByMarketCap),
            UIAction(title: "24h Vol", handler: sortBy24hVolume),
            UIAction(title: "Change", handler: sortByChange),
            UIAction(title: "Listed At", handler: sortByListedAt)])
        
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
//        mainTableView.reloadData()
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
    
}

