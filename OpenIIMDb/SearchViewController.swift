
import UIKit

class SearchViewController:  UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{

    
    
    weak var delegate: ViewController!
    var searchResults: Search?
    
    @IBOutlet var searchText: UITextField!
    let searchController = UISearchController(searchResultsController: nil)
    
    
 
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
        setUpSearchController()
    }
    
    
    fileprivate func setUpSearchController() {
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search Candies"
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        
        searchController.searchBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification) }
    }
    
    func handleKeyboard(notification: Notification) {
      // 1
      guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
       
        view.layoutIfNeeded()
        return
      }
      
      guard
        let info = notification.userInfo,
        let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
          return
      }
      
      // 2
        _ = keyboardFrame.cgRectValue.size.height
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        
        self.view.layoutIfNeeded()
      })
    }
    
 
    
    @IBAction func addFav (sender: UIButton) {
        print("Item #\(sender.tag) was selected as a favorite")
        self.delegate.favoriteMovies.append((searchResults?.search[sender.tag])!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let  count =  searchResults?.search.count else {
            return 0
        }
        
        return count
       
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // grouped vertical sections of the tableview
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // at init/appear ... this runs for each visible cell that needs to render
        let moviecell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomTableViewCell
        
        let idx: Int = indexPath.row
        moviecell.favButton.tag = idx
        if let movies = searchResults?.search {
            //title
            moviecell.movieTitle?.text = movies[idx].title
            //year
            moviecell.movieYear?.text = movies[idx].year
            // image
            displayMovieImage(idx, moviecell: moviecell)
        }
        return moviecell
    }
    
    func displayMovieImage(_ row: Int, moviecell: CustomTableViewCell) {
        let url: String = (URL(string: (searchResults?.search[row].poster)!)?.absoluteString)!
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
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveMoviesByTerm(searchTerm: String) {
        let url = "https://www.omdbapi.com/?apikey=1a378645&s=\(searchTerm)&type=movie&r=json"
        HTTPHandler.getJson(urlString: url, completionHandler: parseDataIntoMovies)
    }
    
    func parseDataIntoMovies(data: Data?) -> Void {
        if let movieData = data {
            self.searchResults = DataProcessor.mapJsonToSwiftObj( data: movieData)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let searchTerm = searchBar.text!
        print("Searching for \(searchTerm)")
        if searchTerm.count > 2 {
            retrieveMoviesByTerm(searchTerm: searchTerm)
        }
    }
}
