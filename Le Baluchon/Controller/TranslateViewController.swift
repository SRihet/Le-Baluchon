//
//  ViewController.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 02/02/2022.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    var desiredLanguage: String = "en"
    var motherLanguage: String = "fr"
    
    @IBOutlet weak var motherLanguageButton: UIButton!
    
    @IBOutlet weak var desiredLanguageButton: UIButton!
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRowMotherLang = 0
    var selectedRowdesiredLang = 1
    
    var textViewTimer: Timer?
    var dictionaryLanguages =
    [
        "Anglais" : "en",
        "Français" : "fr",
        "Italien" : "it",
        "Espagnol" : "es",
        "Néerlandais" : "nl",
        "Indonésien" : "id",
        "Bulgare" : "bg",
        "Croate" : "hr",
        "Danois" : "da",
        "Grec" : "el",
        "Hongrois" : "hu",
        "Islandais" : "is",
        "Norvégien" : "no",
        "Polonais" : "pl",
        "Portugais" : "pt",
        "Russe" : "ru",
        "Suèdois" : "sv",
        "Ukrainien" : "uk",
        "Tchèque" : "cs",
        "Ouïgour" : "ug",
        "Gallois" : "cy",
        "Allemand" : "de"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.delegate = self
        self.desiredLanguageButton.setTitle(dictionaryLanguages.someKey(forValue: desiredLanguage), for: .normal)
        self.motherLanguageButton.setTitle(dictionaryLanguages.someKey(forValue: motherLanguage), for: .normal)
        
        userText.text = "Placeholder text goes right here..."
        userText.textColor = UIColor.lightGray
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func popUpPickerView(_ sender: UIButton) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        switch sender.tag {
        case 1:
            pickerView.selectRow(selectedRowMotherLang, inComponent: 0, animated: true)
        case 2:
            pickerView.selectRow(selectedRowdesiredLang, inComponent: 0, animated: true)
            
        default:
            break
        }
        
        
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select your Language", message: "", preferredStyle: .actionSheet)
        
        if sender.tag == 1 {
            alert.popoverPresentationController?.sourceView = motherLanguageButton
            alert.popoverPresentationController?.sourceRect = motherLanguageButton.bounds
            
            alert.setValue(vc, forKey: "contentViewController")
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            }))
            
            alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
                self.selectedRowMotherLang = pickerView.selectedRow(inComponent: 0)
                let selected = Array(self.dictionaryLanguages)[self.selectedRowMotherLang]
                self.motherLanguage = selected.value
                let name = selected.key
                self.motherLanguageButton.setTitle(name, for: .normal)
                self.typingStopped()
            }))
        }
        
        if sender.tag == 2 {
            alert.popoverPresentationController?.sourceView = desiredLanguageButton
            alert.popoverPresentationController?.sourceRect = desiredLanguageButton.bounds
            
            alert.setValue(vc, forKey: "contentViewController")
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            }))
            
            alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
                self.selectedRowdesiredLang = pickerView.selectedRow(inComponent: 0)
                let selected = Array(self.dictionaryLanguages)[self.selectedRowdesiredLang]
                self.desiredLanguage = selected.value
                let name = selected.key
                self.desiredLanguageButton.setTitle(name, for: .normal)
                self.typingStopped()
            }))
        }
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reverseLanguage(_ sender: Any) {
        let desiredLang = motherLanguage
        let motherLang = desiredLanguage
        
        
        self.desiredLanguageButton.setTitle(dictionaryLanguages.someKey(forValue: desiredLang), for: .normal)
        self.motherLanguageButton.setTitle(dictionaryLanguages.someKey(forValue: motherLang), for: .normal)
        
        self.desiredLanguage = desiredLang
        self.motherLanguage = motherLang
        
        self.userText.text = translatedText.text
        self.translatedText.text = ""
        
        self.typingStopped()
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        textViewTimer?.invalidate()
        textViewTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(typingStopped), userInfo: nil, repeats: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if userText.textColor == UIColor.lightGray {
            userText.text = ""
            userText.textColor = UIColor.black
        }
    }
    
    
    @objc func typingStopped() {
        
        NetWorker.shared.query(API: .translate, input: createParameters()) { (success, translate) in
            if success, let translate = translate as? String {
                self.update(translate: translate)
            } else {
                self.presentAlert()
            }
        }
    }
    
    
    private func createParameters() -> String {
        let text: String = userText.text
        let source = motherLanguage
        let target = desiredLanguage
        
        let completeParameters = TranslationAPI.source + source + TranslationAPI.target + target + TranslationAPI.text + text
        
        return completeParameters
    }
    private func update(translate: String) {
        translatedText.text = translate
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The translation failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(dictionaryLanguages)[row].key
        label.sizeToFit()
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        dictionaryLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 40
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
