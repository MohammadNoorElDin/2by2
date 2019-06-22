//
//  ClickTo.swift
//  2By2
//
//  Created by rocky on 12/6/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class ClickTo {
    
    class func openwhatsapp(phone: String) {
        let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+2\(phone)")
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:])
        }
    }
    
    class func openApp(url: String?) {
        
        let urlStr = ( url != nil ) ? url! : "https://itunes.apple.com/us/app/elbalto/id1387785206?ls=1&mt=8"
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
    }
    
    class func Call(number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    class func OpenBrowser(link: String) {
        guard let url = URL(string: link) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

    }/**/
    
    class func sendEmail(to: String) {
        let email = to 
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    
    class func openMap(lat: Double, lng: Double, playGroundName name: String) {
        // branch.map ( lat and lng )
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = lng
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
        
    }
    class func openMapInBrowser(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        print("http://maps.google.com/maps?daddr=\(lat),\(lng)")
        guard let url = URL(string: "http://maps.google.com/maps?daddr=\(lat),\(lng)") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

