//
//  AppInfoModel.swift
//  FE単語帳
//
//  Created by 富岡広海 on 2020/09/03.
//  Copyright © 2020 hiromi.tomioka. All rights reserved.
//

import Foundation
import RealmSwift

//前画面情報グローバル変数
//前画面情報 0:単語を選択 1:分野から選択 2:お気に入りを表示 3:ランダムに表示
var preScreenInfo:Int = 99
//グループ/分野情報
var receiveGroupInfo:Int = 99

//AppInfoモデルクラス
class AppInfoModel {
    let config = Realm.Configuration(schemaVersion: 4)
    //DBプリセット
    func presetDB(){
        // RealmからAppInfo情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        //初回DBプリセット処理
        if(appInfo.isEmpty){
            //日付を算出
            let now = Date()
            let date = DateFormatter()
            date.dateStyle = .short
            date.timeStyle = .none
            date.locale = Locale(identifier: "ja_JP")
            //AppInfo情報をRealmに登録
            let setAppInfo = AppInfo()
            setAppInfo.hideFlag = 0
            setAppInfo.inputWordNum = 0
            setAppInfo.lasttimeDate = date.string(from: now)
            setAppInfo.inputTechnologyNum = 0
            setAppInfo.inputManagementNum = 0
            setAppInfo.inputStrategyNum = 0
            do {
                try realm.write {
                    realm.add(setAppInfo)
                }
            } catch {
            }
        }
    }
    
    //日付更新確認＆日付更新処理
    func dateCheck(){
        // RealmからAppInfo情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        //現在の日付を取得
        let now = Date()
        let date = DateFormatter()
        date.dateStyle = .short
        date.timeStyle = .none
        date.locale = Locale(identifier: "ja_JP")
        //日付の変更あり
        if(appInfo[0].lasttimeDate != date.string(from: now)){
            try! realm.write {
                //日付更新
                appInfo[0].lasttimeDate = date.string(from: now)
                //インプット単語数を初期化
                appInfo[0].inputWordNum = 0
                appInfo[0].inputTechnologyNum = 0
                appInfo[0].inputManagementNum = 0
                appInfo[0].inputStrategyNum = 0
            }
        }
    }
    
    //Tweet
    func tweet(){
        // RealmからAppInfo情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        //各分野の中からインプット数が最大のものを抽出
        var field:String = ""
        let maxField = [appInfo[0].inputTechnologyNum, appInfo[0].inputManagementNum, appInfo[0].inputStrategyNum]
        if(maxField.max() == 0){
            field = "本日は学習を行えていません、、、"
        }
        else if(maxField.max() == maxField[0]){
            field = "本日はテクノロジ分野を重点的に学習しました"
        }
        else if(maxField.max() == maxField[0]){
            field = "本日はマネジメント分野を重点的に学習しました"
        }
        else{
            field = "本日はストラテジ分野を重点的に学習しました"
        }
        //Tweet
        let text = "本日のインプット単語数：\(appInfo[0].inputWordNum)\n\(field)\nスキマ時間を有効活用！効率的に学習して単語を覚えよう！\n＃基本情報技術者単語帳\napps.apple.com/jp/app/id1529835420?mt=8"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //インプット単語数情報取得
    func getInputWordNum() -> Int{
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        
        return appInfo[0].inputWordNum
    }
    
    //インプット単語数(テクノロジ)情報取得
    func getInputTechnologyNum() -> Int{
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        
        return appInfo[0].inputTechnologyNum
    }
    
    //インプット単語数(マネジメント)情報取得
    func getInputManagementNum() -> Int{
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        
        return appInfo[0].inputManagementNum
    }
    
    //インプット単語数(ストラテジ)情報取得
    func getInputStrategyNum() -> Int{
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        
        return appInfo[0].inputStrategyNum
    }
    
    //非表示フラグ情報取得
    func getHideFlag() -> Int{
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        
        return appInfo[0].hideFlag
    }
    
    //非表示フラグ情報更新
    func setHideFlag(_ flag: Int){
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        //DB更新
        try! realm.write {
            appInfo[0].hideFlag = flag
        }
    }
    
    //インプット単語数インクリメント
    func incInputWordNum(_ field: Int){
        // Realmから該当情報取得
        let realm = try! Realm(configuration:config)
        let appInfo = realm.objects(AppInfo.self)
        //inputWordNumインクリメント
        let incInputWord = appInfo[0].inputWordNum + 1
        try! realm.write {
            appInfo[0].inputWordNum = incInputWord
        }
        //分野別インクリメント
        if(field < 13){
            //テクノロジ
            let incInputField = appInfo[0].inputTechnologyNum + 1
            try! realm.write {
                appInfo[0].inputTechnologyNum = incInputField
            }
        }
        else if(field < 16){
            //マネジメント
            let incInputField = appInfo[0].inputManagementNum + 1
            try! realm.write {
                appInfo[0].inputManagementNum = incInputField
            }
        }
        else{
            //ストラテジ
            let incInputField = appInfo[0].inputStrategyNum + 1
            try! realm.write {
                appInfo[0].inputStrategyNum = incInputField
            }
        }
    }
}
