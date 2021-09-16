//
//  CustomViewController.swift
//  xgo
//
//  Created by 袁文麟 on 2021/8/5.
//

import UIKit

class CustomViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.black
        // Do any additional setup after loading the view.
        
        for (index, viewController) in self.viewControllers!.enumerated() {
            // 声明 TabBarItem 的Image，如果没有imageWithRenderingMode方法Image只会保留轮廓
            let image = UIImage(named: "TabBar\(index)")?.withRenderingMode(.alwaysOriginal)
            let selectedImage = UIImage(named: "TabBar\(index)Sel")?.withRenderingMode(.alwaysOriginal)
            // 声明新的无标题TabBarItem
            let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
            // 设置 tabBarItem 的 imageInsets 可以使图标居中显示
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

            viewController.tabBarItem = tabBarItem
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
