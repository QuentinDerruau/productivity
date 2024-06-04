import Foundation
import UIKit



class PomodoroViewController : UIViewController, UIScrollViewDelegate {
    
    var state = "Work"
    var started = false
    var timeLeft = Int()
    var timer : Timer?
    var initialValueMinuteWork = String()
    var initialValueSecondWork = String()
    
    
    @IBOutlet weak var buttonStyle: UIButton!
    
    @IBOutlet weak var indicatorToScroll: UIImageView!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewSelector: UIStackView!
    @IBOutlet weak var MinuteWorkChrono: UILabel!
    @IBOutlet weak var SecondWorkChrono: UILabel!
    
    @IBOutlet weak var BreakMinute: UILabel!
    @IBOutlet weak var BreakTime: UILabel!
    @IBOutlet weak var BreakSecond: UILabel!
    
    @IBAction func actionButton(_ sender: Any) {
        
        if started == false {
            started = true
            pomodoroWorkflow()
            let image = UIImage(systemName: "stop.fill")
            buttonStyle.setImage(image, for: .normal)
            buttonStyle.configuration?.cornerStyle = .capsule
            buttonStyle.clipsToBounds = true
            BreakTime.isHidden = true
            BreakMinute.isHidden = true
            BreakSecond.isHidden = true
        }
        else if started == true {
            started = false
 
            state = "Work"
            timer!.invalidate()
            SecondWorkChrono.text = initialValueSecondWork
            MinuteWorkChrono.text = initialValueMinuteWork
            let image = UIImage(systemName: "play.fill")
            buttonStyle.setImage(image, for: .normal)
            buttonStyle.configuration?.cornerStyle = .capsule
            buttonStyle.clipsToBounds = true
            view.backgroundColor = colorBrokenWhite
            for subview in scrollViewSelector.subviews {
                let squareView = subview
                squareView.backgroundColor = colorRed
            }
            BreakTime.isHidden = false
            BreakMinute.isHidden = false
            BreakSecond.isHidden = false
            scrollView.isScrollEnabled = true
            
            resetScroll(scrollView,totalValue: (Int(initialValueMinuteWork)! * 60  + Int(initialValueSecondWork)!))
            updateChronoValue(scrollView)
            
        }
    }
    
    func pomodoroWorkflow() {
        timer = Timer()
        var minuteValue = Int()
        var secondValue = Int()
        if state == "Work" {
            minuteValue = Int(MinuteWorkChrono.text!)!
            secondValue = Int(SecondWorkChrono.text!)!
            self.view.backgroundColor = colorRed
            buttonStyle.tintColor = colorBlue
            
            for subview in scrollViewSelector.subviews {
                let squareView = subview
                squareView.backgroundColor = colorBlue
            }
            sendNotification(title: "Break Over", body: "Your break is over. Time to work!")
            
        }
        else if state == "Break" {
            let totalBreakValue = (Int(initialValueMinuteWork)! * 60  + Int(initialValueSecondWork)!) / 4
            minuteValue = totalBreakValue / 60
            secondValue = totalBreakValue - totalBreakValue / 60
            buttonStyle.tintColor = colorRed
            self.view.backgroundColor = colorBlue
            for subview in scrollViewSelector.subviews {
                let squareView = subview
                squareView.backgroundColor = colorRed
            }
            sendNotification(title: "Work Session Over", body: "Your work session is over. Take a break!")
        }
        
        timeLeft = (minuteValue * 60) + secondValue
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShapesToScrollView()
        scrollView.delegate = self
        let image = UIImage(systemName: "play.fill")
        buttonStyle.setImage(image, for: .normal)
        buttonStyle.layer.cornerRadius = buttonStyle.frame.height / 2
        buttonStyle.backgroundColor = colorBlue
        
        
        // 15 * 360 - 15 * 19 = 5115
        scrollView.contentOffset.x = 5115 / 2
        MinuteWorkChrono.text = "30"
        BreakMinute.text = "07"
        BreakSecond.text = "30"
        initialValueMinuteWork = "30"
        scrollView.layoutIfNeeded()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    if granted {
                        print("Notification authorization granted")
                    } else {
                        print("Notification authorization denied")
                    }
                }
        func animateIndicator() {
            // Animation vers la gauche
            UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseOut], animations: {
                self.indicatorToScroll.transform = CGAffineTransform(translationX: 60, y: 0)
                self.indicatorToScroll.layer.opacity = 0
            },  completion: { _ in
                    self.indicatorToScroll.transform = CGAffineTransform(translationX: -60, y: 0)
                    self.indicatorToScroll.layer.opacity = 1
                    // Appel récursif pour démarrer la prochaine itération de l'animation
                    animateIndicator()
            })
        }
        // Appel initial pour démarrer l'animation
        animateIndicator()
    }
    
    func resetScroll(_ scrollView: UIScrollView, totalValue : Int,completion: (() -> Void)? = nil){
        let singleSecondValue = Float(5115) / 3600
        let resetPoint = CGPoint(x: CGFloat(singleSecondValue) * CGFloat(totalValue), y: scrollView.contentOffset.y)
        scrollView.setContentOffset(resetPoint, animated: true)
    }
    
    func updateChronoValue(_ scrollView: UIScrollView){
        
        let offsetX = scrollView.contentOffset.x
        let percentageScrolled = offsetX / (scrollView.contentSize.width - scrollView.frame.width)
        let boundedPercentage = max(0, min(1, percentageScrolled))
        let totalSeconds = Int(boundedPercentage * 3600)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        MinuteWorkChrono.text = String(format: "%02d", minutes)
        
        SecondWorkChrono.text = String(format: "%02d", (seconds / 10) * 10)
        initialValueMinuteWork = String(format: "%02d", minutes)
        initialValueSecondWork = String(format: "%02d", (seconds / 10) * 10)
        estimateBreakTime()
        
    }
    
    func updateChronoScroll (_ scrollView : UIScrollView){
        let singleSecondValue : Float = 5115 / 3600
        let newPoint = CGPoint(x: scrollView.contentOffset.x - CGFloat(singleSecondValue), y: scrollView.contentOffset.y)
        scrollView.setContentOffset(newPoint, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if started == false {
            
            updateChronoValue(scrollView)
        }
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            indicatorToScroll.isHidden = true
        }
    func estimateBreakTime() {
        let totalBreakValue = (Int(initialValueMinuteWork)! * 60  + Int(initialValueSecondWork)!) / 4
        let minuteValue = totalBreakValue / 60
        let secondValue = totalBreakValue - minuteValue * 60
        BreakMinute.text = String(format: "%02d", minuteValue)
        BreakSecond.text = String(format: "%02d", secondValue)
    }
    
    func addShapesToScrollView() {
        var count5 = 5
        for _ in 0...360 {
            let squareView = UIView()
            squareView.backgroundColor = colorRed
            squareView.widthAnchor.constraint(equalToConstant: 5).isActive = true
            if count5 == 5 {
                count5 = 0
                squareView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
            else {
                squareView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            }
            squareView.layer.cornerRadius = 2
            count5 += 1
            scrollViewSelector.addArrangedSubview(squareView)
        }
    }
    @objc func timerAction() {
        guard timeLeft >= 0 else {
            if state == "Work" {
                state = "Break"
                timer?.invalidate()
                pomodoroWorkflow()
                resetScroll(scrollView, totalValue: (Int(initialValueMinuteWork)! * 60  + Int(initialValueSecondWork)!) / 4)
                
                
            } else if state == "Break" {
                state = "Work"
                SecondWorkChrono.text = initialValueSecondWork
                MinuteWorkChrono.text = initialValueMinuteWork
                timer?.invalidate()
                pomodoroWorkflow()
                resetScroll(scrollView,totalValue: (Int(initialValueMinuteWork)! * 60  + Int(initialValueSecondWork)!), completion: nil)
            }
            return
        }
        
        updateChronoScroll(scrollView)
        scrollView.isScrollEnabled = false
        MinuteWorkChrono.text = String(format: "%02d", timeLeft / 60)
        SecondWorkChrono.text = String(format: "%02d", timeLeft % 60)
        timeLeft -= 1
    }
}

func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "PomodoroNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
