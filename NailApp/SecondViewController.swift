//
//  SecondViewController.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/05.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBAction func fetch(sender: AnyObject) {
//        // クラスのNCMBObjectを作成
//        let obj3 = NCMBObject(className: "image")
//        // objectIdプロパティを設定
//        obj3.customerId = "***検索するデータのobjectId***"
//        // 設定されたobjectIdを元にデータストアからデータを取得
//        obj3.fetchInBackgroundWithBlock({(NSError error) in
//            if (error != nil) {
//                // 取得に失敗した場合の処理
//            }else{
//                // 取得に成功した場合の処理
//                // (例)取得したデータの出力
//                print(obj3)
//            }
//        })
    }
    @IBAction func relationButton(sender: AnyObject) {
        // リレーション元のオブジェクトを作成
        let post = NCMBObject(className: "Post")
        post.setObject("about mobile backend", forKey: "title")
        
        // リレーション先1のオブジェクトを作成
        let comment1 = NCMBObject(className: "Comment")
        comment1.setObject("good", forKey: "text")
        comment1.save(nil)
        
        // リレーション先2のオブジェクトを作成
        let comment2 = NCMBObject(className: "Comment")
        comment2.setObject("bad", forKey: "text")
        comment2.save(nil)
        
        // commentsフィールドにNCMBRelationを作成
        let relation = NCMBRelation(className: post, key: "comments")
        
        // リレーションオブジェクトを追加
        relation.addObject(comment1)
        relation.addObject(comment2)
        
        // リレーションを設定したオブジェクトを保存
        post.save(nil)
    }
    @IBAction func pointerButton(sender: AnyObject) {
        // childクラスを作成（keyフィールドにvalueの値を保存）
        let pointer = NCMBObject(className: "pointerTest")
        pointer.setObject("value", forKey : "key")
        pointer.save(nil)
        // objectクラスを作成
        let object = NCMBObject(className: "pointerTestParent")
        let carrentUser = NCMBUser.currentUser()
        // ポインターの設定
        object.setObject(carrentUser, forKey: "pointer")
        object.saveInBackgroundWithBlock({(error) in
            if (error != nil) {
                // 保存に失敗した場合の処理
                print("失敗")
            }else{
                // 保存に成功した場合の処理
                print("成功")
            }
        })
        
        
    }
    @IBAction func mailLogin(sender: AnyObject) {
        // メールアドレスとパスワードでログイン
        NCMBUser.logInWithMailAddressInBackground(userName.text, password: password.text, block: ({(user, error) in
            if (error != nil){
                // ログイン失敗時の処理
                let alertController = UIAlertController(title: "Sorry!", message: "ログイン失敗です。原因は謎。", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }else{
                // ログイン成功時の処理
                let alertController = UIAlertController(title: "Thank You!", message: "ログイン成功！", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: self.hiroki)
                
            }
        }))
    }
    @IBAction func mailAuth(sender: AnyObject) {
        var error : NSError? = nil
        NCMBUser.requestAuthenticationMail(userName.text, error: &error)
    }
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBAction func logout(sender: AnyObject) {
        NCMBUser.logOut()
    }
    @IBAction func login(sender: AnyObject) {
        
        
        // ユーザー名とパスワードでログイン
        NCMBUser.logInWithUsernameInBackground(userName.text, password: password.text, block:({(user, error) in
            if (error != nil){
                // ログイン失敗時の処理
                let alertController = UIAlertController(title: "Sorry!", message: "ログイン失敗です。原因は謎。", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }else{
                // ログイン成功時の処理
                let alertController = UIAlertController(title: "Thank You!", message: "ログイン成功！", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: self.hiroki)
                
            }
        }))
    }
    func hiroki() {
        print("hiroki")
    }
    @IBAction func registerUser(sender: AnyObject) {
        
        //NCMBUserのインスタンスを作成
        let user = NCMBUser()
        //ユーザー名を設定
        user.userName = userName.text
        //パスワードを設定
        user.password = password.text
        //会員の登録を行う
        user.signUpInBackgroundWithBlock({(error) in
            if (error != nil){
                // 新規登録失敗時の処理
                let alertController = UIAlertController(title: "Sorry!", message: "登録失敗です。原因は謎。", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }else{
                // 新規登録成功時の処理
                let alertController = UIAlertController(title: "Thank You!", message: "ご登録ありがとうございます！", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        password.resignFirstResponder()
        userName.resignFirstResponder()
    }

}

