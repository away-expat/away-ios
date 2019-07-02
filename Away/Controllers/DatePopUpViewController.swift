//
//  DatePopUpViewController.swift
//  Away
//
//  Created by Candice Guitton on 25/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class DatePopUpViewController: UIViewController {
    var dateDelegate: ChooseDateDelegate?

    let label: UILabel = {
        let label = UILabel()
        label.text = "Selectionner"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMMM dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = .white
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        return datePicker
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
        popup.addSubview(datePicker)
        popup.addSubview(saveButton)
        
        popup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popup.heightAnchor.constraint(equalToConstant: datePicker.frame.height + 100).isActive = true
        popup.widthAnchor.constraint(equalToConstant: datePicker.frame.width).isActive = true

        label.topAnchor.constraint(equalTo: popup.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: popup.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: popup.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        datePicker.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: popup.centerYAnchor).isActive = true

        saveButton.bottomAnchor.constraint(equalTo: popup.bottomAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: popup.leadingAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: popup.trailingAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    @objc func saveEvent() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        dateDelegate?.saveDate(date: selectedDate)
        dismiss(animated: true)
    }
    
    func setMinimumDate(date: Date = Calendar.current.date(byAdding: .day, value: +1, to: Date())!) {
        datePicker.minimumDate = date

    }
}
protocol ChooseDateDelegate {
    func saveDate(date: String)
}
