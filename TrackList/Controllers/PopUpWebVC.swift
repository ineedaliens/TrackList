//
//  PopUpWebVC.swift
//  TrackList
//
//  Created by Евгений on 08.03.2021.
//

import UIKit
import WebKit

class PopUpWebVC: UIViewController {
    @IBOutlet var views: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    private var tracklists: TrackList?
    var tvc = TrackListTVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views.layer.cornerRadius = 24
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        moveIn()
        tvc.tracklistHandler = { tracklist in
            self.tracklists = tracklist
        }
        print(tracklists?.link)
    }

    func moveIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.24) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }
    }
    
    func moveOut() {
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.view.removeFromSuperview()
        moveOut()
    }
    

}
