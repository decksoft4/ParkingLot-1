import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var det:Transaction=Transaction()
    var msg: String=""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        msg="Ticket Detail\nNumber: \(det.trnId)\nSerial: \(det.tktSer)\nCar brand: \(det.brand)\nCar plate: \(det.type)\nCar color: \(det.color)\nIncoming: \(det.tktInc)\n"
        if det.tktOut != nil {
            msg+="Outgoing:"+det.tktOut!+"\n"
        }
        textView.text=msg
    }


    @IBAction func leaveLot(_ sender: Any) {
        if !(det.tktOut!.isEmpty) {
            let alert = UIAlertController(title: "Ticket already closed", message: "Ticket-Unit leave parking lot at: " + det.tktOut!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in print("ok tap") }))
            present(alert, animated: true, completion: nil)
            return
        }
        if det.tktSer.isEmpty {
            let alert = UIAlertController(title: "Invalid data", message: "There is no available ticket, please reload data!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in print("ok tap") }))
            present(alert, animated: true, completion: nil)
            return
        }

        guard let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "REST_endpoint_URL") as! String + "/\(det.tktSer)") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: req) {
                (data,response,error) in
                if let data=data {
                    print("PUT Request ok")
                    print(data)
                    print(response)
                } else {
                    print("PUT Request error")
                    print(error)
                }
            }.resume()
        }
        let alert = UIAlertController(title: "Transaction has been sent!", message: "Return to list view and wait for server response!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in print("ok tap") }))
            present(alert, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let srcVC = segue.destination as! ViewController
        srcVC.msg=msg
    }

}
