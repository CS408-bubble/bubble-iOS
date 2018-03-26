//
//  ARViewController.swift
//  bubble
//
//  Created by Sawyer Blatz on 3/1/18.
//  Copyright © 2018 CS 408. All rights reserved.
//

import UIKit
import ARKit
import ARCL
import CoreLocation
import Firebase

class ARViewController: UIViewController {

    @IBOutlet weak var createBubbleView: CreateBubbleView!
    @IBOutlet weak var newBubbleButton: UIButton!
    @IBOutlet weak var createBubbleViewCenterY: NSLayoutConstraint!

    var sceneLocationView = SceneLocationView()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the Create Bubble View
        self.createBubbleViewCenterY.constant = view.frame.height / 2 + createBubbleView.frame.height
        createBubbleView.postButton.addTarget(self, action: #selector(postBubble), for: .touchUpInside)
        createBubbleView.cancelButton.addTarget(self, action: #selector(cancelPost), for: .touchUpInside)

        // Set up the AR View
        sceneLocationView.run()
        view.insertSubview(sceneLocationView, belowSubview: newBubbleButton)

        populatePostedBubbles()

    }

    func populatePostedBubbles() {
        guard let latitude = locationManager.location?.coordinate.latitude else {
            return
        }

        guard let longitude = locationManager.location?.coordinate.longitude else {
            return
        }

        DataService.instance.getBubbles(latitude: latitude, longitude: longitude, success: { (bubbles) in
            for bubble in bubbles {
                // Create a visual element:

                let coordinate = CLLocationCoordinate2D(latitude: bubble.geopoint.latitude, longitude: bubble.geopoint.longitude)
                let location = CLLocation(coordinate: coordinate, altitude: (self.locationManager.location?.altitude)! + 10)
                let image = #imageLiteral(resourceName: "bubbleImage")
                let imageWithText = self.addTextToImage(text: bubble.text as NSString, inImage: image, atPoint: CGPoint(x: 0, y: 0))
                let annotationNode = LocationAnnotationNode(location: location, image: imageWithText)
                print("adding bubble: \(bubble.text)")
                annotationNode.scaleRelativeToDistance = true
                self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

            }
        }) { (error) in
            print("error fetching bubble: \(error)")
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK - Image Processing
    func addTextToImage(text: NSString, inImage: UIImage, atPoint:CGPoint) -> UIImage{

        // Setup the font specific variables
        let textColor = UIColor.white
        let textFont = UIFont.systemFont(ofSize: 80)

        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ]

        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)


        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0.0, y: 0.0, width: inImage.size.width, height: inImage.size.height)

        let textSize = text.size(withAttributes: [NSAttributedStringKey.font:textFont])
        let textRect = CGRect(x: drawingBounds.size.width/2 - textSize.width/2, y: drawingBounds.size.height/2 - textSize.height/2,
                              width: textSize.width, height: textSize.height)

        text.draw(in: textRect, withAttributes: textFontAttributes)

        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImag!
    }

    func badAddTextToImage(text: NSString, inImage: UIImage, atPoint:CGPoint) -> UIImage{

        // Setup the font specific variables
        let textColor = UIColor.white
        let textFont = UIFont.systemFont(ofSize: 20)

        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ]

        // Create bitmap based graphics context
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, 0.0)


        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        // Our drawing bounds
        let drawingBounds = CGRect(x: 0.0, y: 0.0, width: inImage.size.width, height: inImage.size.height)

        let textSize = text.size(withAttributes: [NSAttributedStringKey.font:textFont])
        let textRect = CGRect(x: drawingBounds.size.width/2 - textSize.width/2, y: drawingBounds.size.height/2 - textSize.height/2,
                              width: textSize.width, height: textSize.height)

        text.draw(in: textRect, withAttributes: textFontAttributes)

        // Get the image from the graphics context
        let newImag = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImag!
    }

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    // MARK - Bubble Posting

    @objc func postBubble() {

        guard let latitude = locationManager.location?.coordinate.latitude else {
            return
        }

        guard let longitude = locationManager.location?.coordinate.longitude else {
            return
        }
        // Create a visual bubble
        let alteredLatitude = latitude + 0.00010
        let alteredLongitude = longitude + 0.00010
        let alteredCoordinate = CLLocationCoordinate2D(latitude: alteredLatitude, longitude: alteredLongitude)

        let location = CLLocation(coordinate: alteredCoordinate, altitude: (locationManager.location?.altitude)! + 25)
        let image = #imageLiteral(resourceName: "bubbleImage")
        let imageWithText = badAddTextToImage(text: createBubbleView.textView.text! as NSString, inImage: image, atPoint: CGPoint(x: 0, y: 0))
        let annotationNode = LocationAnnotationNode(location: location, image: imageWithText)

        annotationNode.scaleRelativeToDistance = true
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)

        // Dismiss the Post View
        // cancelPost()

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
            //alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {})
        }
    }

    @objc func cancelPost() {

        postBubble()

        self.createBubbleViewCenterY.constant = view.frame.height / 2 + createBubbleView.frame.height
        self.createBubbleView.resignFirstResponder()
        self.createBubbleView.endEditing(true)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.createBubbleView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
