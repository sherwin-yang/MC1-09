//
//  OnboardingFirstPageViewController.swift
//  MC1-09
//
//  Created by Sherwin Yang on 13/04/20.
//  Copyright © 2020 Sherwin Yang. All rights reserved.
//

import UIKit

class OnboardingFirstPageViewController: UIViewController {

    @IBOutlet weak var nextButton_firstPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton_firstPage.layer.cornerRadius = 35
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func nextToSecondPage(_ sender: Any) {
        self.performSegue(withIdentifier: "toSecondPage", sender: self)
    }

    @IBAction func skipToMain(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(identifier: "MainStoryboard") as! UITabBarController
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
}
