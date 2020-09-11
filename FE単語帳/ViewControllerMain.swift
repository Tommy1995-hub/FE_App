//
//  ViewControllerMain.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/09/10.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ViewControllerMain: UIViewController {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    let accessWordModel:WordModel = WordModel()
    let accessAppInfoModel:AppInfoModel = AppInfoModel()
    
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //mainCollectionView作成
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        view.addSubview(mainCollectionView)
        //DBプリセット
        accessWordModel.presetDB()
        accessAppInfoModel.presetDB()
        //Tweetボタン作成&位置を右下固定
        let TweetButton = UIButton()
        TweetButton.translatesAutoresizingMaskIntoConstraints = false
        TweetButton.setImage(UIImage(named: "TwitterImage"), for: .normal)
        self.view.addSubview(TweetButton)
        TweetButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(UIScreen.main.bounds.height / 8)).isActive = true
        TweetButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        TweetButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        TweetButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        TweetButton.addTarget(self, action: #selector(pressTweetButton(_:)), for: UIControl.Event.touchUpInside)
    }
    
    //View表示前処理
    override func viewWillAppear(_ animated: Bool) {
        //日付更新確認＆日付更新
        accessAppInfoModel.dateCheck()
        //View再表示
        mainCollectionView.reloadData()
    }
    
    //Infoボタン押下
    @IBAction func pressInfoButton(_ sender: Any) {
        let storyboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerShowAppExplanation") as! ViewControllerShowAppExplanation
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true)
    }
    
    //Tweetボタン押下
    @objc func pressTweetButton(_ sender: UIButton) {
        //日付更新確認＆日付更新
        accessAppInfoModel.dateCheck()
        //インプット単語数更新
        accessAppInfoModel.tweet()
    }
}

//UICollectionViewDelegateFlowLayout,UICollectionViewDataSourceの適用
extension ViewControllerMain: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //Itemのレイアウト
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = UIScreen.main.bounds.height
        return CGSize(width: width, height: height)
    }
    //Itemの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    //Itemの作成
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Item定義
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath)
        //テキストセット
        let label = item.viewWithTag(1) as! UILabel
        label.text = "本日のインプット単語数：\(accessAppInfoModel.getInputWordNum())"
        //テキストセット
        let fieldLabel = item.viewWithTag(2) as! UILabel
        fieldLabel.text = "テクノロジ:\(accessAppInfoModel.getInputTechnologyNum()) マネジメント:\(accessAppInfoModel.getInputManagementNum()) ストラテジ:\(accessAppInfoModel.getInputStrategyNum())"
        fieldLabel.frame.size.height = 20
        fieldLabel.frame.size.width = UIScreen.main.bounds.width - 40
        fieldLabel.frame.origin = CGPoint(x: 20, y:84)
        //円グラフ作成
        let chart = item.viewWithTag(3) as! PieChartView
        chart.frame.size.height = (UIScreen.main.bounds.height - 164) / 1.5
        chart.frame.size.width = UIScreen.main.bounds.width - 40
        chart.frame.origin = CGPoint(x: 20, y:134)
        chart.centerText = ""//円の中心テキスト
        chart.legend.enabled = false
        // グラフに表示するデータのタイトルと値
        var dataEntries = [
            PieChartDataEntry(value: Double(accessAppInfoModel.getInputTechnologyNum()), label: "テクノロジ"),
            PieChartDataEntry(value: Double(accessAppInfoModel.getInputManagementNum()), label: "マネジメント"),
            PieChartDataEntry(value: Double(accessAppInfoModel.getInputStrategyNum()), label: "ストラテジ")
        ]
        //インプット数0ならばグラフに表示しない
        if(accessAppInfoModel.getInputStrategyNum() == 0){
            dataEntries.removeLast()
        }
        if(accessAppInfoModel.getInputManagementNum() == 0){
            dataEntries.remove(at: 1)
        }
        if(accessAppInfoModel.getInputTechnologyNum() == 0){
            dataEntries.remove(at: 0)
        }
        var emptyFlag = 0
        //空だったらダミーデータ表示
        if(dataEntries.isEmpty){
            emptyFlag = 1
            dataEntries.append(PieChartDataEntry(value:1, label: ""))
        }
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        //空だったら
        if(emptyFlag == 1){
            // グラフの色をグレー&データの値非表示
            dataSet.drawValuesEnabled = false
            dataSet.setColors(UIColor.gray)
            chart.data = PieChartData(dataSet: dataSet)
        }
        //要素が一つでもあれば
        else{
            // グラフの色
            dataSet.colors = ChartColorTemplates.vordiplom()
            // グラフのデータの値の色
            dataSet.valueTextColor = UIColor.black
            // グラフのデータのタイトルの色
            dataSet.entryLabelColor = UIColor.black
            chart.data = PieChartData(dataSet: dataSet)
            // データを％表示にする
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.multiplier = 1.0
            chart.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            chart.usePercentValuesEnabled = true
        }
        return item
    }
}
