//
//  ViewController.swift
//  swifttest
//
//  Created by 乾 夏衣 on 2014/06/04.
//  Copyright (c) 2014年 K Inc. All rights reserved.
//

import UIKit

var data: [String] = []

class CollectionViewMainController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView : UICollectionView?
    var memoArray: NSArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query: NCMBQuery = NCMBQuery(className: "MemoClass")
        query.orderByDescending("createDate")
        try! self.memoArray = query.findObjects()
        print("memoArray.countは" + String(self.memoArray.count))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.memoArray.count
        return self.memoArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("collectionViewの設定開始")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MyCollectionViewCell
        //各値をセルに入れる
        let targetMemoData: AnyObject = self.memoArray[indexPath.row]
        //画像データの取得
        let filename: String = (targetMemoData.objectForKey("filename") as? String)!
        let fileData = NCMBFile.fileWithName(filename, data: nil) as! NCMBFile
        
        fileData.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError!) -> Void in
            
            if error != nil {
                print("写真の取得失敗: \(error)")
            } else {
                cell.image!.image = UIImage(data: imageData!)
            }
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width: CGFloat = self.view.frame.width / 3 - 2
        let height: CGFloat = width
        return CGSize(width: width, height: height) // The size of one cell
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

