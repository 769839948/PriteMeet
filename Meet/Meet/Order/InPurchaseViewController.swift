//
//  InPurchaseViewController.swift
//  Meet
//
//  Created by Zhang on 06/10/2016.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import StoreKit

enum PayCoinsTag {
    case IAP0100
    case IAP0200
    case IAP01000
}

let cellIndef = "InPurchaseTable"

class NumberCoins: UIView {
    var numberLabel:UILabel!
    var detailLable:UILabel!
    
    init(frame:CGRect, number:String) {
        super.init(frame: frame)
        self.setUpView(number: number)
    }
    
    func setUpView(number:String) {
        numberLabel = UILabel(frame:CGRect.init(x: 0, y: 52, width: ScreenWidth, height: 76))
        numberLabel.text = number
        numberLabel.textAlignment = .center
        numberLabel.font = InPurchaseNumberFont
        numberLabel.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        self.addSubview(numberLabel)
        
        detailLable = UILabel(frame:CGRect.init(x: 0, y: numberLabel.frame.maxY + 2, width: ScreenWidth, height: 17))
        detailLable.text = "账户余额 ( 美豆 )"
        detailLable.textAlignment = .center
        detailLable.font = InPurchaseDetailFont
        detailLable.textColor = UIColor.init(hexString: HomeDetailViewPositionColor)
        self.addSubview(detailLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class InPurchaseViewController: UIViewController {

    var button:UIButton!
    let viewModel = OrderViewModel()
    var tableView:UITableView!
    var numberCoins:NumberCoins!
    
    let cellImageArray = ["InPurchase-10","InPurchase-44","InPurchase-98"]
    let cellTitleArray = ["购买100美豆","购买200美豆","购买300美豆"]
    let cellButtonTitleArray = ["￥5.00","￥44.00","￥98.00"]
    
    var bottomLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        self.setNavigationItemDisMiss()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.navigationItemCleanColorWithNotLine()
        self.setUpView()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    
    func setUpView() {
        numberCoins = NumberCoins.init(frame: CGRect.init(x: 0, y: 64, width: ScreenWidth, height: 214), number: "28")
        self.view.addSubview(numberCoins)
        
        tableView = UITableView(frame: CGRect.init(x: 0, y: numberCoins.frame.maxY, width: ScreenWidth, height: 186), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(InPurchaseTableViewCell.self, forCellReuseIdentifier: cellIndef)
        self.view.addSubview(tableView)
        
        bottomLabel = UILabel(frame:CGRect.init(x: 0, y: ScreenHeight - 64, width: ScreenWidth, height: 17))
        let attributedString = NSMutableAttributedString(string: "充值遇到问题请 咨询客服")
        attributedString.addAttributes([NSFontAttributeName:InPurchaseDetailFont!], range: NSRange.init(location: 0, length: 7))
        attributedString.addAttributes([NSFontAttributeName:InPurchaseDetailFont!], range: NSRange.init(location: 8, length: 4))
        attributedString.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: HomeDetailViewPositionColor)], range: NSRange.init(location: 0, length: 7))
        attributedString.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: MeProfileCollectViewItemSelect)], range: NSRange.init(location: 8, length: 4))
        bottomLabel.attributedText = attributedString
        bottomLabel.textAlignment = .center
        self.view.addSubview(bottomLabel)
    }
    
    func buttonTag(){
        self.buy(type: 100)
    }
    
    func buy(type:Int) {
        if SKPaymentQueue.canMakePayments() {
            print("允许内购")
            self.requestProduceData()
        }else{
            print("不允许内购")
        }
    }
    
    func requestProduceData() {
//        let nsset = NSSet.init(array: product as! [NSArray])
        let str = NSSet.init(array: ["com.meet.meet100","app200"])
        let request = SKProductsRequest(productIdentifiers: str as! Set<String>)
//        let request = SKProductsRequest(productIdentifiers: nsset as! Set<String>)
        request.delegate = self
        request.start()
    }
    
    
    func requestProupgradeProductData() {
        print("-----------请求升级数据--------")
        let productIdentifiers = NSSet.init(object: "com.produvtion")
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("------弹出错误信息--------")
        UIAlertController.shwoAlertControl(self, title: "错误信息", message: "错误信息", cancel: "确定", doneTitle: "确定", cancelAction: {
            
            }, doneAction: {
                
        })
    }
    
    func requestDidFinish(_ request: SKRequest) {
        
        print("----------反馈信息结束--------------")
    }
    
    func purchasedTransaction(transaction:SKPaymentTransaction) {
        print("-----PurchasedTransaction----")
        let transactions = NSArray(object: transaction)
        self.paymentQueue(SKPaymentQueue.default(), updatedTransactions: transactions as! [SKPaymentTransaction])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func completeTransaction(transaction:SKPaymentTransaction) {
        print("-----completeTransaction--------");
        // Your application should implement these two methods.
//        let jsonObjectString = transaction.original.
//         NSString* jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
        print(transaction.downloads)
        print(transaction.original)
        print(transaction.transactionDate)
        let rejectUrl = NSData.init(contentsOf:Bundle.main.appStoreReceiptURL!)
        let jsonStr = rejectUrl?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        print(jsonStr)
        SKPaymentQueue.default().finishTransaction(transaction)
        viewModel.rejectUrlforAppStore(jsonStr, successBlock: { (dic) in
            print("\(dic?["success"])")
            }, fail: { (dic) in
            print("支付失败")
        })
    }

    
    func failedTransaction(transaction:SKPaymentTransaction){
        print("失败");
//        if (transaction.error != SKError.paymentCancelled)
//        {
//        
//        }
        SKPaymentQueue.default().finishTransaction(transaction)
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension InPurchaseViewController : SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("--------paymentQueue")
        for trannsaction in transactions {
            switch trannsaction.transactionState {
            case .purchased:
                print("支付完成")
                self.completeTransaction(transaction: trannsaction)
            case .failed:
                print("支付失败")
                self.failedTransaction(transaction: trannsaction)
            case .restored:
                print("已经购买过此商品")
                self.completeTransaction(transaction: trannsaction)
            case .purchasing:
                print("商品添加进列表")
            default:
                break;
            }
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("交易完成")
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("回复交易")
    }
}

extension InPurchaseViewController : SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("-------收到产品反馈信息----------")
        let myProduct = response.products
        print("产品Product ID:\(response.invalidProductIdentifiers)")
        print("产品付费数量:\(myProduct.count)")
        for product in myProduct {
            print("product info");
            print("SKProduct 描述信息\(product.description)");
            print("产品标题 \(product.localizedTitle)");
            print("产品描述信息: \(product.localizedDescription)");
            print("价格: \(product.price)");
            print("Product id: \(product.productIdentifier)");
        }
        
        if myProduct.count > 0 {
            print("发送购买请求")
            let payment = SKPayment.init(product: myProduct[0])
            SKPaymentQueue.default().add(payment)
        }
    }
}

extension InPurchaseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension InPurchaseViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndef, for: indexPath) as! InPurchaseTableViewCell
        cell.setUpData(image: UIImage.init(named:cellImageArray[indexPath.row])!, title: cellTitleArray[indexPath.row], buttonTitle: cellButtonTitleArray[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
