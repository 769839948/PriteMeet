//
//  MeetWebViewController.swift
//  Meet
//
//  Created by Zhang on 6/23/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

class MeetWebViewController: UIViewController {

    var webView:UIWebView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWebView()
        self.setUpNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func setUpWebView(){
        webView = UIWebView()
        let url = NSURL.init(string: "https://jinshuju.net/f/yzVBmI")
        let request = NSURLRequest.init(URL: url!)
        webView.loadRequest(request)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
