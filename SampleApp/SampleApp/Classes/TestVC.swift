//
//  TestVC.swift
//  SampleApp
//
//  Created by Aniruddha Das on 24/07/20.
//  Copyright © 2020 Cred. All rights reserved.
//

import UIKit

class TestVC: UIViewController {
    @IBOutlet weak var headerLbl: UILabel!
    private let position: Int
    private let bgColor: UIColor
    
    init(position: Int, bgColor: UIColor) {
        self.position = position
        self.bgColor = bgColor
        
        super.init(nibName: "TestVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = bgColor
        headerLbl.text = "VIEW - \(position)"
    }
}
