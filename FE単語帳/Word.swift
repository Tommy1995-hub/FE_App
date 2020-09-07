//
//  Word.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/07/23.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import RealmSwift

//単語クラス
class Word: Object {
    //メンバ変数
    @objc dynamic var word:String = ""
    @objc dynamic var furigana:String = ""
    @objc dynamic var explanation:String = ""
    @objc dynamic var group:Int = 99
    @objc dynamic var field:Int = 99
    @objc dynamic var favoriteFlag:Int = 0
}
