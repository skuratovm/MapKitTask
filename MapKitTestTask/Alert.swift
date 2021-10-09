//
//  Alert.swift
//  MapKitTestTask
//
//  Created by Mikhail Skuratov on 9.10.21.
//

import UIKit

extension UIViewController{
    func AlertAddAddress(title: String, placeholder: String, completionHandler: @escaping(String) -> Void){
        let alertConroller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertConroller.addTextField { (tf) in
            tf.placeholder  = placeholder
        }
        let addAddressAction = UIAlertAction(title: "Add ", style: .default) { (action) in
            let tfText = alertConroller.textFields?.first
            guard let text = tfText?.text else {return}
            completionHandler(text )
        }
        
        let cencelAction = UIAlertAction(title: "Cencel", style: .cancel) { (_) in
        }
        
        alertConroller.addAction(addAddressAction)
        alertConroller.addAction(cencelAction)
        
        present(alertConroller, animated: true, completion: nil)
        
    }
    
    func errorAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        }
        alertController.addAction(okAction)
        present(alertController,animated: true)
    }
}
