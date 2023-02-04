//
//  DetailViewController.swift
//  StockMarketApp
//
//  Created by Burak Erden on 1.02.2023.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
    
    var lineChart = LineChartView()
    var viewModel = ViewModel()

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var highPrice: UILabel!
    @IBOutlet weak var lowPrice: UILabel!
    @IBOutlet weak var rank: UILabel!
    
    var currencyData: Coin?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        lineChart.delegate = self
        guard let currencyData = currencyData else {return}
        shortName.text = currencyData.symbol
        name.text = currencyData.name
        rank.text = "Rank: \(currencyData.rank ?? 0)"
        
        guard let currencyPrice = currencyData.price, let coinPrice = Double(currencyPrice) else {return}
        guard let lowestPrice = Double(currencyData.sparkline?.min() ?? "0.00") else {return}
        guard let highestPrice = Double(currencyData.sparkline?.max() ?? "0.00") else {return}
        
        price.text = viewModel.priceFormatter(price: coinPrice, max10To1000: 2, min10To1000: 2, max1To10: 4, min1To10: 5, max001To1: 6, max000001To001: 7)
        lowPrice.text = viewModel.priceFormatter(price: lowestPrice, max10To1000: 2, min10To1000: 2, max1To10: 4, min1To10: 5, max001To1: 6, max000001To001: 7)
        highPrice.text = viewModel.priceFormatter(price: highestPrice, max10To1000: 2, min10To1000: 2, max1To10: 4, min1To10: 5, max001To1: 6, max000001To001: 7)
        viewModel.changeColor(model: currencyData, change: change)
        }
}

//MARK: - CHART

extension DetailViewController: ChartViewDelegate {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setData()
        setChartView()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        guard let sparklineArr = currencyData?.sparkline else {return}
        let arrayY = sparklineArr.map({Double($0)!})

        var entries = [ChartDataEntry]()
        for y in 0...arrayY.count - 1 {
            entries.append(ChartDataEntry(x: Double(y), y: arrayY[y]))
        }
        
        let set = LineChartDataSet(entries: entries, label: "Past prices")
        set.colors = ChartColorTemplates.liberty()
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.setColor(.black)
        set.drawFilledEnabled = true
        set.fillColor = .black
        
        set.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
    
    func setChartView() {
        lineChart.frame = CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: self.myView.frame.size.height)
        
        lineChart.rightAxis.enabled = false
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor  = .black
        yAxis.labelPosition = .outsideChart
//      x axis
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.xAxis.setLabelCount(6, force: false)
//      animation
        lineChart.animate(xAxisDuration: 2.5)
        
        myView.addSubview(lineChart)
    }
}
