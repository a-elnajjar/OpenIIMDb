

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favoriteMovies: [Movie] = []
    var selectedMovie: Movie?
    
    @IBOutlet var mainTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        mainTableView.reloadData()
        super.viewWillAppear(animated)
        if favoriteMovies.count == 0 {
            favoriteMovies.append(Movie(title: "tt0372784", year: "Batman Begins", imdbID: "2005", type: TypeEnum.movie,poster: "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moviecell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomTableViewCell
        
        let idx: Int = indexPath.row
        moviecell.tag = idx
        
        //title
        moviecell.movieTitle?.text = favoriteMovies[idx].title
        //year
        moviecell.movieYear?.text = favoriteMovies[idx].year
        // image
        displayMovieImage(idx, moviecell: moviecell)
        
        return moviecell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = favoriteMovies[indexPath.row]
    }
    
    func displayMovieImage(_ row: Int, moviecell: CustomTableViewCell) {
        let url: String = (URL(string: favoriteMovies[row].poster)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                moviecell.movieImageView?.image = image
            })
        }).resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "searchMoviesSegue" {
            let controller = segue.destination as! SearchViewController
            controller.delegate = self
        }
        
        if segue.identifier == "movieDetailSegue" {
            let controller = segue.destination as! DetailViewController
            let cell = sender as! CustomTableViewCell
            controller.movie = favoriteMovies[cell.tag]
        }
    }
}

