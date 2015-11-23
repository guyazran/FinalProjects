//
//  SettingsController.swift
//  Salary Tracker
//
//  Created by Guy Azran on 11/21/15.
//  Copyright © 2015 Guy Azran. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //constants
    static let kPreferredCurrency = "Preferred Currency";
    static let kPreferredOverallTimeDisplayFormat = "Preferred Overall Time Display Format";
    static let kPreferredOvertimeOn = "Preferred Overtime On";
    
    //navigation bar
    var navBar:UINavigationBar!;
    
    //options layout
    var pckCurrency:UIPickerView!;
    var pckOverallTimeDisplayFormat:UIPickerView!;
    
    //layout parameters
    let padding:CGFloat = 5;
    
    //preferences and keys
    let preferences = NSUserDefaults.standardUserDefaults();
    let preferredCurrency = kPreferredCurrency;
    let preferredOverallTimeDispalyFormat = kPreferredOverallTimeDisplayFormat;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.backgroundColor = UIColor.whiteColor();
        
        createNavBar();
        createOptionsLayout();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        //load preferred currency
        let currency = preferences.integerForKey(preferredCurrency);
        pckCurrency.selectRow(currency, inComponent: 0, animated: false);
        
        //load preferred overall time display format
        let overallTimeDisplayFormat = preferences.integerForKey(preferredOverallTimeDispalyFormat);
        pckOverallTimeDisplayFormat.selectRow(overallTimeDisplayFormat, inComponent: 0, animated: false);
    }
    
    func createNavBar(){
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64));
        let navItem = UINavigationItem();
        navItem.title = "Settings";
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneChangingSettings:");
        navBar.items = [navItem];
        view.addSubview(navBar);
    }
    
    func doneChangingSettings(sender: UIBarButtonItem){
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func createOptionsLayout(){
        //currency picker
        pckCurrency = UIPickerView(frame: CGRect(x: 0, y: navBar.frame.maxY + padding, width: view.frame.width / 2, height: 90));
        pckCurrency.frame.origin.x = view.frame.width - pckCurrency.frame.width - padding;
        pckCurrency.dataSource = self;
        pckCurrency.delegate = self;
        view.addSubview(pckCurrency);
        
        //choose currency label
        let lblChooseCurrency = UILabel(frame: CGRect(x: padding, y: 0, width: view.frame.width / 2 - padding, height: 30));
        lblChooseCurrency.center.y = pckCurrency.center.y;
        lblChooseCurrency.text = "Currency";
        view.addSubview(lblChooseCurrency);
        
        //overall time display format picker
        pckOverallTimeDisplayFormat = UIPickerView(frame: CGRect(x: 0, y: pckCurrency.frame.maxY + padding * 2, width: view.frame.width / 2, height: 90));
        pckOverallTimeDisplayFormat.frame.origin.x = view.frame.width - pckOverallTimeDisplayFormat.frame.width - padding;
        pckOverallTimeDisplayFormat.dataSource = self;
        pckOverallTimeDisplayFormat.delegate = self;
        view.addSubview(pckOverallTimeDisplayFormat);
        
        //choose overall time display format label
        let lblChooseOverallTimeDisplayFormat = UILabel(frame: CGRect(x: padding, y: 0, width: view.frame.width / 2 - padding, height: 60));
        lblChooseOverallTimeDisplayFormat.center.y = pckOverallTimeDisplayFormat.center.y;
        lblChooseOverallTimeDisplayFormat.numberOfLines = 2;
        lblChooseOverallTimeDisplayFormat.text = "Overall Time Display Format";
        lblChooseOverallTimeDisplayFormat.lineBreakMode = .ByWordWrapping;
        view.addSubview(lblChooseOverallTimeDisplayFormat);
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === pckCurrency{
            return Currency.values().count;
        }
        if pickerView === pckOverallTimeDisplayFormat{
            return 2;
        }
        return 0;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === pckCurrency{
            let currencies = Currency.values();
            return currencies[row].rawValue;
        }
        if pickerView === pckOverallTimeDisplayFormat{
            switch row{
            case 0:
                return "Clock (6:30)";
            case 1:
                return "Decimal (6.5 h)";
            default:
                return "";
            }
        }
        return "";
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === pckCurrency{
            preferences.setInteger(row, forKey: preferredCurrency);
        } else if pickerView === pckOverallTimeDisplayFormat{
            preferences.setInteger(row, forKey: preferredOverallTimeDispalyFormat);
        }
    }
}