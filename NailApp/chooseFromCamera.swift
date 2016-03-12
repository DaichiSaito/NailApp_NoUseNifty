//
//  chooseFromCamera.swift
//  NailApp
//
//  Created by DaichiSaito on 2016/03/09.
//  Copyright © 2016年 DaichiSaito. All rights reserved.
//

import UIKit
class chooseFromCamera: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            var imageForUpload = UIImageView()
            //iamgeForUploadというUIImageを用意しておいてそこに一旦預ける
            imageForUpload.image = image
            // 画像をリサイズしてUIImageViewにセット
            var resizeImage = resize(image, width: 480, height: 320)
            imageForUpload.image = resizeImage
//            imageView.image = resizeImage
//            self.message?.hidden = true
            //保存対象の画像ファイルを作成する
            let imageData: NSData = UIImagePNGRepresentation(resizeImage)!
            let targetFile = NCMBFile.fileWithData(imageData) as! NCMBFile
            //新規データを1件登録する
            var saveError: NSError? = nil
            let obj: NCMBObject = NCMBObject(className: "MemoClass")
            obj.setObject("title!", forKey: "title")
            obj.setObject(targetFile.name, forKey: "filename")
            obj.setObject(800, forKey: "money")
            obj.setObject("comment!", forKey: "comment")
            obj.save(&saveError)
            
            //ファイルはバックグラウンド実行をする
            targetFile.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
                
                if error == nil {
                    print("画像データ保存完了: \(targetFile.name)")
                } else {
                    print("アップロード中にエラーが発生しました: \(error)")
                }
                
                }, progressBlock: { (percentDone: Int32) -> Void in
                    
                    // 進捗状況を取得します。保存完了まで何度も呼ばれます
                    print("進捗状況: \(percentDone)% アップロード済み")
            })
            
            if saveError == nil {
                print("success save data.")
            } else {
                print("failure save data. \(saveError)")
            }
        }

            //            self.myImageUploadRequest()
        
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

    
}
