//
//  MapViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/18/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view.
        addClassesToMap()

        mapView.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    func addClassesToMap(){
        let classLocation109 = ClassLocation(title: "CS109",
                                          locationName: "Bishop Auditorium",
                                          discipline: "Computer Science",
                                          coordinate: CLLocationCoordinate2D(latitude: 37.42952182962479, longitude: -122.16713485362516))
        let classLocationPhil2 = ClassLocation(title: "PHIL2",
                                             locationName: "Building 100",
                                             discipline: "Philosophy",
                                             coordinate: CLLocationCoordinate2D(latitude: 37.428053792518988, longitude: -122.17088533478524))
        let classLocationEcon1 = ClassLocation(title: "ECON1",
                                               locationName: "Stanford Graduate School of Education",
                                               discipline: "Philosophy",
                                               coordinate: CLLocationCoordinate2D(latitude: 37.426339256446816, longitude: -122.1683811172405))
        let classLocationCS193P = ClassLocation(title: "CS193P",
                                               locationName: "William R. Hewlett Teaching Center",
                                               discipline: "Computer Science",
                                               coordinate: CLLocationCoordinate2D(latitude: 37.428919285072595, longitude: -122.1727095102182))
        let classLocationCS221 = ClassLocation(title: "CS221",
                                                locationName: "William R. Hewlett Teaching Center",
                                                discipline: "Computer Science",
                                                coordinate: CLLocationCoordinate2D(latitude: 37.427834635374573, longitude: -122.17415696863098))
        mapView.addAnnotation(classLocation109)
        mapView.addAnnotation(classLocationPhil2)
        mapView.addAnnotation(classLocationEcon1)
        mapView.addAnnotation(classLocationCS193P)
        mapView.addAnnotation(classLocationCS221)
        
    
    }
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print(coordinate)
            //Now use this coordinate to add annotation on map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            //Set title and subtitle if you want
            let alert = UIAlertController(title: "New Class",
                                          message: "Enter in class and building name",
                                          preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                // 1
                annotation.title = alert.textFields![0].text
                annotation.subtitle = alert.textFields![1].text
                self.mapView.addAnnotation(annotation)
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            alert.addTextField { textFirstName in
                textFirstName.placeholder = "Class name"
            }
            alert.addTextField { textLastName in
                textLastName.placeholder = "Building name"
            }

            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)

        }
    }
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        myAnnotation.subtitle = "it's lit"
        mapView.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    
    
    
}
