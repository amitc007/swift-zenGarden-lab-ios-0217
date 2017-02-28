//
//  ViewController.swift
//  ZenGarden
//
//  Created by Flatiron School on 6/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var rakeImage: UIImageView!
    @IBOutlet weak var rockImage: UIImageView!
    @IBOutlet weak var shrubImage: UIImageView!
    @IBOutlet weak var swordImage: UIImageView!
    
    
    //tag set in storyboard
    let rake = 1
    let rock = 2
    let shrub = 3
    let sword = 4
    
    var xRakeLoc = CGFloat()
    var yRakeLoc = CGFloat()
    var xRockLoc = CGFloat()
    var yRockLoc = CGFloat()
    var xShrubLoc = CGFloat()
    var yShrubLoc = CGFloat()
    var xSwordLoc = CGFloat()
    var ySwordLoc = CGFloat()
    
    var xBound = CGFloat()
    var yBound = CGFloat()
    
    func scramble() {
        //super.init()
        xBound = UIScreen.main.bounds.width
        yBound = UIScreen.main.bounds.height
        print("xBound:\(xBound) yBound:\(yBound)")
        let moveRakex = CGFloat(arc4random_uniform(UInt32(xBound - rakeImage.frame.width)))
        let moveRakey = CGFloat(arc4random_uniform(UInt32(yBound - rakeImage.frame.height)))
        
        print("moveRakex:\(moveRakex) moveRakey:\(moveRakey)")
        
        print("Before move rakeImage x:\(rakeImage.frame.origin.x) y:\(rakeImage.frame.origin.y)")
        
        //rake
        rakeImage.frame.origin.x = moveRakex   //change pos
        rakeImage.frame.origin.y = moveRakey
        xRakeLoc = rakeImage.frame.origin.x    //store loc
        yRakeLoc = rakeImage.frame.origin.y
        
        //shrub
        xShrubLoc = shrubImage.frame.origin.x
        yShrubLoc = shrubImage.frame.origin.y

        
        print("After move rakeImage x:\(rakeImage.frame.origin.x) y:\(rakeImage.frame.origin.y)")
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scramble()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        rakeImage.translatesAutoresizingMaskIntoConstraints = true
        scramble()
    }*/
    
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        //recognizer.translation(in: <#T##UIView?#>)
        print("handlePan called")
        let translation = recognizer.translation(in: self.view)
        if let gRView = recognizer.view {
            gRView.center = CGPoint(x:gRView.center.x + translation.x,
                                  y:gRView.center.y + translation.y)
            
            
            print("\(gRView.center) tag:\((recognizer.view as! UIImageView).tag)")
            
            switch (recognizer.view as! UIImageView).tag {
                case rake: xRakeLoc = gRView.center.x; yRakeLoc = gRView.center.y
                case rock: xRockLoc = gRView.center.x; yRockLoc = gRView.center.y
                case shrub: xShrubLoc = gRView.center.x; yShrubLoc = gRView.center.y
                case sword: xSwordLoc = gRView.center.x; ySwordLoc = gRView.center.y
                default: break
            }
        } //if let view = recognizer.view
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        checkWinner()
    }

    
    func checkWinner() {
        print("checking winner")
        let swordTopLeft = xSwordLoc < xBound/3 && ySwordLoc < yBound/3 ? true: false
        let swordBtmLeft = xSwordLoc < xBound/3 && ySwordLoc > yBound*2/3 ? true: false
        // sword top left or bottom left.
        if (swordTopLeft || swordBtmLeft)  &&
            // shrub & rake close
            ( sqrt(pow(xShrubLoc - xRakeLoc, 2) + pow(yShrubLoc - yRakeLoc, 2)) < sqrt(pow(xBound,2)+pow(yBound,2))/3 ) &&
            //stone on diff side
            ( (swordTopLeft && yRockLoc > yBound/2) || (swordBtmLeft && yRockLoc < yBound/2) )
        {
            let alert = UIAlertController(title: "Winner",
                                          message: "You have won!!!",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            self.present(alert, animated: true, completion:nil)
            
            alert.addAction(UIAlertAction(title: "Okay",
                                          style: UIAlertActionStyle.default)
                                          { (action) in /*self.scramble()*/ } )
        }
        
        print("swordTopLeft:\(swordTopLeft) swordBtmLeft:\(swordBtmLeft)")
        /*print("ShrubLoc x:\(xShrubLoc) y:\(yShrubLoc) xRakeLoc:\(xRakeLoc) yRakeLoc:\(yRakeLoc)" ) */
        print("shrub & rake dist:\( sqrt(pow(xShrubLoc - xRakeLoc, 2) + pow(yShrubLoc - yRakeLoc, 2)))")
        print("view diagnol/3: \(sqrt(pow(xBound,2)+pow(yBound,2))/3)")
        print("sword & rock opp dir: \( (swordTopLeft && yRockLoc > yBound/2) || (swordBtmLeft && yRockLoc < yBound/2) )")
        
    } //func
    
}

