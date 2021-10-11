//
//  ShowModeVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ShowModeVC: UIViewController,UICollectionViewDelegate{

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var showBtnsCollectionView: UICollectionView!
        
    let _bag: DisposeBag = DisposeBag()
    
    let dataItem = ["趴下","站起","匍匐前进","转圈","原地踏步","蹲起","转动ROLL","转动PITCH","转动YAW","三轴联动","撒尿","坐下","招手","伸懒腰","波浪","摇摆","求食","找食物","握手"]
    
    var _vm:ShowModeVM!
    var selectItem:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _vm = ShowModeVM(input: ShowModeVM.Input(
            backClick: backBtn.rx.tap.asObservable(),
            itemSelect: showBtnsCollectionView.rx.itemSelected.asObservable()
        ))
        
        _vm.output.back.subscribe { (string) in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: _bag)
        _vm.output.itemSelectResult.subscribe { (indexPat) in
            self.selectItem = indexPat
        }.disposed(by: _bag)
//        _vm.output.itemSelectResult.su
        
        let items = Observable.just([SectionModel(model: "", items: dataItem)])
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
        
        showBtnsCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        showBtnsCollectionView.register(UINib(nibName: "ShowModeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,String>> { (dataSource, cv, indexPath, item) -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShowModeCollectionViewCell
            cell.lb_title.text = item
//            cell.contentView.addSubview(T##view: UIView##UIView)
            return cell
        }
        // Do any additional setup after loading the view.
        items.bind(to: showBtnsCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: _bag)
        showBtnsCollectionView.rx.setDelegate(self).disposed(by: _bag)
    }

    @IBAction func onResetClick(_ sender: UIButton) {
        FindControlUtil.actionType(type: 0x00)
        if (self.selectItem != nil) {
            showBtnsCollectionView.deselectItem(at: selectItem!, animated: false)
        }
    }
    @IBAction func onClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ShowModeVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-20)/3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);//分别为上、左、下、右
    }
}
