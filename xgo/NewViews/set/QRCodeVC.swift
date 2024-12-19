//
//  WiFiViewController.swift
//  xgo
//
//  Created by 王壮 on 2023/6/11.
//

import UIKit

class QRCodeVC: NewsBaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var wifiField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var codeButtonWidth: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        wifiField.attributedPlaceholder = NSAttributedString(string: "请输入WiFi", attributes: [.foregroundColor:UIColor(hexString: "#8BA4C7") ?? .white])
        wifiField.textColor = UIColor.white
        wifiField.layer.cornerRadius = 4
        wifiField.layer.borderColor = UIColor(hexString: "#172A51")?.cgColor
        wifiField.layer.borderWidth = 1
        passwordField.attributedPlaceholder = NSAttributedString(string: "请输入密码", attributes: [.foregroundColor:UIColor(hexString: "#8BA4C7") ?? .white])
        passwordField.textColor = UIColor.white
        passwordField.layer.cornerRadius = 4
        passwordField.layer.borderColor = UIColor(hexString: "#172A51")?.cgColor
        passwordField.layer.borderWidth = 1
        passwordField.delegate = self
        codeButton.setHorizontalGradientBackground(colorLeft: UIColor(hexString: "#3E67F7")!, colorRight: UIColor(hexString: "#349AFF")!, forState: .normal)
        codeButton.layer.cornerRadius = 20
        codeButton.layer.masksToBounds = true
        titleLabel.text = "机器人配网".localized
        descLabel.text = "请输入WI-FI名称和密码".localized
        wifiField.placeholder = "请输入WI-FI".localized
        wifiField.delegate = self
        passwordField.placeholder = "请输入密码".localized
        codeButton.setTitle("生成二维码".localized, for: .normal)
        codeButtonWidth.constant = String.getStringWidth(str: "生成二维码".localized, font: .systemFont(ofSize: 14)) + 40
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight / 2 // 根据需要调整偏移量
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func codeButtonClick(_ sender: UIButton) {
        if wifiField.text?.count == 0 {
            return
        }
        
        if passwordField.text?.count == 0 {
            return
        }
        
        codeImage.image = self.generateQRCode(str: self.setCodeString(ssid: wifiField.text ?? "", password: passwordField.text ?? ""))
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setCodeString(ssid: String, password: String) -> String {
        var str = ""
        str.append("WIFI:")
        // 添加SSID
        str.append("S:")
        str.append(ssid)
        str.append(";")
        // 添加密码
        str.append("T:")
        str.append("WPA")
        str.append(";")
        str.append("P:")
        str.append(password)
        str.append(";")
        // 添加隐藏网络标志位（可选）
        str.append("H:")
        str.append("false")
        str.append(";")
        return str
    }
    
    func generateQRCode(str: String) -> UIImage? {
        let data = str.data(using: String.Encoding.ascii)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 9, y: 9)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        return UIImage(ciImage: output)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 隐藏键盘
        textField.resignFirstResponder()
        return true
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


extension UIButton {
    func setHorizontalGradientBackground(colorLeft: UIColor, colorRight: UIColor, forState state: UIControl.State) {
        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorLeft.cgColor, colorRight.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Render the gradient to a UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Set the UIImage as the background image for the button
        setBackgroundImage(gradientImage, for: state)
    }
    
            
    func addRoundedBottomCorners() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: [.bottomLeft, .bottomRight],
                                      cornerRadii: CGSize(width: 10, height: 10)).cgPath
        layer.mask = maskLayer
    }
    
}

extension String {
    
    static func getStringWidth(str: String, font: UIFont) -> CGFloat {
        let attributedText = NSAttributedString(string: str, attributes: [NSAttributedString.Key.font: font]) // 替换为您需要的字体和字号
        let textSize = attributedText.size()
        return textSize.width
    }
    
}
