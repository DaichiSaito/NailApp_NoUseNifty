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
    var imageArray: NSMutableArray = NSMutableArray()
    var favDataArray: NSArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query: NCMBQuery = NCMBQuery(className: "MemoClass")
        query.orderByDescending("createDate")
        try! self.memoArray = query.findObjects()
        print("memoArray.countは" + String(self.memoArray.count))
        
        let queryFavData: NCMBQuery = NCMBQuery(className: "FavData")
        // ここ自分のIDだけにしなきゃだめ
        queryFavData.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
            
            if error == nil {
                
                if objects.count > 0 {
                    
                    self.favDataArray = objects
                    
                }
                
            } else {
                print(error.localizedDescription)
            }
        })

        
        let refreshControl = UIRefreshControl()
        //下に引っ張った時に、リフレッシュさせる関数を実行する。”：”を忘れがちなので注意。
        refreshControl.addTarget(self, action: "guruguru:", forControlEvents: UIControlEvents.ValueChanged)
        //UICollectionView上に、ロード中...を表示するための新しいビューを作る
        self.collectionView?.addSubview(refreshControl)
        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "startLoading:", forControlEvents: UIControlEvents.ValueChanged)
//        collectionView?.addSubview(refreshControl)

//        setImages()
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
    
    func setImages() {
        for targetMemoData in self.memoArray {
            let filename: String = (targetMemoData.objectForKey("filename") as? String)!
            let fileData = NCMBFile.fileWithName(filename, data: nil) as! NCMBFile
            
            fileData.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError!) -> Void in
                
                if error != nil {
                    print("写真の取得失敗: \(error)")
                } else {
                    let img = UIImage(data: imageData!)
                    self.imageArray.addObject(img!)
                }
            }

        }
        print("self.imageArray.count")
        print(self.imageArray.count)
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
        let fav: NSNumber = (targetMemoData.objectForKey("money") as? NSNumber)!
        cell.labelSample.text = String(fav)
        print(targetMemoData)
//        print(targetMemoData.objectForKey("money") as? String)
        
        fileData.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError!) -> Void in
            
            if error != nil {
                print("写真の取得失敗: \(error)")
            } else {
                let img = UIImage(data: imageData!)
                cell.image!.image = img
//                self.imageArray.addObject(img!)
            }
        }
//        cell.image!.image = imageArray[indexPath.row] as! UIImage
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
        print(memoArray[indexPath.row])

        let targetMemoData: AnyObject = self.memoArray[indexPath.row]
        // ユーザーに紐づくfavFlgをみて更新する
        updateFavData(targetMemoData)
//        //選択した画像のプロパティの取得
//        let objectId: String = (targetMemoData.objectForKey("objectId") as? String)!
////        let favFlg: Bool = ((targetMemoData.objectForKey("favFlg") as? Bool))!
//        var saveError: NSError? = nil
//        let obj: NCMBObject = NCMBObject(className: "MemoClass")
//        obj.objectId = objectId
//        obj.fetchInBackgroundWithBlock({(NSError error) in
//            
//            if (error == nil) {
//                
//                if (favFlg) {
//                    obj.incrementKey("money",byAmount: 1)
//                } else {
//                    obj.incrementKey("money",byAmount: -1)
//                }
//                obj.save(&saveError)
//                
//            } else {
//                print("データ取得処理時にエラーが発生しました: \(error)")
//            }
//        })
        
        //ファイルは更新があった際のみバックグラウンドで保存する
//        if targetFile.name != self.targetFileName {
//            
//            targetFile.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
//                
//                if error == nil {
//                    print("画像データ保存完了: \(targetFile.name)")
//                } else {
//                    print("アップロード中にエラーが発生しました: \(error)")
//                }
//                
//                }, progressBlock: { (percentDone: Int32) -> Void in
//                    
//                    // 進捗状況を取得します。保存完了まで何度も呼ばれます
//                    print("進捗状況: \(percentDone)% アップロード済み")
//            })
//        }
        
//        if saveError == nil {
//            print("success save data.")
//        } else {
//            print("failure save data. \(saveError)")
//        }

//        let targetFile = NCMBObject.objectWithClassName("MemoClass", objectId1) as! NCMBObject
//        //新規データを1件登録する
//        var saveError: NSError? = nil
//        let obj: NCMBObject = NCMBObject(className: "MemoClass")
//        obj.setObject("title!", forKey: "title")
//        obj.setObject(targetFile.name, forKey: "filename")
//        obj.setObject(800, forKey: "money")
//        obj.setObject("comment!", forKey: "comment")
//        obj.save(&saveError)
//        
//        //ファイルはバックグラウンド実行をする
//        targetFile.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
//            
//            if error == nil {
//                print("画像データ保存完了: \(targetFile.name)")
//            } else {
//                print("アップロード中にエラーが発生しました: \(error)")
//            }
//            
//            }, progressBlock: { (percentDone: Int32) -> Void in
//                
//                // 進捗状況を取得します。保存完了まで何度も呼ばれます
//                print("進捗状況: \(percentDone)% アップロード済み")
//        })
//        
//        if saveError == nil {
//            print("success save data.")
//        } else {
//            print("failure save data. \(saveError)")
//        }

        
        
        
    }
    func updateFavData(targetMemoData: AnyObject) {
        print(targetMemoData)
        let filename = targetMemoData.objectForKey("filename")!
        let objectIdOfMemoClass = targetMemoData.objectForKey("objectId")!
        print(filename)

        // ファイル名で検索
        let queryFavData: NCMBQuery = NCMBQuery(className: "FavData")
        queryFavData.whereKey("filename", equalTo: filename)
        queryFavData.findObjectsInBackgroundWithBlock({(NSArray items, NSError error) in

            
            if error == nil {
                print("登録件数：\(items.count)")
                var saveError: NSError? = nil
                if items.count > 0 {
                    let objFavData: NCMBObject = NCMBObject(className: "FavData")
                    let objectId: String = (items[0].objectForKey("objectId") as? String)!
                    let favFlg: Bool = ((items[0].objectForKey("favFlg") as? Bool))!
                    objFavData.objectId = objectId
                    objFavData.fetchInBackgroundWithBlock({(NSError error) in
                            
                        if (error == nil) {
                            objFavData.setObject(!favFlg, forKey: "favFlg")
                            objFavData.save(&saveError)
                            
                        } else {
                            print("データ取得処理時にエラーが発生しました: \(error)")
                        }
                    })
                    
//                    var saveError: NSError? = nil
                    let objMemoClass: NCMBObject = NCMBObject(className: "MemoClass")
                    objMemoClass.objectId = objectIdOfMemoClass as! String
                    objMemoClass.fetchInBackgroundWithBlock({(NSError error) in
                        
                        if (error == nil) {
                            
                            if (favFlg) {
                                objMemoClass.incrementKey("money",byAmount: -1)
                            } else {
                                objMemoClass.incrementKey("money",byAmount: 1)
                            }
                            objMemoClass.save(&saveError)
                            
                        } else {
                            print("データ取得処理時にエラーが発生しました: \(error)")
                        }
                    })


                } else {
                    let objFavData: NCMBObject = NCMBObject(className: "FavData")
                    objFavData.setObject(targetMemoData.objectForKey("filename"), forKey: "filename")
                    objFavData.setObject(true, forKey: "favFlg")
                    objFavData.save(&saveError)
                    
                    let objMemoClass: NCMBObject = NCMBObject(className: "MemoClass")
                    objMemoClass.objectId = objectIdOfMemoClass as! String
                    objMemoClass.fetchInBackgroundWithBlock({(NSError error) in
                        
                        if (error == nil) {
                            objMemoClass.incrementKey("money",byAmount: 1)
                            objMemoClass.save(&saveError)
                            
                        } else {
                            print("データ取得処理時にエラーが発生しました: \(error)")
                        }
                    })

                    
                }
            }
            
            
        })
//        // あれば更新なければ新規インサート
//        var saveError: NSError? = nil
//        let obj: NCMBObject = NCMBObject(className: "FavData")
//        obj.setObject(targetMemoData.objectForKey("filename"), forKey: "filename")
//        obj.setObject(true, forKey: "favFlg")
//        obj.save(&saveError)
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
//        controller.imageArray = self.imageArray
//
//        }
        
    }
    
}

