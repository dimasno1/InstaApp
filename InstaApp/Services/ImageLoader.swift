//
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

final class ImageLoader {
    
    typealias Callback = (UIImage?) -> Void
    
    static func load(at url: URL, then callback: Callback? = nil) {
        let shouldStartLoading = !imageCache.keys.contains(url)
        
        if shouldStartLoading {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                let image = data.flatMap(UIImage.init(data:))
            
                DispatchQueue.main.async {
                    callback?(image)
                    imageCache[url] = image
                }
                }.resume()
        } else {
            DispatchQueue.main.async {
                callback?(imageCache[url])
            }
        }
    }
    
    private static var imageCache: [URL: UIImage] = [:]
}
