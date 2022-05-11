import UIKit

class CocktailLogic {
    func getImage(imagePath: String, completion: @escaping (UIImage) -> Void) {
        if let url = URL(string: imagePath) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                }
            }.resume()
        }
    }
}
