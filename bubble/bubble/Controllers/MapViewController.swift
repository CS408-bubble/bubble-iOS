//
//  MapViewController.swift
//  bubble
//
//  Created by Sawyer Blatz on 2/10/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createBubbleView: CreateBubbleView!
    @IBOutlet weak var createBubbleViewCenterY: NSLayoutConstraint!
    
    var bubblesDisplayed = [Bubble]()
    var bubbleAnnotations = [MKAnnotation]()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupBubbleView()
        let bubbleTimer = Timer(timeInterval: 5.0, target: self, selector: #selector(getBubblesNearCurrentLocation), userInfo: nil, repeats: true)
        bubbleTimer.fire()
    }
    
    @objc func getBubblesNearCurrentLocation() {
        var latitude = 0.0
        var longitude = 0.0

        if let latitudeCoordinate = locationManager.location?.coordinate.latitude {
            latitude = Double(latitudeCoordinate)
        } else {
            return
        }

        if let longitudeCoordinate = locationManager.location?.coordinate.longitude {
            longitude = Double(longitudeCoordinate)
        } else {
            return
        }

        DataService.instance.getBubbles(latitude: latitude, longitude: longitude, success: {(bubbleArray) in
            // TODO: add better visual element
            // TODO: don't remove bubbles every time we refresh, but also do this in better than n^2?

            // Remove old bubbles
            for bubble in self.bubbleAnnotations {
                self.mapView.removeAnnotation(bubble)
            }

            // Populate new bubbles
            for bubble in bubbleArray {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: bubble.geopoint.latitude, longitude: bubble.geopoint.longitude)
                annotation.title = bubble.text
                self.mapView.addAnnotation(annotation)
                self.bubbleAnnotations.append(annotation)
                self.bubblesDisplayed.append(bubble)
            }

            // TODO: Remove this:
            /*
             for bubble in bubbleArray {
             // Delete all the bubbles
             // If the bubble is not already being displayed... display it!
                 if !self.bubblesDisplayed.contains(where: {(bubbleInArray) -> Bool in
             // TODO: Replace this with a single if statement that compares the unique ID's of each bubble
                 if bubbleInArray.text != bubble.text {return false}
                 if bubbleInArray.voteCount != bubble.voteCount {return false}
                 if bubbleInArray.uid != bubble.uid {return false}
                 if bubbleInArray.geopoint.latitude != bubble.geopoint.latitude {return false}
                 if bubbleInArray.geopoint.longitude != bubble.geopoint.longitude {return false}
                 return true
             }) {
                 let annotation = MKPointAnnotation()
                 annotation.coordinate = CLLocationCoordinate2D(latitude: bubble.geopoint.latitude, longitude: bubble.geopoint.longitude)
                 annotation.title = bubble.text
                 self.mapView.addAnnotation(annotation)
                 self.bubbleAnnotations.append(annotation)
                 self.bubblesDisplayed.append(bubble)
             }

             }
             */
        }) {(error) in
            print(error)
        }
    }
    
    func setupBubbleView() {
        self.createBubbleViewCenterY.constant = view.frame.height / 2 + createBubbleView.frame.height
        createBubbleView.postButton.addTarget(self, action: #selector(postBubble), for: .touchUpInside)
        createBubbleView.cancelButton.addTarget(self, action: #selector(cancelPost), for: .touchUpInside)
    }
    
    // Set up the map view and grab the current location of the user
    func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                let alert = UIAlertController(title: "Enable Location Services", message: "Without location services, bubble cannot function, as it is a location-based network. Please enable location services for bubble under: Settings>Privacy>Location Serivces>bubble", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {})
                
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                let userLocation = locationManager.location!.coordinate
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 1000, 1000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    @IBAction func newBubbleButtonPressed(_ sender: Any) {
        createBubbleView.textView.text = ""
        self.createBubbleViewCenterY.constant = -100
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.createBubbleView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.createBubbleView.textView.becomeFirstResponder()
            
        }
    }
    
    // MARK - Bubble Posting
    
    @objc func postBubble() {
        var bubbleData = [String: Any]()
        var latitude = 0.0
        var longitude = 0.0
        bubbleData["text"] = createBubbleView.textView.text
        bubbleData["user"] = "currentUser" // TODO: Use firebase to get FIRUser
        
        if let latitudeCoordinate = locationManager.location?.coordinate.latitude {
            latitude = Double(latitudeCoordinate)
        }
        
        if let longitudeCoordinate = locationManager.location?.coordinate.longitude {
            longitude = Double(longitudeCoordinate)
        }
        
        if createBubbleView.textView.text != "" {
            DataService.instance.createBubble(bubbleData: bubbleData, latitude: latitude, longitude: longitude, success: { (bubble) in
                print(bubble)
            }, failure: { (error) in
                print(error)
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {})
            })
        } else {
            let alert = UIAlertController(title: "Cannot post empty bubble", message: "You must enter at least one character to post this bubble.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {})
        }
    }
    
    @objc func cancelPost() {
        self.createBubbleViewCenterY.constant = view.frame.height / 2 + createBubbleView.frame.height
        self.createBubbleView.resignFirstResponder()
        self.createBubbleView.endEditing(true)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.createBubbleView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

