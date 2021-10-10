//
//  ViewController.swift
//  MapKitTestTask
//
//  Created by Mikhail Skuratov on 9.10.21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    let addAddressButton: UIButton = {
          let button = UIButton()
          button.setTitle("Add address", for: .normal)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 5
          button.layer.borderWidth = 1
          button.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.backgroundColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
          return button
      }()
      
      let routeButton: UIButton = {
          let button = UIButton()
          button.setTitle("Route", for: .normal)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 5
          button.layer.borderWidth = 1
          button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.isHidden = true
          return button
      }()
      
      let resetButton: UIButton = {
          let button = UIButton()
          button.setTitle("Reset", for: .normal)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 5
          button.layer.borderWidth = 1
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        button.isHidden = true
          return button
      }()
    
    let mapView: MKMapView = {
           let mapView = MKMapView()
           mapView.translatesAutoresizingMaskIntoConstraints = false
           return mapView
           
       }()
    
    var annotationArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setConstraints()
        addAddressButton.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    @objc func addAddressButtonTapped(){
        AlertAddAddress(title: "Add point", placeholder: "Enter address") { [self](text ) in
            setupPlaceMark(placeAddress: text)
        }
    }
    @objc func routeButtonTapped(){
        print("ll")
    }
    @objc func resetButtonTapped(){
        
    }
    
    private func setupPlaceMark(placeAddress: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(placeAddress) { [self](placemarks, error) in
            
            
            if let error = error{
                print (error)
                errorAlert(title: "error", message: "Server is not available")
                return
            }
            
            guard let placemarks = placemarks  else {return}
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(placeAddress)"
            guard let placemarkLocation = placemark?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            annotationArray.append(annotation)
            
            if annotationArray.count > 0{
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            
            mapView.showAnnotations(annotationArray, animated: true)
        }
    }
    
   
    
  

}

extension ViewController{
    
    func setConstraints(){
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ])
        
        mapView.addSubview(addAddressButton)
        NSLayoutConstraint.activate([
            addAddressButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor,constant: -25),
            addAddressButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor,constant: 5),
            addAddressButton.heightAnchor.constraint(equalToConstant: 50),
            addAddressButton.widthAnchor.constraint(equalToConstant: 170)
            
            
        ])
        mapView.addSubview(routeButton)
        NSLayoutConstraint.activate([
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -25),
            routeButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -5),
            routeButton.heightAnchor.constraint(equalToConstant: 50),
            routeButton.widthAnchor.constraint(equalToConstant: 170)
        ])
        mapView.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40),
            resetButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor, constant: 0.0),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
            resetButton.widthAnchor.constraint(equalToConstant: 120)
            
        ])
    }
    
}


