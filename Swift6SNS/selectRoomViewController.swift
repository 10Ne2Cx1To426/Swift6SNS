//
//  selectRoomViewController.swift
//  Swift6SNS
//
//  Created by Sena Nishida on 2021/02/24.
//

import UIKit
import ViewAnimator

class selectRoomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var roomArray = ["NCT", "BTS", "SEVENTEENS", "TXT", "MONSTA X"]
    var imageArray = ["0", "1", "2", "3", "4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        tableView.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        UIView.animate(views: tableView.visibleCells, animations: animation, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //Roomの画像を反映
        let roomImageView = cell.contentView.viewWithTag(1) as! UIImageView
        roomImageView.image = UIImage(named: imageArray[indexPath.row])
        //roomの名前
        let roomLabel = cell.contentView.viewWithTag(2) as! UILabel
        roomLabel.text = roomArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    //didSelectRowAtでどこのcellが叩かれたのか認識する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let timeLineVC = self.storyboard?.instantiateViewController(identifier: "timeLineVC") as! TimeLineViewController
        timeLineVC.roomNumber = indexPath.row
        self.navigationController?.pushViewController(timeLineVC, animated: true)
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
