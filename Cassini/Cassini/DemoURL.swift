//
//  DemoURL.swift
//  Cassini
//
//  Created by Junyuan Suo on 6/2/15.
//  Copyright (c) 2015 JYLock. All rights reserved.
//

import Foundation

struct DemoURL {
    static let Stanford = NSURL(string: "http://comm.stanford.edu/wp-content/uploads/2013/01/stanford-campus.png")
    static let Chrome = NSURL(string: "http://upload.wikimedia.org/wikipedia/en/3/34/ISync_icon.png")
    struct NASA {
        static let Cassini = NSURL(string: "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg")
        static let Earth = NSURL(string: "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg")
        static let Saturn = NSURL(string: "http://www.nasa.gov/sites/default/files/saturn_collage.jpg")
    }
}
