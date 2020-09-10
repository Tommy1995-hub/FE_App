//
//  TabBarController.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/09/10.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    //初期メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //タブをタップ
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //タップしたタブに応じて処理
        switch item.tag {
        //トップ
        case 1: break
        //探す
        case 2:
            preScreenInfo = 0
        //お気に入り
        case 3:
            preScreenInfo = 2
        //ランダム
        case 4:
            preScreenInfo = 3
        default:
            break
        }
    }
}
