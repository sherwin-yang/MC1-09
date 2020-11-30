//
//  OnboardingThirdPageViewController.swift
//  MC1-09
//
//  Created by Sherwin Yang on 13/04/20.
//  Copyright © 2020 Sherwin Yang. All rights reserved.
//

import UIKit

class OnboardingThirdPageViewController: UIViewController {
    
    @IBOutlet weak var nextButton_thirdPage: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton_thirdPage.layer.cornerRadius = 35
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func getStarted(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(identifier: "MainStoryboard") as! UITabBarController
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
    
    @IBAction func skipToMain(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(identifier: "MainStoryboard") as! UITabBarController
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }

}
