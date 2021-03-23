
import Foundation
final class LibraryAPI {

  static let shared = LibraryAPI()
 
  private let httpClient = HTTPHandler()
  private let isOnline = false

  private init() {
    
  }
  //TODO: 
//  func getAlbums() -> [Movie] {
//
//  }
//
//  func addAlbum(_ album: Movie, at index: Int) {
//
//  }
//
//  func deleteMovie(at index: Int) {
//
//  }
}
