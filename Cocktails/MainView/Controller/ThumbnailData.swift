import UIKit

class ThumbnailData {
    private var thumbnails: [String: UIImage]

    init() {
        thumbnails = [:]
    }
    
    func getCocktailThumbnail(
           for cocktail: CocktailDetails,
           completion: @escaping () -> Void
    ) -> UIImage? {
        let id = cocktail.idDrink
        
        if let thumbnail = thumbnails[id] {
            return thumbnail
        } else {
            if let url = URL(string: cocktail.strDrinkThumb) {
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        self?.thumbnails[id] = image
                    }
                   
                    completion()
                }.resume()
           }
           
           return nil
        }
    }
}
