import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var datmdl = TransactionModel()
    var cuTr:Transaction=Transaction()
    var msg: String=""
    var cuFt: Int = 0
    var cuKy: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updMdl), for: .valueChanged)
        
    }

    @objc func updMdl() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
            self.datmdl.getJsDt()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func chgFltr(_ sender: UISegmentedControl) {
        cuFt=sender.selectedSegmentIndex
        switch cuFt {
        case 2:
            cuKy = cuTr.type
        case 3:
            cuKy = cuTr.brand
        default:
            cuKy=""
        }
        tableView.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="detail" {
            let detVC=segue.destination as? DetailViewController
            detVC?.det=cuTr
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cuTr=datmdl.mdlFltr(cuFt,cuKy)[indexPath.row]
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datmdl.mdlFltr(cuFt,cuKy).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tm=datmdl.mdlFltr(cuFt,cuKy)[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        var tx=tm.trnId+" "+tm.tktSer+" "+tm.brand+" "+tm.type
        cell.textLabel?.text = tx
        tx=tm.color + " " + tm.tktInc.prefix(16)
        if tm.tktOut != nil {
            tx += " -> " + tm.tktOut!.prefix(16)
        }
        cell.detailTextLabel?.text=tx
        return cell
    }
    
}

