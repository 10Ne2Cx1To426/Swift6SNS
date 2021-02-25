//
//  SendDBModel.swift
//  Swift6SNS
//
//  Created by Sena Nishida on 2021/02/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class SendDBModel {
    
    var userID = String()
    var comment = String()
    var userImageString = String()
    var contentImageData = Data()
    var userName = String()
    
    var db = Firestore.firestore()
    //送信機能を集約するクラス
    init () {
    }
    init(userID: String,userName: String, comment: String, userImageString: String, contentImagaData: Data) {
        self.userID = userID
        self.userName = userName
        self.comment = comment
        self.userImageString = userImageString
        self.contentImageData = contentImagaData
    }
    func sendData(roomNumber:String) {
        //editcontrollerでの送信作業をかく 自分のuserIDであることを示すためにselfを用いる
        let imageRef = Storage.storage().reference().child("Images").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        //送信作業
        imageRef.putData(contentImageData, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            //firebaseのサーバーから画像のurlが帰ってくる
            imageRef.downloadURL { (url, error) in
                if error != nil {
                    return
                }
                self.db.collection(roomNumber).document().setData(
                    ["userID":self.userID as Any, "userName":self.userName as Any, "comment":self.comment as Any, "userImage":self.userImageString as Any, "contentImage":url?.absoluteString as Any, "postDate": Date().timeIntervalSince1970]
                )
                //userImageというキー値で画像を保存
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
            }
        }
        
    }
    
    func sendProfileImageData(data:Data) {
        let image = UIImage(data:data)
        let profileImage = image!.jpegData(compressionQuality: 0.1)
        
        //保存先の決定
        //リファレンス パスを作り、フォルダを作成している UUIDで一意性のIDを作成し、uuid+dateでデータ名をつけている
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        //送信作業
        imageRef.putData(profileImage!, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            //firebaseのサーバーから画像のurlが帰ってくる
            imageRef.downloadURL { (url, error) in
                if error != nil {
                    return
                }
                //userImageというキー値で画像を保存
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
            }
        }
    }
    
    func sendHashTag(hashTag:String) {
        let imageRef = Storage.storage().reference().child(hashTag).child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        imageRef.putData(contentImageData, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            imageRef.downloadURL { (url, error) in
                if error != nil {
                    return
                }
                self.db.collection(hashTag).document().setData(["userID":self.userID as Any, "userName":self.userName as Any, "comment":self.comment as Any, "userImage":self.userImageString as Any, "contentImage":url?.absoluteString as Any, "postDate":Date().timeIntervalSince1970])
            }
        }
    }
}
