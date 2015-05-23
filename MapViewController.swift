//
//  MapViewController.swift
//  GeoTweet
//
//  Created by Vishnu on 23/05/15.
//  Copyright (c) 2015 Vishnu Pillai. All rights reserved.
//

import UIKit
import MapKit
import TwitterKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var dropPin: MKPointAnnotation!
    
    var tweet: String!
    var tweets = [String]()
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "didLongTapMap:")
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.numberOfTapsRequired = 0
        longPressGestureRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // MARK: - Map View
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView.canShowCallout = true
        pinView.animatesDrop = true
        
        return pinView
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        println("annotation view selected")
    }
    
    // MARK: - Actions
    
    func didLongTapMap(gestureRecognizer: UIGestureRecognizer) {
        // Get the spot that was tapped
        let tapPoint: CGPoint = gestureRecognizer.locationInView(mapView)
        let touchMapCoordinate: CLLocationCoordinate2D = mapView.convertPoint(tapPoint, toCoordinateFromView: mapView)
        
        if gestureRecognizer.state != .Ended {
            return
        }
    
        // Create the pin to be added
        
        self.tweets = [String]()
        
        // Add the pin to mapView
        dropPin = MKPointAnnotation()
        dropPin.coordinate.latitude = touchMapCoordinate.latitude
        dropPin.coordinate.longitude = touchMapCoordinate.longitude
        mapView.addAnnotation(dropPin)
        
        getTweet(dropPin.coordinate.latitude, longitude: dropPin.coordinate.longitude)
        
    }
    
    func getTweet(latitude: Double, longitude: Double) {
            
            let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
            
            let params = ["geocode" : "\(latitude),\(longitude),10km",
                "lang" : "pt",
                "result_type" : "recent"]
            
            var clientError : NSError?
            
            
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
            
            if request != nil {
                
                Twitter.sharedInstance().APIClient.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                    if (connectionError == nil) {
                        var jsonError : NSError?
                        let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
                        if let jsonData: AnyObject = json {
                            let statuses = jsonData["statuses"] as! [NSDictionary]
                            for status in statuses {
                                let tweet = status["text"] as! String
                                self.tweets.append(tweet)
                            }
                            
                            println(self.tweets)
                            
                            let randomNumber = Int(arc4random_uniform(UInt32(self.tweets.count-1)))
                            
                            self.dropPin.title = self.tweets[randomNumber]
                        }
                        
                    } else {
                        println("Error: \(connectionError)")
                    }
                }
            }  else {
                println("Error: \(clientError)")
                
            }
    }

}

