//
//  MeetWebViewController.swift
//  Meet
//
//  Created by Zhang on 6/23/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import NJKWebViewProgress

class MeetWebViewController: UIViewController {

    var webView:UIWebView! = nil
    var url: String! = ""
    var progressProxy:NJKWebViewProgress! = nil
    var progressView:NJKWebViewProgressView! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWebView(url)
        self.setUpNavigationBar()
        self.talKingDataPageName = "Home-Detail-MeetWeb"

        // Do any additional setup after loading the view.
    }
    
    func setUpWebView(_ url: String){
        webView = UIWebView()
        webView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor);
        let url = URL.init(string: url)
        let request = URLRequest.init(url: url!)
//        progressProxy = NJKWebViewProgress()
        webView.delegate = self
//        progressProxy.webViewProxyDelegate = self
//        progressProxy.progressDelegate = self
        //
//        let  progressBarHeight:CGFloat = 2
//        let  navigationBarBounds:CGRect = self.navigationController!.navigationBar.bounds;
//        let barFrame:CGRect = CGRectMake(0, 64, navigationBarBounds.size.width, progressBarHeight);
//        progressView = NJKWebViewProgressView(frame:barFrame);
//        progressView.autoresizingMask = [.FlexibleWidth,.FlexibleTopMargin]
        
        
        
        
        webView.loadRequest(request)
        

        
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
        }
    }

    func setUpNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MeetWebViewController.leftItemClick(_:)))
        self.navigaitonItemColor(UIColor.init(hexString: "202020"))
    }
    
    func leftItemClick(_ sender:UIBarButtonItem){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MeetWebViewController : UIWebViewDelegate
{
    
}

//extension MeetWebViewController : NJKWebViewProgressDelegate {
//    
////    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
////        progressView.setProgress(progress, animated: true)
////    }
//}
