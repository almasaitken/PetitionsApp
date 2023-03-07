//
//  DetailViewController.swift
//  Project7_reedo
//
//  Created by Almas Aitken on 06.01.2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var petition: Petition!
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let petition = petition {
            let htmlString = """
            <!DOCTYPE>
            <html>
            <head>
            <title> "Petition data" </title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            </head>
            <body>
            <h3> \(petition.title) </h3>
            <p> \(petition.body) </p>
            </body>
            </html>
            """
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
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
