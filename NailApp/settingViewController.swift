//
//  FirstViewController.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/05.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit

class settingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear_settingViewController")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //        let cell = sender as! UICollectionViewCell
        //        let indexPath = self.collectionView!.indexPathForCell(cell)
        //        let controller = segue.destinationViewController as! DetailViewController
        //        controller.indexPath = indexPath!
        //        controller.imageInfo = self.imageInfo
//        let controller = segue.destinationViewController as! DetailUserController
//        //        controller.customerId = self.imageInfo?.objectForKey("customerId") as! String
//        //        controller.tmpCustomerId = self.imageInfo?.objectForKey("customerId") as! String
//        //        controller.tmpUserName = self.imageInfo?.objectForKey("customerId") as! String
//        let carrentUser = NCMBUser.currentUser()
//        print("carrentUser")
//        print(carrentUser)
//        controller.tmpCustomerId = carrentUser.userName
//        controller.tmpUserName = carrentUser.userName
        
        
    }
    //Table Viewのセルの数を指定
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    //各セルの要素を設定する
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
//        let img = UIImage(named:"\(imgArray[indexPath.row])")
        // Tag番号 1 で UIImageView インスタンスの生成
//        let imageView = table.viewWithTag(1) as! UIImageView
//        imageView.image = img
        
        // Tag番号 ２ で UILabel インスタンスの生成
        let label1 = table.viewWithTag(2) as! UILabel
        label1.text = "No.\(indexPath.row + 1)"
        
        // Tag番号 ３ で UILabel インスタンスの生成
//        let label2 = table.viewWithTag(3) as! UILabel
//        label2.text = "\(label2Array[indexPath.row])"
        
        
        return cell
    }
}

