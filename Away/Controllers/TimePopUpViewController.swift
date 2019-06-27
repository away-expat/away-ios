//
//  TimePopUpViewController.swift
//  Away
//
//  Created by Candice Guitton on 26/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class TimePopUpViewController: UIViewController {
    var timeDelegate: ChooseTimeDelegate?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Selectionner"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = UIDatePicker.Mode.time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        let selectedTime = timeFormatter.string(from: timePicker.date)
        timePicker.backgroundColor = .white
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return timePicker
    }()
    let saveButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
        return button
    }()
    let popup : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppLightGrey")
        view.addSubview(popup)
        popup.addSubview(label)
        popup.addSubview(timePicker)
        popup.addSubview(saveButton)
        
        popup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popup.heightAnchor.constraint(equalToConstant: timePicker.frame.height + 100).isActive = true
        popup.widthAnchor.constraint(equalToConstant: timePicker.frame.width).isActive = true
        
        label.topAnchor.constraint(equalTo: popup.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: popup.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: popup.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timePicker.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        timePicker.centerYAnchor.constraint(equalTo: popup.centerYAnchor).isActive = true
        
        saveButton.bottomAnchor.constraint(equalTo: popup.bottomAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: popup.leadingAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: popup.trailingAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    @objc func saveEvent() {
        let timeFormatter: DateFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let selectedTime: String = timeFormatter.string(from: timePicker.date)
        timeDelegate?.saveTime(time: selectedTime)
        dismiss(animated: true)
    }
    
    
}
protocol ChooseTimeDelegate {
    func saveTime(time: String)
}
