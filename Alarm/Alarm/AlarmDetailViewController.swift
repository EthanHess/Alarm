//
//  AlarmDetailViewController.swift
//  Alarm
//
//  Created by Ethan Hess on 5/18/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class AlarmDetailViewController: UIViewController, AlarmScheduler {
    
    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTitleTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm: Alarm?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let alarm = alarm {
            
            updateWithAlarm(alarm)
        }
        
        setupView()
    }
    
    func setupView() {
        
        if alarm == nil {
            enableButton.hidden = true
        } else {
            enableButton.hidden = false
            if alarm?.enabled == true {
                
                enableButton.setTitle("Disable", forState: .Normal)
                enableButton.setTitleColor(.whiteColor(), forState: .Normal)
                enableButton.backgroundColor = .redColor()
                
            } else {
                
                enableButton.setTitle("Enable", forState: .Normal)
                enableButton.setTitleColor(.blueColor(), forState: .Normal)
                enableButton.backgroundColor = .grayColor()
            }
        }
    }
    
    func updateWithAlarm(alarm: Alarm) {
        
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
        
        alarmDatePicker.setDate(NSDate(timeInterval: alarm.fireTimeFromMidnight, sinceDate: thisMorningAtMidnight), animated: false)
        alarmTitleTextField.text = alarm.name
        
        self.title = alarm.name
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        guard let title = alarmTitleTextField.text,
            thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
        
        let timeIntervalSinceMidnight = alarmDatePicker.date.timeIntervalSinceDate(thisMorningAtMidnight)
        
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            cancelLocalNotification(alarm)
            scheduleLocalNotification(alarm)
            
        } else {
            let alarm = AlarmController.sharedInstance.addAlarm(timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
            scheduleLocalNotification(alarm)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func enableButtonTapped(sender: AnyObject) {
        
        guard let alarm = alarm else { return }
        
        AlarmController.sharedInstance.toggleEnabled(alarm)
        if alarm.enabled {
            scheduleLocalNotification(alarm)
        } else {
            cancelLocalNotification(alarm)
        }
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
