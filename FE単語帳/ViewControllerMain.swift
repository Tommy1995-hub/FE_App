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
    let accessWordModel:WordModel = WordModel()
    let accessAppInfoModel:AppInfoModel = AppInfoModel()
    
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //DBプリセット
        accessWordModel.presetDB()
        accessAppInfoModel.presetDB()
        //「Twitterでつぶやく」を押下
        //日付更新確認＆日付更新
        //accessAppInfoModel.dateCheck()
        //Tweet
        //accessAppInfoModel.tweet()
    }
    
    //Infoボタン押下
    @IBAction func pressInfoButton(_ sender: Any) {
        let storyboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerShowAppExplanation") as! ViewControllerShowAppExplanation
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true)
    }
}
