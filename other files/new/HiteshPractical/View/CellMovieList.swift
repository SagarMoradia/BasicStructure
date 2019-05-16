//
//  CellMovieList.swift
//  HiteshPractical
//
//  Created by Sagar on 16/5/19.
//  Copyright © 2019 Sagar. All rights reserved.
//

import UIKit

class CellMovieList: UITableViewCell {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var objModal_VideoResults: Any! {
        didSet {
            if let data = objModal_VideoResults as? Modal_VideoResults{
                lblMovieTitle.text = data.title
                lblReleaseDate.text = data.release_date
                lblDescription.text = data.overview
                imgPoster?.sd_setImage(with: URL(string:  imagebaseURL + (data.poster_path ?? "")), completed: nil)
            }else if let dict = objModal_VideoResults as? NSDictionary{
                lblMovieTitle.text = dict.value(forKey: "title") as? String ?? ""
                lblReleaseDate.text = dict.value(forKey: "release_date") as? String ?? ""
                lblDescription.text = dict.value(forKey: "overview") as? String ?? ""
                imgPoster?.sd_setImage(with: URL(string:  imagebaseURL + (dict.value(forKey: "poster_path") as? String ?? "")), completed: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
