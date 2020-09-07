//
//  ViewControllerTop.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/20.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerTop: UIViewController {
    @IBOutlet weak var topTableView: UITableView!
    var topShowBox: [String] = ["単語を選択","分野から選択","お気に入りを表示","ランダムに表示","Twitterでつぶやく"]
    let accessWordModel:WordModel = WordModel()
    let accessAppInfoModel:AppInfoModel = AppInfoModel()
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //topTable作成
        topTableView.dataSource = self
        topTableView.delegate = self
        topTableView.isScrollEnabled = false
        view.addSubview(topTableView)
        //DBプリセット
        accessWordModel.presetDB()
        accessAppInfoModel.presetDB()
    }
    
    //Infoボタン押下
    @IBAction func pressInfoButton(_ sender: Any) {
        let storyboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerShowAppExplanation") as! ViewControllerShowAppExplanation
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true)
    }
}

//UITableViewDataSource,UITableViewDelegateの適用
extension ViewControllerTop: UITableViewDataSource,UITableViewDelegate{
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topShowBox.count
    }
    //cellの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboardからcell情報取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "topTableViewCell", for: indexPath as IndexPath)
        //cellの作成
        let setText: String = topShowBox[indexPath.row]
        cell.textLabel?.text = setText
        return cell
    }
    //cellタップ時処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)//セルの選択を解除
        let storyboard = self.storyboard!
        //タップされたcellごとに画面遷移
        //「単語を選択」を押下
        if(indexPath.row == 0){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectGroup") as! ViewControllerSelectGroup
            next.modalPresentationStyle = .fullScreen
            preScreenInfo = 0
            self.present(next, animated: true)
        }
        //「分野から選択」を押下
        else if(indexPath.row == 1){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectGroup") as! ViewControllerSelectGroup
            next.modalPresentationStyle = .fullScreen
            preScreenInfo = 1
            self.present(next, animated: true)
        }
        //「お気に入りを表示」を押下
        else if(indexPath.row == 2){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectWord") as! ViewControllerSelectWord
            next.modalPresentationStyle = .fullScreen
            preScreenInfo = 2
            self.present(next, animated: true)
        }
        //「ランダムに表示」を押下
        else if(indexPath.row == 3){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerShowWord") as! ViewControllerShowWord
            next.modalPresentationStyle = .fullScreen
            next.WordInfo = accessWordModel.getRandomWord()
            preScreenInfo = 3
            self.present(next, animated: true)
        }
        //「Twitterでつぶやく」を押下
        else if(indexPath.row == 4){
            //日付更新確認＆日付更新
            accessAppInfoModel.dateCheck()
            //Tweet
            accessAppInfoModel.tweet()
        }
        else{
            //処理なし
        }
    }
}
