import UIKit

class NwCar2PkLtVC: UIViewController {

    @IBOutlet weak var tktSerial: UITextField!
    @IBOutlet weak var plateTag: UITextField!
    @IBOutlet weak var carInfo: UIPickerView!
    
    let cInf: CarInfo = CarInfo()
    var nwTr: NewTrans = NewTrans()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carInfo.delegate=self
        carInfo.dataSource=self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addTrn(_ sender: Any) {
        nwTr.brand=cInf.brand[carInfo.selectedRow(inComponent: 0)]
        nwTr.color=cInf.color[carInfo.selectedRow(inComponent: 1)]
        nwTr.tktSer = tktSerial.text!
        nwTr.type=plateTag.text!
        if tktSerial.text!.isEmpty || plateTag.text!.isEmpty {
            let alert = UIAlertController(title: "Incomplete data!", message: "Please provide ticket serial/plate tag/brand/color!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in print("ok tap") }))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let svrmsg = try! JSONEncoder().encode(nwTr)
        guard let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "REST_endpoint_URL") as! String) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody=svrmsg
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: req) {
                (data,response,error) in
                if let data=data {
                    print("POST Request ok")
                    print(data)
                    print(response)
                } else {
                    print("POST Request error")
                    print(error)
                }
            }.resume()
        }
        tktSerial.text=""
        plateTag.text=""
        carInfo.reloadAllComponents()
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
}

extension NwCar2PkLtVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cInf.brand.count
        } else {
            return cInf.color.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return  cInf.brand[row]
        } else {
            return cInf.color[row]
        }
    }
}

extension NwCar2PkLtVC:  UIPickerViewDelegate {
    
}
