//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Andreas Talg on 26.03.15.
//  Copyright (c) 2015 Andreas Talg. All rights reserved.
//

import Foundation

// Object holding path and title of recorded audio (passed to play scene)
class RecordedAudio:NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}