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
        // Do any additional setup after loading the view.
    }
    
    func setUpWebView(url: String){
        webView = UIWebView()
        progressProxy = NJKWebViewProgress() // instance variable
        webView.backgroundColor = UIColor.init(hexString: TableViewBackGroundColor);
        let url = NSURL.init(string: url)
        let request = NSURLRequest.init(URL: url!)
        webView.loadRequest(request)
        progressProxy = NJKWebViewProgress()
        webView.delegate = self
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
//
//        
        let  progressBarHeight:CGFloat = 2
        let  navigationBarBounds:CGRect = self.navigationController!.navigationBar.bounds;
        let barFrame:CGRect = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        progressView = NJKWebViewProgressView(frame:barFrame);
        progressView.autoresizingMask = [.FlexibleWidth,.FlexibleTopMargin]
        
        self.view.addSubview(webView)
        
        webView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(0)
            make.left.equalTo(self.view.snp_left).offset(0)
            make.right.equalTo(self.view.snp_right).offset(0)
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
    }
    
    func setUpNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_back"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeetWebViewController.leftItemClick(_:)))
        self.navigaitonItemColor(UIColor.init(hexString: "202020"))
    }
    
    func leftItemClick(sender:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AboutDetailViewController : UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title");
        self.navigationItem.title = title
        return true
    }
    
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title");
        self.navigationItem.title = title
    }
}

extension AboutDetailViewController : NJKWebViewProgressDelegate {
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
}
