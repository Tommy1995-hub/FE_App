//
//  WordModel.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/09/03.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import RealmSwift

//Wordモデルクラス
class WordModel {
    let config = Realm.Configuration(schemaVersion: 3)
    //DBプリセット
    func presetDB(){
        // RealmからWord情報取得
        let realm = try! Realm(configuration:config)
        let wordInfo = realm.objects(Word.self)
        //DBリセット用
        /*try! realm.write {
          realm.deleteAll()
        }*/
        //初回DBプリセット処理
        if(wordInfo.isEmpty){
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
            //csvStrArrayの要素ごとにRealmに保存
            for word in csvStrArray {
                // ","ごとに区切って、変数wordMemberに格納
                let wordMember = word.components(separatedBy: ",")
                //追加するWordオブジェクト作成
                let addWord = Word()
                addWord.word = wordMember[0]
                addWord.furigana = wordMember[1]
                addWord.explanation = wordMember[2]
                addWord.group = Int(wordMember[3])!
                addWord.field = Int(wordMember[4])!
                addWord.favoriteFlag = Int(wordMember[5])!
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
    
    //グループからWord取得
    func getWordByGroup(_ group: Int) -> [Word]{
        //word情報返却用
        var returnWordBox: [Word] = []
        // RealmからWord情報取得
        let realm = try! Realm(configuration:config)
        let wordInfo = realm.objects(Word.self).filter("group == \(group)").sorted(byKeyPath: "furigana", ascending: true)
        //取得データをreturnWordBoxに設定
        for word in wordInfo {
            returnWordBox.append(word)
        }
        
        return returnWordBox
    }
    
    //分野からWord取得
    func getWordByField(_ field: Int) -> [Word]{
        //word情報返却用
        var returnWordBox: [Word] = []
        // RealmからWord情報取得
        let realm = try! Realm(configuration:config)
        let wordInfo = realm.objects(Word.self).filter("field == \(field)").sorted(byKeyPath: "furigana", ascending: true)
        //取得データをreturnWordBoxに設定
        for word in wordInfo {
            returnWordBox.append(word)
        }
        
        return returnWordBox
    }
    
    //お気に入りWord取得
    func getWordByFavorite() -> [Word]{
        //word情報返却用
        var returnWordBox: [Word] = []
        // RealmからWord情報取得
        let realm = try! Realm(configuration:config)
        let wordInfo = realm.objects(Word.self).filter("favoriteFlag == 1").sorted(byKeyPath: "furigana", ascending: true)
        //取得データをreturnWordBoxに設定
        for word in wordInfo {
            returnWordBox.append(word)
        }
        
        return returnWordBox
    }
    
    //ランダムにWord取得
    func getRandomWord() -> Word{
        // RealmからWord情報取得
        let realm = try! Realm(configuration:config)
        let wordInfo = realm.objects(Word.self)
        
        return wordInfo.randomElement()!
    }
    
    //Wordのお気に入りフラグOn
    func isOnFavoriteFlag(_ word: Word){
        let realm = try! Realm(configuration:self.config)
        try! realm.write {
            word.favoriteFlag = 1
        }
    }
    
    //Wordのお気に入りフラグOff
    func isOffFavoriteFlag(_ word: Word){
        let realm = try! Realm(configuration:self.config)
        try! realm.write {
            word.favoriteFlag = 0
        }
    }
}
