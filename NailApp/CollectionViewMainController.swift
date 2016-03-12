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
        
        let refreshControl = UIRefreshControl()
        //下に引っ張った時に、リフレッシュさせる関数を実行する。”：”を忘れがちなので注意。
        refreshControl.addTarget(self, action: "guruguru:", forControlEvents: UIControlEvents.ValueChanged)
        //UICollectionView上に、ロード中...を表示するための新しいビューを作る
        self.collectionView?.addSubview(refreshControl)
        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "startLoading:", forControlEvents: UIControlEvents.ValueChanged)
//        collectionView?.addSubview(refreshControl)

    }
    
    //リフレッシュさせる
    func guruguru(sender:AnyObject) {
        sender.beginRefreshing()
        let query: NCMBQuery = NCMBQuery(className: "MemoClass")
        query.orderByDescending("createDate")
        try! self.memoArray = query.findObjects()
        print("memoArray.countは" + String(self.memoArray.count))
        collectionView!.reloadData()
        sender.endRefreshing()
    }
    //MARK: RefreshControl
    func startLoading(refreshControl : UIRefreshControl) {
        NSThread.detachNewThreadSelector("wait:", toTarget: self, withObject: refreshControl)
    }
    func wait(refreshControl : UIRefreshControl) {
        // 2 sec
        sleep(2)
        dispatch_async(dispatch_get_main_queue()) {
            refreshControl.endRefreshing()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        print(self.view.bounds.size.width)
//        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.bounds.size.width, self.view.frame.size.height)
//        self.view.setTranslatesAutoresizingMaskIntoConstraints(true)

//        self.view.frame = CGRectMake(0,0,414,100)
//        //UIRefreshControllのインスタンスを生成する。
//        let refreshControl = UIRefreshControl()
//        //下に引っ張った時に、リフレッシュさせる関数を実行する。”：”を忘れがちなので注意。
//        refreshControl.addTarget(self, action: "guruguru:", forControlEvents: UIControlEvents.ValueChanged)
//        //UICollectionView上に、ロード中...を表示するための新しいビューを作る
//        self.view.addSubview(refreshControl)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        
//        let width: CGFloat = self.view.frame.width / 3 - 2
//        let width: CGFloat = self.view.frame.width / 3 - 2
        let width: CGFloat = super.view.frame.width / 3 - 6
        print(width)
        let height: CGFloat = width
        return CGSize(width: width, height: height) // The size of one cell
        
    }
    //Cellがクリックされた時によばれます
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("選択しました: \(indexPath.row)")
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        if let indexPath = self.collectionView?.indexPathsForSelectedItems {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPathForCell(cell)
        let controller = segue.destinationViewController as! DetailViewController
        controller.indexPath = indexPath!
        controller.memoArray = self.memoArray
//
//        }
        
    }
    
}

