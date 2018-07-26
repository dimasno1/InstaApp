//
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

final class ImageLoader {
    
    typealias Callback = (UIImage?) -> Void
    
    static func load(at url: URL, then callback: Callback? = nil) {
        let nsUrl = url as NSURL
        let shouldStartLoading = picturesCache.object(forKey: nsUrl) == nil
        
        if shouldStartLoading {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let image = data.flatMap(UIImage.init(data:)) else {
                    return
                }
            
                DispatchQueue.main.async {
                    callback?(image)
                    picturesCache.setObject(image, forKey: nsUrl, cost: 1)
                }
                }.resume()
        } else {
            DispatchQueue.main.async {
                callback?(picturesCache.object(forKey: nsUrl))
            }
        }
    }
    
    private static var picturesCache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.name = "pictures_cache"
        cache.totalCostLimit = 100
        
        return cache
    }()
}
