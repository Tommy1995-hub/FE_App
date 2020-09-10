//
//  ViewControllerSelectWord.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/24.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerSelectWord: UIViewController {
    @IBOutlet weak var selectWordTable: UITableView!
    @IBOutlet weak var returnButton: UIBarButtonItem!
    var selectWordShowBox: [Word] = []
    let accessWordModel:WordModel = WordModel()
    let accessAppInfoModel:AppInfoModel = AppInfoModel()
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectWordTable作成
        selectWordTable.dataSource = self
        selectWordTable.delegate = self
        view.addSubview(selectWordTable)
        // 「単語を選択」「分野から選択」から遷移した場合、DBから該当データ取得
        if(preScreenInfo == 0){
            //「単語を選択」から遷移
            selectWordShowBox = accessWordModel.getWordByGroup(receiveGroupInfo)
        }
        else if(preScreenInfo == 1){
            //「分野から選択」から遷移
            selectWordShowBox = accessWordModel.getWordByField(receiveGroupInfo)
        }
        else{
            //処理なし
        }
    }
    
    //View表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 「お気に入りを表示」から遷移した場合
        if(preScreenInfo == 2){
            //お気に入り単語取得
            selectWordShowBox = []
            selectWordShowBox = accessWordModel.getWordByFavorite()
            //「戻るボタン」無効化
            returnButton.isEnabled = false
            returnButton.tintColor = UIColor.clear
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectWordTableCell", for: indexPath as IndexPath)
        //TableViewCellのLabel作成
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
