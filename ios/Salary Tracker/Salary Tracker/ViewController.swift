//
//  ViewController.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/18/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //navigation bar
    var navBar:UINavigationBar!;
    
    //settings ViewController
    var settingsController = SettingsController();
    
    //delegate filters for texfields
    var txtRateDelegate = DecimalInputFilter();
    var txtOvertimeRateDelegate = DecimalInputFilter();
    
    //main layout view
    var mainScrollView: UIScrollView!;
    var defaultScroolViewRect:CGRect!;
    
    //main layout componenets
    var lblCurrency:UILabel!;
    var txtRate:UITextField!;
    var lblChosenStartOfShift:UILabel!;
    var lblChosenEndOfShift:UILabel!;
    var lblCalculatedHoursWorked:UILabel!;
    var chkAddOvertime:UICheckBox!;
    var btnCalculateSalary:UIButton!;
    var lblFinalSalary:UILabel!;
    var lblCalculatedFinalSalary:UILabel!;
    
    //layout parameters
    let padding:CGFloat = 10;
    
    //overtime layout view
    var overtimeView: UIView!;
    
    //overtime layout components
    var lblOvertimeCurrency:UILabel!;
    var txtOvertimeRate:UITextField!;
    var lblChosenOvertimeStart:UILabel!;
    var lblChosenOvertimeEnd:UILabel!;
    var lblCalculatedOvertimeWorked:UILabel!;
    var lblCalculatedOverallTimeWorked:UILabel!;
    
    //time variables
    var startTime:Clock?;
    var endTime:Clock?;
    var overtimeStartTime:Clock?;
    var overtimeEndTime:Clock?;
    
    //User Prefference variables
    var preferences = NSUserDefaults.standardUserDefaults();
    var currency: Currency!;
    var displayFormat: Int!;
    var overTimeOn: Bool!;
    
    //a boolean to help load the user preferences only once when the application loads
    var isFirstLoad = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreferences();
        
        //initialize all views in the UI
        createNavBar();
        createMainLayoutView();
        createMainLayout();
        setScrollViewContentSize();
        createAddOvertimeLayoutView()
        setupKeyboard();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        //when the app first loads the preferences are loaded in the viewDidLoad() method, before the UI is created
        if !isFirstLoad{
            loadPreferences();
            
            //after preferences are loaded, reset views that need changing
            resetCurrencies();
            showHoursWorked();
            showOveralTimeWorked();
            if lblCalculatedFinalSalary.text != "-"{
                btnCalculateSalary(btnCalculateSalary);
            }
        } else{
            isFirstLoad = false;
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        //the second the UI appears set the checkbox to the preferred state
        if overTimeOn == false && chkAddOvertime.isChecked || overTimeOn == true && !chkAddOvertime.isChecked{
            chkAddOvertime.sendActionsForControlEvents(.TouchUpInside);
        }
    }
    
    private func loadPreferences(){
        //laod preferred currency
        let currencyInt = preferences.integerForKey(SettingsController.kPreferredCurrency);
        currency = Currency.values()[currencyInt];
        
        //load preferred overall time display format
        displayFormat = preferences.integerForKey(SettingsController.kPreferredOverallTimeDisplayFormat);
        
        overTimeOn = preferences.boolForKey(SettingsController.kPreferredOvertimeOn);
    }
    
    private func resetCurrencies(){
        lblCurrency.text = currency.description();
        lblOvertimeCurrency.text = currency.description();
    }
    
    func createNavBar(){
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64));
        let navItem = UINavigationItem();
        navItem.title = "Salary Tracker";
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.Plain, target: self, action: "btnOpenSettings:");
        navBar.items = [navItem];
        view.addSubview(navBar);
    }
    
    func btnOpenSettings(sender: UIBarButtonItem){
        presentViewController(settingsController, animated: true, completion: nil)
    }
    
    func createMainLayoutView(){
        defaultScroolViewRect = CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width, height: view.frame.height - navBar.frame.height);
        mainScrollView = UIScrollView(frame: defaultScroolViewRect);
        view.addSubview(mainScrollView);
    }
    
    func createMainLayout(){
        //set start time button
        let btnSetStartTime = UIButton(type: .Custom);
        btnSetStartTime.setTitle("Set Start Time", forState: .Normal);
        btnSetStartTime.frame = CGRect(x: padding / 3, y: padding, width: view.frame.width / 2 - padding / 5, height: 40);
        btnSetStartTime.setBackgroundImage(UIImage(named: "button_background"), forState: .Normal)
        btnSetStartTime.setBackgroundImage(UIImage(named: "highlighted_button_background"), forState: .Highlighted);
        btnSetStartTime.addTarget(self, action: "btnSetStartTime:", forControlEvents: .TouchUpInside);
        mainScrollView.addSubview(btnSetStartTime);
        
        //set end time button
        let btnSetEndTime = UIButton(type: .Custom);
        btnSetEndTime.setTitle("Set End Time", forState: .Normal);
        btnSetEndTime.frame = CGRect(x: view.frame.width / 2 + padding / 5, y: btnSetStartTime.frame.origin.y, width: view.frame.width / 2 - padding / 3, height: 40);
        btnSetEndTime.setBackgroundImage(UIImage(named: "button_background"), forState: .Normal);
        btnSetEndTime.setBackgroundImage(UIImage(named: "highlighted_button_background"), forState: .Highlighted);
        btnSetEndTime.addTarget(self, action: "btnSetEndTime:", forControlEvents: .TouchUpInside);
        mainScrollView.addSubview(btnSetEndTime);
        
        //rate input label
        let lblRate = UILabel(frame: CGRect(x: padding, y: btnSetStartTime.frame.maxY + padding, width: 0, height: 0));
        lblRate.text = "Rate: ";
        lblRate.sizeToFit();
        mainScrollView.addSubview(lblRate);
        
        //rate currency label
        lblCurrency = UILabel(frame: CGRect(x: 0, y: lblRate.frame.origin.y, width: 0, height: 0));
        lblCurrency.text = currency.description();
        lblCurrency.sizeToFit();
        lblCurrency.frame.origin.x = view.frame.width - lblCurrency.frame.width - padding;
        mainScrollView.addSubview(lblCurrency);
        
        //rate input textField
        txtRate = UITextField(frame: CGRect(x: lblRate.frame.maxX, y: lblRate.frame.origin.y, width: lblCurrency.frame.origin.x - lblRate.frame.maxX - padding, height: 22));
        txtRate.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.03);
        txtRate.font = UIFont.systemFontOfSize(16);
        txtRate.keyboardType = .DecimalPad;
        txtRate.delegate = txtRateDelegate;
        mainScrollView.addSubview(txtRate);
        
        //start of shift label
        let lblStartOfShift = UILabel(frame: CGRect(x: 0, y: lblRate.frame.maxY + padding * 2, width: 0, height: 0));
        lblStartOfShift.text = "Start of shift:";
        lblStartOfShift.sizeToFit();
        lblStartOfShift.center.x = view.center.x / 2;
        mainScrollView.addSubview(lblStartOfShift);
        
        //chosen start of shift label
        lblChosenStartOfShift = UILabel(frame: CGRect(x: 0, y: lblStartOfShift.frame.origin.y, width: 0, height: 0));
        lblChosenStartOfShift.text = "--:--";
        lblChosenStartOfShift.sizeToFit();
        lblChosenStartOfShift.center.x = view.center.x * 1.5;
        mainScrollView.addSubview(lblChosenStartOfShift);
        
        //end of shift label
        let lblEndOfShift = UILabel(frame: CGRect(x: 0, y: lblStartOfShift.frame.maxY + padding / 2, width: 0, height: 0));
        lblEndOfShift.text = "End of shift:";
        lblEndOfShift.sizeToFit();
        lblEndOfShift.center.x = view.center.x / 2;
        mainScrollView.addSubview(lblEndOfShift);
        
        //chosen end of shift label
        lblChosenEndOfShift = UILabel(frame: CGRect(x: 0, y: lblEndOfShift.frame.origin.y, width: 0, height: 0));
        lblChosenEndOfShift.text = "--:--";
        lblChosenEndOfShift.sizeToFit();
        lblChosenEndOfShift.center.x = view.center.x * 1.5;
        mainScrollView.addSubview(lblChosenEndOfShift);
        
        //hours worked label
        let lblHoursWorked = UILabel(frame: CGRect(x: 0, y: lblEndOfShift.frame.maxY + padding / 2, width: 0, height: 0));
        lblHoursWorked.text = "Hours worked:";
        lblHoursWorked.sizeToFit();
        lblHoursWorked.center.x = view.center.x / 2;
        mainScrollView.addSubview(lblHoursWorked);
        
        //calculated hours worked label
        lblCalculatedHoursWorked = UILabel(frame: CGRect(x: 0, y: lblHoursWorked.frame.origin.y, width: 0, height: 0));
        lblCalculatedHoursWorked.text = "-";
        lblCalculatedHoursWorked.sizeToFit();
        lblCalculatedHoursWorked.center.x = view.center.x * 1.5;
        mainScrollView.addSubview(lblCalculatedHoursWorked);
        
        //add overtime checkbox
        chkAddOvertime = UICheckBox();
        chkAddOvertime.frame = CGRect(x: padding, y: lblHoursWorked.frame.maxY + padding * 2, width: 20, height: 20);
        chkAddOvertime.setImage(UIImage(named: "checkbox_unchecked"), forState: .Normal);
        chkAddOvertime.addTarget(self, action: "chkAddOvertime:", forControlEvents: .TouchUpInside);
        mainScrollView.addSubview(chkAddOvertime);
        
        //add overtime label
        let lblAddOvertime = UILabel(frame: CGRect(x: chkAddOvertime.frame.maxX + padding, y: chkAddOvertime.frame.origin.y, width: 0, height: 0));
        lblAddOvertime.text = "Add Overtime";
        lblAddOvertime.sizeToFit();
        lblAddOvertime.userInteractionEnabled = true;
        lblAddOvertime.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "addOvertimeLabelClicked:"));
        mainScrollView.addSubview(lblAddOvertime);
        
        //Calculate Salary Button
        btnCalculateSalary = UIButton(type: .Custom);
        btnCalculateSalary.frame = CGRect(x: 0, y: chkAddOvertime.frame.maxY + padding * 2, width: view.frame.width / 1.5, height: 60);
        btnCalculateSalary.center.x = view.center.x;
        btnCalculateSalary.setTitle("Calculate Salary", forState: .Normal);
        btnCalculateSalary.setBackgroundImage(UIImage(named: "button_background"), forState: .Normal);
        btnCalculateSalary.setBackgroundImage(UIImage(named: "highlighted_button_background"), forState: .Highlighted);
        btnCalculateSalary.addTarget(self, action: "btnCalculateSalary:", forControlEvents: .TouchUpInside);
        mainScrollView.addSubview(btnCalculateSalary);
        
        //final salary label
        lblFinalSalary = UILabel(frame: CGRect(x: 0, y: btnCalculateSalary.frame.maxY + padding, width: 0, height: 0));
        lblFinalSalary.text = "The final salary is: ";
        lblFinalSalary.sizeToFit();
        lblFinalSalary.center.x = view.center.x;
        mainScrollView.addSubview(lblFinalSalary);
        
        //calculated final salary label
        lblCalculatedFinalSalary = UILabel(frame: CGRect(x: 0, y: lblFinalSalary.frame.maxY + padding, width: 0, height: 0));
        lblCalculatedFinalSalary.text = "-"
        lblCalculatedFinalSalary.font = UIFont.systemFontOfSize(20);
        lblCalculatedFinalSalary.sizeToFit();
        lblCalculatedFinalSalary.center.x = view.center.x;
        mainScrollView.addSubview(lblCalculatedFinalSalary);
    }
    
    func btnSetStartTime(sender: UIButton){
        //create a date starting at the last startTime chosen or at midnight
        let defaultDate = getChosenOrMidnightDate(startTime);
        
        DatePickerDialog().show("Set Start Time", defaultDate: defaultDate, datePickerMode: .Time) { [weak self](date) -> Void in
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = cal.components([.Hour, .Minute], fromDate: date);
            
            self!.timeChosen(components.hour, minutes: components.minute, clock: &self!.startTime, label: self!.lblChosenStartOfShift, result: self!.showHoursWorked);
        }
    }
    
    func btnSetEndTime(sender: UIButton){
        //create a date starting at the last startTime chosen or at midnight
        let defaultDate = getChosenOrMidnightDate(endTime);
        
        DatePickerDialog().show("Set Start Time", defaultDate: defaultDate, datePickerMode: .Time) { [weak self](date) -> Void in
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!;
            let components = cal.components([.Hour, .Minute], fromDate: date);
            
            self!.timeChosen(components.hour, minutes: components.minute, clock: &self!.endTime, label: self!.lblChosenEndOfShift, result: self!.showHoursWorked);
        }
    }
    
    private func getChosenOrMidnightDate(clock: Clock?) ->NSDate{
        let date = NSDate();
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!;
        let components = cal.components([.Hour, .Minute], fromDate: date);
        if let theClock = clock{
            components.hour = theClock.hour;
            components.minute = theClock.minutes;
        } else{
            components.hour = 0;
            components.minute = 0;
        }
        return cal.dateFromComponents(components)!;
    }
    
    private func timeChosen(hour: Int, minutes: Int, inout clock: Clock?, label: UILabel, result: ()->Void){
        if let theClock = clock{
            theClock.hour = hour;
            theClock.minutes = minutes;
        } else{
            clock = Clock(hour: hour, minutes: minutes);
        }
        label.text = clock!.description();
        label.sizeToFit();
        label.center.x = view.center.x * 1.5;
        
        result();
        
        showOveralTimeWorked();
        clearSalary();
    }
    
    private func showOveralTimeWorked(){
        if startTime != nil && endTime != nil && overtimeStartTime != nil && overtimeEndTime != nil{
            let overallTimeWorked = startTime!.hourAndMinutesDifference(endTime) + overtimeStartTime!.hourAndMinutesDifference(overtimeEndTime);
            
            //consider display format preferrences
            if displayFormat == 0{
                lblCalculatedOverallTimeWorked.text = overallTimeWorked!.description();
            } else{
                lblCalculatedOverallTimeWorked.text = roundToTwoDigitsAfterTheDecimal(overallTimeWorked!.getDecimalValue()) + " h";
            }
            
            lblCalculatedOverallTimeWorked.sizeToFit();
            lblCalculatedOverallTimeWorked.center.x = view.center.x;
        }
    }
    
    private func clearSalary(){
        lblCalculatedFinalSalary.text = "-";
        lblCalculatedFinalSalary.sizeToFit();
        lblCalculatedFinalSalary.center.x = view.center.x;
    }
    
    private func roundToTwoDigitsAfterTheDecimal(number: Double) -> String{
        let roundedNumber = Double(round(100.0 * number) / 100.0);
        let stringNumber = NSString(format: "%.2f", roundedNumber);
        return stringNumber as String;
    }
    
    private func showHoursWorked(){
        if startTime != nil && endTime != nil{
            let hoursWorked = startTime!.hourAndMinutesDifference(endTime!);
            
            //consider display format preferrences
            if displayFormat == 0{
                lblCalculatedHoursWorked.text = hoursWorked!.description();
            } else{
                lblCalculatedHoursWorked.text = roundToTwoDigitsAfterTheDecimal(hoursWorked!.getDecimalValue()) + " h";
            }
            
            lblCalculatedHoursWorked.sizeToFit();
            lblCalculatedHoursWorked.center.x = view.center.x * 1.5;
        }
    }
    
    func chkAddOvertime(sender: UICheckBox){
        if chkAddOvertime.isChecked{
            mainScrollView.addSubview(overtimeView);
            btnCalculateSalary.frame.origin.y = overtimeView.frame.maxY + padding * 2;
            lblFinalSalary.frame.origin.y = btnCalculateSalary.frame.maxY + padding;
            lblCalculatedFinalSalary.frame.origin.y = lblFinalSalary.frame.maxY + padding;
            
            //add preference
            preferences.setBool(true, forKey: SettingsController.kPreferredOvertimeOn);
        } else{
            overtimeView.removeFromSuperview();
            btnCalculateSalary.frame.origin.y = chkAddOvertime.frame.maxY + padding * 2
            lblFinalSalary.frame.origin.y = btnCalculateSalary.frame.maxY + padding;
            lblCalculatedFinalSalary.frame.origin.y = lblFinalSalary.frame.maxY + padding;
            
            //add preference
            preferences.setBool(false, forKey: SettingsController.kPreferredOvertimeOn);
        }
        
        setScrollViewContentSize();
    }
    
    func addOvertimeLabelClicked(sender: UILabel){
        chkAddOvertime.clicked(chkAddOvertime);
        chkAddOvertime(chkAddOvertime);
    }
    
    func btnCalculateSalary(sender: UIButton){
        if startTime === nil || endTime === nil{
            inputMistakeAlert("Please enter a start time and a finishing time");
            return;
        }
        
        let timeWorked = startTime!.hourAndMinutesDifference(endTime!)
        let salaryPerHour = Double(txtRate.text!);
        var payRate:Money;
        if let theSalary  = salaryPerHour{
            payRate = Money(amount: theSalary, currency: currency);
        } else{
            inputMistakeAlert("Invalid salary");
            return;
        }
        
        var overtimeWorked:OverflowClock? = nil;
        var overtimePayRate:Money? = nil;
        var overtimeSalaryPerHour:Double?;
        if chkAddOvertime.isChecked{
            if overtimeStartTime === nil || overtimeEndTime === nil{
                inputMistakeAlert("Please enter the overtime start time and a finishing time");
                return;
            }
            overtimeWorked = overtimeStartTime!.hourAndMinutesDifference(overtimeEndTime!);
            
            overtimeSalaryPerHour = Double(txtOvertimeRate.text!);
            if let theOvertimeSalary = overtimeSalaryPerHour{
                overtimePayRate = Money(amount: theOvertimeSalary, currency: currency);
            } else{
                inputMistakeAlert("Invalid overtime salary");
                return;
            }
        }
        
        let finalSalary = Salary(payRate: payRate, timeWorked: timeWorked, overtimePayRate: overtimePayRate, overtimeWorked: overtimeWorked);
        
        lblCalculatedFinalSalary.text = finalSalary.finalPay!.description();
        lblCalculatedFinalSalary.sizeToFit();
        lblCalculatedFinalSalary.center.x = view.center.x;
        txtRate.resignFirstResponder();
        txtOvertimeRate.resignFirstResponder();
        
    }
    
    private func inputMistakeAlert(message: String){
        let alert:UIAlertController = UIAlertController(title: "Wong Input", message: message, preferredStyle: .Alert);
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil));
        presentViewController(alert, animated: true, completion: nil);
    }
    
    func setScrollViewContentSize(){
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: lblCalculatedFinalSalary.frame.maxY + padding);
    }
    
    func createAddOvertimeLayoutView(){
        overtimeView = UIView();
        createAddOvertimeLayout();
        overtimeView.frame = CGRect(x: 0, y: chkAddOvertime.frame.maxY + padding, width: view.frame.width, height: lblCalculatedOverallTimeWorked.frame.maxY);
    }
    
    func createAddOvertimeLayout(){
        //set overtime start button
        let btnSetOvertimeStart = UIButton(type: .Custom);
        btnSetOvertimeStart.setTitle("Set Overtime Start", forState: .Normal);
        btnSetOvertimeStart.frame = CGRect(x: padding / 3, y: 0, width: view.frame.width / 2 - padding / 5, height: 40);
        btnSetOvertimeStart.setBackgroundImage(UIImage(named: "button_background"), forState: .Normal)
        btnSetOvertimeStart.setBackgroundImage(UIImage(named: "highlighted_button_background"), forState: .Highlighted);
        btnSetOvertimeStart.addTarget(self, action: "btnSetOvertimeStart:", forControlEvents: .TouchUpInside);
        overtimeView.addSubview(btnSetOvertimeStart);
        
        //set overtime end button
        let btnSetOvertimeEnd = UIButton(type: .Custom);
        btnSetOvertimeEnd.setTitle("Set Overtime End", forState: .Normal);
        btnSetOvertimeEnd.frame = CGRect(x: view.frame.width / 2 + padding / 5, y: btnSetOvertimeStart.frame.origin.y, width: view.frame.width / 2 - padding / 3, height: 40);
        btnSetOvertimeEnd.setBackgroundImage(UIImage(named: "button_background"), forState: .Normal);
        btnSetOvertimeEnd.setBackgroundImage(UIImage(named: "highlighted_button_background"), forState: .Highlighted);
        btnSetOvertimeEnd.addTarget(self, action: "btnSetOvertimeEnd:", forControlEvents: .TouchUpInside);
        overtimeView.addSubview(btnSetOvertimeEnd);
        
        //overtime rate input label
        let lblOvertimeRate = UILabel(frame: CGRect(x: padding, y: btnSetOvertimeStart.frame.maxY + padding, width: 0, height: 0));
        lblOvertimeRate.text = "Rate: ";
        lblOvertimeRate.sizeToFit();
        overtimeView.addSubview(lblOvertimeRate);
        
        //overtime rate currency label
        lblOvertimeCurrency = UILabel(frame: CGRect(x: 0, y: lblOvertimeRate.frame.origin.y, width: 0, height: 0));
        lblOvertimeCurrency.text = currency.description();
        lblOvertimeCurrency.sizeToFit();
        lblOvertimeCurrency.frame.origin.x = view.frame.width - lblOvertimeCurrency.frame.width - padding;
        overtimeView.addSubview(lblOvertimeCurrency);
        
        //overtime rate input textField
        txtOvertimeRate = UITextField(frame: CGRect(x: lblOvertimeRate.frame.maxX, y: lblOvertimeRate.frame.origin.y, width: lblOvertimeCurrency.frame.origin.x - lblOvertimeRate.frame.maxX - padding, height: 22));
        txtOvertimeRate.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.03);
        txtOvertimeRate.font = UIFont.systemFontOfSize(16);
        txtOvertimeRate.keyboardType = .DecimalPad;
        txtOvertimeRate.delegate = txtOvertimeRateDelegate;
        overtimeView.addSubview(txtOvertimeRate);
        
        //overtime start label
        let lblOvertimeStart = UILabel(frame: CGRect(x: 0, y: lblOvertimeRate.frame.maxY + padding * 2, width: 0, height: 0));
        lblOvertimeStart.text = "Start of shift:";
        lblOvertimeStart.sizeToFit();
        lblOvertimeStart.center.x = view.center.x / 2;
        overtimeView.addSubview(lblOvertimeStart);
        
        //chosen overtime start label
        lblChosenOvertimeStart = UILabel(frame: CGRect(x: 0, y: lblOvertimeStart.frame.origin.y, width: 0, height: 0));
        lblChosenOvertimeStart.text = "--:--";
        lblChosenOvertimeStart.sizeToFit();
        lblChosenOvertimeStart.center.x = view.center.x * 1.5;
        overtimeView.addSubview(lblChosenOvertimeStart);
        
        //overtime end label
        let lblOvertimeEnd = UILabel(frame: CGRect(x: 0, y: lblOvertimeStart.frame.maxY + padding / 2, width: 0, height: 0));
        lblOvertimeEnd.text = "End of shift:";
        lblOvertimeEnd.sizeToFit();
        lblOvertimeEnd.center.x = view.center.x / 2;
        overtimeView.addSubview(lblOvertimeEnd);
        
        //chosen overtime end label
        lblChosenOvertimeEnd = UILabel(frame: CGRect(x: 0, y: lblOvertimeEnd.frame.origin.y, width: 0, height: 0));
        lblChosenOvertimeEnd.text = "--:--";
        lblChosenOvertimeEnd.sizeToFit();
        lblChosenOvertimeEnd.center.x = view.center.x * 1.5;
        overtimeView.addSubview(lblChosenOvertimeEnd);
        
        //overtime worked label
        let lblOvertimeWorked = UILabel(frame: CGRect(x: 0, y: lblOvertimeEnd.frame.maxY + padding / 2, width: 0, height: 0));
        lblOvertimeWorked.text = "Overtime worked:";
        lblOvertimeWorked.sizeToFit();
        lblOvertimeWorked.center.x = view.center.x / 2;
        overtimeView.addSubview(lblOvertimeWorked);
        
        //calculated ovdertime worked label
        lblCalculatedOvertimeWorked = UILabel(frame: CGRect(x: 0, y: lblOvertimeWorked.frame.origin.y, width: 0, height: 0));
        lblCalculatedOvertimeWorked.text = "-";
        lblCalculatedOvertimeWorked.sizeToFit();
        lblCalculatedOvertimeWorked.center.x = view.center.x * 1.5;
        overtimeView.addSubview(lblCalculatedOvertimeWorked);
        
        //overall time worked label
        let lblOverallTimeWorked = UILabel(frame: CGRect(x: 0, y: lblOvertimeWorked.frame.maxY + padding * 2, width: 0, height: 0));
        lblOverallTimeWorked.text = "Overall Time Worked";
        lblOverallTimeWorked.sizeToFit();
        lblOverallTimeWorked.center.x = view.center.x;
        overtimeView.addSubview(lblOverallTimeWorked);
        
        //calculated overall time worked label
        lblCalculatedOverallTimeWorked = UILabel(frame: CGRect(x: 0, y: lblOverallTimeWorked.frame.maxY + padding, width: 0, height: 0))
        lblCalculatedOverallTimeWorked.text = "-";
        lblCalculatedOverallTimeWorked.font = UIFont.systemFontOfSize(20);
        lblCalculatedOverallTimeWorked.sizeToFit();
        lblCalculatedOverallTimeWorked.center.x = view.center.x;
        overtimeView.addSubview(lblCalculatedOverallTimeWorked);
    }
    
    func btnSetOvertimeStart(sender: UIButton){
        //create a date starting at the last startTime chosen or at midnight
        let defaultDate = getChosenOrMidnightDate(overtimeStartTime);
        
        DatePickerDialog().show("Set Start Time", defaultDate: defaultDate, datePickerMode: .Time) { [weak self](date) -> Void in
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = cal.components([.Hour, .Minute], fromDate: date);
            
            self!.timeChosen(components.hour, minutes: components.minute, clock: &self!.overtimeStartTime, label: self!.lblChosenOvertimeStart, result: self!.showOvertimeWorked);
        }
    }
    
    func btnSetOvertimeEnd(sender: UIButton){
        //create a date starting at the last startTime chosen or at midnight
        let defaultDate = getChosenOrMidnightDate(overtimeEndTime);
        
        DatePickerDialog().show("Set Start Time", defaultDate: defaultDate, datePickerMode: .Time) { [weak self](date) -> Void in
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let components = cal.components([.Hour, .Minute], fromDate: date);
            
            self!.timeChosen(components.hour, minutes: components.minute, clock: &self!.overtimeEndTime, label: self!.lblChosenOvertimeEnd, result: self!.showOvertimeWorked);
        }
    }
    
    private func showOvertimeWorked(){
        if overtimeStartTime != nil && overtimeEndTime != nil{
            let overtimeWorked = overtimeStartTime!.hourAndMinutesDifference(overtimeEndTime!);
            
            //consider display format preferences
            if displayFormat == 0{
                lblCalculatedOvertimeWorked.text = overtimeWorked!.description();
            } else{
                lblCalculatedOvertimeWorked.text = roundToTwoDigitsAfterTheDecimal(overtimeWorked!.getDecimalValue()) + " h";
            }
            
            lblCalculatedOvertimeWorked.sizeToFit();
            lblCalculatedOvertimeWorked.center.x = view.center.x * 1.5;
        }
    }
    
    func setupKeyboard(){
        //setup notifications for for layout changes
        let notificationCenter = NSNotificationCenter.defaultCenter();
        notificationCenter.addObserver(self, selector: "handleKeyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil);
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil);
        
        //setup done button for keyboard
        addDoneButtonToKeyboard();
    }
    
    func handleKeyboardDidShow(notification: NSNotification){
        //get the frame of the keyboard
        let keyboardRectAsObject = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue;
        
        //place it in a CGRect
        var keyboardRect = CGRectZero;
        keyboardRectAsObject.getValue(&keyboardRect);
        
        //change the frame of the scrollView so that it ends right before the keyboard begins
        mainScrollView.frame = CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width, height: view.frame.height - navBar.frame.height - keyboardRect.height);
    }
    
    func handleKeyboardWillHide(sender: NSNotification){
        mainScrollView.frame = defaultScroolViewRect;
    }
    
    func addDoneButtonToKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50));
        doneToolbar.barStyle = .Default;
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("keyboardDoneButtonPressed"));
        
        var items = [UIBarButtonItem]();
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items;
        doneToolbar.sizeToFit()
        
        self.txtRate.inputAccessoryView = doneToolbar
        self.txtOvertimeRate.inputAccessoryView = doneToolbar
        
    }
    
    func keyboardDoneButtonPressed(){
        btnCalculateSalary(btnCalculateSalary);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

