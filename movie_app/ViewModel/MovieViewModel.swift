//
//  ViewModel.swift
//  movie_app
//
//  Created by Trung on 31/10/24.
//

import Foundation

class MovieViewModel{
    private var apiService = ApiService()
    private var movies: [Result] = []
    private var genres: [Genre] = []
    private var pageCount: Int = 1
    
    var onMoviesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var moviesCount: Int {
        return movies.count
    }
    func movie(at index: Int) -> Result? {
        return index < movies.count ? movies[index] : nil
    }
    func loadGenres(){
        apiService.fetchGenres{
            [weak self] genres, error in
            if let error = error{
                self?.onError?(error.localizedDescription)
            }
            else if let genres = genres{
                self?.genres = genres
            }
        }
    }
    func loadMovies(){
        apiService.fetchPopularMovies(page: pageCount){
            [weak self] movies, error in
            guard let self = self else{
                return
            }
            if let error = error{
                self.onError?(error.localizedDescription)
            }
            else if let movies = movies{
                self.pageCount += 1
                self.movies.append(contentsOf: movies)
                self.onMoviesUpdated?()
            }
        }
    }
    func getGenreName(for genresIds:[Int]) -> String{
        let genreName = genres.filter { genresIds.contains($0.id)}.map{$0.name}
        return genreName.first ?? "N/A"
    }
}
