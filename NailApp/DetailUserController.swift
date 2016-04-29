//
//  ViewController.swift
//  ZDT_InstaTutorial
//
//  Created by Sztanyi Szabolcs on 22/12/15.
//  Copyright © 2015 Zappdesigntemplates. All rights reserved.
//

import UIKit

class DetailUserController: UIViewController {
    
    
    @IBAction func editProfileButton(sender: AnyObject) {
    }
    @IBOutlet weak var editProfileButtonOutlet: UIButton!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var ProfileComment: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var tmpCustomerId: String?
    var tmpUserName: String?
    var tmpNickName: String?
    var imageInfo = []
    var ownORotherFlg: String? // "1"が自分のプロフィール表示時。"2"が他人のプロフィール表示時
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setProfile()
//        getProfileImagePath()
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.setProfile()
        if (ownORotherFlg == "2") {
            self.editProfileButtonOutlet.hidden = true
        }
        
    }
    
    func setProfile() {
        nickName.text = self.tmpNickName
        let userQuery = NCMBUser.query()
        userQuery.whereKey("userName", equalTo: self.tmpUserName)
        userQuery.findObjectsInBackgroundWithBlock({(items, error) in
            
            if error == nil {
                print("登録件数：\(items.count)")
                // items.countは1か0しかない。
                if items.count > 0 {
                    let comment: String = ((items[0].objectForKey("comment") as? String))!
                    let nickName: String = ((items[0].objectForKey("nickName") as? String))!
                    let imagePath: String = ((items[0].objectForKey("imagePath") as? String))!
                    self.ProfileComment.text = comment
                    self.nickName.text = nickName
                    
                    let url = NSURL(string: imagePath)
                    let placeholder = UIImage(named: "transparent.png")
                    self.profileImage.setImageWithURL(url, placeholderImage: placeholder)
                    
                } else {
                    
                    
                }
            }
            
            
        })

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
        if (segue.identifier == "segueToEdit") {
            // プロフィール編集処理画面遷移時
            let controller = segue.destinationViewController as! editProfileViewController
            controller.tmpNickName = self.nickName.text
            controller.tmpProfileComment = self.ProfileComment.text
            
        } else if (segue.identifier == "segueToCollectionView") {
            let controller = segue.destinationViewController as! CollectionViewMainController
            controller.userName = tmpUserName!
        }

        
    }
    func setProfileImage() {
        print("setProfileImageの設定開始")
        //        //各値をセルに入れる
        let targetImageData = self.imageInfo[0]
        let url = NSURL(string: (targetImageData.objectForKey("imagePath") as? String)!)
        let placeholder = UIImage(named: "transparent.png")
        self.profileImage.setImageWithURL(url, placeholderImage: placeholder)
//        profileImage.layer.cornerRadius = 40
        
    }
    func getProfileImagePath() {
        /**
         * Just FYI
         *
         * Example: 文字列と一致する場合
         * query.whereKey("title", equalTo: "xxx")
         *
         * メソッドのインターフェイスについて:
         * NCMBQuery.hを参照するとNCMBQueryのインスタンスメソッドの引数にとるべき値等が見れます。
         *
         */
        
        let query: NCMBQuery = NCMBQuery(className: "profileImage")
        if(self.tmpUserName == nil) {
            
        } else {
            query.whereKey("userName", equalTo: self.tmpUserName!)
            
        }
        query.orderByDescending("createDate")
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            
            if error == nil {
                
                if objects.count > 0 {
                    
                    self.imageInfo = objects
                    self.setProfileImage()
                }
                
            } else {
                print(error.localizedDescription)
            }
        })

    }
}
