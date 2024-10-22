//
//  NewSetVC.swift
//  xgo
//
//  Created by Arther on 15.7.24.
//

import UIKit


class NewSetVC: NewsBaseViewController {
    
    @IBOutlet weak var systemButton: UIButton!
    @IBOutlet weak var chineseButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    var languageButtonArray: [UIButton]! = []
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var developButtonArray: [UIButton]! = []
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var developerDesc: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "基础设置".localized
        languageLabel.text = "语言选择".localized
        systemButton.setTitle("跟随系统".localized, for: .normal)
        chineseButton.setTitle("中文".localized, for: .normal)
        englishButton.setTitle("English".localized, for: .normal)
        developerLabel.text = "开发选项".localized
        developerDesc.text = "以开发者身份运行此项目".localized
        yesButton.setTitle("是".localized, for: .normal)
        noButton.setTitle("否".localized, for: .normal)
        
        languageButtonArray = []
        developButtonArray = []
        initSetButtonStyle()
        
        if let localLanguage = UserDefaults.standard.string(forKey: "languageFileName") {
            if localLanguage == "Auto" {
                setButtonSelect(index: 0)
            } else if localLanguage == "English" {
                setButtonSelect(index: 2)
            } else {
                setButtonSelect(index: 1)
            }
        }
        
        if UserDefaultsManager.shared.developMode {
            yesButton.isSelected = true
        }else{
            noButton.isSelected = true
        }
        
        
        if(UserDefaults.standard.bool(forKey: "developMode")) {
            if let buttonToSelect = developButtonArray.first(where: { $0.title(for: .normal) == "是".localized }) {
                buttonToSelect.isSelected = true
            }

            if let anotherButton = developButtonArray.first(where: { $0.title(for: .normal) != "是".localized }) {
                anotherButton.isSelected = false
            }
        } else {
            if let buttonToSelect = developButtonArray.first(where: { $0.title(for: .normal) == "是".localized }) {
                buttonToSelect.isSelected = false
            }

            if let anotherButton = developButtonArray.first(where: { $0.title(for: .normal) != "是".localized }) {
                anotherButton.isSelected = true
            }
        }
        
  
        
       
    }
    
    func setButtonSelect(index: Int) {
        for i in 0..<languageButtonArray.count {
            if i == index {
                languageButtonArray[i].isSelected = true
            } else {
                languageButtonArray[i].isSelected = false
            }
        }
    }
    
    
    private func initSetButtonStyle() {
        
        systemButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        systemButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        
        chineseButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        chineseButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        
        englishButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        englishButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)

        yesButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        yesButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        
        noButton.setImage(UIImage(named: "radiobuttonunselect"), for: .normal)
        noButton.setImage(UIImage(named: "radiobuttonselect"), for: .selected)
        
        languageButtonArray.append(contentsOf: [systemButton, chineseButton, englishButton])
        developButtonArray.append(contentsOf: [yesButton, noButton])
        
    }
    
    
    @IBAction func languageButtonClick(serder: UIButton) {
        if serder.currentTitle == "中文".localized {
            LanguageManager.shared.switchLanguage("Chinese")
        } else if serder.currentTitle == "English".localized {
            LanguageManager.shared.switchLanguage("English")
        } else {
            LanguageManager.shared.switchLanguage("Auto")
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
        if serder == yesButton{
            UserDefaultsManager.shared.developMode = true
        }else{
            UserDefaultsManager.shared.developMode = false
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
