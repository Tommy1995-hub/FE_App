//
//  ViewControllerSelectGroup.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/20.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import UIKit

class ViewControllerSelectGroup: UIViewController {
    @IBOutlet weak var selectGroupTable: UITableView!
    var selectGroupShowBox: [String] =
        ["あ行","か行","さ行","た行","な行","は行","ま行","や行","ら行","わ行","A〜E","F〜J","K〜O","P〜T","U〜Z"]
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //topTable作成
        selectGroupTable.dataSource = self
        selectGroupTable.delegate = self
        view.addSubview(selectGroupTable)
    }
    
    //戻るボタン押下
    @IBAction func pressReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
    
//UITableViewDataSource,UITableViewDelegateの適用
extension ViewControllerSelectGroup: UITableViewDataSource,UITableViewDelegate{
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectGroupShowBox.count
    }
    //cellの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboardからTableViewCell取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectGroupTableCell", for: indexPath as IndexPath)
        //TableViewCellのLavel作成
        let setText: String = selectGroupShowBox[indexPath.row]
        cell.textLabel?.text = setText
                
        return cell
    }
    //cellタップ時処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)// セルの選択を解除
        //選択された年、月情報を次画面に渡す&画面遷移
        /*let storyboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerDaily") as! ViewControllerDaily
        next.modalPresentationStyle = .fullScreen
        next.receiveMonyhly = monthlyBox[indexPath.row]
        self.present(next, animated: true)*/
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.scrollToRow(at: IndexPath(row: selectGroupShowBox.count - 1, section: 0),
                              at: UITableView.ScrollPosition.bottom, animated: true)
    }
}
