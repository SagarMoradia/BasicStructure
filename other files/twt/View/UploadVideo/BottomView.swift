//
//  BottomView.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 26/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit

struct Privacy {
    static let Public = "Public"
    static let Private = "Private"
}

typealias CompletionBlock = (( _ index:Int, _ strTitle:String)->())?

class BottomView: UIView,UITableViewDataSource,UITableViewDelegate{

    //MARK: - Outlets Methods
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: - Properties Methods
    //Callback
    var handler: CompletionBlock!
    
    
    //For pop up
    var maxHeight : CGFloat = UIScreen.main.bounds.height/2
    var dictActiveSuites = [Dictionary<String, Any>]()
    var dictInActiveSuites = [Dictionary<String, Any>]()
    
    var aryPrivacy = [Privacy.Public,Privacy.Private]
  
    //MARK: - View Methods
    override func awakeFromNib() {
        tblView.register(UINib.init(nibName: "CellPopUp", bundle: nil), forCellReuseIdentifier: "CellPopUp")
        tblView.tableFooterView = UIView()
        
        //Background Shadow...
       // self.viewMain.backgroundColor = UIColor.init(red: 0.0/255.0, green:0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
       
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func layoutSubviews() {
        
        
    }
    
  
    //MARK: - Button Event Methods
    @IBAction func actionHide(_ sender:UIControl){
        
        //SMP:Change
        //self.viewMain.backgroundColor = .clear
        self.removeFromSuperviewWithAnimationBottom(animation: {
        }) {//Completion
        }
    }
    
    //MARK: - Tableview datasource delegate  Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryPrivacy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellPopUp", for: indexPath) as! CellPopUp
        cell.textLabel?.backgroundColor = UIColor.clear
        
        cell.lblName.text = aryPrivacy[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //SMP:Change
        //self.viewMain.backgroundColor = .clear
        self.removeFromSuperviewWithAnimationBottom(animation: {            
        }) {//Completion
            self.handler!(indexPath.row,self.aryPrivacy[indexPath.row])
        }
    }
}
