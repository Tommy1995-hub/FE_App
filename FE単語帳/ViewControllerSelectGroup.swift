//
//  ViewControllerSelectGroup.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/20.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerSelectGroup: UIViewController {
    @IBOutlet weak var selectGroupTable: UITableView!
    var selectGroupShowBox: [[String]] = [[]]
    var sectionShowBox: [String] = []
    var groupBox: [[String]] =
        [["数字/記号"],["A〜E","F〜J","K〜O","P〜T","U〜Z"],["あ行","か行","さ行","た行","な行","は行","ま行","や行","ら行","わ行"]]
    var groupSectionBox = ["数字/記号","アルファベット","かな"]
    var fieldBox: [[String]] =
    [["基礎理論","アルゴリズムとプログラミング","コンピュータ構成要素","システム構成要素","ソフトウェア","ハードウェア","ヒューマンインターフェース","マルチメディア","データベース","ネットワーク","セキュリティ","システム開発技術","ソフトウェア開発管理技術"],["プロジェクトマネジメント","サービスマネジメント","システム監査"],["システム戦略","システム企画","経営戦略マネジメント","技術戦略マネジメント","ビジネスインダストリ","企業活動","法務"]
    ]
    var fieldSectionBox = ["テクノロジ系","マネジメント系","ストラテジ系"]
    
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //selectGroupTable作成
        selectGroupTable.dataSource = self
        selectGroupTable.delegate = self
        view.addSubview(selectGroupTable)
    }
    
    //View表示前処理
    override func viewWillAppear(_ animated: Bool) {
        //「分野から選択」が押された
        if(preScreenInfo == 1){
            selectGroupShowBox = fieldBox
            sectionShowBox = fieldSectionBox
        }
        //「単語を選択」が押された
        else{
            selectGroupShowBox = groupBox
            sectionShowBox = groupSectionBox
        }
        //View再表示
        selectGroupTable.reloadData()
    }
    
    //リフレッシュボタン押下
    @IBAction func pressArrowButton(_ sender: Any) {
        //「分野から選択」「単語を選択」を切り替え
        if(preScreenInfo == 1){
            preScreenInfo = 0
            selectGroupShowBox = groupBox
            sectionShowBox = groupSectionBox
        }
        //「単語を選択」が押された
        else if(preScreenInfo == 0){
            preScreenInfo = 1
            selectGroupShowBox = fieldBox
            sectionShowBox = fieldSectionBox
        }
        else{
            //処理なし
        }
        //View再表示
        selectGroupTable.reloadData()
    }
}

//UITableViewDataSource,UITableViewDelegateの適用
extension ViewControllerSelectGroup: UITableViewDataSource,UITableViewDelegate{
    //sectionの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectGroupShowBox.count
    }
    //sectionのヘッダー作成
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionShowBox[section]
    }
    //section内のcellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectGroupShowBox[section].count
    }
    //cellの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboardからTableViewCell取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectGroupTableCell", for: indexPath as IndexPath)
        //TableViewCellのLabel作成
        let setText: String = selectGroupShowBox[indexPath.section][indexPath.row]
        cell.textLabel?.text = setText
        
        return cell
    }
    //cellタップ時処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)// セルの選択を解除
        //「分野から選択」
        if(preScreenInfo == 1){
            //テクノロジ系
            if(indexPath.section == 0){
                receiveGroupInfo = indexPath.row
            }
            //マネジメント系
            else if(indexPath.section == 1){
                receiveGroupInfo = indexPath.row + 13
            }
            //ストラテジ系
            else if(indexPath.section == 2){
                receiveGroupInfo = indexPath.row + 16
            }
        }
        //「単語を選択」
        else{
            //数字/記号
            if(indexPath.section == 0){
                receiveGroupInfo = indexPath.row
            }
            //アルファベット
            else if(indexPath.section == 1){
                receiveGroupInfo = indexPath.row + 1
            }
            //かな
            else if(indexPath.section == 2){
                receiveGroupInfo = indexPath.row + 6
            }
        }
        //選択されたcellのグループ情報を渡す&画面遷移
        let storyboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectWord") as! ViewControllerSelectWord
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true)
    }
}
