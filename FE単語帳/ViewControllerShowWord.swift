//
//  ViewControllerShowWord.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/26.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit
import HeartButton

class ViewControllerShowWord: UIViewController {
    @IBOutlet weak var showWordCollection: UICollectionView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    var WordInfo:Word = Word()
    let accessWordModel:WordModel = WordModel()
    let accessAppInfoModel:AppInfoModel = AppInfoModel()
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //showWordCollection作成
        showWordCollection.delegate = self
        showWordCollection.dataSource = self
        showWordCollection.isScrollEnabled = false
        view.addSubview(showWordCollection)
        // 「ランダムに表示」からの遷移でなければ「次へ」ボタン無効化
        if(preScreenInfo != 3){
            nextButton.isEnabled = false
            nextButton.tintColor = UIColor.clear
        }
    }
    
    //View表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //お気に入りボタン
        let wordCell = showWordCollection.viewWithTag(0) as! UICollectionViewCell
        let favoriteButton = wordCell.viewWithTag(2) as! HeartButton
        //お気に入りボタン押下
        favoriteButton.stateChanged = { sender, isOn in
            //DB更新(フラグオン)
            if isOn {
                self.accessWordModel.isOnFavoriteFlag(self.WordInfo)
            }
            //DB更新(フラグオフ)
            else {
                self.accessWordModel.isOffFavoriteFlag(self.WordInfo)
            }
        }
    }
    
    //非表示ボタン押下
    @IBAction func pressHiddenButton(_ sender: Any) {
        //cell情報取得
        let wordCell = showWordCollection.viewWithTag(0) as! UICollectionViewCell
        let hideButton = wordCell.viewWithTag(3) as! UIButton
        let explanationCell = showWordCollection.viewWithTag(4) as! UICollectionViewCell
        let Text = explanationCell.viewWithTag(5) as! UILabel
        //hideFlag取得
        let hideFlag = accessAppInfoModel.getHideFlag()
        //hideFlag=1の時
        if(hideFlag == 1){
            //説明文表示
            Text.isHidden = false
            //ボタン文字を「非表示」に変更
            hideButton.setTitle("非表示", for: .normal)
            //DB更新
            accessAppInfoModel.setHideFlag(0)
        }
        //hideFlag=0の時
        else if(hideFlag == 0){
            //説明文非表示
            Text.isHidden = true
            //ボタン文字を「表示」に変更
            hideButton.setTitle("表示", for: .normal)
            //DB更新
            accessAppInfoModel.setHideFlag(1)
        }
    }
    
    //次へボタン押下
    @IBAction func pressNext(_ sender: Any) {
        //ランダムに単語情報取得
        WordInfo = accessWordModel.getRandomWord()
        //View再表示
        showWordCollection.reloadData()
    }
    
    //戻るボタン押下
    @IBAction func pressReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//UICollectionViewDelegateFlowLayout,UICollectionViewDataSourceの適用
extension ViewControllerShowWord: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //Itemのレイアウト
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = 128
        //説明cellは大きめに設定
        if(indexPath.row == 1){
            height *= UIScreen.main.bounds.height - 128
        }
        return CGSize(width: width, height: height)
    }
    //Itemの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    //Itemの作成
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Item定義
        var item:UICollectionViewCell = UICollectionViewCell()
        //Itemに応じて表示させる内容を変更
        if(indexPath.row == 0){
            item = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath)
            //テキストセット
            let label = item.viewWithTag(1) as! UILabel
            label.text = WordInfo.word
            //UILabelの大きさ調整
            label.frame.size.height = label.frame.size.height
            label.frame.size.width = UIScreen.main.bounds.width - 130
            label.frame.origin = CGPoint(x: 20, y:item.center.y - (label.frame.size.height/2))
            //お気に入りボタン
            let favoriteButton = item.viewWithTag(2) as! HeartButton
            //favoriteFlagに応じてボタン変更
            if(WordInfo.favoriteFlag == 1){
                favoriteButton.setOn(false, animated: false)
                favoriteButton.backgroundColor = UIColor.white
                favoriteButton.setOn(true, animated: false)
            }
            else{
                favoriteButton.setOn(false, animated: false)
                favoriteButton.backgroundColor = UIColor.white
            }
            //非表示ボタン
            let hideButton = item.viewWithTag(3) as! UIButton
            hideButton.layer.borderWidth = 0.5
            hideButton.layer.borderColor = UIColor.black.cgColor
            hideButton.layer.cornerRadius = 10
            //hideFlagに応じてボタンテキスト変更
            if(accessAppInfoModel.getHideFlag() == 1){
                hideButton.setTitle("表示", for: .normal)
            }
            else{
                hideButton.setTitle("非表示", for: .normal)
            }
            //日付更新確認＆日付更新
            accessAppInfoModel.dateCheck()
            //インプット単語数更新
            accessAppInfoModel.incInputWordNum()
        }
        else if (indexPath.row == 1){
            item = collectionView.dequeueReusableCell(withReuseIdentifier: "explanationCell", for: indexPath)
            let label = item.viewWithTag(5) as! UILabel
            //テキストセット
            // "。"ごとに区切って、改行用の「\n」を追加し、labelに設定
            var lineBreakWord = WordInfo.explanation.components(separatedBy: "。")
            lineBreakWord.removeLast()
            var explanation:String = ""
            for word in lineBreakWord {
                explanation += word + "。\n"
            }
            label.text = explanation
            //UILabelの大きさ調整
            label.frame.size.height = label.frame.size.height
            label.frame.size.width = UIScreen.main.bounds.width - 40
            label.sizeToFit()
            label.frame.origin = CGPoint(x: 20, y:10)
            //hideFlagに応じてボタンテキスト変更
            if(accessAppInfoModel.getHideFlag() == 1){
                label.isHidden = true
            }
            else{
                label.isHidden = false
            }
        }
        return item
    }
}

