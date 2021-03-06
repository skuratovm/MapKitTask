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
    
    let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9867531657, green: 0.9864431024, blue: 0.8667159081, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.isHidden = true
        return view
    }()
    
    let indicationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets.bottom = 8
        button.imageEdgeInsets.top = 8
        button.imageEdgeInsets.left = 8
        button.imageEdgeInsets.right = 8
        return button
    }()
    let directionsLabel: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    let addAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Vector-Search.png"), for: .normal)
        button.imageEdgeInsets.left = 20
        button.imageEdgeInsets.right = 20
        button.imageEdgeInsets.bottom = 20
        button.imageEdgeInsets.top = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 1
        button.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.backgroundColor =  #colorLiteral(red: 0.6804623008, green: 0.8824461102, blue: 0.9622985721, alpha: 1)
        return button
    }()
    let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "location.png"), for: .normal)
        button.imageEdgeInsets.left = 18
        button.imageEdgeInsets.right = 20
        button.imageEdgeInsets.bottom = 18
        button.imageEdgeInsets.top = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 1
        button.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.backgroundColor =  #colorLiteral(red: 0.6804623008, green: 0.8824461102, blue: 0.9622985721, alpha: 1)
        return button
    }()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.imageEdgeInsets.left = 55
        button.imageEdgeInsets.right = 55
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "5684692.png"), for: .normal)
        
        
        return button
    }()
    
    let routeButton: UIButton = {
        let button = UIButton()
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
        button.setImage(#imageLiteral(resourceName: "close.png"), for: .normal)
        button.imageEdgeInsets.left = 12
        button.imageEdgeInsets.right = 12
        button.imageEdgeInsets.bottom = 12
        button.imageEdgeInsets.top = 12
        button.layer.cornerRadius = 25
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //mapView.layer.cornerRadius = 41
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return mapView
    }()
    
    var annotationArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        view.backgroundColor = #colorLiteral(red: 0.1671384573, green: 0.1766074598, blue: 0.1851920187, alpha: 1)
        setConstraints()
        addAddressButton.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        //routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        currentLocationButton.addTarget(self, action: #selector(trackUserTapped), for: .touchUpInside)
        mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "gps-arrow-navigator-lite-appstore-for-android-499687")
            pin.frame = CGRect(x: 0, y: 0, width: 55, height: 55)
            
            return pin
            
        } else {
            // handle other annotations
            
        }
        return nil
    }
    @objc func trackUserTapped(){
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
    @objc func menuButtonTapped(){
        toggleMenu()
    }
    @objc func addAddressButtonTapped(){
        AlertAddAddress(title: "???????? ?????????????", placeholder: "?????????????? ??????????") { [self](text ) in
            setupPlaceMark(placeAddress: text)
        }
    }
//    @objc func routeButtonTapped(){
//        for index in 0...annotationArray.count - 2{
//            createTheRoute(startCoord: annotationArray[index].coordinate, destinationCoord: annotationArray[index + 1].coordinate)
//        }
//        mapView.showAnnotations(annotationArray, animated: true)
//    }
    @objc func resetButtonTapped(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationArray = [MKPointAnnotation]()
        resetButton.isHidden = true
        infoView.isHidden = true
    }
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            // ???????????????????? menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.mapView.frame.origin.y = self.mapView.frame.origin.y - 110
                           }) { (finished) in
                
            }
        } else {
            // ?????????????? menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.mapView.frame.origin.y = 0
                           }) { (finished) in
                print("?????????????? menuViewController")
            }
        }
    }
    
    func toggleMenu() {
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
    
    private func setupPlaceMark(placeAddress: String){
        //
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = placeAddress
        let region = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response, _) in
            guard let response = response else { return }
            guard let firstMapItem = response.mapItems.first else { return }
            self.getDirections(to: firstMapItem)
            self.infoView.isHidden = false
            self.resetButton.isHidden = false
        }
    }
    
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
            
            //let intZeroStepDistance = Int(self.steps[0].distance)
            let intFirstStepDistance = Int(self.steps[1].distance)
            
            let initialMessage = "?????????? \(intFirstStepDistance) ????????????, \(self.steps[1].instructions)."
            self.directionsLabel.text = "\(intFirstStepDistance) m"
            print(self.steps[1].instructions)
            //MARK: String split
            let sent = self.steps[1].instructions
            self.configureDirectionimage(sent: sent)
            let speechUtterance = AVSpeechUtterance(string: initialMessage)
            self.speechSynthesizer.accessibilityLanguage = "ru-RU"
            self.speechSynthesizer.speak(speechUtterance)
            
            self.stepCounter += 1
        }
    }
    
    private func configureDirectionimage(sent: String){
        let words = sent.split(separator: " ")
        let directionWord = words[1]
        let direcyionWordRe = words[0]
        if directionWord == "??????????????"{
            self.indicationButton.setImage(#imageLiteral(resourceName: "???Pngtree???vector turn right icon_4184680.png"), for: .normal)
        } else if directionWord == "????????????"{
            self.indicationButton.setImage(#imageLiteral(resourceName: "???Pngtree???vector turn left icon_4184711.png"), for: .normal)
        } else if direcyionWordRe == "????????????????????????"{
            self.indicationButton.setImage(#imageLiteral(resourceName: "???Pngtree???vector u-turn icon_4190813.png"), for: .normal)
        }
    }
    
//    private func createTheRoute(startCoord: CLLocationCoordinate2D, destinationCoord: CLLocationCoordinate2D){
//
//        let startLocation = MKPlacemark(coordinate: startCoord)
//        let destinateLocation = MKPlacemark(coordinate: destinationCoord)
//
//        let request = MKDirections.Request()
//        request.source = MKMapItem(placemark: startLocation)
//        request.destination = MKMapItem(placemark: destinateLocation)
//
//        request.transportType = .walking
//        request.requestsAlternateRoutes = true
//
//        let direction = MKDirections(request: request)
//        direction.calculate { (response, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            guard let response = response else {
//                self.errorAlert(title: "Error", message:" Unable to create the route")
//                return
//            }
//            var minRoute = response.routes[0]
//            for route in response.routes{
//                minRoute = (route.distance < minRoute.distance) ? route : minRoute
//            }
//            self.mapView.addOverlay(minRoute.polyline)
//        }
//    }
//
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
            let intStepDistance = Int(currentStep.distance)
            let message = "?????????? \(intStepDistance) ????????????, \(currentStep.instructions)"
            directionsLabel.text = "\(intStepDistance) m"
            let sent = self.steps[stepCounter].instructions
            configureDirectionimage(sent: sent)
            
            let speechUtterance = AVSpeechUtterance(string: message)
            speechSynthesizer.speak(speechUtterance)
        } else {
            let message = "???? ??????????????"
            directionsLabel.text = " ??????????????"
            indicationButton.setImage(#imageLiteral(resourceName: "2334378-200.png"), for: .normal)
            let speechUtterance = AVSpeechUtterance(string: message)
            speechSynthesizer.speak(speechUtterance)
            stepCounter = 0
            locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            renderer.lineWidth = 10
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            renderer.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            renderer.alpha = 0.5
            return renderer
        }
        return MKOverlayRenderer()
    }
}

extension ViewController{
    
    func setConstraints(){
        
        view.insertSubview(infoView, at: 1)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            infoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            infoView.widthAnchor.constraint(equalToConstant: 160),
            infoView.heightAnchor.constraint(equalToConstant: 70)
        ])
        view.insertSubview(mapView, at: 0)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ])
        
        infoView.insertSubview(directionsLabel, at: 0)
        NSLayoutConstraint.activate([
            
            directionsLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 25),
            directionsLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor, constant: 0),
            //directionsLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -10),
            directionsLabel.heightAnchor.constraint(equalToConstant: 30),
            directionsLabel.widthAnchor.constraint(equalToConstant: 75)
        ])
        
        view.insertSubview(addAddressButton, at: 0)
        NSLayoutConstraint.activate([
            addAddressButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor,constant: -20),
            addAddressButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor,constant: 15),
            addAddressButton.heightAnchor.constraint(equalToConstant: 70),
            addAddressButton.widthAnchor.constraint(equalToConstant: 70)
            
            
        ])
        
        view.insertSubview(currentLocationButton, at: 0)
        NSLayoutConstraint.activate([
            currentLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor,constant: -20),
            currentLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor,constant: -15),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 70),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 70)
            
        ])
        
        mapView.addSubview(menuButton)
        NSLayoutConstraint.activate([
            menuButton.heightAnchor.constraint(equalToConstant: 54),
            menuButton.widthAnchor.constraint(equalToConstant: 167),
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
        view.insertSubview(resetButton, at: 0)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 50)
            
        ])
        infoView.addSubview(indicationButton)
        NSLayoutConstraint.activate([
            indicationButton.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -5),
            indicationButton.centerYAnchor.constraint(equalTo: infoView.centerYAnchor, constant: 0),
            indicationButton.heightAnchor.constraint(equalToConstant: 60),
            indicationButton.widthAnchor.constraint(equalToConstant: 60)
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


