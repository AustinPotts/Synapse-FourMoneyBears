//
//  SpenderBearGameFourViewController.swift
//  FourMoneyBears
//
//  Created by Austin Potts on 7/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase
import AVFoundation


class SpenderBearGameFourViewController: UIViewController {
    
    
    
    @IBOutlet var statusBar: UIView!
    @IBOutlet var orangeStatus: UIView!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
   
    @IBOutlet var spenderBearImage: UIImageView!
    @IBOutlet var audioPlayerView: UIView!
    @IBOutlet var userHealthLabel: UILabel!
    
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpMiscViews()
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.userHealthLabel.text = dictionary["health"] as? String
            }
            print(snapshot)
        }, withCancel: nil)
        
        audioPlayer()
    }
    
    func audioPlayer(){
        
        do {
            let audioPath = Bundle.main.path(forResource: "sniper", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        } catch {
            
        }
        
    }
    
    //MARK: TASK: Increase Users Rank by 10 when they get the final correct answer
    // Step 1. Fetch the users Data
    // Step 2. Increment Rank
    // Step 3. Put new Rank to Database
    
    //MARK:- Update Users Rank by 10
    func updateData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var userRank = 10
        
        let values = ["rank": "\(userRank)"]
        
        self.createCopyForUserRank(uid: uid,values: values as [String : AnyObject])
    }
    
    func createCopyForUserRank(uid: String, values: [String: AnyObject]) {
        var ref: DatabaseReference!
            
            ref = Database.database().reference(fromURL: "https://fourbears-63cd1.firebaseio.com/")
            
            let userRef = ref.child("users").child(uid)
            
           
            
            userRef.updateChildValues(values) { (error, refer) in
                if let error = error {
                    print("ERROR CHILD values: \(error)")
                    return
                }
         }
    }
        
    
    
    
    func setUpMiscViews() {
        statusBar.layer.cornerRadius = 9
        orangeStatus.layer.cornerRadius = 9
        yesButton.layer.cornerRadius = 20
        noButton.layer.cornerRadius = 20
        audioPlayerView.layer.cornerRadius = 20
        spenderBearImage.layer.cornerRadius = 50
        
    }
    
    func animateStatusBar(){
          UIView.animate(withDuration: 2, animations: {
               // self.orangeStatus.frame.origin.x -= 70
              self.orangeStatus.translatesAutoresizingMaskIntoConstraints = false
              self.orangeStatus.layer.frame.size.width += 15
              
             
            })
      }
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        player.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func xTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
    
    
   
    
    @IBAction func yesTapped(_ sender: Any) {
       SCLAlertView().showError("Wrong Answer", subTitle: "Try Again!")
    }
    
    @IBAction func noTapped(_ sender: Any) {
        let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showCustom("Good job, you won!", subTitle: "Reward: 10xp", color: UIColor.white, icon: UIImage(named: "Crown-fill.png")!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
            alertViewResponder.close()
        }
        
        animateStatusBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
            self.updateData()
            NotificationCenter.default.post(name: .didReceiveData, object: nil)
            
        }
        
    }
    
}

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let onDidReceiveDataSaver = Notification.Name("onDidReceiveDataSaver")
    static let onDidReceiveDataGiver = Notification.Name("onDidReceiveDataGiver")
    static let onDidReceiveDataInvestor = Notification.Name("onDidReceiveDataInvestor")
}
