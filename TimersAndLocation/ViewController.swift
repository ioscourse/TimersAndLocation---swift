//
//  ViewController.swift
//  TimersAndLocation
//
//  Created by Charles Konkol on 2015-11-09.
//  Copyright © 2015 Chuck Konkol. All rights reserved.
//

import UIKit
//0) Add import for CoreData
import CoreData
import CoreLocation

class ViewController: UIViewController,  CLLocationManagerDelegate  {
    
    //Get location
    
    var mylatitude: Double!
    var mylongitude:Double!
      var slocationObj:CLLocation!
    var blnLoad:Bool!
    var blnStop:Bool!
    var gnumber:Int = 0
    var timer1:NSTimer!
    var timer2:NSTimer!
    var locationManager = CLLocationManager()
    /*


    
    add CoreLocation.framework to BuildPhases -> Link Binary With Libraries
    import CoreLocation to your class - probably ViewController.swift
    add CLLocationManagerDelegate to your class decleration
    Add NSLocationWhenInUseUsageDescription and NSLocationAlwaysUsageDescription to plist
    
    init location manager:
    
    locationManager = CLLocationManager()
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
    get User Location By:
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    var userLocation:CLLocation = locations[0] as! CLLocation
    let long = userLocation.coordinate.longitude;
    let lat = userLocation.coordinate.latitude;
    //Do What ever you want with it
    }
    


     */
    
    @IBOutlet weak var IsLocation: UISwitch!
    
    @IBAction func IsLocation(sender: AnyObject) {
        
    }
    
    //1) Add ManagedObject Data Context
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    //2) Add variable contactdb (used from UITableView
    var timerdb:NSManagedObject!
    
    var gLong:Double!
     var gLat:Double!

    @IBOutlet weak var timername: UITextField!
 
    @IBOutlet weak var timermessage: UITextField!
    
    @IBOutlet weak var timertiem: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    
    @IBOutlet weak var status: UILabel!
    
    
    @IBAction func btnSave(sender: AnyObject) {
        //4 Add Save Logic
        if (timerdb != nil)
        {
            
            timerdb.setValue(timername.text, forKey: "timername")
            timerdb.setValue(timermessage.text, forKey: "timermsg")
            timerdb.setValue(timertiem.text, forKey: "timertime")
            timerdb.setValue(IsLocation.on, forKey: "bylocation")
            //removeNotification(timername.text!)
            if (IsLocation.on == true)
            {
                getlocation()
                timerdb.setValue(String(mylatitude), forKey: "timelat")
                  timerdb.setValue(String(mylongitude), forKey: "timelong")

            }
        }
        else
        {
            let entityDescription =
            NSEntityDescription.entityForName("MyTimers",inManagedObjectContext: managedObjectContext)
            
            let contact = MyTimers(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            
            contact.timername = timername.text!
            contact.timermsg = timermessage.text!
            contact.timertime = timertiem.text!
             contact.bylocation = IsLocation.on
            if (IsLocation.on == true)
            {
                
                getlocation()
              //  CreateByLocation()
               print(String(mylatitude))
                contact.timelat = String(mylatitude)
                contact.timelong = String(mylongitude)
            }
            
            }
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let err = error {
            status.text = err.localizedFailureReason
        } else {
            

            self.dismissViewControllerAnimated(false, completion: nil)
            
        }
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        //3) Dismiss ViewController
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        blnLoad=false
        blnStop = false

        // Ask for Authorisation from the User.
      
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.distanceFilter = 0.01
            locationManager.startUpdatingLocation()
            getlocation()
            //   getlocation()
        } else {
            status.text = "Location services are not enabled"
        }

        
        
        // Do any additional setup after loading the view, typically from a nib.
        //5 Add logic to load db. If contactdb has content that means a row was tapped on UiTableView
        if (timerdb != nil)
        {
            timername.text = timerdb.valueForKey("timername") as? String
            timermessage.text = timerdb.valueForKey("timermsg") as? String
            timertiem.text = timerdb.valueForKey("timertime") as? String
             IsLocation.on = (timerdb.valueForKey("bylocation") as? Bool)!
            btnSave.setTitle("Update", forState: UIControlState.Normal)
            if (IsLocation.on == false)
            {
                timertiem.enabled = true
                let TimerTime = Double(timertiem.text!)
             timer1 = NSTimer.scheduledTimerWithTimeInterval(TimerTime!, target: self, selector: "message", userInfo: nil, repeats: false)
                blnLoad=false
            }
            else
            {
                timertiem.enabled = false
                gLong = Double((timerdb.valueForKey("timelong") as? String)!)
                gLat = Double((timerdb.valueForKey("timelat") as? String)!)
                print("locations = \(gLat) \(gLong)")
                blnLoad=true
            }
            
        }
        timername.becomeFirstResponder()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)
    }
    
    func getlocation()
    {
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.distanceFilter = 0.01
            locationManager.startUpdatingLocation()
            
            
        }        // Do any additi
        else
        {
            status.text = "Location services are not enabled"
        }
    }

    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
         let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        mylatitude = locValue.latitude
        mylongitude = locValue.longitude
        if (IsLocation.on == true)
        {
            
            if (blnLoad == true)
            {
                self.slocationObj = CLLocation(latitude: gLat, longitude: gLong)
                
                var distance = locationObj.distanceFromLocation(slocationObj)
               
                print("distance = \(distance)")
                status.text = "Distance from Saved location:\(distance))"
                if (distance < 10)
                {
                    gnumber = gnumber + 1
                    if (gnumber > 4 && blnStop == false)
                    {
                        gnumber = 7
                        blnStop = true
                        message()
                    }
                   
                }
            }
           
        }

        
        
    }
    
    // must be internal or public.
    func message() {
        // Something cool
        let alert = UIAlertView()
        alert.title = timername.text!
        alert.message = timermessage.text
        
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //6 Add to hide keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as UITouch! {
            DismissKeyboard()
        }
        super.touchesBegan(touches , withEvent:event)
    }
    
    //7 Add to hide keyboard
    func DismissKeyboard(){
        //forces resign first responder and hides keyboard
        timername.endEditing(true)
        timertiem.endEditing(true)
        
    }
    //8 Add to hide keyboard
    func textFieldShouldReturn(textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
 
   
    

}

