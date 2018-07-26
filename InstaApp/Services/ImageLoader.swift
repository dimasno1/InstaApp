//
//  Copyright © 2018 dimasno1. All rights reserved.
//

import UIKit

final class ImageLoader {

    typealias Callback = (UIImage?) -> Void
    
    static func load(at url: URL, then callback: Callback? = nil) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                callback?(data.flatMap(UIImage.init(data:)))
            }
        }.resume()
    }
}
