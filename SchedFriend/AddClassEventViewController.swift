//
//  AddClassEventViewController.swift
//  SchedFriend
//
//  Created by Akshay Ramaswamy on 3/18/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//
// This file uses event kit to add classes to a user's default calendar.
// The user can set the recurrence rule for what day the class is each week

import UIKit
import EventKit
var calendarForEvent: EKCalendar?

class AddClassEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    let eventStore = EKEventStore()
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    
    @IBOutlet weak var dayPicker: UIPickerView!
    var pickerData: [String] = [String]()
    var selectedPick:String = "Monday"
    func initialDatePickerValue() -> Date {
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        
        dateComponents.hour = 0
        dateComponents.minute = 1
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dayPicker.delegate = self
        self.dayPicker.dataSource = self
        self.eventStartDatePicker.setValue(UIColor.white, forKey: "textColor")
        // Input data into the Array:
        pickerData = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        
        checkCalendarAuthorizationStatus()
        self.eventStartDatePicker.setDate(initialDatePickerValue(), animated: false)
        self.hideKeyboardWhenTappedAround()
        self.eventNameTextField.delegate = self
        
    }
    
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    calendarForEvent = self.eventStore.defaultCalendarForNewEvents
                })
            } else {
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "Event could not save", message: "please grant access to calendars in settings", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                })
            }
        })
    }
    @IBAction func addEvent(_ sender: UIButton) {
        // Use Event Store to create a new calendar instance
        let calendarForEvent = eventStore.defaultCalendarForNewEvents
        
        
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = calendarForEvent
        newEvent.title = self.eventNameTextField.text ?? "Some Event Name"
        newEvent.startDate = self.eventStartDatePicker.date
        newEvent.endDate = self.eventStartDatePicker.date
        let newRule = getRecurrenceRule()
        
        newEvent.addRecurrenceRule(newRule)
        // Save the event using the Event Store instance
        do {
            
            try eventStore.save(newEvent, span: .thisEvent, commit: true)
            let alert = UIAlertController(title: "Event added to calendar!", message: newEvent.title, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
            
            
        } catch {
            let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getRecurrenceRule()->EKRecurrenceRule{
        var newRule = EKRecurrenceRule()
        switch (self.selectedPick) {
        case "Monday":
            let monday = EKRecurrenceDayOfWeek(.monday)
            newRule = EKRecurrenceRule(recurrenceWith: .monthly , interval: 1, daysOfTheWeek: [monday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        case "Tuesday":
            let tuesday = EKRecurrenceDayOfWeek(.tuesday)
            newRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, daysOfTheWeek: [tuesday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        case "Wednesday":
            let wednesday = EKRecurrenceDayOfWeek(.thursday)
            newRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, daysOfTheWeek: [wednesday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        case "Thursday":
            let thursday = EKRecurrenceDayOfWeek(.thursday)
            newRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, daysOfTheWeek: [thursday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        case "Friday":
            let friday = EKRecurrenceDayOfWeek(.friday)
            newRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, daysOfTheWeek: [friday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
            
        default: break
            
            
        }
        return newRule
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            self.requestAccessToCalendar()
        default: break
            
            
            
        }
        
        
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.selectedPick = pickerData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = pickerData[row]
        return NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
}

extension AddClassEventViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }}



