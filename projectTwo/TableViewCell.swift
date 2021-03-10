
import UIKit


class TableViewCell: UITableViewCell{

    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Task1: UILabel!
    @IBOutlet weak var dateBtn: UILabel!
    @IBOutlet weak var taskCheck: UIButton!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var remainingdays: UILabel!
    @IBOutlet weak var remainderButton: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var conVieww: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conVieww.layer.cornerRadius = 12.0
        conVieww.layer.borderColor = UIColor.black.cgColor
        conVieww.layer.borderWidth = 0.5
       
       
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
