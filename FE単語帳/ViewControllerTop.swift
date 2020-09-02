//
//  ViewControllerTop.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/20.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Firebase

class ViewControllerTop: UIViewController {
    @IBOutlet weak var topTableView: UITableView!
    var topShowBox: [String] = ["単語を選択","分野から選択","お気に入りを表示","ランダムに表示","Twitterでつぶやく"]
    let config = Realm.Configuration(schemaVersion: 3)
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //topTable作成
        topTableView.dataSource = self
        topTableView.delegate = self
        topTableView.isScrollEnabled = false
        view.addSubview(topTableView)
        // RealmからWord情報取得
        let realm = try! Realm(configuration:config)
        let wordInfo = realm.objects(Word.self)
        //DBリセット用
        /*try! realm.write {
          realm.deleteAll()
        }*/
        //初回DBプリセット処理
        if(wordInfo.isEmpty){
            //csvデータ登録
            Word().setCsvData()
            //日付を算出
            let now = Date()
            let date = DateFormatter()
            date.dateStyle = .short
            date.timeStyle = .none
            date.locale = Locale(identifier: "ja_JP")
            //AppInfo情報を登録
            let setAppInfo = AppInfo()
            setAppInfo.hideFlag = 0
            setAppInfo.inputWordNum = 0
            setAppInfo.lasttimeDate = date.string(from: now)
            do {
                try realm.write {
                    realm.add(setAppInfo)
                }
            } catch {
            }
        }
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
            self.present(next, animated: true)
        }
        //「分野から選択」を押下
        else if(indexPath.row == 1){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectGroup") as! ViewControllerSelectGroup
            next.modalPresentationStyle = .fullScreen
            next.previousScreenInfo = 1
            self.present(next, animated: true)
        }
        //「お気に入りを表示」を押下
        else if(indexPath.row == 2){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectWord") as! ViewControllerSelectWord
            next.modalPresentationStyle = .fullScreen
            next.previousScreenInfo = 2
            self.present(next, animated: true)
        }
        //「ランダムに表示」を押下
        else if(indexPath.row == 3){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerShowWord") as! ViewControllerShowWord
            next.modalPresentationStyle = .fullScreen
            let realm = try! Realm(configuration:config)
            let wordInfo = realm.objects(Word.self)
            next.WordInfo = wordInfo.randomElement()!
            next.pressedRandom = 1
            self.present(next, animated: true)
        }
        //「Twitterでつぶやく」を押下
        else if(indexPath.row == 4){
            // RealmからAppInfo取得
            let realm = try! Realm(configuration:config)
            let appInfo = realm.objects(AppInfo.self)
            //現在の日付を取得
            let now = Date()
            let date = DateFormatter()
            date.dateStyle = .short
            date.timeStyle = .none
            date.locale = Locale(identifier: "ja_JP")
            //日付の変更あり
            if(appInfo[0].lasttimeDate != date.string(from: now)){
                try! realm.write {
                    //日付更新
                    appInfo[0].lasttimeDate = date.string(from: now)
                    //インプット単語数を初期化
                    appInfo[0].inputWordNum = 0
                }
            }
            //Tweet
            let text = "本日のインプット単語数：\(appInfo[0].inputWordNum)\nスキマ時間を有効活用！効率的に学習して単語を覚えよう！\n＃基本情報技術者単語帳\n\nhttps://apps.apple.com/us/app/id1529835420"
            let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let encodedText = encodedText,
                let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        else{
            //処理なし
        }
    }
}
