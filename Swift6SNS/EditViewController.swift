//
//  EditViewController.swift
//  Swift6SNS
//
//  Created by Sena Nishida on 2021/02/24.
//

import UIKit
import Firebase
import FirebaseAuth

class EditViewController: UIViewController {
    
    //タイムラインでタップしたcellから受け取る値を格納するための箱
    var roomNumber = Int()
    var passImage = UIImage()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    let screenSize = UIScreen.main.bounds.size
    
    var userName = String()
    var userImageString = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボード
        //iphoneが持っている機能としてキーボードが呼ばれるとkeyboardwillshowが呼ばれる
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //キーボードが隠れた時
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        profileImageView.sd_setImage(with: URL(string: userImageString), completed: nil)
        userNameLabel.text = userName
        contentImageView.image = passImage
        
        profileImageView.layer.cornerRadius = 50
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        //y座標は左上から始まる
        //スクリーン全体の高さから、キーボードの高さと、テキストフィールドの高さを引いている
        textField.frame.origin.y = screenSize.height - keyboardHeight - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height
    }
    @objc func keyboardWillHide(_ notification:NSNotification) {
        textField.frame.origin.y = screenSize.height - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
        //キーボードが下がっていく時間がduration
        //durationを渡してanimationを作成する
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //ハッシュタグ機能
    func searchHashTag() {
        let hashTagText = textField.text as NSString?
        do {
            //テキストフィールドの中のテキストをインスタンス化して#以降を取り出している
            let regex = try NSRegularExpression(pattern: "#\\S+", options: [])
            for match in regex.matches(in: hashTagText! as String, options: [], range: NSRange(location: 0, length: hashTagText!.length)) {
                let passedData = self.passImage.jpegData(compressionQuality: 0.01)
                let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: self.userName, comment: self.textField.text!, userImageString: self.userImageString, contentImagaData: passedData!)
                //複数のhashtagを持っていたら別々に送ってくれる
                sendDBModel.sendHashTag(hashTag: hashTagText!.substring(with: match.range))
            }
        }catch{
            
        }
    }
    
    
    
    
    @IBAction func send(_ sender: Any) {
        //送信
        if textField.text?.isEmpty == true {
            return
        }
        searchHashTag()
        
        //前の画面から送信されたデータをさらに圧縮
        let passData = passImage.jpegData(compressionQuality: 0.01)
        //コントローラーから得られる情報を入れてインスタンス化する
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: userName, comment: textField.text!, userImageString: userImageString, contentImagaData: passData!)
        sendDBModel.sendData(roomNumber: String(roomNumber))
        //送信した段階でタイムラインに新しい投稿が表示される
        self.navigationController?.popViewController(animated: true)
        
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
