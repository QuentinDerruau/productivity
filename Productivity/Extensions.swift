//
//  extensions.swift
//  Productivity
//
//  Created by Quentin on 20/01/2024.
//

import Foundation
import UIKit

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter.string(from: Date())

    }
    
}
func convertDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter.string(from: date)
}

extension UITableView {
    func reloadDataWithAnimation(duration: TimeInterval, options: UIView.AnimationOptions) {
    UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { self.alpha = 0 }, completion: nil)
    self.reloadData()
    UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { self.alpha = 1 }, completion: nil)
  }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
}

