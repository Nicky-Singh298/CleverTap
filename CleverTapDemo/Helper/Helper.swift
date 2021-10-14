//
//  Helper.swift
//  CleverTapDemo
//
//  Created by Nicky on 12/10/21.
//

import Foundation
import UIKit
import ReachabilitySwift


class StaticHelper{

    let reachability = Reachability()!
    var isInternetConnected = false

    class var shared : StaticHelper {
        struct Static {
            static let instance = StaticHelper()
        }
        
        return Static.instance
    }

    func getImage(from string: String) -> UIImage? {
        //2. Get valid URL
        guard let url = URL(string: string)
            else {
                print("Unable to create URL")
                return nil
        }

        var image: UIImage? = nil
        do {
            //3. Get valid data
            let data = try Data(contentsOf: url, options: [])

            //4. Make image
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }

        return image
    }


    class func showAlert(message : String, title : String , VC: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        VC.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Network Monitoring
    func startMonitoringNetworkStatus() {
        
        reachability.whenReachable = { reachability in
            if reachability.isReachableViaWiFi {
                // //print("Reachable via WiFi")
                self.isInternetConnected = true
            } else {
                // //print("Reachable via Cellular")
                self.isInternetConnected = true
            }
        }
        reachability.whenUnreachable = { _ in
            // //print("Not reachable")
            self.isInternetConnected = false
        }
        
        do {
            try reachability.startNotifier()
            
        } catch {
            // //print("could not start reachability notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        if let reachability = note.object as? Reachability{
            
            if reachability.isReachable {
                if reachability.isReachableViaWiFi {
                    // //print("Reachable via WiFi")
                    self.isInternetConnected = true
                } else {
                    // //print("Reachable via Cellular")
                    self.isInternetConnected = true
                }
            } else {
                // //print("Network not reachable")
                self.isInternetConnected = false
            }
        }
        else{
            
        }
    }

    
}
