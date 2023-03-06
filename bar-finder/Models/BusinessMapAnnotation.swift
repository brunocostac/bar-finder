//
//  BusinessMapAnnotation.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import Foundation
import MapKit

class BusinessMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var image: UIImage?
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, image: UIImage?) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.image = image
    }
}

extension BusinessMapAnnotation {
    static func generate(from business: Business) -> BusinessMapAnnotation {
        return .init(
            title: business.name,
            coordinate: .init(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude),
            info: (business.categories.first?.title!)!, image: BFImages.businessWithoutImage)
    }
}
