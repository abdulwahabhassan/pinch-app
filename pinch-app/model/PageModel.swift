//
//  PageModel.swift
//  pinch-app
//
//  Created by Hassan Abdulwahab on 12/01/2022.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String { //computed property return the thumbnail name of the image
        return "thumb-" + imageName
    }
}
