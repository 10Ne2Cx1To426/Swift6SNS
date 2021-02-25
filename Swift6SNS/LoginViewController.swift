//
//  LoginViewController.swift
//  Swift6SNS
//
//  Created by Sena Nishida on 2021/02/24.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var sendDBModel = SendDBModel()
    
    var urlString = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        //許可画面
        let checkModel = CheckModel()
        checkModel.showCheckPermission()
    }
    
    @IBAction func login(_ sender: Any) {
        //匿名ログイン
        Auth.auth().signInAnonymously { (result, error) in
            //データベースのデータがresultに入る
            //エラー処理
            if error != nil {
                return
            }
            //ユーザーが本当にいるのか
            let user = result?.user
            print(user.debugDescription)
            //次の画面遷移 -> 次のViewControllerへ
            let selectVC = self.storyboard?.instantiateViewController(identifier: "selectVC") as! selectRoomViewController
            //アプリ内に名前を保存する forkeyはキー値
            UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
            //画像をクラウドストレージに送信する + データを圧縮する
            let data = self.profileImageView.image?.jpegData(compressionQuality: 0.01)
            //データをストレージに保存する クラス名.sendProfileImageData(data: data)->classのメソッドに入る
            self.sendDBModel.sendProfileImageData(data: data!)
            //Modelを使用
            //画面遷移
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
    }
    func doCamera() {
        let sourceType:UIImagePickerController.SourceType = .camera
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    func doAlbum() {
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //アルバム利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] as? UIImage != nil {
            let selectedImage = info[.originalImage] as! UIImage
            profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapImageView(_ sender: Any) {
        let generater = UINotificationFeedbackGenerator()
        generater.notificationOccurred(.success)
        showAlert()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //アラート
    func showAlert() {
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.doAlbum()
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
