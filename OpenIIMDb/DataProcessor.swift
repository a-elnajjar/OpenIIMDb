
import Foundation

class DataProcessor {

    static func mapJsonToMovies(searchData: Data?, moviesKey: String) -> Search? {
        var mappedMovies: Search?
        
        guard let moviesData = searchData else { return mappedMovies! }
        
        do {
            let decoder = JSONDecoder()
            mappedMovies = try decoder.decode(Search.self, from: moviesData)
           
        } catch let serializationError {
            print(serializationError)
        }
        return mappedMovies
    }
    
    static func write(movies: [Movie]) {
        // TODO: Implement
    }
}
