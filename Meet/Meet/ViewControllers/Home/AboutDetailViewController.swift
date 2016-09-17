//
//  AboutDetailViewController.swift
//  Meet
//
//  Created by Zhang on 6/17/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit
import NJKWebViewProgress

class AboutDetailViewController: UIViewController {

    var webView:UIWebView! = nil
    var url: String! = ""
    var progressProxy:NJKWebViewProgress! = nil
    var progressView:NJKWebViewProgressView! = nil
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor);
        super.viewDidLoad()
        
        self.setUpWebView(url)
        self.setUpNavigationBar()
        
        self.talKingDataPageName = "Home-Detail-AboutDetail"

        // Do any additional setup after loading the view.
    }
    
    func setUpWebView(_ url: String){
        webView = UIWebView()
        progressProxy = NJKWebViewProgress() // instance variable
        webView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor);
        let url = URL.init(string: url)
        let request = URLRequest.init(url: url!)
        webView.loadRequest(request)
//        progressProxy = NJKWebViewProgress()
        webView.delegate = self
//        progressProxy.webViewProxyDelegate = self
//        progressProxy.progressDelegate = self
//
//        
//        let  progressBarHeight:CGFloat = 2
//        let  navigationBarBounds:CGRect = self.navigationController!.navigationBar.bounds;
//        let barFrame:CGRect = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
//        progressView = NJKWebViewProgressView(frame:barFrame);
//        progressView.autoresizingMask = [.FlexibleWidth,.FlexibleTopMargin]
        
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

}

extension AboutDetailViewController : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let title = webView.stringByEvaluatingJavaScript(from: "document.title");
        self.navigationItem.title = title
        return true
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.webkitTextFillColor= '202020'")
        let title = webView.stringByEvaluatingJavaScript(from: "document.title");
        self.navigationItem.title = title
    }
}

//extension AboutDetailViewController : NJKWebViewProgressDelegate {
//    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
//        progressView.setProgress(progress, animated: true)
//    }
//}
