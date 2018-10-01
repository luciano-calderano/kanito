//
//  BookingMultiple
//

import UIKit

class BookingMultiple: MYViewController, UITableViewDelegate, UITableViewDataSource, ViewBookingDelegate {
    class func Instance () -> BookingMultiple {
        let vc = self.load(storyboard: .Booking) as! BookingMultiple
        return vc
    }
    
    @IBOutlet private var tableView: UITableView!

    private let cellName = "Cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
//        let view = BookingViewBig.Instance()
//        print(view)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellName,
                                                                  for: indexPath)
        let view = BookingViewBig.Instance()
        cell?.contentView.addSubview(view)
        view.frame = (cell?.bounds)!
        view.show(booking: dataArray[indexPath.row] as! BookingClass)
        view.delegateBooking = self
        return cell!
    }
    
    func delegateBookingSubview(bookings: [BookingClass]) {
        self.bookingEdit(booking: bookings.first!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.bookingEdit(booking: dataArray[indexPath.row] as! BookingClass)
    }
    
    private func bookingEdit (booking: BookingClass) {
        let ctrl = BookingDetail.Instance()
        ctrl.booking = booking
        self.navigationController?.show(ctrl, sender: self)
        
    }

}

