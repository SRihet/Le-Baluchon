//
//  Extension-UiViewController.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 16/04/2022.
//

import Foundation
import UIKit

extension UIViewController {

    func presentAlert(alert: LeBaluchonAlertVC) {
        let alertVC = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
