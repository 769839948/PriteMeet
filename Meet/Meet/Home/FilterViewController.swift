//
//  FilterViewController.swift
//  Meet
//
//  Created by Zhang on 19/09/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

typealias FileStringClouse = (_ filterStr:String) -> Void

class FilterViewController: UIViewController {

    let genderArray:NSArray = ["不限","只看男神","只看女神"]
    let sortArray:NSArray = ["智能排序","离我最近"]
    
    var selectItemSort:SelectItemView!
    var selectItemGender:SelectItemView!
    
    var insturyTextField:UITextField!
    
    var pickerView:ZHPickView!

    var filterStr:String = "recommend"
    
    var genderStr:String = "0"
    
    var instureStr:String = "0"
    
    var fileStringClouse:FileStringClouse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItemWhiteColorAndNotLine()
        self.setUpNavigationItem()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    func setUpNavigationItem() {
        self.setNavigationItemDisMiss()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: Selector?(#selector(FilterViewController.rightItemClick(_:))))
    }
    
    func rightItemClick(_ sender:UIBarButtonItem) {
        var str = "&filter=\(filterStr)"
        if instureStr != "0" {
            str = str.appending("&industry=\(instureStr)")
        }
        str = str.appending("&gender=\(genderStr)")
        if fileStringClouse != nil {
            self.fileStringClouse(str)
        }
        self.dismiss(animated: true) { 
            
        }
    }
    
    func setUpView() {
        let filterTitle = UILabel(frame: CGRect.init(x: 40, y: 71, width: 60, height: 42))
        filterTitle.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        filterTitle.text = "筛选"
        filterTitle.font = FilterViewTitleFont
        self.view.addSubview(filterTitle)
        
        let sort = self.setUpInfoLabel(frame: CGRect.init(x: 40, y: filterTitle.frame.maxY + 70, width: 64, height: 22), title: "排序")
        self.view.addSubview(sort)
        
        self.view.addSubview(self.setUpLineLabel(frame: CGRect.init(x: 40, y: sort.frame.maxY + 27, width: ScreenWidth - 80, height: 0.5)))
        
        selectItemSort = self.setUpSelectView(frame: CGRect.init(x: (ScreenWidth - 40 - 164), y: sort.frame.minY - 4, width: 164, height: 31), tag: 2)
        self.view.addSubview(selectItemSort)
        
        let industry = self.setUpInfoLabel(frame: CGRect.init(x: 40, y: sort.frame.maxY + 50, width: 64, height: 22), title: "选择行业")
        self.view.addSubview(industry)
        
        insturyTextField = self.setUpTextField(frame: CGRect.init(x: industry.frame.maxX + 18, y: industry.frame.minY + 2, width: ScreenWidth - industry.frame.maxX - 40, height: 22))
        self.view.addSubview(insturyTextField)
        
        let infoNext = UIImage.init(named: "info_next")
        let infoNextImageView = UIImageView(frame: CGRect.init(x: ScreenWidth - 40 - infoNext!.size.width, y: industry.frame.minY + 7, width: (infoNext?.size.width)!, height: (infoNext?.size.height)!))
        infoNextImageView.image = infoNext
        self.view.addSubview(infoNextImageView)
        
        self.view.addSubview(self.setUpLineLabel(frame: CGRect.init(x: 40, y: industry.frame.maxY + 27, width: ScreenWidth - 80, height: 0.5)))

        
        let gender = self.setUpInfoLabel(frame: CGRect.init(x: 40, y: industry.frame.maxY + 50, width: 64, height: 22), title: "性别")
        self.view.addSubview(gender)
        
        selectItemGender = self.setUpSelectView(frame: CGRect.init(x: (ScreenWidth - 40 - 222), y: gender.frame.minY - 4, width: 222, height: 31), tag: 1)
        self.view.addSubview(selectItemGender)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpInfoLabel(frame:CGRect, title:String) -> UILabel {
        let infoLabel = UILabel(frame: frame)
        infoLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        infoLabel.text = title
        infoLabel.font = FilterViewTitleInfoFont
        return infoLabel
    }
    
    func setUpLineLabel(frame:CGRect) -> UILabel {
        let lineLabel = UILabel(frame: frame)
        lineLabel.backgroundColor = UIColor.init(hexString: lineLabelBackgroundColor)
        return lineLabel
    }

    
    func setUpSelectView(frame:CGRect, tag:NSInteger) -> SelectItemView {
        let selectItem = SelectItemView.init(frame:frame)
        selectItem.tag = tag
        selectItem.delegate = self
        selectItem.dataSource = self
        selectItem.setUpView()
        return selectItem
    }
    
    func setUpTextField(frame:CGRect) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.placeholder = "互联网"
        textField.delegate = self
        textField.font = FilterViewTitleInfoFont
        textField.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        textField.endEditing(false)
        return textField
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showPickView() {
        pickerView = ZHPickView.init(pickviewWith: ["互联网/软件","金融","重工制造","电信","农林牧渔"], isHaveNavControler: false)
        pickerView.delegate = self
        pickerView.setToolbarTintColor(UIColor.white)
        pickerView.setTintFont(IQKeyboardManagerFont, color: UIColor.init(hexString: IQKeyboardManagerTinColor))
        pickerView.setSelectRow(1, inComponent: 0, animate: true)
        pickerView.setToobarCenterTitle("选择行业", color: UIColor.init(hexString: IQKeyboardManagerTinColor), font: IQKeyboardManagerplaceholderFont)
        pickerView.setPickViewColer(UIColor.white)
        pickerView.show()
    }

}

extension FilterViewController : SelectItemViewDelegate {
    func selectViewDidSelectItem(selectView: SelectItemView, selectItem: NSInteger) {
        if selectView.tag == 1 {
            genderStr = "\(selectItem)"
        }else{
            filterStr = selectItem == 0 ? "recommend":"location"
        }
    }

}

extension FilterViewController : SelectItemViewDataSource {
    func selectViewNuberOfItem(selectView: SelectItemView) -> NSInteger {
        if selectView.tag == 1 {
            return 3
        }else{
            return 2
        }
    }
    
    func selectViewItemTitle(selectView: SelectItemView, index: NSInteger) -> String {
        if selectView.tag == 1 {
            return genderArray[index] as! String
        }
        return sortArray[index] as! String
    }
}

extension FilterViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.showPickView()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension FilterViewController : ZHPickViewDelegate {
    func toobarDonBtnHaveClick(_ pickView: ZHPickView!, resultString: String!) {
        insturyTextField.text = resultString
//        instureStr = ((((ProfileKeyAndValue.shareInstance().appDic as NSDictionary).object(forKey: "industry") as! NSDictionary).object(forKey: resultString))! as! String)
    }
}
