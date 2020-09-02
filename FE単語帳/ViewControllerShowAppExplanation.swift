//
//  ViewControllerShowAppExplanation.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/08/27.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerShowAppExplanation: UIViewController {
    @IBOutlet weak var showInfoCollectionView: UICollectionView!
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //showInfoCollectionView作成
        showInfoCollectionView.delegate = self
        showInfoCollectionView.dataSource = self
        //画面サイズに応じてcell固定
        if(UIScreen.main.bounds.height > 700){
            showInfoCollectionView.isScrollEnabled = false
        }
        view.addSubview(showInfoCollectionView)
    }
    
    //戻るボタン押下
    @IBAction func pressReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//UICollectionViewDelegateFlowLayout,UICollectionViewDataSourceの適用
extension ViewControllerShowAppExplanation: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //Itemのレイアウト
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.2)
    }
    //Itemの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    //Itemの作成
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Item定義
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "appInfoCell", for: indexPath)
        //UILabel作成
        let label = item.viewWithTag(1) as! UILabel
        let appExplanation:String = "本アプリケーションをご利用いただきありがとうございます。\n\n【利用方法】\n本アプリケーションは国家試験である基本情報技術者試験における頻出単語をまとめた単語帳です。「単語を選択」または「分野から選択」から単語を選択することで、特定の単語画面が表示されます。単語表示画面のお気に入りボタンを押下することで、「お気に入りを表示」欄にお気に入りした単語が表示されるようになります。「ランダムに表示」は全ての単語からランダムに一つ選択された単語を表示します。また、単語表示画面にて単語の説明文を非表示にすることも可能です。「Twitterでつぶやく」ではインプットした単語数をツイートすることができます。\n\n【免責事項】\n本アプリケーションの利用から生じた、いかなる損害について責任を負いかねますのでご了承下さい。また、本アプリケーションは試験の合格を保証するものではございません。あらかじめご了承下さい。"
        label.text = appExplanation
        //UILabelの大きさ調整
        label.frame.size.height = label.frame.size.height
        label.frame.size.width = UIScreen.main.bounds.width - 40
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 20, y:70)
        
        return item
    }
}

