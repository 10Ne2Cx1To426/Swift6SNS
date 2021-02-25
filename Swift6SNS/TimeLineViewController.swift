//
//  TimeLineViewController.swift
//  Swift6SNS
//
//  Created by Sena Nishida on 2021/02/24.
//

import UIKit
import Firebase
import Photos
import ActiveLabel
import SDWebImage

extension UIAlertController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        pruneNegativeWidthConstraints()
    }
    
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

class TimeLineViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, LoadOKDelegate {
    
    var roomNumber = Int()
    var loadDBModel = LoadModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadDBModel.loadOKDelegate = self
        
        // Do any additional setup after loading the view.
    }
    func loadOK(check: Int) {
        if check == 1 {
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 687
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //受信する
        loadDBModel.loadContent(roomNumber: String(roomNumber))
    }
    //テーブルビューの表示
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadDBModel.dataSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //プロパティにアクセスして表示させる
        //セルのidをつけるのと、パーツにtagをつける
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // アイコン
        let profileImageView = cell.contentView.viewWithTag(1) as! UIImageView
        profileImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].profileImage), completed: nil)
        //形を丸くする
        profileImageView.layer.cornerRadius = 50
        
        //ユーザーネーム
        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        userNameLabel.text = loadDBModel.dataSets[indexPath.row].userName
        
        //投稿画像
        let contentImageView = cell.contentView.viewWithTag(3) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].contentImage), completed: nil)
        
        //コメントラベル
        let commentLabel = cell.contentView.viewWithTag(4) as! ActiveLabel
        commentLabel.enabledTypes = [.hashtag]
        commentLabel.text = "\(loadDBModel.dataSets[indexPath.row].comment)"
        commentLabel.handleHashtagTap { (hashTag) in
            //タップされたハッシュタグから画面遷移を行う
            let hashVC = self.storyboard?.instantiateViewController(identifier: "hashVC") as! HashTagViewController
            hashVC.hashTag = hashTag
            self.navigationController?.pushViewController(hashVC, animated: true)
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    
    
    
    @IBAction func openCamera(_ sender: Any) {
        showAlert()
        
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
            //値を渡しながら画面遷移
            let editVC = self.storyboard?.instantiateViewController(identifier: "editVC") as! EditViewController
            editVC.roomNumber = roomNumber
            editVC.passImage = selectedImage
            self.navigationController?.pushViewController(editVC, animated: true)
            //アルバムを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
