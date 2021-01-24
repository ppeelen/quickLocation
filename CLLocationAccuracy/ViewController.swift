import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var authStatus: UILabel!
  @IBOutlet weak var exactPositionEnabled: UILabel!

  private let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
  }

  @IBAction func openSettings(_ sender: Any) {
    let string = UIApplication.openSettingsURLString.appending("?root=Privacy&path=LOCATION")
    UIApplication.shared.open(URL(string: string)!)
  }
}

private extension ViewController {

  func setup() {
    locationManager.delegate = self

    setTexts()

    locationManager.desiredAccuracy = .greatestFiniteMagnitude
    locationManager.requestAlwaysAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
    }
  }

  func setTexts() {
    let authStatusText: String

    switch locationManager.authorizationStatus {
    case .authorizedAlways:
      authStatusText = "Always"
    case .authorizedWhenInUse:
      authStatusText = "When in use"
    case .denied:
      authStatusText = "Denied"
    case .notDetermined:
      authStatusText = "Not determined"
    case .restricted:
      authStatusText = "Restricted"
    @unknown default:
      authStatusText = "-"
    }

    authStatus.text = authStatusText

    let accuracyText: String
    switch locationManager.accuracyAuthorization {
    case .fullAccuracy:
      accuracyText = "Yes, Full"
    case .reducedAccuracy:
      accuracyText = "No, reduced"
    @unknown default:
      accuracyText = "-"
    }

    exactPositionEnabled.text = accuracyText
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    setTexts()
  }
}
