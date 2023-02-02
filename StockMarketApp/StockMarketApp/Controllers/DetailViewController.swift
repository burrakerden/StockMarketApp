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
    
    @IBOutlet weak var svgImageView: UIImageView!
    var currencyData: Coin?
    let currencyFormatter = NumberFormatter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        lineChart.delegate = self
        
    }
    

    
    func setupUI() {
        shortName.text = currencyData?.symbol
        name.text = currencyData?.name
        rank.text = "Rank: \(currencyData?.rank ?? 0)"
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        guard let currencyPrice = currencyData?.price, let price1 = Double(currencyPrice) else {return}
        let lowestPrice = Double(currencyData?.sparkline?.min() ?? "0.00")
        let highestPrice = Double(currencyData?.sparkline?.max() ?? "0.00")
        
        switch price1 {
        case 10.0...:
            currencyFormatter.maximumFractionDigits = 2
            currencyFormatter.minimumFractionDigits = 2
        case 1.0...10.0:
            currencyFormatter.maximumFractionDigits = 4
            currencyFormatter.minimumFractionDigits = 5
        case 0.01...1.0:
            currencyFormatter.maximumFractionDigits = 6
        case 0.00001...0.01:
            currencyFormatter.maximumFractionDigits = 7
        default:
            print("\(currencyData?.name ?? "error")")
        }
        
        price.text = currencyFormatter.string(from: NSNumber(value: price1))
        lowPrice.text = currencyFormatter.string(from: NSNumber(value: lowestPrice!))
        highPrice.text = currencyFormatter.string(from: NSNumber(value: highestPrice!))
        
        
        if Double(currencyData?.change! ?? "0")! < 0 {
            change.textColor = .systemRed
            change.text = (currencyData?.change ?? "0") + "%"
        } else {
            change.textColor = .systemGreen
            change.text = "+" + (currencyData?.change ?? "0") + "%"
        }
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
//        set.valueFont = .boldSystemFont(ofSize: 8)
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
        
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.xAxis.setLabelCount(6, force: false)
        
        lineChart.animate(xAxisDuration: 2.5)
        
        myView.addSubview(lineChart)
    }

    
    
}
