//
//  SNLog.h
//  Workbench
//
//  Created by Jason Agostoni on 2/27/11.
//  Copyright 2011 Jason Agostoni. All rights reserved.
//
//  Modified by John Basile on 11/07/11.
//  Copyright 2011 Numerics. All rights reserved.
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//	Function:		SNLog
//
//	Description:
//		Very simple logging framework for iOS apps.
//      SNLog is a simple-to-use replacement for NSLog, it re-defines NSLog, so that all NSLog statements still work.
//      Consequently, all logging is done thru 2 Macros, and three Flags defined in ChinUp_Prefix.pch
//      
//      1) MACRO: NSLog - which operates as expected with the addition that all output has the Function and Line number where the log is used.
//      2) MACRO: SNSLog - operates just as NSLOG with the addition that a Stack Trace is included in the output.
//
//      DEBUGLOGGING               Set in the OTHER FLAG OF THE DEBUG BUILD   - if the Flag is on, then logging is ON, otherwise NSLOG is a NOP.
//      LOGGING_ENABLED            If DEBUGLOGGING is set then LOGGING_ENABLED is set. Otherwise, setting this Flag in ChinUp_Prefix.pch will enable logging everywhere
//      FILELOGGING_ENABLED        If LOGGING_ENABLED is set: Will sent the Log to the File SNConsole.log
//      STACKLOGGING_ENABLED       All NSLog's will also include a Stack Trace - use SNSLOG to have a singular Stack trace
//
//
//
//	Notes:             !!! IF LOGGING_ENABLED IS ENABLED IN ChinUp_Prefix.pch IT MUST BE TURNED OFF IN RELEASE MODE  !!!!!
//
//                     This is a Singleton, and should be initialized in the AppDidFinishLoading.... like so:
//
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *documentsDirectory = [paths objectAtIndex:0];                                                                                         // gets the document Directory
//  SNFileLogger *logger = [[SNFileLogger alloc] initWithPathAndSize:[documentsDirectory stringByAppendingFormat:@"/SNConsole.log"]: 1000000];      // this caps the log file at million characters
//
//  [[SNLog logManager] addLogStrategy:logger];                                                                                                     // adds the console & File strategies
//  [logger release];                                                                                                                               
//
//	Keywords:
//	See Also:
//
//++++++++++++++++++++++++++-+++++++++++++++-+++++++-+++++++++++++++++++++++++++//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//      Usage example: [SNLog Log:"@Log text %@", aString];




// Re-define NSLog to use SNLog instead

#if (LOGGING_ENABLED == 1 && STACKLOGGING_ENABLED == 1)
#define NSLog(format, ...)  [SNLog Log:[NSString stringWithFormat:@"%s[Line %d] - %@\r\n%@", __PRETTY_FUNCTION__, __LINE__,format,[NSThread callStackSymbols]], ##__VA_ARGS__]
#elif (LOGGING_ENABLED == 1)
#define NSLog(format, ...)  [SNLog Log:[NSString stringWithFormat:@"%s[Line %d] - %@", __PRETTY_FUNCTION__, __LINE__,format], ##__VA_ARGS__] //[SNLog Log:format, ##__VA_ARGS__]
#else
#define NSLog(format, ...)
#endif

#if (LOGGING_ENABLED == 1)
#define SNSLog(format, ...)  [SNLog Log:[NSString stringWithFormat:@"%s[Line %d] - %@\r\n%@", __PRETTY_FUNCTION__, __LINE__,format,[NSThread callStackSymbols]], ##__VA_ARGS__]
#else
#define SNSLog(format, ...)
#endif

#if (LOGGING_ENABLED == 1)
#define MEMLog(format, ...)  [SNLog Log:[NSString stringWithFormat:@"%@", format], ##__VA_ARGS__]
#else
#define MEMLog(format, ...)
#endif

//    @protocol
//    @abstract    Protocol for all SNLog log strategies
//    @discussion  Any custom log strategies for SNLog must implement this protocol
@protocol SNLogStrategy


// Writes data to the particular log strategy
- (void) writeToLog:(NSInteger)logLevel entry:(NSString *)logData;

@property(nonatomic) NSInteger logAtLevel;

@end



//===================== interface SNLog ======================================================
//      @class
//      @abstract    SNLog drop-in replacement for NSLog
//      @discussion  This class implements SNLog as a singleton object and allows for multiple, simultaneous logging strategies
@interface SNLog : NSObject
{
@private
	NSMutableArray *logStrategies; /*< List of log strategies to log to */
	
}


//      Returns the shared log instance for any setup (adding strategies, etc.)
//      @return SNLog singleton

+ (SNLog *) logManager;


//      Sends the string format to the logs with the default log level (1)
//      @param format NSString format

+ (void) Log: (NSString *) format, ...;


//      Sends the string format to the logs
//      @param format NSString format
//      @param logLevel Logging level, the higher the level the more important
+ (void) Log:(NSInteger)logLevel  entry:(NSString *) format, ...;


//      Writes the given log entry to all the logs.  Use the class method Log instead.
//      @param logEntry Log entry to write
- (void) writeToLogs:(NSInteger)logLevel  entry:(NSString *)logEntry;


//      Adds a new log strategy to SNLog.  Must implement the SNLogStrategy protocol.
//      @param logStrategy Object which implements the SNLogStrategy protocol
- (void) addLogStrategy: (id<SNLogStrategy>) logStrategy;


//      Creates the final log entry string
- (NSString *)formatLogEntry:(NSInteger)logLevel entry:(NSString *) logData;

@end


//===================== interface SNConsoleLogger ======================================================
//      @class
//      @abstract    Console logging strategy for SNLog
//      @discussion  This class implements a logging strategy which writes to the console while debugging.
@interface SNConsoleLogger : NSObject<SNLogStrategy>
{
}

@end


//===================== interface SNFileLogger ======================================================
//      @class
//      @abstract    File logging strategy for SNLog
//      @discussion  This class implements a logging strategy which write to a given file.
@interface SNFileLogger : NSObject<SNLogStrategy>
{
	NSString *logFilePath; /*!< Path to log file */
	NSInteger truncateBytes; /*!< Bytes at which to truncate file */
}

@property (nonatomic, strong) NSString *logFilePath;
//      Construcs a new SNFileLogger with the given file path
//      @param filePath Path to log file
//      @param truncateSize Truncates log file at the given bytes
//      @return New instance

- (id) initWithPathAndSize: (NSString *) filePath size:(NSInteger) truncateSize;

@end

















