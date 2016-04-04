//
//  SecondViewController.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/05.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var customerId: UITextField!
    @IBAction func logout(sender: AnyObject) {
        NCMBUser.logOut()
    }
    @IBAction func login(sender: AnyObject) {
        
        
        // ユーザー名とパスワードでログイン
        NCMBUser.logInWithUsernameInBackground(customerId.text, password: password.text, block:({(user, error) in
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
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }))
    }
    @IBAction func registerUser(sender: AnyObject) {
        
        //NCMBUserのインスタンスを作成
        let user = NCMBUser()
        //ユーザー名を設定
        user.userName = customerId.text
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


}

