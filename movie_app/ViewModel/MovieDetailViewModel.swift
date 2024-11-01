//
//  MovieDetailViewModel.swift
//  movie_app
//
//  Created by Trung on 31/10/24.
//

import Foundation

class MovieDetailViewModel {
    private var apiService = ApiService()

    var movie: MovieDetail?
    var onMovieFetched: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchMovieDetail(movieID: Int) {
        apiService.fetchMovie(movieID: movieID) { [weak self] movie, error in
            guard let self = self else { return }
            if let error = error {
                self.onError?(error.localizedDescription)
            } else if let movie = movie {
                self.movie = movie
                self.onMovieFetched?()
            }
        }
    }
}
