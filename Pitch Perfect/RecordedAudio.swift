//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Martin on 05.03.15.
//  Copyright (c) 2015 martin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl url:NSURL!, andTitle titleString:String!) {
        filePathUrl = url
        title = titleString
    }
}