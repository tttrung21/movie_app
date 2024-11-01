import Foundation

class ApiService{

    func fetchPopularMovies(page:Int = 1, completion: @escaping ([Result]?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constant.api_key)&language=en-US&page=\(page)"
        guard let url = URL(string: urlString) else{
            completion(nil,NSError(domain: "", code: 0,userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let data = data else{
                completion(nil,NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"]))
                return
            }
                do{
                    let movies = try JSONDecoder().decode(ListMovies.self, from: data )
                    completion(movies.results, nil)
                }
            catch let decodingError as DecodingError {
                print("Decoding error:", decodingError)
            }
            catch{
                completion(nil,error)
            }
           
        }
        task.resume()
    }
    
    func fetchGenres(completion: @escaping ([Genre]?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(Constant.api_key)&language=en-US"
            guard let url = URL(string: urlString) else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"]))
                    return
                }
                do {
                    let genreResponse = try JSONDecoder().decode(ListGenre.self, from: data)
                    completion(genreResponse.genres, nil) // Access the "genres" property
                } catch {
                    completion(nil, error)
                }
            }

            task.resume()
        }
    func fetchMovie(movieID: Int, completion: @escaping (MovieDetail?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(Constant.api_key)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil,error)
                return
            }
            
            guard let data = data else {
                print("No data returned.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(MovieDetail.self, from: data)
                print("khong loi~")
                completion(movie,nil)
            } catch {
                print("loi~")
                completion(nil,error)
            }
        }
        task.resume()
    }
}

