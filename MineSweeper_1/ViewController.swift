

//
//  ViewController.swift
//  MineSweeper_1
//
//  Created by Ekveera on 1/20/17.
//  Copyright © 2017 Ekveera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var smileyButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    var cellTitles = [String]()
    var mineCellNos = [Int]()
    var lookupStrCoords = [String : Int]()
    var neighbors = [Int : [[CustomButton]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBoard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateRandomMineCellNos(numOfCells : Int){
        let randomMineCellnumber = Int(arc4random_uniform(UInt32(numOfCells))+1)
        mineCellNos.append(randomMineCellnumber)
    }
    
    func createBoard(){
         cellTitles = [String]()
         mineCellNos = [Int]()
         lookupStrCoords = [String : Int]()
         neighbors = [Int : [[CustomButton]]]()

        var y :CGFloat = 150
        var tag : Int = 1;
        
        for _ in 1...10{
            generateRandomMineCellNos(numOfCells: 64)
        }
        
        smileyButton.setBackgroundImage(UIImage(named: "smiley_h"),for: UIControlState.normal)
        
        newGameButton.layer.cornerRadius = 5
        newGameButton.layer.borderWidth = 2
        newGameButton.layer.borderColor = UIColor.black.cgColor
        newGameButton.layer.backgroundColor = UIColor.lightGray.cgColor
        
        for i in 1...8{
            var x :CGFloat = 60
            for j in 1...8 {
               
                let button = CustomButton(frame: CGRect(x: x, y: y, width: 25, height: 25))
              
                button.setTitle("", for: .normal)
                button.backgroundColor = UIColor.lightGray
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.tag = tag
                let iStr = String(i)
                let jStr = String(j)
                let coordsTag = iStr.appending(jStr)
                
                button.setValue([i,j], forKey: "coords")
                button.setValue(coordsTag, forKey: "coordsTag")
                
                lookupStrCoords[coordsTag] = tag
               
                button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                
                if mineCellNos.index(of: tag) == nil{
                    let title = String(Int(arc4random_uniform(3)))
                    cellTitles.append(title)
                }
                else{
                    cellTitles.append(String("mine"))
                }
               
                button.setTitle("", for: .normal)
                self.view.addSubview(button)
                x = x + 25.0
                
                getNeighbours(cellTag: tag, x: i, y: j)
                tag = tag + 1
            }
            y = y + 25.0
        }
        
        
        
    }
    func alertCtrl(){
        let alertController = UIAlertController(title: "Game over", message: "Oops! Mine!! Better luck next time!", preferredStyle: UIAlertControllerStyle.alert)
        
        let DestructiveAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
           
            self.disableBoard()
        }
        
        let okAction = UIAlertAction(title: "New Game", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.newGame()
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        
        alertController.view.backgroundColor = UIColor.lightGray
        alertController.view.backgroundColor = UIColor.lightGray
        alertController.view.layer.cornerRadius = 5
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func buttonAction(sender: UIButton!) {
        if cellTitles[sender.tag-1] == "mine"{
            sender.setBackgroundImage(UIImage(named: "mine"), for: UIControlState.normal)
            sender.backgroundColor = UIColor.white
            smileyButton.setBackgroundImage(UIImage(named: "smiley_s"),for: UIControlState.normal)
            alertCtrl()
        }
        else if cellTitles[sender.tag-1] == "0"{
            sender.setTitle("", for: .normal)
            sender.backgroundColor = UIColor(red: CGFloat(Int(arc4random_uniform(256)))/255, green: CGFloat(Int(arc4random_uniform(256)))/255, blue: CGFloat(Int(arc4random_uniform(256)))/255, alpha: 0.5)
            
            // if clicked propogate the event to neighbors
            let nbrs = neighbors[sender.tag-1]
           
            for i in nbrs! {
                if let btn = i[0] as? CustomButton {
                    let lookedUpTag = lookupStrCoords[btn.coordsTag]
                    let lookedUpButton = self.view.viewWithTag(lookedUpTag!) as! CustomButton
                    let title = cellTitles[(lookedUpTag!-1)]
                  
                    if title == "mine" {
                        print("mine")
                    }
                    else{
                        if title == "0"{
                            lookedUpButton.setTitle("", for: .normal)
                        }
                        else{
                            lookedUpButton.setTitle(title, for: .normal)
                        }
                         lookedUpButton.backgroundColor = UIColor(red: CGFloat(Int(arc4random_uniform(256)))/255, green: CGFloat(Int(arc4random_uniform(256)))/255, blue: CGFloat(Int(arc4random_uniform(256)))/255, alpha: 0.5)
                    }
                }
            }
        }
        else{
            
            sender.setTitle(cellTitles[sender.tag-1], for: .normal)
            sender.backgroundColor = UIColor(red: CGFloat(Int(arc4random_uniform(256)))/255, green: CGFloat(Int(arc4random_uniform(256)))/255, blue: CGFloat(Int(arc4random_uniform(256)))/255, alpha: 0.5)
        }
    }
    
    func getNeighbours(cellTag : Int, x : Int, y :Int){
        var tempArr : [[CustomButton]] = []
        for i in x-1...x+1 {
            for j in y-1...y+1 {
                if i == 0 || j == 0{
                    continue
                }
                
                if (i == x) && (j == y){
                    continue
                }else{
                    
                    let btn =  CustomButton(frame: CGRect(x: x, y: y, width: 25, height: 25))
                    btn.setValue([i,j], forKey: "coords")
                    
                    let iStr = String(i)
                    let jStr = String(j)
                    let coordsTag = iStr.appending(jStr)
                  
                    btn.setValue(coordsTag, forKey: "coordsTag")
                    tempArr.append([btn])
                }
            } // for j
        }// for i
        let tempTag = cellTag - 1
        neighbors[tempTag] = tempArr
    }
    
    func disableBoard(){
        for idx in 1...64 {
            let tmpButton = self.view.viewWithTag(idx) as? CustomButton
            tmpButton?.isEnabled = false
        }
    }
    
    func newGame(){
        createBoard()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        newGame()
    }
    
}

