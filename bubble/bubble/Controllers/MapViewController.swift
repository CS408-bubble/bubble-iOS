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
import Firebase

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createBubbleView: CreateBubbleView!
    @IBOutlet weak var createBubbleViewCenterY: NSLayoutConstraint!

    var locationManager = CLLocationManager()
    var bubbles = [Bubble]()
    let bubbleSemaphore = DispatchSemaphore(value: 1)
    var currentBubble: Bubble!
    var currentUser: BubbleUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupBubbleView()
        getCurrentUser()
        // Retrieve posts around me with backend function!
    }
    @IBAction func LogOutClick(_ sender: Any) {
        AuthService.sharedInstance.LogOutClicked()
        print("am out mann")
        self.performSegue(withIdentifier: "segueOnSuccessfulLogOut", sender: self)
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
                //mapView.setRegion(viewRegion, animated: false)
            }
        }
    }

    @IBAction func newBubbleButtonPressed(_ sender: Any) {
        createBubbleView.textView.text = ""
        self.createBubbleViewCenterY.constant = -100

        UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseOut, animations: {
            self.createBubbleView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.createBubbleView.textView.becomeFirstResponder()
        }
    }

    // MARK - Bubble Posting

    @objc func postBubble() {

        guard let latitude = locationManager.location?.coordinate.latitude else {
            return
        }

        guard let longitude = locationManager.location?.coordinate.longitude else {
            return
        }

        // Dismiss the Post View
        cancelPost()

        var bubbleData = [String: Any]()
        let doubleLatitude = Double(latitude)
        let doubleLongitude = Double(longitude)
        bubbleData["text"] = createBubbleView.textView.text
        bubbleData["owner"] = Auth.auth().currentUser?.uid // TODO: Use firebase to get FIRUser

        if createBubbleView.textView.text != "" {
            DataService.instance.createBubble(bubbleData: bubbleData, latitude: doubleLatitude, longitude: doubleLongitude, success: { (bubble) in
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

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate = mapView.centerCoordinate
        bubbleSemaphore.wait()
        DataService.instance.getBubbles(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude, success: { (bubbles) in
            self.bubbles = bubbles
            DispatchQueue.main.async {
                self.placeBubbles()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "BubblePin")
        let selectButton = UIButton(type: .detailDisclosure)
        selectButton.addTarget(self, action: #selector(pinButtonClicked(_:)), for: .touchUpInside)
        pinView.rightCalloutAccessoryView = selectButton
        pinView.canShowCallout = true
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let bubbleAnnotationView = view as! MKPinAnnotationView
        let bubbleAnnotation = bubbleAnnotationView.annotation as! BubbleAnnotation
        currentBubble = bubbleAnnotation.bubble
    }

    //var success: Bubble!
    @objc func pinButtonClicked(_ sender: UIButton) {
       
        let myuid:String = (Auth.auth().currentUser?.uid)!
        // TODO: Do something with selected bubble using currentBubble
       
        /*DataService.instance.getUserBubbles(uid: myuid, success: {(bubbleResult) in
            for bubbler in bubbleResult {
                
                print(bubbler.uid)
            }
            }) { (error) in
                print(error.localizedDescription)
            }*/
        print("this is just to confirm you have tried to expand the bubble")
    }
    
    func placeBubbles() {
        for bubble in bubbles {
            let bubbleAnnotation = BubbleAnnotation()
            bubbleAnnotation.bubble = bubble
            bubbleAnnotation.title = bubble.text
            bubbleAnnotation.coordinate = CLLocationCoordinate2DMake(bubble.geopoint.latitude, bubble.geopoint.longitude)
            mapView.addAnnotation(bubbleAnnotation)
        }
        
        bubbleSemaphore.signal()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueOnBubblePop" {
            if let destination = segue.destination as? BubbleViewController {
                destination.currentBubble = currentBubble 
            }
        }
    }
  
    
    func getCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.getUser(userID: uid) { (user) in
            self.currentUser = user
        }
    }
}
