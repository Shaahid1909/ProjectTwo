
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Task1: UILabel!
    @IBOutlet weak var dateBtn: UILabel!
    @IBOutlet weak var taskCheck: UIButton!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var remainingdays: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
