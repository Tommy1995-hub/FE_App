//
//  ViewControllerMain.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/09/10.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit

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
        TweetButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        TweetButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
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
        let height: CGFloat = UIScreen.main.bounds.height * 1.3
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
        return item
    }
}
