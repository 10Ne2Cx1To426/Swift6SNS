//
//  CheckModel.swift
//  Swift6SNS
//
//  Created by Sena Nishida on 2021/02/24.
//

import Foundation
import Photos

class CheckModel {
    
    func showCheckPermission() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status) {
            case .authorized:
                print("許可")
            case .denied:
                print("拒否")
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .limited:
                print("limited")
            @unknown default: break
            }
        }
    }
}
