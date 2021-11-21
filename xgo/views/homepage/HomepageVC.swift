//
//  HomepageVC.swift
//  xgo
//
//  Created by 袁文麟 on 2021/7/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomepageVC: UIViewController, UICollectionViewDelegate{
    
    @IBOutlet weak var _btn_ble: UIButton!
    @IBOutlet weak var _et_test: UITextField!
    
    private var collectionView : UICollectionView!
    private var flowLayout : LeftRightItem = LeftRightItem()
    
    let _bag: DisposeBag = DisposeBag()
    
    var _vm: HomepageVM!
    
    let dataItem = [DataElement(itemTitle: NSLocalizedString("表演模式", comment: "表演模式"), vc: ShowModeVC(), itemImage: #imageLiteral(resourceName: "biaoyan-1")),
                    DataElement(itemTitle: NSLocalizedString("整机控制", comment: "整机控制"), vc: IntegralModeVC(), itemImage: #imageLiteral(resourceName: "yaokong-1")),
                    DataElement(itemTitle: NSLocalizedString("单脚控制", comment: "单脚控制"), vc: SingleLegVC(), itemImage: #imageLiteral(resourceName: "biaoyan-1")),
                    DataElement(itemTitle: NSLocalizedString("舵机控制", comment: "舵机控制"), vc: ServoVC(), itemImage: #imageLiteral(resourceName: "guanjie-1"))]
    
    struct DataElement {
        let itemTitle:String!
        let vc:UIViewController!
        let itemImage:UIImage!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        let items = Observable.just([SectionModel(model: "",
                                                  items: dataItem)])
        self.view.layer.contents = UIImage(named: "background")?.cgImage
        _vm = HomepageVM(input: HomepageVM.Input(
            show: _btn_ble.rx.tap.asObservable()
        ))
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: SCREEN_HEIGHT/4, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*2/3), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        let dataSouce = RxCollectionViewSectionedReloadDataSource<SectionModel<String,DataElement>>(
            configureCell:{
                (dataSouece, tv, indexPath, element) -> HomePageCollectionViewCell in
                let cell = tv.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomePageCollectionViewCell
                cell.title_homepage_title.text = element.itemTitle
                cell.icon_item_homepage.image = element.itemImage
//                cell.icon_item_homepage.backgroundColor = UIColor.red
//                cell.backgroundColor = UIColor.green
                return cell
            }
        )
        
        collectionView.rx.setDelegate(self).disposed(by: _bag)
        
        items.bind(to: collectionView.rx.items(dataSource: dataSouce))
            .disposed(by: _bag)
        
        collectionView.register(UINib(nibName: "HomePageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
        _vm.output.showResult.subscribe { (string) in
//            QuickAlert.alert(title: string, message:"onnext", btnTitle: "ok", btnAction: nil)
            self.navigationController?.pushViewController(BleConnectViewController(), animated: true)
        } onError: { (error) in
            print(error)
        } onCompleted: {
            print("onCompleted")
        } onDisposed: {
            print("onDisposed")
        }.disposed(by: _bag)
        // Do any additional setup after loading the view.
//        test()
    }
    
    var time:TimeInterval?
    
    func test() -> Void {
        print("---------测试----------")
        time = Date().timeIntervalSince1970
        let timer = Timer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .default)

    }
    // 执行的Action
    @objc private func timerAction() {
            // 需要执行的操作
        let time2 = Date().timeIntervalSince1970
        print("时间戳:\(time)   时间戳2:\(time2)  时间戳3:\(time2 - time!)")
    }
    
    var firstAppear = true
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppear {
            firstAppear = false
            let indexPath = IndexPath(row: 1, section: 0)
            collectionView.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: false)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if let selectedIndex = collectionView.indexPathsForSelectedItems {//已选中的列表,初次进来是0个
            if selectedIndex.count == 1 {//非第一次选择
                if indexPath.row == selectedIndex[0].row {
                    self.navigationController?.pushViewController(dataItem[indexPath.row].vc, animated: true)
                }
            }else{//第一次选择
                if indexPath.row == 1{
                    self.navigationController?.pushViewController(IntegralModeVC(), animated: true)
                }
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: true)
    }
}

