//
//  DetailViewController.swift
//  movie_app
//
//  Created by Trung on 30/10/24.
//

import UIKit

class DetailViewController : UIViewController{
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingStack: UIStackView!
    var id:Int = 0
    
    private var detailViewModel = MovieDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavBar()
        setup()
        detailViewModel.fetchMovieDetail(movieID: id)
    }
    
    @objc func handleBackButton(){
        navigationController?.popViewController(animated: true)
    }
    private func setupNavBar(){
        let icon = UIImage(systemName: "chevron.backward")
        let backButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(handleBackButton))
        navigationItem.leftBarButtonItem = backButton
        let item = UIImage(systemName: "bookmark.fill")
        let rightButton = UIBarButtonItem(image: item, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightButton
        self.title = "Detail"
    }
    private func setup(){
        self.nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.yearLabel.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        self.durationLabel.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        self.genreLabel.font = UIFont.systemFont(ofSize: 12,weight: .medium)
        self.overviewLabel.font = UIFont.systemFont(ofSize: 12,weight: .regular)
        self.ratingView.layer.cornerRadius = 8
        self.ratingView.clipsToBounds = true
        self.ratingStack.alignment = .center
        self.ratingStack.axis = .horizontal
        self.ratingStack.distribution = .fill
        self.ratingStack.spacing = 4
        self.ratingStack.isLayoutMarginsRelativeArrangement = true
        self.ratingStack.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
    }
    private func setupBinding(){
        
        detailViewModel.onError = {error in print("There's an error: \(error)")}
        detailViewModel.onMovieFetched = {
            [weak self] in
            guard let self = self, let movie = self.detailViewModel.movie else { return }
            DispatchQueue.main.async {
                self.updateUI(movie: movie)
            }
        }
    }
    private func updateUI(movie: MovieDetail){
        if let backdropPath = movie.backdropPath {
            getImg(path: backdropPath) { imgView in
                if let imgView = imgView {
                    self.backImage.image = imgView.image
                }
            }
        }
        if let backdropPath = movie.posterPath {
            getImg(path: backdropPath) { imgView in
                if let imgView = imgView {
                    self.frontImage.image = imgView.image
                    self.frontImage.layer.cornerRadius = 20
                    self.frontImage.clipsToBounds = true                            }
            }
        }
        ratingLabel.text = movie.voteAverage == nil ? "N/A" : String(format: "%.2f",movie.voteAverage ?? 0)
        nameLabel.text = movie.title ?? ""
        durationLabel.text = movie.runtime != nil ? "\(movie.runtime!) minutes" : "N/A"
        genreLabel.text = movie.genres?[0].name ?? "N/A"
        overviewLabel.text = movie.overview ?? "N/A"
        yearLabel.text = movie.releaseDate == nil ? "N/A" : configTime(time: movie.releaseDate!)
    }
}
