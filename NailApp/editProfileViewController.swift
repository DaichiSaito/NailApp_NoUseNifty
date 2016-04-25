//
//  chooseFromCamera.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/09.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit
class editProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func saveProfile(sender: AnyObject) {
        // ログイン中のユーザーの取得
//        let carrentUser = NCMBUser.currentUser()
//        carrentUser.setObject(self.nickNameTextField.text, forKey: "nickName")
//        carrentUser.setObject(self.profileCommentTextView.text, forKey: "comment")
//        carrentUser.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
//            self.dismissViewControllerAnimated(true, completion: nil)
//        })
//        self.myImageUploadRequest()
        if (imgageChangFlg) {
            self.myImageUploadRequest()
        } else {
            let carrentUser = NCMBUser.currentUser()
            carrentUser.setObject(self.nickNameTextField.text, forKey: "nickName")
            carrentUser.setObject(self.profileCommentTextView.text, forKey: "comment")
//            carrentUser.setObject(urlUploadProfileImagesLocation + String(time) + ".jpg", forKey: "imagePath")
            carrentUser.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
    }
    @IBAction func backToProfile(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func updateProfileImageButton(sender: AnyObject) {
//        self.pickImageFromCamera()
        self.pickImageFromLibrary()
    }
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var profileCommentTextView: UITextView!
    
    @IBOutlet weak var profileImage: UIImageView!
    var tmpNickName: String?
    var tmpProfileComment: String?
    var imgageChangFlg = false as Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nickNameTextField.text = self.tmpNickName
        self.profileCommentTextView.text = self.tmpProfileComment
        self.imgageChangFlg = false
    }
    
    // 写真を撮ってそれを選択
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.allowsEditing = true
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerEditedImage] != nil {
            var image = info[UIImagePickerControllerEditedImage] as! UIImage
            //            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print(image)
            image = resizeImage(image,width: 200,height: 200)
            print(image)
            self.profileImage.image = image
            self.imgageChangFlg = true
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImage(image: UIImage, width: Int, height: Int) -> UIImage {
//        let ref: CGImageRef = image.CGImage!
//        var srcWidth: Int = CGImageGetWidth(ref)
//        var srcHeight: Int = CGImageGetHeight(ref)
        
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage
    }
    //画像のアップロード処理
    func myImageUploadRequest() {
        //myUrlには自分で用意したphpファイルのアドレスを入れる
        let myUrl = NSURL(string:urlUploadProfileImagesPhp)
        //        let myUrl = NSURL(string:"http://dsh4k2h4k2.esy.es/uploadTest4.php")
        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        
        // ログイン中のユーザーの取得
        let carrentUser = NCMBUser.currentUser()
        let userName = carrentUser.userName
        print(userName!)
        let time:Int = Int(NSDate().timeIntervalSince1970)
        print(time)
        //下記のパラメータはあくまでもPOSTの例
        let param = [
            "userName" : userName!,
            "fileName" : String(time)
        ]
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 1)
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
                self.dismissViewControllerAnimated(true, completion: nil)
            });
        }
        task.resume()
        
//        let carrentUser = NCMBUser.currentUser()
        carrentUser.setObject(self.nickNameTextField.text, forKey: "nickName")
        carrentUser.setObject(self.profileCommentTextView.text, forKey: "comment")
        carrentUser.setObject(urlUploadProfileImagesLocation + String(time) + ".jpg", forKey: "imagePath")
        carrentUser.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
//            self.dismissViewControllerAnimated(true, completion: nil)
        })
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
