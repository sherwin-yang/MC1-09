//
//  OnboardingSecondPageViewController.swift
//  MC1-09
//
//  Created by Sherwin Yang on 13/04/20.
//  Copyright © 2020 Sherwin Yang. All rights reserved.
//

import UIKit

class OnboardingSecondPageViewController: UIViewController {
    
    @IBOutlet weak var nextButton_secondPage: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton_secondPage.layer.cornerRadius = 35
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func nextToThirdPage(_ sender: Any) {
        self.performSegue(withIdentifier: "toThirdPage", sender: self)
    }
    
    @IBAction func skipToMain(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(identifier: "MainStoryboard") as! UITabBarController
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
}
