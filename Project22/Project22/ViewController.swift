//
//  ViewController.swift
//  Project22
//
//  Created by MTMAC51 on 08/11/22.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet var circleView: UIView!
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconTypeLabel: UILabel!
    var currentBeaconUuid: UUID?
    
    var isdetected = false
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        circleView.layer.zPosition = -1
        circleView.clipsToBounds = true
        circleView.layer.backgroundColor = UIColor.clear.cgColor
        circleView.layer.borderColor = UIColor.green.cgColor
        circleView.layer.borderWidth = 5
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways{
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }
    
    func startScanning(){
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion1 = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegion1)
    }
    
    func update(distance: CLProximity, identifier: String){
        UIView.animate(withDuration: 1){
            self.beaconTypeLabel.text = identifier
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
                
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
            }
        }
        
        if distance != .unknown {
            if !isdetected {
                let ac = UIAlertController(title: "Beacon is detected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(ac, animated: true, completion: nil)
                isdetected = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity, identifier: "Apple AirLocate 5A4BCFCE")
        } else {
            currentBeaconUuid = nil
            
            update(distance: .unknown, identifier: "There is No Beacon Located")
            
        }
    }
}

