//
//  NewSetVC.swift
//  xgo
//
//  Created by Arther on 15.7.24.
//

import UIKit


class NewSetVC: UIViewController {
    
    @IBOutlet weak var systemButton: UIButton!
    @IBOutlet weak var chineseButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    var languageButtonArray: [UIButton]! = []
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var developButtonArray: [UIButton]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        languageButtonArray = []
        developButtonArray = []
        initSetButtonStyle()
    }
    
    
    private func initSetButtonStyle() {
        
        systemButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        systemButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        systemButton.isSelected = true
        
        chineseButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        chineseButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        
        englishButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        englishButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)

        yesButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        yesButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        
        yesButton.isSelected = true
        
        noButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        noButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        
        languageButtonArray.append(contentsOf: [systemButton, chineseButton, englishButton])
        developButtonArray.append(contentsOf: [yesButton, noButton])
        
    }
    
    
    @IBAction func languageButtonClick(serder: UIButton) {
        for item in languageButtonArray {
            if item.currentTitle == serder.currentTitle {
                item.isSelected = true
            } else {
                item.isSelected = false
            }
        }
    }
    
    @IBAction func developButtonClick(serder: UIButton) {
        for item in developButtonArray {
            if item.currentTitle == serder.currentTitle {
                item.isSelected = true
            } else {
                item.isSelected = false
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
