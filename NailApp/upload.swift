import UIKit

class upload: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var uploadTextView: UITextView!
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBAction func addButton(sender: AnyObject) {
//        self.pickImageFromCamera()
        self.pickImageFromLibrary()
    }
    
    @IBAction func uploadButton(sender: AnyObject) {
        self.myImageUploadRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print(image)
            self.uploadImageView.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //画像のアップロード処理
    func myImageUploadRequest() {
        //myUrlには自分で用意したphpファイルのアドレスを入れる
        let myUrl = NSURL(string:"http://test.localhost/NailApp_NoUseNifty/uploadToFileServer.php")
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
        let imageData = UIImageJPEGRepresentation(self.uploadImageView.image!, 1)
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
                // これかかないとアップロード後画面が固まる。
//                self.removeFromParentViewController()
//                self.view.removeFromSuperview()
            });
        }
        task.resume()
        
        // niftyにもあげないと
        // imageコレクションも更新
        var saveError: NSError? = nil
        let objImage: NCMBObject = NCMBObject(className: "image")
        objImage.setObject(userName!, forKey: "userName")
        objImage.setObject("http://test.localhost/NailApp_NoUseNifty/images/" + String(time) + ".jpg", forKey: "imagePath")
        objImage.setObject(uploadTextView.text!, forKey: "comment")
        objImage.setObject(0, forKey: "kawaiine")
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
            //            self.removeFromParentViewController()
            //            self.view.removeFromSuperview()
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