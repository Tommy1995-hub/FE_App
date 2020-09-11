//
//  AppInfo.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/24.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import RealmSwift

//アプリ情報クラス
class AppInfo: Object {
    //メンバ変数
    @objc dynamic var hideFlag:Int = 0
    @objc dynamic var inputWordNum:Int = 0
    @objc dynamic var lasttimeDate:String = ""
    @objc dynamic var inputTechnologyNum:Int = 0
    @objc dynamic var inputManagementNum:Int = 0
    @objc dynamic var inputStrategyNum:Int = 0
}
