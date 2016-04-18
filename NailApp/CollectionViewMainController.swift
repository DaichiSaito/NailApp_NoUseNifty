//
//  ViewController.swift
//  swifttest
//
//  Created by 乾 夏衣 on 2014/06/04.
//  Copyright (c) 2014年 K Inc. All rights reserved.
//

import UIKit

var data: [String] = []

class CollectionViewMainController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView : UICollectionView?
    var memoArray: NSArray = NSArray()
    var imageArray: NSMutableArray = NSMutableArray()
    var favDataArray: NSArray = NSArray()
    var cellRect: CGRect?
    var favFlg: Bool = false
    @IBOutlet weak var FavImage: UIImageView!
//    var favImageView = UIImageView()
    var imageInfo = []
    var userName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let query: NCMBQuery = NCMBQuery(className: "MemoClass")
//        query.orderByDescending("createDate")
//        try! self.memoArray = query.findObjects()
//        print("memoArray.countは" + String(self.memoArray.count))
//        
//        let queryFavData: NCMBQuery = NCMBQuery(className: "FavData")
//        // ここ自分のIDだけにしなきゃだめ
//        queryFavData.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
//            
//            if error == nil {
//                
//                if objects.count > 0 {
//                    
//                    self.favDataArray = objects
//                    
//                }
//                
//            } else {
//                print(error.localizedDescription)
//            }
//        })
        
//        //myUrlには自分で用意したphpファイルのアドレスを入れる
//        let myUrl = NSURL(string:"http://test.localhost/NailApp_NoUseNifty/loadFromMySql.php")
//        let request = NSMutableURLRequest(URL:myUrl!)
//        request.HTTPMethod = "POST"
//        // 会員IDはいったんなし。
////        let customerId = self.customerId.text;
//        // パラメータはnilでおけ。New側の処理だから最新のものから全部とってくるため。
//        let param = [
//            "customerId" : "1234"
//        ]
//        
//        do {
//            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(param, options: [])
//            
//        } catch {
//            
//        }
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            if error != nil {
//                print("error=\(error)")
//                return
//            }
//            // レスポンスを出力
//            print("******* response = \(response)")
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("****** response data = \(responseString!)")
//            //            var json:NSDictionary = [:]
//            do {
//                self.imageInfo = try NSJSONSerialization.JSONObjectWithData(data!,
//                                                                            options: NSJSONReadingOptions.MutableContainers) as! NSArray
//                // ここで再読み込みしないとCollectionViewが設定されない気がする。
//                // なぜならimageInfoは非同期で設定されるため。
//            } catch {
//                
//            }
//            print("-------")
//            print(self.imageInfo)
//            print((self.imageInfo[0]["imagePath"]))
//            
//            //            print(self.imageInfo)
//            //            imageInfo = json;
//            dispatch_async(dispatch_get_main_queue(),{
//                self.collectionView!.reloadData()
//            });
//        }
//        task.resume()
        
        
        loadImageData()

        
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
    //データのリロード
    func loadImageData() {
        
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
        
        let query: NCMBQuery = NCMBQuery(className: "image")
        if(userName == nil) {
            
        } else {
            query.whereKey("userName", equalTo: userName!)
            
        }
        query.orderByDescending("createDate")
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            
            if error == nil {
                
                if objects.count > 0 {
                    
                    self.imageInfo = objects
                    
                    //コレクションビューをリロードする
                    self.collectionView!.reloadData()
                }
                
            } else {
                print(error.localizedDescription)
            }
        })
        
    }
    // Favのリロード
//    func loadFav() {
//        
//        /**
//         * Just FYI
//         *
//         * Example: 文字列と一致する場合
//         * query.whereKey("title", equalTo: "xxx")
//         *
//         * メソッドのインターフェイスについて:
//         * NCMBQuery.hを参照するとNCMBQueryのインスタンスメソッドの引数にとるべき値等が見れます。
//         *
//         */
//        
//        let query: NCMBQuery = NCMBQuery(className: "Fav")
//        if(customerId == nil) {
//            
//        } else {
//            query.whereKey("customerId", equalTo: customerId!)
//            
//        }
//        query.orderByDescending("createDate")
//        query.findObjectsInBackgroundWithBlock({(objects, error) in
//            
//            if error == nil {
//                
//                if objects.count > 0 {
//                    
//                    self.imageInfo = objects
//                    
//                    //コレクションビューをリロードする
//                    self.collectionView!.reloadData()
//                }
//                
//            } else {
//                print(error.localizedDescription)
//            }
//        })
//        
//    }

    func loadFromMySql() {
        
        //myUrlには自分で用意したphpファイルのアドレスを入れる
        let myUrl = NSURL(string:"http://test.localhost/NailApp_NoUseNifty/loadFromMySql.php")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        // 会員IDはいったんなし。
        //        let customerId = self.customerId.text;
        // パラメータはnilでおけ。New側の処理だから最新のものから全部とってくるため。
        let param = [
            "userName" : "1234"
        ]
        //        let param = nil
        
        // これも不要かな。
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(param, options: [])
            
        } catch {
            
        }
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            // レスポンスを出力
            print("******* response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            //            var json:NSDictionary = [:]
            do {
                self.imageInfo = try NSJSONSerialization.JSONObjectWithData(data!,
                                                                            options: NSJSONReadingOptions.MutableContainers) as! NSArray
                // ここで再読み込みしないとCollectionViewが設定されない気がする。
                // なぜならimageInfoは非同期で設定されるため。
            } catch {
                
            }
            print("-------")
            print(self.imageInfo)
//            print((self.imageInfo[0]["imagePath"]))
            //            print(self.imageInfo)
            //            imageInfo = json;
            dispatch_async(dispatch_get_main_queue(),{
                
            });
        }
        task.resume()
    }
    //リフレッシュさせる
    func guruguru(sender:AnyObject) {
        sender.beginRefreshing()
//        let query: NCMBQuery = NCMBQuery(className: "MemoClass")
//        query.orderByDescending("createDate")
//        try! self.memoArray = query.findObjects()
//        print("memoArray.countは" + String(self.memoArray.count))
        // ここにmysqlからの再読み込み処理を書かないと。
        loadImageData()
//        collectionView!.reloadData()
        sender.endRefreshing()
    }
    //MARK: RefreshControl
//    func startLoading(refreshControl : UIRefreshControl) {
//        NSThread.detachNewThreadSelector("wait:", toTarget: self, withObject: refreshControl)
//    }
//    func wait(refreshControl : UIRefreshControl) {
//        // 2 sec
//        sleep(2)
//        dispatch_async(dispatch_get_main_queue()) {
//            refreshControl.endRefreshing()
//        }
//    }
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
//        for targetMemoData in self.memoArray {
//            let filename: String = (targetMemoData.objectForKey("filename") as? String)!
//            let fileData = NCMBFile.fileWithName(filename, data: nil) as! NCMBFile
//            
//            fileData.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError!) -> Void in
//                
//                if error != nil {
//                    print("写真の取得失敗: \(error)")
//                } else {
//                    let img = UIImage(data: imageData!)
//                    self.imageArray.addObject(img!)
//                }
//            }
//
//        }
//        print("self.imageArray.count")
//        print(self.imageArray.count)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageInfo.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        print("collectionViewの設定開始")
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MyCollectionViewCell
//        //各値をセルに入れる
//        let targetMemoData: AnyObject = self.memoArray[indexPath.row]
//        //画像データの取得
//        let filename: String = (targetMemoData.objectForKey("filename") as? String)!
//        let fileData = NCMBFile.fileWithName(filename, data: nil) as! NCMBFile
//        let fav: NSNumber = (targetMemoData.objectForKey("money") as? NSNumber)!
//        cell.labelSample.text = String(fav)
//        print(targetMemoData)
////        print(targetMemoData.objectForKey("money") as? String)
//        
//        fileData.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError!) -> Void in
//            
//            if error != nil {
//                print("写真の取得失敗: \(error)")
//            } else {
//                let img = UIImage(data: imageData!)
//                cell.image!.image = img
////                self.imageArray.addObject(img!)
//            }
//        }
////        cell.image!.image = imageArray[indexPath.row] as! UIImage
//        return cell
        
        print("collectionViewの設定開始")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MyCollectionViewCell
        //        //各値をセルに入れる
//        let targetImageData: NSDictionary = self.imageInfo[indexPath.row] as! NSDictionary
        let targetImageData = self.imageInfo[indexPath.row]
//        let url = NSURL(string: targetImageData["imagePath"] as! String)
//        let url = NSURL(fileURLWithPath: (targetImageData.objectForKey("imagePath") as? String)!)
        let url = NSURL(string: (targetImageData.objectForKey("imagePath") as? String)!)
        
        //        let url = NSURL(targetImageData
        let placeholder = UIImage(named: "transparent.png")
//        cell.image!.setImageWithURL(url, placeholderImage: placeholder)
        let imageView = UIImageView()
        imageView.frame = self.cellRect!
        cell.addSubview(imageView)
        imageView.setImageWithURL(url, placeholderImage: placeholder)
        // imageのAutoLayoutを解除してやる必要があるっぽい。
//        cell.image!.translatesAutoresizingMaskIntoConstraints = true
//        cell.image!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
//        cell.image!.layoutIfNeeded()
//        cell.contentView.translatesAutoresizingMaskIntoConstraints = true
//        var autoresizingMask: UIViewAutoresizing = [.FlexibleWidth, .FlexibleHeight]
//        cell.contentView.autoresizingMask = autoresizingMask;
//        cell.image!.autoresizingMask = autoresizingMask;
//        print("cell.image!.frame")
//        print(cell.image!.frame)
        print("cell.contentView.frame")
        print(cell.contentView.frame)
//        cell.contentView.frame = self.cellRect!
//        cell.image!.frame = self.cellRect!
//        print("cell.image!.frame")
//        print(cell.image!.frame)
        print("cell.contentView.frame")
        print(cell.contentView.frame)
//        cell.image!.frame = cell.contentView.frame
//        cell.FavImage.image = UIImage(named: "heart_unlike.png")
        
        
        // FavImageをコードで追加するよう修正
//        let favImageView = UIImageView()
        let rect:CGRect = CGRectMake(cell.contentView.frame.width/3*2, cell.contentView.frame.height/3*2, cell.contentView.frame.width/3, cell.contentView.frame.height/3)
        let rect2:CGRect = CGRectMake(61, 61, cell.contentView.bounds.width/3, cell.contentView.bounds.height/3)
        print("rect")
        print(rect)
        print("rect2")
        print(rect2)
        var favImageView = UIImageView()
//        self.favImageView.frame = rect
        favImageView.frame = rect
        cell.addSubview(favImageView)
        // didClickImageViewを有効化するための処理
        favImageView.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target:self, action:"didClickImageView:")
        favImageView.addGestureRecognizer(gesture)
        favImageView.tag = indexPath.row
//        self.favImageView.layer.position = CGPoint(x: cell.frame.width/3, y: 30)
        self.setInitFavImage(targetImageData, cell: cell, favImageView: favImageView)
        
//        cell.FavImage.userInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target:self, action:"didClickImageView:")
//        cell.FavImage.addGestureRecognizer(gesture)
//        cell.FavImage.tag = indexPath.row
//        self.setInitFavImage(targetImageData, cell: cell)
//        self.view.bringSubviewToFront(cell.FavImage) //FavImageを最前面へ
        
        return cell
        
        
    }
    func didClickImageView(recognizer: UIGestureRecognizer) {
        if var imageView = recognizer.view as? UIImageView {
//            let image = imageView.image
//            let nextViewController = /** 次のUIViewControllerのインスタンス */
//                nextViewController.image = iamge
            /** netViewController への遷移 */
            print("FavImage!!!!")
            print(imageView.tag)
//            imageView.image = UIImage(named: "heart_like.png")
            if(NCMBUser.currentUser() == nil) {
                print("ログインせよ")
                return
            }
            let targetFavData: AnyObject = self.imageInfo[imageView.tag]
            updateFavData(targetFavData, imageView: imageView)
            
        }
    }
    func setInitFavImage(targetFavData: AnyObject, cell: MyCollectionViewCell, favImageView: UIImageView) {
        print(targetFavData)
        // imageのobjectIdを取得。
        let objectIdOfImageInfo = targetFavData.objectForKey("objectId")!
        // imageのcustomerIdを取得。
//        let customerIdOfImageInfo = targetFavData.objectForKey("customerId")!
        
        // nifty_cloudのFavテーブルオブジェクトを取得。
        let queryFav: NCMBQuery = NCMBQuery(className: "Fav")
        // imageのobjectIdとFavのimageObjectIdが一致するものを抽出
        // つまり、タップしたimageに対応するレコードがFavにあるかどうか。
        queryFav.whereKey("imageObjectId", equalTo: objectIdOfImageInfo)
//        queryFav.whereKey("customerId", equalTo: customerIdOfImageInfo)
        // ログイン中のユーザーの取得
        let carrentUser = NCMBUser.currentUser()
        if(carrentUser != nil) {
            let userName = carrentUser.userName
            queryFav.whereKey("userName", equalTo: userName)
        }
        queryFav.findObjectsInBackgroundWithBlock({(items, error) in
            
            if error == nil {
                print("登録件数：\(items.count)")
                var saveError: NSError? = nil
                // items.countは1か0しかない。
                if items.count > 0 {
                    let favFlg: Bool = ((items[0].objectForKey("favFlg") as? Bool))!
//                    self.favFlg = favFlg
//                    // favFlgをself.imageInfoに追加してあげたほうが後々楽かも。
//                    targetFavData.favFlg = favFlg
                    if (favFlg) {
//                        cell.FavImage.image = UIImage(named: "heart_like.png")
                        favImageView.image = UIImage(named: "heart_like.png")
//                        self.favFlg = true // ここじゃ全然ダメ
                        
                    } else {
//                        cell.FavImage.image = UIImage(named: "heart_unlike.png")
                        favImageView.image = UIImage(named: "heart_unlike.png")
//                        self.favFlg = false // ここじゃ全然ダメ
                    }
//                    // Favに保存するためのオブジェクト生成
//                    let objFav: NCMBObject = NCMBObject(className: "Fav")
//                    // objectId
//                    let objectId: String = (items[0].objectForKey("objectId") as? String)!
//                    // favFlg
//                    let favFlg: Bool = ((items[0].objectForKey("favFlg") as? Bool))!
//                    // customerId
//                    //                    let customerId: String = (items[0].objectForKey("customerId") as? String)!
//                    // プロパティ設定
//                    objFav.objectId = objectId
//                    objFav.fetchInBackgroundWithBlock({(error) in
//                        
//                        if (error == nil) {
//                            if (favFlg) {
////                                return UIImage(named: "heart_like.png")
//                                cell.FavImage.image = UIImage(named: "heart_like.png")
//                            } else {
////                                return UIImage(named: "heart_unlike.png")
//                                cell.FavImage.image = UIImage(named: "heart_unlike.png")
//                            }
////                            // favFlgの反対を設定
////                            objFav.setObject(!favFlg, forKey: "favFlg")
////                            // 保存
////                            objFav.save(&saveError)
//                            // 画像の変更
//                        } else {
//                            print("データ取得処理時にエラーが発生しました: \(error)")
//                        }
//                    })
                    // MemoClassのカワイイネの数も更新
                    //                    let objMemoClass: NCMBObject = NCMBObject(className: "MemoClass")
                    //                    objMemoClass.objectId = objectIdOfMemoClass as! String
                    //                    objMemoClass.fetchInBackgroundWithBlock({(NSError error) in
                    //                        if (error == nil) {
                    //                            if (favFlg) {
                    //                                objMemoClass.incrementKey("money",byAmount: -1)
                    //                            } else {
                    //                                objMemoClass.incrementKey("money",byAmount: 1)
                    //                            }
                    //                            objMemoClass.save(&saveError)
                    //
                    //                        } else {
                    //                            print("データ取得処理時にエラーが発生しました: \(error)")
                    //                        }
                    //                    })
                    
                    // いいねおしてない場合
                } else {
//                    let objFav: NCMBObject = NCMBObject(className: "Fav")
//                    objFav.setObject(targetFavData.objectForKey("objectId"), forKey: "imageObjectId")
//                    objFav.setObject(targetFavData.objectForKey("customerId"), forKey: "customerId")
//                    objFav.setObject(true, forKey: "favFlg")
//                    objFav.save(&saveError)
//                    cell.FavImage.image = UIImage(named: "heart_unlike.png")
                    favImageView.image = UIImage(named: "heart_unlike.png")
                    
                    //                    let objMemoClass: NCMBObject = NCMBObject(className: "MemoClass")
                    //                    objMemoClass.objectId = objectIdOfMemoClass as! String
                    //                    objMemoClass.fetchInBackgroundWithBlock({(NSError error) in
                    //
                    //                        if (error == nil) {
                    //                            objMemoClass.incrementKey("money",byAmount: 1)
                    //                            objMemoClass.save(&saveError)
                    //                            
                    //                        } else {
                    //                            print("データ取得処理時にエラーが発生しました: \(error)")
                    //                        }
                    //                    })
                    
                    
                }
            }
            
            
        })
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        let width: CGFloat = self.view.frame.width / 2
        
//        let width: CGFloat = self.view.frame.width / 3 - 2
        // 3カラム
        let width: CGFloat = super.view.frame.width / 3 - 6
//        let width: CGFloat = super.view.frame.width
        print(width)
        let height: CGFloat = width
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MyCollectionViewCell
        let rect:CGRect = CGRectMake(0, 0, width, height)

//        cell.image!.frame = rect
        self.cellRect = rect
        return CGSize(width: width, height: height) // The size of one cell
        
    }
    //Cellがクリックされた時によばれます
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("選択しました: \(indexPath.row)")
        
        
//        print(memoArray[indexPath.row])

//        let targetMemoData: AnyObject = self.memoArray[indexPath.row]
        // ユーザーに紐づくfavFlgをみて更新する
//        updateFavData(targetMemoData)
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
//    // Favを更新。（かわいいねの数やハート画像の更新）
    func updateFavData(targetFavData: AnyObject, imageView: UIImageView) {
        print(targetFavData)
        // imageのobjectIdを取得。
        let objectIdOfImageInfo = targetFavData.objectForKey("objectId")!
        // imageのcustomerIdを取得。
        let userNameOfImageInfo = targetFavData.objectForKey("userName")!
        // ログイン中のユーザーの取得
        let carrentUser = NCMBUser.currentUser()
        let userName = carrentUser.userName
        // nifty_cloudのFavテーブルオブジェクトを取得。
        let queryFav: NCMBQuery = NCMBQuery(className: "Fav")
        // imageのobjectIdとFavのimageObjectIdが一致するものを抽出
        // つまり、タップしたimageに対応するレコードがFavにあるかどうか。
        queryFav.whereKey("imageObjectId", equalTo: objectIdOfImageInfo)
//        queryFav.whereKey("customerId", equalTo: customerIdOfImageInfo)
        queryFav.whereKey("userName", equalTo: userName)
        queryFav.findObjectsInBackgroundWithBlock({(items, error) in

            if error == nil {
                print("登録件数：\(items.count)")
                var saveError: NSError? = nil
                // items.countは1か0しかない。
                if items.count > 0 {
                    // Favに保存するためのオブジェクト生成
                    let objFav: NCMBObject = NCMBObject(className: "Fav")
                    // objectId
                    let objectId: String = (items[0].objectForKey("objectId") as? String)!
                    // favFlg
                    let favFlg: Bool = ((items[0].objectForKey("favFlg") as? Bool))!
                    // customerId
//                    let customerId: String = (items[0].objectForKey("customerId") as? String)!
                    // 画像の変更
                    if (favFlg) {
                        imageView.image = UIImage(named: "heart_unlike.png")
                        // imageコレクション内のkawaiine数も更新
                        let objImage: NCMBObject = NCMBObject(className: "image")
                        objImage.objectId = objectIdOfImageInfo as! String
                        objImage.fetchInBackgroundWithBlock({(error) in
                            var saveError: NSError? = nil
                            if (error == nil) {
                                objImage.incrementKey("kawaiine",byAmount: -1)
                                objImage.save(&saveError)
                            } else {
                                print("kawaiine保存時にエラーが発生しました: \(error)")
                            }
                        })
                        
                    } else {
                        imageView.image = UIImage(named: "heart_like.png")
                        // imageコレクション内のkawaiine数も更新
                        let objImage: NCMBObject = NCMBObject(className: "image")
                        objImage.objectId = objectIdOfImageInfo as! String
                        objImage.fetchInBackgroundWithBlock({(error) in
                            var saveError: NSError? = nil
                            if (error == nil) {
                                objImage.incrementKey("kawaiine",byAmount: 1)
                                objImage.save(&saveError)
                            } else {
                                print("kawaiine保存時にエラーが発生しました: \(error)")
                            }
                        })
                    }
                    // プロパティ設定
                    objFav.objectId = objectId
                    objFav.fetchInBackgroundWithBlock({(error) in
                            
                        if (error == nil) {
                            
                            
                            // favFlgの反対を設定
                            objFav.setObject(!favFlg, forKey: "favFlg")
                            // 保存
                            objFav.save(&saveError)
                            
                        } else {
                            print("データ取得処理時にエラーが発生しました。!fav: \(error)")
                        }
                    })
                    // MemoClassのカワイイネの数も更新
//                    let objMemoClass: NCMBObject = NCMBObject(className: "MemoClass")
//                    objMemoClass.objectId = objectIdOfMemoClass as! String
//                    objMemoClass.fetchInBackgroundWithBlock({(NSError error) in
//                        if (error == nil) {
//                            if (favFlg) {
//                                objMemoClass.incrementKey("money",byAmount: -1)
//                            } else {
//                                objMemoClass.incrementKey("money",byAmount: 1)
//                            }
//                            objMemoClass.save(&saveError)
//                            
//                        } else {
//                            print("データ取得処理時にエラーが発生しました: \(error)")
//                        }
//                    })

                // 初めてかわいいねを押す場合
                } else {
                    let objFav: NCMBObject = NCMBObject(className: "Fav")
                    objFav.setObject(targetFavData.objectForKey("objectId"), forKey: "imageObjectId")
//                    objFav.setObject(targetFavData.objectForKey("customerId"), forKey: "customerId")
                    objFav.setObject(userName, forKey: "userName")
                    objFav.setObject(true, forKey: "favFlg")
                    objFav.save(&saveError)
                    
                    
                    // 画像の設定
                    imageView.image = UIImage(named: "heart_like.png")
//                    let objMemoClass: NCMBObject = NCMBObject(className: "MemoClass")
//                    objMemoClass.objectId = objectIdOfMemoClass as! String
//                    objMemoClass.fetchInBackgroundWithBlock({(NSError error) in
//                        
//                        if (error == nil) {
//                            objMemoClass.incrementKey("money",byAmount: 1)
//                            objMemoClass.save(&saveError)
//                            
//                        } else {
//                            print("データ取得処理時にエラーが発生しました: \(error)")
//                        }
//                    })

                    
                }
            }
            
            
        })
//        // imageコレクション内のkawaiine数も更新
//        //                    let objMemoClass: NCMBObject = NCMBObject(className: "MemoClass")
//        let objImage: NCMBObject = NCMBObject(className: "image")
//        // imageのを取得。
////        let customerIdOfImageInfo = targetFavData.objectForKey("customerId")!
////
//        objImage.objectId = objectIdOfImageInfo as! String
//        objImage.fetchInBackgroundWithBlock({(error) in
//            var saveError: NSError? = nil
//            if (error == nil) {
//                if (self.favFlg) {
//                    objImage.incrementKey("kawaiine",byAmount: -1)
//                } else {
//                    objImage.incrementKey("kawaiine",byAmount: 1)
//                }
//                objImage.save(&saveError)
//
//            } else {
//                print("kawaiine保存時にエラーが発生しました: \(error)")
//            }
//        })

        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPathForCell(cell)
        let controller = segue.destinationViewController as! DetailViewController
        controller.indexPath = indexPath!
        controller.imageInfo = self.imageInfo

        
    }
    
}

