//
//  AddActivityViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
class CreateEventViewController: UIViewController, ChooseDateDelegate, ChooseTimeDelegate, SelectActivityDelegate{
   
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
        sv.spacing = 10
        sv.alignment = .center
        return sv
    }()
    let stackViewTitle: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Titre : "
        return label
    }()
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "de l'évènement"
        return tf
    }()
    
    let stackViewDescription: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Description : "
        return label
    }()
    let descriptionTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "de l'évènement"
        return tf
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
        //tf.allowsEditingTextAttributes = false
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

        stackView.addArrangedSubview(stackViewDescription)
        
        stackViewDescription.addArrangedSubview(descriptionLabel)
        stackViewDescription.addArrangedSubview(descriptionTextField)

        stackView.addArrangedSubview(stackViewDatePicker)
        
        stackViewDatePicker.addArrangedSubview(dateLabel)
        stackViewDatePicker.addArrangedSubview(dateTextField)

        stackView.addArrangedSubview(stackViewTimePicker)

        stackViewTimePicker.addArrangedSubview(timeLabel)
        stackViewTimePicker.addArrangedSubview(timeTextField)

        stackView.addArrangedSubview(selectActivity)
        stackView.addArrangedSubview(saveEventButton)
        selectActivity.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 60).isActive = true
        selectActivity.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -60).isActive = true
        saveEventButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20).isActive = true
        saveEventButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        
    }
    @objc func datePickerPopup(_ sender: UITextField) {
        let datePopupViewController = DatePopUpViewController()
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
                    //eventDetailsController.event = response
                    self.present(eventDetailsController, animated: true)
                }
            }
            
        })
    }
}
