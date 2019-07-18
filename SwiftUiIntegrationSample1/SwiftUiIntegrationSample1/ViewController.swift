//
//  ViewController.swift
//  SwiftUiIntegrationSample1
//
//  Created by Ranjeet on 16/07/19.
//  Copyright © 2019 Ranjeet. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class AppSettings: BindableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    var userName = "Ranjeet" {
        didSet {
            didChange.send(())
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var settings = AppSettings()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UIView"
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.label.text = "I am in UI View controler user name \(settings.userName)"
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        debugPrint("Button tapped")
        
       let vc = UIHostingController(rootView: SwiftUIView().environmentObject(settings))
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

