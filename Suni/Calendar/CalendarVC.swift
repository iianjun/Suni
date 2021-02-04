//
//  CalendarVC.swift
//  Suni
//
//  Created by 전하성 on 2021/01/20.
//

import UIKit
class CalendarVC : UIViewController {


    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var infoView: UIView!
    var didDrawBorder = false
    var minimumDate : Date?
    var maximumDate : Date?

    @IBOutlet var infoTableView: UITableView!
    var events : [CalendarVO] = []
    var detailContainer : [String : Array<String>] = [:] {
        didSet  {
            self.infoTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        self.setup()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if didDrawBorder == false {
            let layerOfWeekdayView = UIView(frame: CGRect(x: 0, y: 0, width: self.calendar.calendarWeekdayView.frame.width, height: self.calendar.calendarWeekdayView.frame.height))
            layerOfWeekdayView.layer.chooseBorder(edge: .bottom, thickness: Constant.timetableBorderWidth)
            self.calendar.calendarWeekdayView.addSubview(layerOfWeekdayView)
            self.calendar.calendarWeekdayView.bringSubviewToFront(layerOfWeekdayView)
            print(self.calendar.calendarWeekdayView.subviews.count)
            print("didDrawBorder : \(didDrawBorder)")
            didDrawBorder = true
        }
        
        
    }
    func setup() {
        self.initHeader()
        self.getCalendarInfo()
        self.setupCalendar()
        self.setUpEvents()
        
    }
    
    func initHeader() {
        let viewTitle = UILabel()
        viewTitle.text = "Academic Calendar"
        viewTitle.font = getRigteous(size: Constant.titleFontSize)
        viewTitle.sizeToFit()
        viewTitle.textColor = .themeColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitle)
    }
    
    func getCalendarInfo() {
        if let path = Bundle.main.path(forResource: "calendar", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as! [NSDictionary]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "ko_KR")
                for event in jsonResult {
                    if let minimumStr = event["minimum"] as? String {
                        if let minimumDate = dateFormatter.date(from: minimumStr) {
                            self.minimumDate = minimumDate
                            continue
                        }
                        
                    }
                    if let maximumStr = event["maximum"] as? String {
                        if let maximumDate = dateFormatter.date(from: maximumStr) {
                            self.maximumDate = maximumDate
                            continue
                        }
                    }
                    let cvo = CalendarVO()
                    cvo.isHoliday = event["holiday"] as? Bool
                    cvo.date = dateFormatter.date(from: event["date"] as! String)
                    cvo.title = event["title"] as? Array<String>
                    cvo.contents = event["contents"] as? Array<String>
                    
                    self.events.append(cvo)
                }
                
                if let today = dateFormatter.date(from: dateFormatter.string(from: Date())) {
                    if calendar(self.calendar, numberOfEventsFor: today) > 0 {
                        calendar(self.calendar, didSelect: today, at: .current)
                    }
                }
                

            } catch {
                NSLog("Error for parsing JSON format file for Calendar!\n\(error.localizedDescription)" )
            }
        }
    }
    
    func setupCalendar() {
        self.calendar.layer.borderColor = UIColor.themeColor.cgColor
        self.calendar.layer.borderWidth = Constant.timetableBorderWidth
        self.calendar.layer.cornerRadius = Constant.cornerRadius
        self.calendarHeightConstraint.constant = self.view.frame.height / 2.5
        

        
        
        self.calendar.delegate = self
        self.calendar.dataSource = self

        //Header
        self.calendar.appearance.headerTitleColor = .themeTextColor
        self.calendar.appearance.headerTitleFont = getWMPBold(size: self.calendar.appearance.headerTitleFont.pointSize)
        
        //Weekday
        self.calendar.appearance.weekdayFont = getWMPSemiBold(size: self.calendar.appearance.weekdayFont.pointSize)
        self.calendar.appearance.weekdayTextColor = .themeTextColor
        
        //days
        self.calendar.appearance.todayColor = .themeColor
        self.calendar.appearance.titleFont = getWMPRegular(size: self.calendar.appearance.titleFont.pointSize)
        self.calendar.appearance.selectionColor = UIColor.pastel[6]
        self.calendar.appearance.eventDefaultColor = .themeColor
        self.calendar.appearance.eventSelectionColor = .themeTextColor
        
        self.calendar.appearance.titleDefaultColor = .themeTextColor
        self.calendar.appearance.titleWeekendColor = .red
        
        self.calendar.select(Date())
        
        self.calendar.placeholderType = .none
        
        
  
        

        
        
    }
    func setUpEvents () {
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.separatorStyle = .none
        self.infoTableView.bounces = false
    }
}

extension CalendarVC : FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var eventsFromJson = [Date]()
        for event in events {
            eventsFromJson.append(event.date!)
        }
        
        if eventsFromJson.contains(date) {
            return 1
        }
        else {
            return 0
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        
        let event = self.events.filter { $0.date == date }
        if !event.isEmpty {
            detailContainer = [ "titles" : event[0].title!, "contents" : event[0].contents!]

        }
        else {
            detailContainer.removeAll()
        }
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        if let minDate = self.minimumDate {
            return minDate
        }
        return self.calendar.minimumDate
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        if let maxDate = self.maximumDate {
            return maxDate
        }
        return self.calendar.maximumDate
    }

}

extension CalendarVC : FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let holidayDate = events.filter { $0.isHoliday == true }
        if holidayDate.count != 0 {
            for event in holidayDate {
                if event.date == date {
                    return .red
                }
            }
        }
        return nil
    }


}
extension CalendarVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ret = self.detailContainer["titles"] {
            return ret.count
        }
        return 0
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.infoCellId) else { return UITableViewCell() }
        
        if let titles = detailContainer["titles"] {
            cell.textLabel?.text = titles[indexPath.row]
            cell.textLabel?.sizeToFit()
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = getWMPBold(size: 17)
        }
        if let contents = detailContainer["contents"] {
            cell.detailTextLabel?.text = contents[indexPath.row]
            cell.detailTextLabel?.font = getWMPRegular(size: 13)
            cell.detailTextLabel?.numberOfLines = 0
        }
        
        cell.selectionStyle = .none
        return cell
        
        
        
    }
    
    
}

