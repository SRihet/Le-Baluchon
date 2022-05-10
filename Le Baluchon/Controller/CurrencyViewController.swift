//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 04/02/2022.
//

import UIKit

class CurrencyViewController: UIViewController,UITextViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var userRateButton: UIButton!
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var resultRateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRowUserRate = MyCurrency.myCurrency
    var selectedRowResultRate = MyCurrency.myTravelCurrency
    var textViewTimer: Timer?
    var resultForReverse = ""
    var placeHolderText = "Saisir un montant"
    
    // MARK: - PickerView elements
   

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.delegate = self
        userText.text = placeHolderText
        userText.textColor = UIColor.lightGray
        userText.layer.cornerRadius = 10
        resultText.layer.cornerRadius = 10
        
        userRateButton.setTitle(CurrencyService.arrayRates[selectedRowUserRate].currencys, for: .normal)
        userRateButton.layer.cornerRadius = 5
        resultRateButton.setTitle(CurrencyService.arrayRates[selectedRowResultRate].currencys, for: .normal)
        resultRateButton.layer.cornerRadius = 5
        activityIndicator.isHidden = true
        
    }
    
    // MARK: - IBAction
    @IBAction func onClearPressed(_ sender: Any) {
        userText.text = placeHolderText
        userText.textColor = UIColor.lightGray
        resultText.text  = ""
        resultForReverse = ""
        clearButton.isEnabled = false
    }
    
    @IBAction func ChangeCurrency(_ sender: UIButton) {
        ShowPickerView(senderTag: sender.tag)
    }
    
    @IBAction func reverseRate(_ sender: Any) {
        let selectedRowUser = selectedRowResultRate
        let selectedRowResult = selectedRowUserRate
        
        self.userRateButton.setTitle(CurrencyService.arrayRates[selectedRowUser].currencys, for: .normal)
        self.resultRateButton.setTitle(CurrencyService.arrayRates[selectedRowResult].currencys, for: .normal)
        
        self.selectedRowUserRate = selectedRowUser
        self.selectedRowResultRate = selectedRowResult
        
        self.userText.text = resultForReverse
        self.resultText.text = ""
        
        self.typingStopped()
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
            resultText.text = ""
        }else {
            getCurrency()
        }
    }
    
    // MARK: - Request API
    private func getCurrency(){
        activityIndicator.isHidden = false
        
        NetWorker.shared.query(API: .currency, input: "") { (success, currency) in
            if success, let currency = currency as? CurrencyModel {
                self.activityIndicator.isHidden = true
                CurrencyService.arrayRates[0].rates = currency.rates.USD
                CurrencyService.arrayRates[1].rates = currency.rates.JPY
                CurrencyService.arrayRates[2].rates = currency.rates.CAD
                CurrencyService.arrayRates[3].rates = currency.rates.AUD
                CurrencyService.arrayRates[4].rates = currency.rates.CHF
                CurrencyService.arrayRates[5].rates = currency.rates.DKK
                CurrencyService.arrayRates[6].rates = currency.rates.CNY
                CurrencyService.arrayRates[7].rates = currency.rates.IDR
                CurrencyService.arrayRates[8].rates = currency.rates.GBP
                CurrencyService.arrayRates[9].rates = currency.rates.BGN
                CurrencyService.arrayRates[10].rates = currency.rates.HUF
                CurrencyService.arrayRates[11].rates = currency.rates.ISK
                CurrencyService.arrayRates[12].rates = currency.rates.NOK
                CurrencyService.arrayRates[13].rates = currency.rates.HRK
                CurrencyService.arrayRates[14].rates = currency.rates.RUB
                CurrencyService.arrayRates[15].rates = currency.rates.SEK
                CurrencyService.arrayRates[16].rates = currency.rates.UAH
                CurrencyService.arrayRates[17].rates = currency.rates.CZK
                CurrencyService.arrayRates[18].rates = currency.rates.EUR
                self.convert(amount: self.userText.text!, userRateIndex: self.selectedRowUserRate, resultRateIndex: self.selectedRowResultRate)
            } else {
                self.activityIndicator.isHidden = true
                self.presentAlert(alert: LeBaluchonAlertVC.currencyErrorNetwork)
            }
        }
    }
    
    // MARK: - setUp UI with response
    private func convert(amount: String, userRateIndex: Int, resultRateIndex: Int) {
        guard let amountDouble = amount.toDouble()  else {
            presentAlert(alert: LeBaluchonAlertVC.currencyInputInvalid)
            userText.text = ""
            return
        }
        let departureRate: Double = CurrencyService.arrayRates[userRateIndex].rates
        let finalRate: Double = CurrencyService.arrayRates[resultRateIndex].rates
        
        let result = (amountDouble/departureRate)*finalRate
        self.resultForReverse = result.toString()
        
        self.resultText.text = result.toString() + CurrencyService.arrayRates[resultRateIndex].symbols

        
    }

}

extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        let pickerAlert = UIAlertController(title: "Choisissez une devise", message: "", preferredStyle: .actionSheet)
        
        switch senderTag{
        case 1:
            pickerView.selectRow(selectedRowUserRate, inComponent: 0, animated: true)
            pickerAlert.popoverPresentationController?.sourceView = userRateButton
            pickerAlert.popoverPresentationController?.sourceRect = userRateButton.bounds
            
            pickerAlert.addAction(UIAlertAction(title: "Sélectionner", style: .default, handler: { (UIAlertAction) in
                self.selectedRowUserRate = pickerView.selectedRow(inComponent: 0)
                let selected = Array(CurrencyService.arrayRates)[self.selectedRowUserRate].currencys
                self.userRateButton.setTitle(selected, for: .normal)
                self.typingStopped()
            }))
        case 2:
            pickerView.selectRow(selectedRowResultRate, inComponent: 0, animated: true)
            pickerAlert.popoverPresentationController?.sourceView = resultRateButton
            pickerAlert.popoverPresentationController?.sourceRect = resultRateButton.bounds
            
            pickerAlert.addAction(UIAlertAction(title: "Sélectionner", style: .default, handler: { (UIAlertAction) in
                self.selectedRowResultRate = pickerView.selectedRow(inComponent: 0)
                let selected = Array(CurrencyService.arrayRates)[self.selectedRowResultRate].currencys
                self.resultRateButton.setTitle(selected, for: .normal)
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
        CurrencyService.arrayRates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrencyService.arrayRates[row].currencys
    }
}
