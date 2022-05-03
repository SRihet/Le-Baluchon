//
//  ViewController.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 02/02/2022.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var motherLanguageButton: UIButton!
    @IBOutlet weak var desiredLanguageButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRowMotherLang = MyLanguages.myLanguages
    var selectedRowdesiredLang = MyLanguages.myTravelLanguages
    var textViewTimer: Timer?
    var placeHolderText = "Saisir votre texte"
    
    // MARK: - PickerView elements
    var sourceLanguages: [(langs:String,sources:String)] =
    [
        ("Anglais","en"),
        ("Français","fr"),
        ("Italien","it"),
        ("Espagnol","es"),
        ("Néerlandais","nl"),
        ("Indonésien","id"),
        ("Bulgare","bg"),
        ("Croate","hr"),
        ("Danois","da"),
        ("Grec","el"),
        ("Hongrois","hu"),
        ("Islandais","is"),
        ("Norvégien","no"),
        ("Polonais","pl"),
        ("Portugais","pt"),
        ("Russe","ru"),
        ("Suèdois","sv"),
        ("Ukrainien","uk"),
        ("Tchèque","cs"),
        ("Ouïgour","ug"),
        ("Gallois","cy"),
        ("Allemand","de")
    ]
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.delegate = self
        userText.text = placeHolderText
        userText.textColor = UIColor.lightGray
        userText.layer.cornerRadius = 10
        translatedText.layer.cornerRadius = 10
        desiredLanguageButton.setTitle(sourceLanguages[selectedRowdesiredLang].langs, for: .normal)
        desiredLanguageButton.layer.cornerRadius = 5
        motherLanguageButton.setTitle(sourceLanguages[selectedRowMotherLang].langs, for: .normal)
        motherLanguageButton.layer.cornerRadius = 5
        activityIndicator.isHidden = true
        
    }
    
    // MARK: - IBAction
    @IBAction func ChangeLanguage(_ sender: UIButton) {
        ShowPickerView(senderTag: sender.tag)
    }
    
    @IBAction func reverseLanguage(_ sender: Any) {
        let desiredLang = selectedRowMotherLang
        let motherLang = selectedRowdesiredLang

        self.desiredLanguageButton.setTitle(sourceLanguages[desiredLang].langs, for: .normal)
        self.motherLanguageButton.setTitle(sourceLanguages[motherLang].langs, for: .normal)

        self.selectedRowdesiredLang = desiredLang
        self.selectedRowMotherLang = motherLang

        self.userText.text = translatedText.text
        self.translatedText.text = ""

        self.typingStopped()
        
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        userText.text = placeHolderText
        userText.textColor = UIColor.lightGray
        translatedText.text  = ""
        clearButton.isEnabled = false
    }
    
    // MARK: - TextView
    func textViewDidChange(_ textView: UITextView) {
        clearButton.isEnabled = !textView.text.isEmpty
        textViewTimer?.invalidate()
        textViewTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(typingStopped), userInfo: nil, repeats: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if userText.textColor == UIColor.lightGray {
            userText.text = ""
            clearButton.isEnabled = true
            userText.textColor = UIColor.white
        }
    }
    
    @objc func typingStopped() {
        if userText.text == "" || userText.text == placeHolderText {
            translatedText.text = ""
        }else {
            getTranslate()
        }
    }
    
    // MARK: - Request API
    private func getTranslate() {
        
        activityIndicator.isHidden = false
        
        NetWorker.shared.query(API: .translate, input: createParameters()) { (success, translate) in
            if success, let translate = translate as? TranslateModel? {
                self.activityIndicator.isHidden = true
                self.update(translate: (translate?.data.translations[1].translatedText)!)
            } else {
                self.activityIndicator.isHidden = true
                self.presentAlert(alert: LeBaluchonAlertVC.translateErrorNetwork)
            }
        }
    }
    
    
    private func createParameters() -> String {
        let text: String = userText.text
        let source = sourceLanguages[selectedRowMotherLang].sources
        let target = sourceLanguages[selectedRowdesiredLang].sources
        
        let completeParameters = TranslationAPI.source + source + TranslationAPI.target + target + TranslationAPI.text + text
        
        return completeParameters
    }
    
    // MARK: - setUp UI with response
    private func update(translate: String) {
        translatedText.text = translate
    }
}

extension TranslateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - PickerView Components
    func ShowPickerView(senderTag: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let pickerAlert = UIAlertController(title: "Choisissez une langue", message: "", preferredStyle: .actionSheet)
        
        switch senderTag {
        case 1:
            pickerView.selectRow(selectedRowMotherLang, inComponent: 0, animated: true)
            pickerAlert.popoverPresentationController?.sourceView = motherLanguageButton
            pickerAlert.popoverPresentationController?.sourceRect = motherLanguageButton.bounds
            
            pickerAlert.addAction(UIAlertAction(title: "Sélectionner", style: .default, handler: { (UIAlertAction) in
                self.selectedRowMotherLang = pickerView.selectedRow(inComponent: 0)
                let selected = Array(self.sourceLanguages)[self.selectedRowMotherLang].langs
                self.motherLanguageButton.setTitle(selected, for: .normal)
                self.typingStopped()
            }))
        case 2:
            pickerView.selectRow(selectedRowdesiredLang, inComponent: 0, animated: true)
            pickerAlert.popoverPresentationController?.sourceView = desiredLanguageButton
            pickerAlert.popoverPresentationController?.sourceRect = desiredLanguageButton.bounds
            
            pickerAlert.addAction(UIAlertAction(title: "Sélectionner", style: .default, handler: { (UIAlertAction) in
                self.selectedRowdesiredLang = pickerView.selectedRow(inComponent: 0)
                let selected = Array(self.sourceLanguages)[self.selectedRowdesiredLang].langs
                self.desiredLanguageButton.setTitle(selected, for: .normal)
                self.typingStopped()
            }))
            
        default:
            break
        }
        pickerAlert.setValue(vc, forKey: "contentViewController")
        pickerAlert.addAction(UIAlertAction(title: "Annuler", style: .default, handler: { (UIAlertAction) in
        }))
        self.present(pickerAlert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        sourceLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sourceLanguages[row].langs
    }
}
