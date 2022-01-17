//
//  ViewController.swift
//  MapKitTestTask
//
//  Created by Mikhail Skuratov on 9.10.21.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController {
    var isMove = false
    var currentCoordinate: CLLocationCoordinate2D!
    var steps = [MKRoute.Step]()
    let locationManager = CLLocationManager()
    let speechSynthesizer = AVSpeechSynthesizer()
       
    
    var stepCounter = 0
    
    let directionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Direction"
        label.textColor = .black
        
        return label
    }()
    let addAddressButton: UIButton = {
          let button = UIButton()
          //button.setTitle("Add", for: .normal)
        button.setImage(#imageLiteral(resourceName: "point-1984772-1677550.png"), for: .normal)
        button.imageEdgeInsets.left = 25
        button.imageEdgeInsets.right = 25
        button.imageEdgeInsets.bottom = 25
        button.imageEdgeInsets.top = 25
          button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 27
          button.layer.borderWidth = 1
          button.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.backgroundColor =  #colorLiteral(red: 0.6804623008, green: 0.8824461102, blue: 0.9622985721, alpha: 1)
          return button
      }()
    
    let menuButton: UIButton = {
         let button = UIButton()
       // button.setTitle(" ^ ", for: .normal)
        
        button.setImage(#imageLiteral(resourceName: "up-chevron-458462.png"), for: .normal)
        button.imageEdgeInsets.left = 35
        button.imageEdgeInsets.right = 35
        button.imageEdgeInsets.bottom = 9
        button.imageEdgeInsets.top = 9
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return button
    }()
      
      let routeButton: UIButton = {
          let button = UIButton()
          //button.setTitle("Route", for: .normal)
        button.setImage(#imageLiteral(resourceName: "route-2459472-2139747.png"), for: .normal)
        button.imageEdgeInsets.left = 23
        button.imageEdgeInsets.right = 23
        button.imageEdgeInsets.bottom = 23
        button.imageEdgeInsets.top = 23
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 27
          button.layer.borderWidth = 1
          button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        button.isHidden = true
          return button
      }()
      
      let resetButton: UIButton = {
          let button = UIButton()
          button.setTitle("Reset", for: .normal)
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal)
       
        button.isHidden = true
          return button
      }()
    
    let mapView: MKMapView = {
           let mapView = MKMapView()
           mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = 41
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           return mapView
           
       }()
    
    var annotationArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        view.backgroundColor = #colorLiteral(red: 0.9743027091, green: 0.9609521031, blue: 0.9301842451, alpha: 1)
       setConstraints()
        addAddressButton.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        mapView.delegate = self
    }
    @objc func menuButtonTapped(){
        toggleMenu()
    }
    @objc func addAddressButtonTapped(){
        AlertAddAddress(title: "Add point", placeholder: "Enter address") { [self](text ) in
            setupPlaceMark(placeAddress: text)
        }
    }
    @objc func routeButtonTapped(){
        for index in 0...annotationArray.count - 2{
            createTheRoute(startCoord: annotationArray[index].coordinate, destinationCoord: annotationArray[index + 1].coordinate)
        }
        mapView.showAnnotations(annotationArray, animated: true)
    }
    @objc func resetButtonTapped(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationArray = [MKPointAnnotation]()
        resetButton.isHidden = true
        routeButton.isHidden = true
    }
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            // показываем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.mapView.frame.origin.y = self.mapView.frame.origin.y - 130
                            //self.menuButton.setImage(#imageLiteral(resourceName: "down-chevron-458459.png"), for: .normal)
            }) { (finished) in
                
            }
        } else {
            // убираем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.mapView.frame.origin.y = 0
                            //self.menuButton.setImage(#imageLiteral(resourceName: "up-chevron-458462.png"), for: .normal)
            }) { (finished) in
    
//                self.menuViewController.willMove(toParent: nil)
//                self.menuViewController.view.removeFromSuperview()
//                self.menuViewController.removeFromParent()
                //self.menuViewController.remove()
                print("Удалили menuViewController")
            }
        }
    }
    
    func toggleMenu() {
        
        if !isMove {
            //configureMenuViewController()
        }
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
    
    private func setupPlaceMark(placeAddress: String){
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(placeAddress) { [self](placemarks, error) in
//
//
//            if let error = error{
//                print (error)
//                errorAlert(title: "error", message: "Server is not available")
//                return
//            }
//
//            guard let placemarks = placemarks  else {return}
//            let placemark = placemarks.first
//            guard let placemarkLocation = placemark?.location else {return}
//
//            let annotation = MKPointAnnotation()
//            annotation.title = "\(placeAddress)"
//
//            annotation.coordinate = placemarkLocation.coordinate
//            annotationArray.append(annotation)
//
//            if annotationArray.count > 1{
//                routeButton.isHidden = false
//                resetButton.isHidden = false
//            }
//
//            mapView.showAnnotations(annotationArray, animated: true)
//        }
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = placeAddress
        let region = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response, _) in
            guard let response = response else { return }
            guard let firstMapItem = response.mapItems.first else { return }
            self.getDirections(to: firstMapItem)
        }
    }
    //MARK:Some source code
    
    func getDirections(to destination: MKMapItem) {
        let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destination
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, _) in
            guard let response = response else { return }
            guard let primaryRoute = response.routes.first else { return }
            
            self.mapView.addOverlay(primaryRoute.polyline)
            
        self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
            self.steps = primaryRoute.steps
            for i in 0 ..< primaryRoute.steps.count {
                let step = primaryRoute.steps[i]
                print(step.instructions)
                print(step.distance)
                let region = CLCircularRegion(center: step.polyline.coordinate,
                                              radius: 20,
                                              identifier: "\(i)")
                self.locationManager.startMonitoring(for: region)
                let circle = MKCircle(center: region.center, radius: region.radius)
                self.mapView.addOverlay(circle)
            }
            
            let initialMessage = "Через \(self.steps[0].distance) метров, \(self.steps[0].instructions) далее через \(self.steps[1].distance) метров, \(self.steps[1].instructions)."
            self.directionsLabel.text = initialMessage
            let speechUtterance = AVSpeechUtterance(string: initialMessage)
            self.speechSynthesizer.accessibilityLanguage = "ru-RU"
            self.speechSynthesizer.speak(speechUtterance)
            
            self.stepCounter += 1
        }
    }
    
    private func createTheRoute(startCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D){
        
        let startLocation = MKPlacemark(coordinate: startCoord)
        let destinateLocation = MKPlacemark(coordinate: destinationCoord)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinateLocation)
        
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            if let error = error {
                print(error)
                return
                
            }
            
            guard let response = response else {
                self.errorAlert(title: "Error", message:" Unable to create the route")
                return
            }
            var minRoute = response.routes[0]
            for route in response.routes{
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
        
    }
    
   
    
  

}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
        mapView.userTrackingMode = .followWithHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED")
        stepCounter += 1
        if stepCounter < steps.count {
            let currentStep = steps[stepCounter]
            let message = "Через \(currentStep.distance) метров, \(currentStep.instructions)"
            directionsLabel.text = message
            let speechUtterance = AVSpeechUtterance(string: message)
            speechSynthesizer.speak(speechUtterance)
        } else {
            let message = "Arrived at destination"
            directionsLabel.text = message
            let speechUtterance = AVSpeechUtterance(string: message)
            speechSynthesizer.speak(speechUtterance)
            stepCounter = 0
            locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
        }
    }
}

extension ViewController: MKMapViewDelegate{
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let rendered = MKPolylineRenderer(overlay: overlay as! MKPolyline)
//        rendered.strokeColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//        return rendered
//    }
//    if overlay is MKCircle {
//        let renderer = MKCircleRenderer(overlay: overlay)
//        renderer.strokeColor = .red
//        renderer.fillColor = .red
//        renderer.alpha = 0.5
//        return renderer
//    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            renderer.lineWidth = 10
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            renderer.fillColor = .red
            renderer.alpha = 0.5
            return renderer
        }
        return MKOverlayRenderer()
    }
}

extension ViewController{
    
    func setConstraints(){
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ])
        
        view.addSubview(directionsLabel)
        NSLayoutConstraint.activate([
            directionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
            directionsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            directionsLabel.heightAnchor.constraint(equalToConstant: 30),
            directionsLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        view.insertSubview(addAddressButton, at: 0)
        NSLayoutConstraint.activate([
            addAddressButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor,constant: -25),
            addAddressButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor,constant: 5),
            addAddressButton.heightAnchor.constraint(equalToConstant: 90),
            addAddressButton.widthAnchor.constraint(equalToConstant: 90)
            
            
        ])
        mapView.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.heightAnchor.constraint(equalToConstant: 43),
            menuButton.widthAnchor.constraint(equalToConstant: 150),
            menuButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -15),
            menuButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor, constant: 0.0)
        ])
        
        view.insertSubview(routeButton, at: 0)
        NSLayoutConstraint.activate([
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -25),
            routeButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -5),
            routeButton.heightAnchor.constraint(equalToConstant: 90),
            routeButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40),
            resetButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor, constant: 0.0),
            resetButton.heightAnchor.constraint(equalToConstant: 60),
            resetButton.widthAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}


