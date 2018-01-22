
#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface MyHTTPConnection : HTTPConnection  {
    BOOL isUploading;                         //Is not being performed Upload
    MultipartFormDataParser*        parser;
	NSFileHandle*					storeFile;
	
	NSMutableArray*					uploadedFiles;
    UInt64 uploadFileSize;                     //The total size of the uploaded file
}

@end
