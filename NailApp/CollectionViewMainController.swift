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
    var orderByKey: String?
    @IBOutlet weak var FavImage: UIImageView!
    var imageInfo = []
    var userName: String?
    // "0" -> 初期値
    // "1" -> New
    // "2" -> Popular
    // "3" -> Favorite
    var tabKindSign = "0" as String
//    init(tabKind: String) {
//        
//    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // memoArrayとindexPathを引数に持つinit
//    init(_tabKind: String) {
//        super.init(nibName: nil, bundle: nil)
//        if (_tabKind == "1") {
//            self.orderByKey = "createDate"
//        } else if (_tabKind == "2") {
//            self.orderByKey = "kawaiine"
//        }
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImageData()
        
        let refreshControl = UIRefreshControl()
        //下に引っ張った時に、リフレッシュさせる関数を実行する。”：”を忘れがちなので注意。
        refreshControl.addTarget(self, action: "guruguru:", forControlEvents: UIControlEvents.ValueChanged)
        //UICollectionView上に、ロード中...を表示するための新しいビューを作る
        self.collectionView?.addSubview(refreshControl)
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
        var query: NCMBQuery?
        let currentuser = NCMBUser.currentUser()
        if (tabKindSign == "0") {
            query = NCMBQuery(className: "image")
            query!.whereKey("userName", equalTo: userName!)
            query!.orderByDescending("createDate")
        } else if (tabKindSign == "1") {
            query = NCMBQuery(className: "image")
            query!.orderByDescending(self.orderByKey!)
        } else if (tabKindSign == "2") {
            query = NCMBQuery(className: "image")
            query!.orderByDescending(self.orderByKey!)
        } else if (tabKindSign == "3") {
            query = NCMBQuery(className: "Fav")
            // ここ要修正。curentuserがnilの場合を考慮できていない。
            // nilの場合というのはログインしていない場合
            // つまりログインしてねのダイアログ表示が必要。
            // TODO(4/25記載)
            // 解決(x/xx)
            query!.whereKey("myName", equalTo: currentuser.userName)
            query!.orderByDescending(self.orderByKey!)
        }
//        if(userName == nil) {
//            query.orderByDescending(self.orderByKey!)
//            if (self.tabKindSign == "3") {
//                query.whereKey("userName", equalTo: userName!)
//            }
//            
//        } else {
//            // userNameがnilじゃない場合というのは、DetailUserViewControllerの場合なはず。
//            query.whereKey("userName", equalTo: userName!)
//            query.orderByDescending("createDate")
//            
//        }
//        query.orderByDescending("createDate")
//        query.orderByDescending("kawaiine")
//        query.orderByDescending(self.orderByKey!)
        query!.findObjectsInBackgroundWithBlock({(objects, error) in
            
            if error == nil {
                
                if objects.count > 0 {
                    
                    self.imageInfo = objects
                    
                    //コレクションビューをリロードする
                    self.collectionView!.reloadData()
                }
                
            } else {
                print("エラー")
                print(error.localizedDescription)
            }
        })
        
    }

    //リフレッシュさせる
    func guruguru(sender:AnyObject) {
        sender.beginRefreshing()
        loadImageData()
        sender.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
//        print(self.view.bounds.size.width)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageInfo.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("collectionViewの設定開始")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MyCollectionViewCell
        //        //各値をセルに入れる
        let targetImageData = self.imageInfo[indexPath.row]
        let url = NSURL(string: (targetImageData.objectForKey("imagePath") as? String)!)
        
        let placeholder = UIImage(named: "transparent.png")
        let imageView = UIImageView()
        imageView.frame = self.cellRect!
//        print(self.cellRect!)
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
        
        
        // FavImageをコードで追加するよう修正
//        let favImageView = UIImageView()
        let rect:CGRect = CGRectMake(cell.contentView.frame.width/3*2, cell.contentView.frame.height/3*2, cell.contentView.frame.width/3, cell.contentView.frame.height/3)
        let favImageView = UIImageView()
        favImageView.frame = rect
        cell.addSubview(favImageView)
        // didClickImageViewを有効化するための処理
        favImageView.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target:self, action:#selector(CollectionViewMainController.didClickImageView(_:)))
        favImageView.addGestureRecognizer(gesture)
        favImageView.tag = indexPath.row
        self.setInitFavImage(targetImageData, cell: cell, favImageView: favImageView)
        return cell
        
        
    }
    func didClickImageView(recognizer: UIGestureRecognizer) {
        if let imageView = recognizer.view as? UIImageView {

            /** netViewController への遷移 */
            print("FavImage!!!!")
            if(NCMBUser.currentUser() == nil) {
                print("ログインせよ")
                // 未ログインの場合はポップアップを出して処理終了
                let alertController = UIAlertController(title: "Sorry!", message: "カワイイネをするには会員になってね", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            let targetFavData: AnyObject = self.imageInfo[imageView.tag]
            updateFavData(targetFavData, imageView: imageView)
            
        }
    }
    func setInitFavImage(targetFavData: AnyObject, cell: MyCollectionViewCell, favImageView: UIImageView) {
//        print(targetFavData)
        // imageのobjectIdを取得。
        
        if (tabKindSign == "3") {
            favImageView.image = UIImage(named: "heart_like.png")
            return
        }
        if (NCMBUser.currentUser() == nil) {
            favImageView.image = UIImage(named: "heart_unlike.png")
            return
        }
        let objectIdOfImageInfo = targetFavData.objectForKey("objectId")
        
        // nifty_cloudのFavテーブルオブジェクトを取得。
        let queryFav: NCMBQuery = NCMBQuery(className: "Fav")
        // imageのobjectIdとFavのimageObjectIdが一致するものを抽出
        // つまり、タップしたimageに対応するレコードがFavにあるかどうか。
        queryFav.whereKey("imageObjectId", equalTo: objectIdOfImageInfo)
        // ログイン中のユーザーの取得
        let carrentUser = NCMBUser.currentUser()
        if(carrentUser != nil) {
            let userName = carrentUser.userName
            queryFav.whereKey("myName", equalTo: userName)
        }
        queryFav.findObjectsInBackgroundWithBlock({(items, error) in
            
            if error == nil {
//                print("登録件数：\(items.count)")
                // items.countは1か0しかない。
                if items.count > 0 {
                    let favFlg: Bool = ((items[0].objectForKey("favFlg") as? Bool))!

                    if (favFlg) {

                        favImageView.image = UIImage(named: "heart_like.png")

                        
                    } else {

                        favImageView.image = UIImage(named: "heart_unlike.png")

                    }
                    
                    // いいねおしてない場合
                } else {

                    favImageView.image = UIImage(named: "heart_unlike.png")
                    
                }
            }
            
            
        })
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // 3カラム
        let width: CGFloat = super.view.frame.width / 3 - 6
        let height: CGFloat = width
        let rect:CGRect = CGRectMake(0, 0, width, height)

        self.cellRect = rect
//        print("width!!!!")
//        print(width)
        return CGSize(width: width, height: height) // The size of one cell
        
    }
    //Cellがクリックされた時によばれます
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("選択しました: \(indexPath.row)")
        
    }
//    // Favを更新。（かわいいねの数やハート画像の更新）
    func updateFavData(targetFavData: AnyObject, imageView: UIImageView) {
//        print(targetFavData)
        // imageのobjectIdを取得。
        var objectIdOfImageInfo: String
        if (tabKindSign == "3") {
            objectIdOfImageInfo = targetFavData.objectForKey("imageObjectId")! as! String
        } else {
            objectIdOfImageInfo = targetFavData.objectForKey("objectId")! as! String
        }
//        let objectIdOfImageInfo = targetFavData.objectForKey("objectId")!
        let imagePath = targetFavData.objectForKey("imagePath")!
        // ログイン中のユーザーの取得
        let carrentUser = NCMBUser.currentUser()
        let myName = carrentUser.userName
        // nifty_cloudのFavテーブルオブジェクトを取得。
        let queryFav: NCMBQuery = NCMBQuery(className: "Fav")
        // imageのobjectIdとFavのimageObjectIdが一致するものを抽出
        // つまり、タップしたimageに対応するレコードがFavにあるかどうか。
        queryFav.whereKey("imageObjectId", equalTo: objectIdOfImageInfo)
        queryFav.whereKey("myName", equalTo: myName)
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
                                print("favFlgがtrue時のkawaiine保存時にエラーが発生しました: \(error)")
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
                                print("favFlgがfalse時のkawaiine保存時にエラーが発生しました: \(error)")
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

                // 初めてかわいいねを押す場合
                } else {
                    let objFav: NCMBObject = NCMBObject(className: "Fav")
                    objFav.setObject(targetFavData.objectForKey("objectId"), forKey: "imageObjectId")
                    objFav.setObject(targetFavData.objectForKey("imagePath"), forKey: "imagePath")
                    objFav.setObject(targetFavData.objectForKey("userName"), forKey: "userName")
                    objFav.setObject(myName, forKey: "myName")
                    objFav.setObject(true, forKey: "favFlg")
                    objFav.save(&saveError)
                    
                    
                    // 画像の設定
                    imageView.image = UIImage(named: "heart_like.png")
                    // imageコレクション内のkawaiine数も更新
                    let objImage: NCMBObject = NCMBObject(className: "image")
                    objImage.objectId = objectIdOfImageInfo as! String
                    objImage.incrementKey("kawaiine",byAmount:1)
                    objImage.save(&saveError)
                    
                }
            }
            
            
        })

        
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

