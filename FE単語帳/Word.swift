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
    @objc dynamic var explanation:String = ""
    @objc dynamic var group:Int = 99
    @objc dynamic var favoriteFlag:Int = 0
    
    //csvファイルのデータを読み出し、Realmにセット
    func setCsvData(){
        //csvファイル
        let csvBundle = Bundle.main.path(forResource: "wordList", ofType: "csv")
        //csv内データ格納用
        var csvStrArray:[String] = []
        do {
            //csvデータをUTF8文字列に変換
            let csvStr = try String(contentsOfFile: csvBundle!, encoding: String.Encoding.utf8)
            //改行で区切って、配列csvStrArrayに格納
            csvStrArray = csvStr.components(separatedBy: .newlines)
            //Xcodeの仕様上最後に空白の行が追加されてしまうため、それを削除
            csvStrArray.removeLast()
        }
        catch {
            //処理失敗
            return
        }
        //Realmオブジェクト生成
        let config = Realm.Configuration(schemaVersion: 1)
        let realm = try! Realm(configuration:config)
        //csvStrArrayごとにRealmに保存
        for wordInfo in csvStrArray {
            // ","ごとに区切って、変数wordMemberに格納
            let wordMember = wordInfo.components(separatedBy: ",")
            let addWord = Word()
            addWord.word = wordMember[0]
            addWord.explanation = wordMember[1]
            addWord.group = Int(wordMember[2])!
            addWord.favoriteFlag = Int(wordMember[3])!
            // 保存処理
            do {
                try realm.write {
                    realm.add(addWord)
                }
            } catch {
            }
        }
    }
}


