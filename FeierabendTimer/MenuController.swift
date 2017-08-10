import Cocoa

class MenuController: NSObject {

  @IBOutlet weak var statusMenu: NSMenu!
  
  @IBOutlet weak var startMenuItem: NSMenuItem!
  
  let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
  
  var timer = Timer()
  var startTime = Date()
  var finishTime = 8*60*60
  var pauseTime = 0
  var isPaused = true
  
  override func awakeFromNib() {
    statusItem.menu = statusMenu
    updateStatus()
    
    startClicked(sender: NSMenuItem())
  }
  
  @IBAction func startClicked(sender: NSMenuItem) {
    if isPaused {
      isPaused = false
      startMenuItem.title = "Stop"
      timer.invalidate()
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateStatus), userInfo: nil, repeats: true)
    } else {
      isPaused = true
      startMenuItem.title = "Start"
      timer.invalidate()
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatePause), userInfo: nil, repeats: true)
    }
  }
  
  @IBAction func quitClicked(sender: NSMenuItem) {
    NSApplication.shared().terminate(self)
  }
  
  @objc private func updateStatus() {
    let seconds = Calendar.current.dateComponents([.second], from: startTime, to: Date()).second ?? 0
    let time = (finishTime + pauseTime) - seconds

    let (h, m, s) = secondsToHoursMinutesSeconds (seconds: time)
    
    let hour = h > 9 ? "\(h)" : "0\(h)"
    let min = m > 9 ? "\(m)" : "0\(m)"
    let sec = s > 9 ? "\(s)" : "0\(s)"
    
    statusItem.title = "\(hour):\(min):\(sec)"
  }
  
  @objc private func updatePause() {
    pauseTime += 1
  }
  
  private func showNotification() {
    let notification = NSUserNotification()
    notification.title = "Feierabend"
    notification.informativeText = "Time to go home now"
    notification.soundName = NSUserNotificationDefaultSoundName
    NSUserNotificationCenter.default.deliver(notification)
  }
  
  private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
  }
}
