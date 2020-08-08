//
//  ViewControllerSelectWord.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/24.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ViewControllerSelectWord: UIViewController {
    @IBOutlet weak var selectWordTable: UITableView!
    let config = Realm.Configuration(schemaVersion: 1)
    var selectWordShowBox: [Word] = []
    var receiveGroupInfo:Int = 99
    var pressedFavorite:Int = 0
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectWordTable作成
        selectWordTable.dataSource = self
        selectWordTable.delegate = self
        view.addSubview(selectWordTable)
        // 「単語を選択」から遷移した場合、DBから該当データ取得
        if(pressedFavorite != 1){
            let realm = try! Realm(configuration:config)
            let wordInfo = realm.objects(Word.self).filter("group == \(receiveGroupInfo)").sorted(byKeyPath: "word", ascending: true)
            //取得データをselectWordShowBoxに設定
            for word in wordInfo {
                selectWordShowBox.append(word)
            }
        }
    }
    
    //View表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 「お気に入りを表示」から遷移した場合、DBから該当データ取得
        if(pressedFavorite == 1){
            selectWordShowBox = []
            let realm = try! Realm(configuration:config)
            let wordInfo = realm.objects(Word.self).filter("favoriteFlag == 1").sorted(byKeyPath: "word", ascending: true)
            //取得データをselectWordShowBoxに設定
            for word in wordInfo {
                selectWordShowBox.append(word)
            }
            //View再表示
            selectWordTable.reloadData()
        }
    }
    
    //戻るボタン押下
    @IBAction func pressReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//UITableViewDataSource,UITableViewDelegateの適用
extension ViewControllerSelectWord: UITableViewDataSource,UITableViewDelegate{
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectWordShowBox.count
    }
    //cellの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboardからTableViewCell取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectWordTableCell", for: indexPath as IndexPath)
        //TableViewCellのLavel作成
        let setText: String = selectWordShowBox[indexPath.row].word
        cell.textLabel?.text = setText
                
        return cell
    }
    //cellタップ時処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)// セルの選択を解除
        //選択されたcellの単語情報を渡す&画面遷移
        let storyboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerShowWord") as! ViewControllerShowWord
        next.modalPresentationStyle = .fullScreen
        next.WordInfo = selectWordShowBox[indexPath.row]
        self.present(next, animated: true)
    }
}
