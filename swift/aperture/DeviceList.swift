import Foundation
import AVFoundation
import CoreMediaIO

// Enable access to iOS devices
private func enableDalDevices() {
  var property = CMIOObjectPropertyAddress(mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices), mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal), mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))
  var allow: UInt32 = 1
  let sizeOfAllow = MemoryLayout<UInt32>.size
  CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &property, 0, nil, UInt32(sizeOfAllow), &allow)
}

final class DeviceList {
  func audio() -> [Dictionary<String, String>] {
    let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio) as! [AVCaptureDevice]

    return captureDevices
      .map {[
        "name": $0.localizedName,
        "id": $0.uniqueID
      ]}
  }

  func ios() -> [Dictionary<String, String>] {
    enableDalDevices()
    let captureDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeMuxed) as! [AVCaptureDevice]
    return captureDevices
      .filter {$0.localizedName == "iPhone" || $0.localizedName == "iPad"}
      .map {[
        "name": $0.localizedName,
        "id": $0.uniqueID
      ]}
  }
}
