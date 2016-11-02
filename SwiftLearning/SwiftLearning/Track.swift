//
//  Song.swift
//  SwiftLearning
//
//  Created by qky on 16/11/2.
//  Copyright © 2016年 boostfield. All rights reserved.
//

import Foundation

class Track {
    var title: String = ""
    var mediaUrl: String = ""
    
    init(title: String, mediaUrl: String) {
        self.title = title
        self.mediaUrl = mediaUrl
    }
}
