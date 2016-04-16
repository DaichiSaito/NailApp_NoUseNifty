//
//  chooseFromCamera.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/09.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit
class uploadProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imageForUpload = UIImageView()
    
    @IBAction func uploadImageButton(sender: AnyObject) {
        uploadImages()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func uploadImages() {
        
        let photoLibrary = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(photoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = photoLibrary
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            //iamgeForUploadというUIImageを用意しておいてそこに一旦預ける
            self.imageForUpload.image = image
            //            self.AFNetworkingUploadRequest()
            self.myImageUploadRequest()
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // 画像をリサイズ
    func resize(image: UIImage, width: Int, height: Int) -> UIImage {
        let imageRef: CGImageRef = image.CGImage!
        var sourceWidth: Int = CGImageGetWidth(imageRef)
        var sourceHeight: Int = CGImageGetHeight(imageRef)
        
        var size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        var resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage
    }
    
    //画像のアップロード処理
    func myImageUploadRequest() {
        //myUrlには自分で用意したphpファイルのアドレスを入れる
        let myUrl = NSURL(string:"http://test.localhost/NailApp_NoUseNifty/uploadProfileImageToFileServer.php")
        //        let myUrl = NSURL(string:"http://dsh4k2h4k2.esy.es/uploadTest4.php")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        // ログイン中のユーザーの取得
        let carrentUser = NCMBUser.currentUser()
        let customerId = carrentUser.userName
        print(customerId!)
        let time:Int = Int(NSDate().timeIntervalSince1970)
        print(time)
        //下記のパラメータはあくまでもPOSTの例
        let param = [
            "customerId" : customerId!,
            "fileName" : String(time)
        ]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(self.imageForUpload.image!, 1)
        if(imageData==nil) { return; }
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            // リクエストを出力
            print("******* resquest = \(request)")
            // レスポンスを出力
            print("******* response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            dispatch_async(dispatch_get_main_queue(),{
                //アップロード完了
            });
        }
        task.resume()
        
        // niftyにもあげないと
        // imageコレクションも更新
        var saveError: NSError? = nil
        let objImage: NCMBObject = NCMBObject(className: "profileImage")
        objImage.setObject(customerId!, forKey: "customerId")
        objImage.setObject("http://test.localhost/NailApp_NoUseNifty/profileImages/" + String(time) + ".jpg", forKey: "imagePath")
        //        objImage.save(&saveError)
        objImage.saveInBackgroundWithBlock { (error: NSError?) -> Void in
            if let e = error {
                // 端末情報の登録が失敗した場合の処理
                print(e.description)
                if (e.code == 409001){
                    // 失敗した原因がdeviceTokenの重複だった場合
                    //                    self.updateExistInstallation(installation)
                } else {
                    // deviceTokenの重複以外のエラーが返ってきた場合
                }
            }
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData()
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        let filename = "image(1).jpg"
        let mimetype = "image/jpg"
        body.appendString("--\(boundary)\r\n")
        // filePathKeyという識別しに対応するのがfilenameという変数
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body
    }
}
