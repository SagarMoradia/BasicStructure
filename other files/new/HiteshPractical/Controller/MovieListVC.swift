//
//  MovieListVC.swift
//  HiteshPractical
//
//  Created by Sagar on 16/5/19.
//  Copyright © 2019 Sagar. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListVC: UIViewController {

    var aryMovieListData = [Any]()
    var currenPage = 1
    var totalPages = 1
    

    @IBOutlet weak var tlbMoviewList: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tlbMoviewList.infiniteScrollIndicatorStyle = .white
        tlbMoviewList.register(UINib(nibName: "CellMovieList", bundle: nil), forCellReuseIdentifier: "CellMovieList")
        self.title = "Movie List"
        callMovieListAPI()
        setupPagination()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Movie List"
    }
    
    fileprivate func setupPagination(){
        tlbMoviewList.rowHeight = UITableView.automaticDimension
        tlbMoviewList.addInfiniteScroll { (tableView) -> Void in
                self.callMovieListAPI()
        }
        
        tlbMoviewList.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.totalPages > self.currenPage && API.sharedInstance.isInternetAvailable
        }
    }
}

//MARK: - API Calling
extension MovieListVC{
    fileprivate func callMovieListAPI(){
       
        let apiName = "\(APIName.DiscoverMovie)?api_key=\(API_Key)&page=\(currenPage)"
        
        API.sharedInstance.apiRequestWithModalClass(modelClass: Model_VideoList.self, apiName: apiName, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
            let objMainResponse = response as! Model_VideoList
            let objVidioResult = objMainResponse.resultsData ?? []
            for objMovie in objVidioResult{
                self.aryMovieListData.append(objMovie)
                let id = objMovie.id!
                let title = objMovie.title!.replacingOccurrences(of: "'", with: "''")
                let poster_path = objMovie.poster_path!.replacingOccurrences(of: "'", with: "''")
                let original_title = objMovie.original_title!.replacingOccurrences(of: "'", with: "''")
                let backdrop_path = objMovie.backdrop_path!.replacingOccurrences(of: "'", with: "''")
                let overview = objMovie.overview!.replacingOccurrences(of: "'", with: "''")
                let release_date = objMovie.release_date!.replacingOccurrences(of: "'", with: "''")
                LocalDatabase.sharedInstance.methodToInsertUpdateDeleteData("INSERT or REPLACE INTO `discovermovie`(`id`,`title`,`poster_path`,`original_title`,`backdrop_path`,`overview`,`release_date`) VALUES ('\(id)','\(title)','\(poster_path)','\(original_title)','\(backdrop_path)','\(overview)','\(release_date)')", completion: { (status) in
                })
            }
            
            self.tlbMoviewList.finishInfiniteScroll()
            self.tlbMoviewList.reloadData()
            self.currenPage = self.currenPage + 1
            self.totalPages = objMainResponse.total_pages ?? 1
            
        },FailureBlock:{ (error) in
            self.tlbMoviewList.finishInfiniteScroll()
            self.view.makeToast(error.localizedDescription)
        }, NoInternetBlock:{status in
                LocalDatabase.sharedInstance.methodToSelectData("SELECT * FROM discovermovie", completion: { (aryDB) in
                    self.aryMovieListData.append(contentsOf: aryDB)
                    self.tlbMoviewList.finishInfiniteScroll()
                    self.tlbMoviewList.reloadData()
                })
        })
    }
}

//MARK: - UITableview delegate and datasource
extension MovieListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryMovieListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMovieList", for: indexPath) as! CellMovieList
        cell.objModal_VideoResults = aryMovieListData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailsVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        movieDetailsVC.objModal_VideoResults = aryMovieListData[indexPath.row]
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

