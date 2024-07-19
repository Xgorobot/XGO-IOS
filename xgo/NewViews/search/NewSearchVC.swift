//
//  NewSearchVC.swift
//  xgo
//
//  Created by Arther on 20.6.24.
//

import UIKit


class NewSearchVC: UIViewController {
    
    @IBOutlet weak var disconnectButton: GradientButton!
    var searchView: NewSearchListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView = NewSearchListView()
        self.view.addSubview(searchView)
        
        searchView.isHidden = true
        
        searchView.hiddenAction = { [weak self] in
            self?.searchView.isHidden = !(self?.searchView.isHidden ?? false)
        }
        
        searchView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        disconnectButton.setGradient(GradientButton.Gradient(colors: [UIColor(hex: 0x2205FF), UIColor(hex: 0x12C4FF)]), for: .normal)
        disconnectButton.cornerRadius = 3
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: Any) {
        
        searchView.isHidden = !searchView.isHidden
        
    }
    
    @IBAction func disconnect(_ sender: Any) {
    }
    
    @IBAction func renameAction(_ sender: Any) {
    }
    
    
}
