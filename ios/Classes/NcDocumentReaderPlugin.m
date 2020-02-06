#import "NcDocumentReaderPlugin.h"
#import <nc_document_reader/nc_document_reader-Swift.h>

@implementation NcDocumentReaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNcDocumentReaderPlugin registerWithRegistrar:registrar];
}
@end
