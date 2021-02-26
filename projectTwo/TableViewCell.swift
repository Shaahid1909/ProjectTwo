
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Task1: UILabel!
    @IBOutlet weak var dateBtn: UILabel!
    @IBOutlet weak var taskCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
