//
//  ViewControllerTop.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/20.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import UIKit

class ViewControllerTop: UIViewController {
    @IBOutlet weak var topTableView: UITableView!
    var topShowBox: [String] = ["単語を選択","お気に入りを表示","ランダムに表示","Twitterでつぶやく"]
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの枠線削除
        UINavigationBar.self.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.self.appearance().shadowImage = UIImage()
        //topTable作成
        topTableView.dataSource = self
        topTableView.delegate = self
        view.addSubview(topTableView)
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
        //storyboardからTableViewCell取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "topTableViewCell", for: indexPath as IndexPath)
        //TableViewCellのLavel作成
        let setText: String = topShowBox[indexPath.row]
        cell.textLabel?.text = setText
        return cell
    }
    //cellタップ時処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)//セルの選択を解除
        let storyboard = self.storyboard!
        //選択されたCellごとに画面遷移
        //「単語を選択」を押下
        if(indexPath.row == 0){
            let next = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectGroup") as! ViewControllerSelectGroup
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true)
        }
        //「お気に入りを表示」を押下
        else if(indexPath.row == 1){
            
        }
        //「ランダムに表示」を押下
        else if(indexPath.row == 2){
            
        }
        //「Twitterでつぶやく」を押下
        else if(indexPath.row == 3){
            
        }
        else{
            //処理なし
        }
    }
}
