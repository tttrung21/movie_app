import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var movieViewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movies"
        setupBinding()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "movie")
        movieViewModel.loadGenres()
        movieViewModel.loadMovies()
    }
    private func setupBinding(){
        movieViewModel.onError = {error in print("There's an error: \(error)")}
        movieViewModel.onMoviesUpdated = {
            [weak self] in
            DispatchQueue.main.async{
                self?.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.moviesCount
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as? TableViewCell else{
            return UITableViewCell()
        }
        if let movie = movieViewModel.movie(at: indexPath.row)
        {
            cell.configure(movie: movie,genre: movieViewModel.getGenreName(for: movie.genreIDS ?? []))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        performSegue(withIdentifier: "navigateDetail", sender: self)
        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController, let movie = movieViewModel.movie(at: indexPath.row){
            vc.id = movie.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = movieViewModel.moviesCount-1
        if indexPath.row == lastItem{
            movieViewModel.loadMovies()
        }
    }
    
}
