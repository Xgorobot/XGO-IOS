//
//  NewSearchListView.swift
//  xgo
//
//  Created by Arther on 18.7.24.
//

import UIKit
import CoreBluetooth

class NewSearchListView: UIView {
    
    var tableView: UITableView!
    
    var myPeripherals: NSMutableArray = NSMutableArray() //初始化动态数组 用以储存字典
    
    
    var objectChangedClosure: ((NSDictionary) -> Void)?

    
    var hiddenAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hex: 0x011359)
        self.addSubview(tableView)
        
        tableView.register(NewSearchListCell.self, forCellReuseIdentifier: "NewSearchListCell")
        
        tableView.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.3)
        }
        
        
        let hiddenButton = UIButton()
        hiddenButton.backgroundColor = .clear
        self.addSubview(hiddenButton)
        
        hiddenButton.addTarget(self, action: #selector(hiddenButtonAction), for: .touchUpInside)
        
        hiddenButton.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(tableView.snp.left)
        }
        
    }
    
    @objc func hiddenButtonAction() {
        self.hiddenAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewSearchListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPeripherals.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewSearchListCell") as? NewSearchListCell
        
//        let cell:NewSearchListCell =
        
        let data:NSDictionary = myPeripherals[indexPath.row] as! NSDictionary
        let peripheral:CBPeripheral = data.value(forKey: "peripheral") as! CBPeripheral
        let name:String = data.value(forKey: "name") as! String
        
        cell?.titleLabel.text = name
//        cell?.titleLabel.text? = "\(name)  "
        
        print("设备名:\(name)")

        
        return cell ?? NewSearchListCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("停止搜索")
        
        let myPeriDict:NSDictionary = myPeripherals[indexPath.row] as! NSDictionary

        objectChangedClosure?(myPeriDict)
        
       

    }
    
}


class NewSearchListCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var iconImage: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(hex: 0x011359)
        
        self.selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = .white
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10)
        }
        
        iconImage = UIImageView(image: UIImage(named: "xuanze"))
        self.contentView.addSubview(iconImage)
        
        iconImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 17, height: 17))
            make.right.equalTo(self.contentView).offset(-20)
            make.centerY.equalTo(self.contentView)
        }
        
        let line = UIView()
        line.backgroundColor = .white
        self.contentView.addSubview(line)
        
        line.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView)
            make.left.right.equalTo(self.contentView).inset(10)
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
