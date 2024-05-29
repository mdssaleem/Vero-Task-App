//
//  ExtensionClass.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 28/05/24.
//

import Foundation
import UIKit


// Extension to convert hex string to UIColor
extension UIColor {
    convenience init(hexString: String) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}


extension UIView {
    func applyShadow(color: UIColor = .gray, opacity: Float = 0.3, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}


class ToastView: UIView {
    
    static func show(message: String, inView view: UIView) {
        let toast = ToastView(message: message)
        view.addSubview(toast)
        
        toast.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toast.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        toast.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            toast.alpha = 1.0
            toast.applyShadow()
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                toast.alpha = 0.0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
    
    private init(message: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.black.withAlphaComponent(1.8)
        self.layer.cornerRadius = 10
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
