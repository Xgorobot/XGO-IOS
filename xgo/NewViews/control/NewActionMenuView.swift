//
//  NewActionMenuView.swift
//  xgo
//
//  Created by Arther on 12.7.24.
//

import UIKit

class NewActionMenuView: UIView {
    
    var collectionView: UICollectionView!
    var resetButton: GradientButton!
    var closeButton: UIButton!
    var container: UIView!
    var actionArray: [String]!
    var isSelect: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        container = UIView()
        container.backgroundColor = UIColor(hex: 0x011359)
        self.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.5)
            make.width.equalTo(self).multipliedBy(0.6)
        }
        
        resetButton = GradientButton()
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        resetButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x2205FF), UIColor(hex: 0x12C4FF)]), for: .normal)
        resetButton.cornerRadius = 0
        container.addSubview(resetButton)
        
        resetButton.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(container)
            make.height.equalTo(40)
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        container.addSubview(collectionView)
        
        collectionView.register(ActionMenuCell.self, forCellWithReuseIdentifier: "ActionMenuCell")
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(container).inset(10)
            make.bottom.equalTo(resetButton.snp.top).offset(-5)
        }
        
        closeButton = UIButton()
        closeButton.setTitle("x", for: .normal)
        self.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(container.snp.top)
            make.right.equalTo(container)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
    }
    
    @objc func closeButtonAction() {
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension NewActionMenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 动作轮播
            
        } else {
            isSelect = indexPath.row
        }
        self.collectionView.reloadData()
    }
}

extension NewActionMenuView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionMenuCell", for: indexPath) as? ActionMenuCell
        cell?.name = actionArray[indexPath.row]
        cell?.isSelect = isSelect == indexPath.row
        return cell ?? UICollectionViewCell()
    }
    
}

extension NewActionMenuView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (SCREEN_WIDTH * 0.6 / 5) - 20, height: 25)
    }
    
}


class ActionMenuCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var icon: UIImageView!
    var isSelect: Bool! {
        didSet {
            if name != "动作轮播" {
                if  isSelect {
                    icon.image = UIImage(named: "xuanzhong8")
                } else {
                    icon.image = UIImage(named: "weixuan8")
                }
            }
        }
    }
    var name: String! {
        didSet {
            titleLabel.text = name
            if name == "动作轮播" {
                icon.image = UIImage(named: "bgitem")
            } else {
                icon.image = UIImage(named: "weixuan8")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        icon = UIImageView(image: UIImage(named: "weixuan8"))
        self.contentView.addSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        
        titleLabel = UILabel()
        titleLabel.text = "坐下"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .white
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
