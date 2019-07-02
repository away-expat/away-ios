//
//  AddActivityViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
class CreateEventViewController: UIViewController, ChooseDateDelegate, ChooseTimeDelegate, SelectActivityDelegate, UITextViewDelegate{
   
    var activity: Activity?
    var activitySelected: Bool = false
    let eventService = EventService()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .equalSpacing
        return sv
    }()
    let stackViewTitle: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Titre : "
        return label
    }()
    let titleTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let lineTitle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "AppLightOrange")
        return view
    }()
    let stackViewDescription: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Description : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextField: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        return textView
    }()
    
    let lineDescription: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "AppLightOrange")
        return view
    }()
    let stackViewDatePicker: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Date : "
        return label
    }()
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "de l'évènement"
        tf.addTarget(self, action: #selector(datePickerPopup(_:)), for: .allTouchEvents)
        return tf
    }()
    
    let stackViewTimePicker: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "Horaire : "
        return label
    }()
    let timeTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "de l'évènement"
        tf.addTarget(self, action: #selector(timePickerPopup(_:)), for: .allTouchEvents)
        return tf
    }()
   
    let selectActivity : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.layer.cornerRadius = 15.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        button.setTitle("Select Activity", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(searchActivity), for: .touchUpInside)
        return button
    }()

    let saveEventButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.layer.cornerRadius = 15.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        button.setTitle("Save Event", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Event"
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        setupViews()
    }
   
    func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(stackViewTitle)
        stackViewTitle.addArrangedSubview(titleLabel)
        stackViewTitle.addArrangedSubview(titleTextField)
        stackView.addSubview(lineTitle)
        lineTitle.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        lineTitle.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        lineTitle.topAnchor.constraint(equalTo: stackViewTitle.bottomAnchor, constant: 15).isActive = true

        stackView.addArrangedSubview(stackViewDescription)
        stackViewDescription.addArrangedSubview(descriptionLabel)
        stackViewDescription.addArrangedSubview(descriptionTextField)

        
        descriptionTextField.delegate = self
        descriptionTextField.isScrollEnabled = true
        stackView.addSubview(lineDescription)
        lineDescription.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineDescription.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        lineDescription.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        lineDescription.topAnchor.constraint(equalTo: stackViewDescription.bottomAnchor, constant: 15).isActive = true

        stackView.addArrangedSubview(stackViewDatePicker)
        
        stackViewDatePicker.addArrangedSubview(dateLabel)

        stackViewDatePicker.addArrangedSubview(dateTextField)

        stackView.addArrangedSubview(stackViewTimePicker)

        stackViewTimePicker.addArrangedSubview(timeLabel)

        stackViewTimePicker.addArrangedSubview(timeTextField)

        stackView.addArrangedSubview(selectActivity)
        stackView.addArrangedSubview(saveEventButton)
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        
        selectActivity.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        selectActivity.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        saveEventButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        saveEventButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
    }
    
   
    
    @objc func datePickerPopup(_ sender: UITextField) {
        let datePopupViewController = DatePopUpViewController()
        datePopupViewController.setMinimumDate()
        datePopupViewController.dateDelegate = self
        present(datePopupViewController, animated: true)
    }
    func saveDate(date: String) {
        dateTextField.text = date
    }
    func saveTime(time: String) {
        timeTextField.text = time
    }
    @objc func timePickerPopup(_ sender: UITextField) {
        let timePopupViewController = TimePopUpViewController()
        timePopupViewController.timeDelegate = self
        present(timePopupViewController, animated: true)
    }
    
    func onActivitySelected(activity: Activity) {
        self.activity = activity
        activitySelected = true
    }
    
    @objc func searchActivity() {
        let selectActivityViewController = SelectActivityViewController()
        selectActivityViewController.activityDelegate = self
        present(selectActivityViewController, animated: true)
    }
    
    @objc func saveEvent() {
        saveEventService()
        print("save event")
    }

    func saveEventService() {
        if titleTextField.text == nil{
            print("titre vide")
        }
        if descriptionTextField.text == nil{
            print("description vide")
        }
        if dateTextField.text == nil{
            print("pas de date")
        }
        if timeTextField.text == nil{
            print("pas d'heure")
        }
        if !activitySelected && activity == nil
        {
            print("pas d'activity")
        }
       
        eventService.createEvent(token: token!, title: titleTextField.text!, description: descriptionTextField.text!, date: dateTextField.text!, time: timeTextField.text!, activity: activity!.id!, completion: { response , error in
            if error != nil {
                print ("create event error:", error!)
            } else {
                DispatchQueue.main.async{
                    let eventDetailsController = EventDetailsController()
                    eventDetailsController.eventId = response?.event.id
                    self.navigationController?.pushViewController(eventDetailsController, animated: true)
                }
            }
            
        })
        titleTextField.text = ""
        descriptionTextField.text = ""
        dateTextField.text = ""
        timeTextField.text = ""
        activity = nil
        
    }
}
