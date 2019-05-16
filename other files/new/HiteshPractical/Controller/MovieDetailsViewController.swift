//
//  File.swift
//  HiteshPractical
//
//  Created by Sagar on 16/5/19.
//  Copyright © 2019 Sagar. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    
    //MARK: - Outlets and variables -
    @IBOutlet weak var scrMain: UIScrollView!
    
    @IBOutlet weak var ivBackgroundPoster: UIImageView!
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblTagLine: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblReleaseDAte: UILabel!
    @IBOutlet weak var lblProductionCompanies: UILabel!
    @IBOutlet weak var lblProductionBudget: UILabel!
    @IBOutlet weak var lblRevenue: UILabel!
    @IBOutlet weak var lblLanguages: UILabel!
    
    var objModal_VideoResults:Any!
    var videoID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = objModal_VideoResults as? Modal_VideoResults{
            self.title = data.title
            videoID = "\(data.id!)"
        }else if let dict = objModal_VideoResults as? NSDictionary{
            self.title = dict.value(forKey: "title") as? String ?? ""
            videoID = "\(dict.value(forKey: "id") as? Int ?? 0)"
        }
        callMovieDetailsAPI()
        self.navigationController?.navigationBar.topItem?.title = " "
    }
}


//MARK: - API Calling
extension MovieDetailsViewController{
    fileprivate func callMovieDetailsAPI(){
        
        let apiName = "\(APIName.MovieDetails)\(videoID)?api_key=\(API_Key)"
        API.sharedInstance.apiRequestWithModalClass(modelClass: Modal_Movie_Details.self, apiName: apiName, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            print(response)
            if let objModal_Movie_Details = (response) as? Modal_Movie_Details{
                self.setupData(objModal_Movie_Details: objModal_Movie_Details)
                self.scrMain.isHidden = false
            }
        },FailureBlock:{ (error) in
            self.view.makeToast(error.localizedDescription)
            self.scrMain.isHidden = true
        }, NoInternetBlock:{status in
            
            LocalDatabase.sharedInstance.methodToSelectData("SELECT * FROM MovieDetails WHERE id = '\(self.videoID)'", completion: { (aryDataFromDB) in
                if aryDataFromDB.count > 0{
                    self.setupDataWithDict(dictInfo: aryDataFromDB.firstObject as! NSDictionary)
                    self.scrMain.isHidden = false
                }else{
                    self.scrMain.isHidden = true
                    Alert.showAlert(title: "Your're offline", message: "Internet connection not available...")
                }
            })
        })
    }
}


//Mark: - Setup UI
extension MovieDetailsViewController{
    
    func setupData(objModal_Movie_Details : Modal_Movie_Details)  {
        
        ivBackgroundPoster?.sd_setImage(with: URL(string:  imagebaseURL + (objModal_Movie_Details.backdrop_path ?? "")), completed: nil)
        ivPoster?.sd_setImage(with: URL(string:  imagebaseURL + (objModal_Movie_Details.poster_path ?? "")), completed: nil)
        lblMovieTitle.text = objModal_Movie_Details.title
        lblTagLine.text = objModal_Movie_Details.tagline
        lblOverview.text = objModal_Movie_Details.overview
        lblGenres.text = objModal_Movie_Details.genres?.compactMap{$0.name}.joined(separator: ",")
        lblDuration.text = String(objModal_Movie_Details.runtime ?? 0) + " Minutes"
        lblReleaseDAte.text = objModal_Movie_Details.release_date
        lblProductionCompanies.text = objModal_Movie_Details.production_companies?.compactMap{$0.name}.joined(separator: ",")
        lblProductionBudget.text = String(objModal_Movie_Details.budget ?? 0).StringToCurrency
        lblRevenue.text = String(objModal_Movie_Details.revenue ?? 0).StringToCurrency
        lblLanguages.text = objModal_Movie_Details.spoken_languages?.compactMap{$0.name}.joined(separator: ",")
        
        
        let id = "\(objModal_Movie_Details.id!)"
        let title = objModal_Movie_Details.title!
        let poster_path = objModal_Movie_Details.poster_path!
        let backdrop_path = objModal_Movie_Details.backdrop_path!
        let overview = objModal_Movie_Details.overview!
        let release_date = objModal_Movie_Details.release_date!
        let tagline = objModal_Movie_Details.tagline!
        let genres = lblGenres.text!
        let runtime = lblDuration.text!
        let production_companies = lblProductionCompanies.text!
        let budget = lblProductionBudget.text!
        let revenue = lblRevenue.text!
        let spoken_languages = lblLanguages.text!
        
        LocalDatabase.sharedInstance.methodToInsertUpdateDeleteData("INSERT or REPLACE INTO `MovieDetails`(`id`,`title`,`poster_path`,`backdrop_path`,`overview`,`release_date`,`tagline`,`genres`,`runtime`,`production_companies`,`budget`,`revenue`,`spoken_languages`) VALUES ('\(id)','\(title)','\(poster_path)','\(backdrop_path)','\(overview)','\(release_date)','\(tagline)','\(genres)','\(runtime)','\(production_companies)','\(budget)','\(revenue)','\(spoken_languages)')", completion: { (status) in
        })
    }
    
    func setupDataWithDict(dictInfo : NSDictionary)  {
        
        ivBackgroundPoster?.sd_setImage(with: URL(string:  imagebaseURL + (dictInfo.value(forKey: "backdrop_path") as? String ?? "")), completed: nil)
        ivPoster?.sd_setImage(with: URL(string:  imagebaseURL + (dictInfo.value(forKey: "poster_path") as? String ?? "")), completed: nil)
        lblMovieTitle.text = (dictInfo.value(forKey: "title") as? String ?? "")
        lblTagLine.text = (dictInfo.value(forKey: "tagline") as? String ?? "")
        lblOverview.text = (dictInfo.value(forKey: "overview") as? String ?? "")
        lblGenres.text = (dictInfo.value(forKey: "genres") as? String ?? "")
        lblDuration.text = dictInfo.value(forKey: "runtime") as? String ?? ""
        lblReleaseDAte.text = dictInfo.value(forKey: "release_date") as? String ?? ""
        lblProductionCompanies.text = dictInfo.value(forKey: "production_companies") as? String ?? ""
        lblProductionBudget.text = dictInfo.value(forKey: "budget") as? String ?? ""
        lblRevenue.text = dictInfo.value(forKey: "revenue") as? String ?? ""
        lblLanguages.text = dictInfo.value(forKey: "spoken_languages") as? String ?? ""
    }
}
