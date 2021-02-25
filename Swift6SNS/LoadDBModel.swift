//
//  LoadDBModel.swift
//  Swift6SNS
//
//  Created by Sena Nishida on 2021/02/25.
//

import Foundation
import Firebase

protocol LoadOKDelegate {
    func loadOK(check: Int)
}

class LoadModel {
    
    var dataSets = [DataSet]() //DataSetのプロパティを持った構造体が入る配列
    let db = Firestore.firestore()
    var loadOKDelegate:LoadOKDelegate?
    
    func loadContent(roomNumber: String) {
        db.collection(roomNumber).order(by: "postDate").addSnapshotListener { (snapShot, error) in
            if error != nil {
                return
            }
            //snapShot
            if let snapShotDoc = snapShot?.documents {
                for doc in snapShotDoc {
                    //ドキュメントの中のデータを取ってくる
                    let data = doc.data()
                    if let userID = data["userID"] as? String, let userName = data["userName"] as? String, let comment = data["comment"] as? String, let profileImage = data["userImage"] as? String, let contentImage = data["contentImage"] as? String, let postDate = data["postDate"] as? Double {
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, profileImage: profileImage, postDate: postDate, contentImage: contentImage)
                        
                        self.dataSets.append(newDataSet)
                        self.dataSets.reverse() //順番を反転させる
                    }
                }
            }
        }
    }
    func loadHashTag(hashTag:String) {
        db.collection("#\(hashTag)").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            self.dataSets = []
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents {
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let userID = data["userID"] as? String, let userName = data["userName"] as? String, let comment = data["comment"] as? String, let profileImage = data["userImage"] as? String, let contentImage = data["contentImage"] as? String, let postDate = data["postDate"] as? Double {
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, profileImage: profileImage, postDate: postDate, contentImage: contentImage)
                        
                        self.dataSets.append(newDataSet)
                        self.dataSets.reverse()
                        //datasetsに値が入り切っていない状態でdatasetが呼ばれないようにするため
                        self.loadOKDelegate?.loadOK(check: 1)
                    }
                }
            }
        }
    }
    
}
