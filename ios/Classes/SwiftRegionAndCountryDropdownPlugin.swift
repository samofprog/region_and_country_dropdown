import Flutter
import UIKit

public class SwiftRegionAndCountryDropdownPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "region_and_country_dropdown", binaryMessenger: registrar.messenger())
    let instance = SwiftRegionAndCountryDropdownPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
