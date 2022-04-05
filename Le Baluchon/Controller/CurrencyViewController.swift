//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 04/02/2022.
//

import UIKit

class CurrencyViewController: UIViewController,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userTextField: UITextView!
    
    @IBOutlet weak var userRateButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultRateButton: UIButton!

    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRowUserRate = 18
    var selectedRowResultRate = 0
    var textViewTimer: Timer?

    
    var arrayRates: [(currencys:String,rates:Double)] =
    [
        ("Dollar américain $",1.091894),
        ("Yen ¥",134.873433),
        ("Dollar canadien $",1.360822),
        ("Dollar australien $",1.438722),
        ("Franc suisse Fr",1.014751),
        ("Couronne danoise kr",7.437805),
        ("Yuan 元",6.948593),
        ("Roupie indonésienne Rp",15678.009386),
        ("Livre sterling £",0.833612),
        ("Lev bulgare лв",1.951028),
        ("Forint Ft",375.110234),
        ("Couronne islandaise kr",140.810215),
        ("Couronne norvégienne kr",9.541245),
        ("Kuna croate kn",7.541822),
        ("Rouble russe ₽",91.17143),
        ("Couronne suédoise",10.28495),
        ("Hryvnia ₴",32.09571),
        ("Couronne tchèque Kč",24.356219),
        ("Euro €",1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        userTextField.text = "1"
        userRateButton.setTitle(arrayRates[selectedRowUserRate].currencys, for: .normal)
        resultRateButton.setTitle(arrayRates[selectedRowResultRate].currencys, for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        typingStopped()
    }
    
    @IBAction func popUpPickerView(_ sender: UIButton) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        switch sender.tag {
        case 1:
            pickerView.selectRow(selectedRowUserRate, inComponent: 0, animated: true)
        case 2:
            pickerView.selectRow(selectedRowResultRate, inComponent: 0, animated: true)
            
        default:
            break
    }
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select your Currency", message: "", preferredStyle: .actionSheet)
        
        if sender.tag == 1 {
            alert.popoverPresentationController?.sourceView = userRateButton
            alert.popoverPresentationController?.sourceRect = userRateButton.bounds
            
            alert.setValue(vc, forKey: "contentViewController")
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            }))
            
            alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
                self.selectedRowUserRate = pickerView.selectedRow(inComponent: 0)
                let selected = Array(self.arrayRates)[self.selectedRowUserRate].currencys
                self.userRateButton.setTitle(selected, for: .normal)
                self.typingStopped()
            }))
        }
        
        if sender.tag == 2 {
            alert.popoverPresentationController?.sourceView = resultRateButton
            alert.popoverPresentationController?.sourceRect = resultRateButton.bounds
            
            alert.setValue(vc, forKey: "contentViewController")
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            }))
            
            alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
                self.selectedRowResultRate = pickerView.selectedRow(inComponent: 0)
                let selected = Array(self.arrayRates)[self.selectedRowResultRate].currencys
                self.resultRateButton.setTitle(selected, for: .normal)
                self.typingStopped()
            }))
        }
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reverseRate(_ sender: Any) {
        let selectedRowUser = selectedRowResultRate
        let selectedRowResult = selectedRowUserRate
        
        self.userRateButton.setTitle(arrayRates[selectedRowUser].currencys, for: .normal)
        self.resultRateButton.setTitle(arrayRates[selectedRowResult].currencys, for: .normal)
        
        self.selectedRowUserRate = selectedRowUser
        self.selectedRowResultRate = selectedRowResult
        
        self.userTextField.text = resultLabel.text
        self.resultLabel.text = ""
        
        self.typingStopped()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        textViewTimer?.invalidate()
        textViewTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(typingStopped), userInfo: nil, repeats: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if userTextField.textColor == UIColor.lightGray {
            userTextField.text = ""
            userTextField.textColor = UIColor.black
        }
    }
    
    @objc func typingStopped() {
        
        NetWorker.shared.query(API: .currency, input: "") { (success, currency) in
            if success, let currency = currency as? CurrencyModel {
                self.arrayRates[0].rates = currency.rates.USD
                self.arrayRates[1].rates = currency.rates.JPY
                self.arrayRates[2].rates = currency.rates.CAD
                self.arrayRates[3].rates = currency.rates.AUD
                self.arrayRates[4].rates = currency.rates.CHF
                self.arrayRates[5].rates = currency.rates.DKK
                self.arrayRates[6].rates = currency.rates.CNY
                self.arrayRates[7].rates = currency.rates.IDR
                self.arrayRates[8].rates = currency.rates.GBP
                self.arrayRates[9].rates = currency.rates.BGN
                self.arrayRates[10].rates = currency.rates.HUF
                self.arrayRates[11].rates = currency.rates.ISK
                self.arrayRates[12].rates = currency.rates.NOK
                self.arrayRates[13].rates = currency.rates.HRK
                self.arrayRates[14].rates = currency.rates.RUB
                self.arrayRates[15].rates = currency.rates.SEK
                self.arrayRates[16].rates = currency.rates.UAH
                self.arrayRates[17].rates = currency.rates.CZK
                self.arrayRates[18].rates = currency.rates.EUR
                self.convert(amount: self.userTextField.text!, userRateIndex: self.selectedRowUserRate, resultRateIndex: self.selectedRowResultRate)
            } else {
                self.presentAlert()
            }
        }
    }
    
    
    private func convert(amount: String, userRateIndex: Int, resultRateIndex: Int) {
        let amountDouble = stringToDouble(textToTransform: amount)
        let departureRate: Double = arrayRates[userRateIndex].rates
        let finalRate: Double = arrayRates[resultRateIndex].rates
        
        let result = (amountDouble/departureRate)*finalRate
        
        self.resultLabel.text = doubleToString(currentDouble: result)

        
    }
    
    private func doubleToString(currentDouble: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        let doubleAsString =  formatter.string(from: NSNumber(value: currentDouble))!
        return doubleAsString
    }
    
    func stringToDouble(textToTransform: String) -> Double {
        let formatter = NumberFormatter()
        
        if textToTransform.firstIndex(of: ",") != nil {
            formatter.decimalSeparator = ","
        } else { formatter.decimalSeparator = "." }
        
        let grade = formatter.number(from: textToTransform)
        if let doubleGrade = grade?.doubleValue {
            return doubleGrade
        } else {
            presentAlert()
            return 0.0
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The conversion failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        arrayRates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayRates[row].currencys
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
