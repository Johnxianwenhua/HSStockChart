//
//  LandscapeViewController.swift
//  HSStockChartDemo
//
//  Created by Hanson on 16/9/1.
//  Copyright © 2016年 hanson. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    var pageMenu : CAPSPageMenu?
    var stockBriefView: HSStockBriefView?
    var kLineBriefView: HSKLineBriefView?
    var controllerArray: [UIViewController] = []
    var parameters: [CAPSPageMenuOption] = []
    var viewindex: Int = 0
    
    
    //MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(showLongPressView), name: NSNotification.Name(rawValue: "TimeLineLongpress"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUnLongPressView), name: NSNotification.Name(rawValue: "TimeLineUnLongpress"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKLineChartLongPressView), name: NSNotification.Name(rawValue: KLineChartLongPress), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKLineChartUnLongPressView), name: NSNotification.Name(rawValue: KLineChartUnLongPress), object: nil)
        
        let timeViewcontroller = ChartViewController()
        timeViewcontroller.chartType = HSChartType.timeLineForDay
        timeViewcontroller.title = "分时"
        controllerArray.append(timeViewcontroller)
        
        let fiveDayTimeViewController = ChartViewController()
        fiveDayTimeViewController.chartType = HSChartType.timeLineForFiveday
        fiveDayTimeViewController.title = "五日"
        controllerArray.append(fiveDayTimeViewController)
        
        let kLineViewController = ChartViewController()
        kLineViewController.chartType = HSChartType.kLineForDay
        kLineViewController.title = "日K"
        controllerArray.append(kLineViewController)
        
        let weeklyKLineViewController = ChartViewController()
        weeklyKLineViewController.chartType = HSChartType.kLineForWeek
        weeklyKLineViewController.title = "周K"
        controllerArray.append(weeklyKLineViewController)
        
        let monthlyKLineViewController = ChartViewController()
        monthlyKLineViewController.chartType = HSChartType.kLineForMonth
        monthlyKLineViewController.title = "月K"
        controllerArray.append(monthlyKLineViewController)
        
        let oneMonthViewController = UIViewController()
        oneMonthViewController.title = "1月"
        controllerArray.append(oneMonthViewController)
        
        let sixMonthViewController = UIViewController()
        sixMonthViewController.title = "6月"
        controllerArray.append(sixMonthViewController)
        
        let threeYearViewController = UIViewController()
        threeYearViewController.title = "3年"
        controllerArray.append(threeYearViewController)
        
        let  allViewController = UIViewController()
        allViewController.title = "全部"
        controllerArray.append(allViewController)
        
        parameters = [
            .scrollMenuBackgroundColor(UIColor.white),
            .selectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .unselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
            .menuItemSeparatorHidden(true),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .titleTextSizeBasedOnMenuItemWidth(true)
        ]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 横屏切换时，frame 的 width 和 Height 在 viewDidLayoutSubviews 中才变化，但是该方法会调用多次
        //setUpControllerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setUpControllerView()
        
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    @IBAction func backButtonDidClick(_ sender: AnyObject) {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Function
    
    func setUpControllerView() {
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 30, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.moveToPage(self.viewindex)
        
        stockBriefView = HSStockBriefView(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: 34))
        stockBriefView?.isHidden = true
        
        kLineBriefView = HSKLineBriefView(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: 34))
        kLineBriefView?.isHidden = true
        
        self.view.addSubview(pageMenu!.view)
        self.view.addSubview(stockBriefView!)
        self.view.addSubview(kLineBriefView!)

    }
    
    
    // MARK: - Handle Notification function
    
    func showLongPressView(_ notification: Notification) {
        let dataDictionary = (notification as NSNotification).userInfo as! [String: AnyObject]
        let timeLineEntity = dataDictionary["timeLineEntity"] as! TimeLineEntity
        stockBriefView?.isHidden = false
        stockBriefView?.configureView(timeLineEntity)
    }
    
    func showUnLongPressView() {
        stockBriefView?.isHidden = true
    }
    
    func showKLineChartLongPressView(_ notification: Notification) {
        let dataDictionary = (notification as NSNotification).userInfo as! [String: AnyObject]
        let preClose = dataDictionary["preClose"] as! CGFloat
        let klineEntity = dataDictionary["kLineEntity"] as! KLineEntity
        kLineBriefView?.configureView(preClose, kLineEntity: klineEntity)
        kLineBriefView?.isHidden = false
    }
    
    func showKLineChartUnLongPressView(_ notification: Notification) {
        kLineBriefView?.isHidden = true
    }
    
    
}
