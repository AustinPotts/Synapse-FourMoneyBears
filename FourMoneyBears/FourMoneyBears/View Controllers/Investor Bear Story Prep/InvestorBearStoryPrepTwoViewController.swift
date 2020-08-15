//
//  InvestorBearStoryPrepTwoViewController.swift
//  FourMoneyBears
//
//  Created by Austin Potts on 7/30/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class InvestorBearStoryPrepTwoViewController: UIViewController {

    //MARK: - Interface Outlets
    @IBOutlet var seeExampleButton: UIButton!
    @IBOutlet var investorBearText: UITextView!
    @IBOutlet var textBubbleOne: UIView!
    @IBOutlet var textBubbleTwo: UIView!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animateText()
        setUpMiscViews()
        setUpBubbleViews()
        investorBearText.isHidden = true
        textBubbleOne.isHidden = true
        textBubbleTwo.isHidden = true
    }
    
    
    //MARK: - Set Up Views
    func setUpMiscViews(){
        seeExampleButton.layer.cornerRadius = 20
        investorBearText.layer.cornerRadius = 20
        seeExampleButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        seeExampleButton.layer.shadowRadius = 5
        seeExampleButton.layer.shadowOpacity = 1.0
        
    }
    
    //MARK: - Set Up Text Animations
    func animateText() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.textBubbleOne.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.textBubbleTwo.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.investorBearText.isHidden = false
        }
        
    }
    
    //MARK: - Set Up Text Bubble Views
    func setUpBubbleViews(){
        self.textBubbleOne.layer.cornerRadius = self.textBubbleOne.frame.height / 2
        self.textBubbleOne.layer.masksToBounds = false
        self.textBubbleOne.clipsToBounds = true
        self.textBubbleTwo.layer.cornerRadius = self.textBubbleTwo.frame.height / 2
        self.textBubbleTwo.layer.masksToBounds = false
        self.textBubbleTwo.clipsToBounds = true
        
    }
    
}
