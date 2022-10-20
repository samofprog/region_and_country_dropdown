#import "RegionAndCountryDropdownPlugin.h"
#if __has_include(<region_and_country_dropdown/region_and_country_dropdown-Swift.h>)
#import <region_and_country_dropdown/region_and_country_dropdown-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "region_and_country_dropdown-Swift.h"
#endif

@implementation RegionAndCountryDropdownPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRegionAndCountryDropdownPlugin registerWithRegistrar:registrar];
}
@end
