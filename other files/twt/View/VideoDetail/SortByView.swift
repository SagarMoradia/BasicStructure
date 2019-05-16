//
//  SortByView.swift
//  TheWeedTube
//
//  Created by Sweta Vani on 14/03/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
struct SortBy {
    static let MostLiked = "Most Liked"
    static let Oldest = "Oldest"
    static let Newest = "Newest"
}

typealias CompletionHandlerBlockSortBy = (( _ index:Int, _ strTitle:String, _ indexpathId:IndexPath)->())?

class SortByView: UIView ,UITableViewDataSource,UITableViewDelegate{
    
    //MARK: - Outlets Methods
    @IBOutlet weak var tblViewSortBy: UITableView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    //MARK: - Properties Methods
    //Callback
    var handler: CompletionHandlerBlockSortBy!
    var arrSortBy = [SortBy.MostLiked,SortBy.Oldest,SortBy.Newest]
    var selectedIndexPath: IndexPath?

    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override func awakeFromNib() {
        tblViewSortBy.register(UINib.init(nibName: "SortByCell", bundle: nil), forCellReuseIdentifier: "SortByCell")
        tblViewSortBy.tableFooterView = UIView()
    }
    
    
    //MARK:- Hide Method
    @IBAction func btnCloseTap(_ sender: Any){
        self.hidePopUp()
    }
    
    
    //MARK:- Common Method
    func hidePopUp(){
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
        return arrSortBy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortByCell", for: indexPath) as! SortByCell
        cell.textLabel?.backgroundColor = UIColor.clear
        
        cell.lblName.text = arrSortBy[indexPath.row]
        //For selected cell display
        if selectedIndexPath != nil && indexPath == selectedIndexPath {
            cell.imgSelected.image = UIImage.init(named: "check_selected")
        }
        else{
            cell.imgSelected.image = UIImage.init(named: "check_unselected")
        }
       
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.tblViewSortBy.reloadData()
        if (handler != nil){
            self.handler!(indexPath.row,arrSortBy[indexPath.row],selectedIndexPath!)
        }
        self.hidePopUp()
    }
    
}
