
import Foundation

class DataProcessor: Decodable {

    static func mapJsonToSwiftObj<T:Decodable>(data: Data?) -> T? {
        var obj: T?
        
        guard let data = data else { return nil }
        
        do {
            let decoder = JSONDecoder()
            obj = try decoder.decode(T.self, from: data)
        } catch let serializationError {
            print(serializationError)
        }
        return obj
    }
    
    static func write(movies: [Movie]) {
        // TODO: Implement
    }
}
