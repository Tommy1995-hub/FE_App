//
//  ViewControllerShowWord.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/26.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import HeartButton

class ViewControllerShowWord: UIViewController {
    @IBOutlet weak var showWordCollection: UICollectionView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    let config = Realm.Configuration(schemaVersion: 1)
    var WordInfo:Word = Word()
    var pressedRandom:Int = 0
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //showWordCollection作成
        showWordCollection.delegate = self
        showWordCollection.dataSource = self
        showWordCollection.isScrollEnabled = false
        view.addSubview(showWordCollection)
        // 「ランダムに表示」から遷移した場合のみ「次へ」ボタン表示
        if(pressedRandom != 1){
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
            // Realmから該当情報取得
            let realm = try! Realm(configuration:self.config)
            //DB更新(フラグオン)
            if isOn {
                try! realm.write {
                    self.WordInfo.favoriteFlag = 1
                }
            }
            //DB更新(フラグオフ)
            else {
              try! realm.write {
                  self.WordInfo.favoriteFlag = 0
              }
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
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        //hideFlag=1の時
        if(appInfo[0].hideFlag == 1){
            //説明文表示
            Text.isHidden = false
            //ボタン文字を「非表示」に変更
            hideButton.setTitle("非表示", for: .normal)
            //DB更新
            try! realm.write {
                appInfo[0].hideFlag = 0
            }
        }
        //hideFlag=0の時
        else if(appInfo[0].hideFlag == 0){
            //説明文非表示
            Text.isHidden = true
            //ボタン文字を「表示」に変更
            hideButton.setTitle("表示", for: .normal)
            //DB更新
            try! realm.write {
                appInfo[0].hideFlag = 1
            }
        }
    }
    
    //次へボタン押下
    @IBAction func pressNext(_ sender: Any) {
        // RealmからWord情報取得
        let realm = try! Realm(configuration:config)
        let wordInfo = realm.objects(Word.self)
        WordInfo = wordInfo.randomElement()!
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
        var height: CGFloat = UIScreen.main.bounds.height / 7
        //説明cellは大きめに設定
        if(indexPath.row == 1){
            height *= 6
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
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        //Itemに応じて表示させる内容を変更
        if(indexPath.row == 0){
            item = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath)
            //テキストセット
            let Text = item.viewWithTag(1) as! UILabel
            Text.text = WordInfo.word
            //お気に入りボタン
            let favoriteButton = item.viewWithTag(2) as! HeartButton
            //favoriteFlagに応じてボタン変更
            if(WordInfo.favoriteFlag == 1){
                favoriteButton.setOn(true, animated: false)
            }
            else if(WordInfo.favoriteFlag == 0){
                favoriteButton.setOn(false, animated: false)
            }
            //非表示ボタン
            let hideButton = item.viewWithTag(3) as! UIButton
            hideButton.layer.borderWidth = 0.5
            hideButton.layer.borderColor = UIColor.black.cgColor
            hideButton.layer.cornerRadius = 10
            //hideFlagに応じてボタンテキスト変更
            if(appInfo[0].hideFlag == 1){
                hideButton.setTitle("表示", for: .normal)
            }
            else if(appInfo[0].hideFlag == 0){
                hideButton.setTitle("非表示", for: .normal)
            }
        }
        else if (indexPath.row == 1){
            item = collectionView.dequeueReusableCell(withReuseIdentifier: "explanationCell", for: indexPath)
            let lavel = item.viewWithTag(5) as! UILabel
            lavel.text = WordInfo.explanation
            //UILavelの大きさ調整
            var fixedFrame = lavel.frame
            lavel.sizeToFit()
            fixedFrame.size.width = UIScreen.main.bounds.width - 40
            fixedFrame.size.height = lavel.frame.size.height
            lavel.frame = CGRect(x:20, y:10, width: fixedFrame.size.width, height: fixedFrame.size.height)
            //hideFlagに応じてボタンテキスト変更
            if(appInfo[0].hideFlag == 1){
                lavel.isHidden = true
            }
            else if(appInfo[0].hideFlag == 0){
                lavel.isHidden = false
            }
        }
        return item
    }
}

