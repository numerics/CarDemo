//
//  SNLog.m
//  Workbench
//
//  Created by Jason Agostoni on 2/27/11.
//  Copyright 2011 Jason Agostoni. All rights reserved.
//
//  Modified by John Basile on 11/07/11.
//  Copyright 2011 Numerics. All rights reserved.
//
#import "SNLog.h"

@implementation SNLog


#pragma mark Singleton Methods
static SNLog *sharedInstance;
+ (SNLog *) logManager 
{
#if (LOGGING_ENABLED )
	if (sharedInstance == nil) 
    {
		sharedInstance = [[SNLog alloc] init];
	}
	
	return sharedInstance;
#else
    return nil;
#endif
}

+ (id) allocWithZone:(NSZone *)zone 
{
	if (sharedInstance == nil) 
    {
		sharedInstance = [super allocWithZone:zone];
	}	
	return sharedInstance;
}

+ (void) Log: (NSString *) format, ...
{
#if (LOGGING_ENABLED )
	SNLog *log = [SNLog logManager];
	va_list args;
	va_start(args, format);
	NSString *logEntry = [[NSString alloc] initWithFormat:format arguments:args];
	#if (FILELOGGING_ENABLED )
		[log writeToLogs: 3 entry:logEntry];
	#else
		[log writeToLogs: 1 entry:logEntry];
	#endif
#endif
}


+ (void) Log:(NSInteger)logLevel  entry:(NSString *) format, ...
{
#if (LOGGING_ENABLED )
	SNLog *log = [SNLog logManager];
	va_list args;
	va_start(args, format);
	NSString *logEntry = [[NSString alloc] initWithFormat:format arguments:args];
	[log writeToLogs:logLevel entry:logEntry];
	
#endif
}
#pragma mark Instance Methods

- (void) writeToLogs:(NSInteger)logLevel entry:(NSString *)logEntry
{
	NSString *formattedLogEntry = [self formatLogEntry:logLevel entry:logEntry];
	for (NSObject<SNLogStrategy> *logger in logStrategies)
    {
		if (logLevel >= logger.logAtLevel)
        {
			[logger writeToLog:logLevel entry:formattedLogEntry];
		}
	}
	
}
- (id) init 
{
	if (self = [super init]) 
    {
		SNConsoleLogger *consoleLogger = [[SNConsoleLogger alloc] init];
		consoleLogger.logAtLevel = 0;
		[self addLogStrategy:consoleLogger];
		return self;
	 } 
    else 
     {
		 return nil;
	 }
}

- (void) addLogStrategy: (id<SNLogStrategy>) logStrategy 
{
	if (logStrategies == nil) 
    {
		logStrategies = [[NSMutableArray alloc] init];
	}
	
	[logStrategies addObject: logStrategy];
}


- (NSString *)formatLogEntry:(NSInteger)logLevel entry:(NSString *) logData
{
	NSDate *now = [NSDate date];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *formattedString = [dateFormatter stringFromDate:now];
    
	return [NSString stringWithFormat:@"%@ %@", formattedString, logData];
}

@end


@implementation SNConsoleLogger
@synthesize logAtLevel;

- (void) writeToLog:(NSInteger)logLevel entry:(NSString *)logData
{
	printf("%s\r\n", [logData UTF8String]);
}

@end


@implementation SNFileLogger

@synthesize logAtLevel,logFilePath;

- (id) initWithPathAndSize: (NSString *) filePath  size:(NSInteger) truncateSize
{
#if (LOGGING_ENABLED )
    logAtLevel = 2;
	
	if (self = [super init]) 
    {
		self.logFilePath = filePath;
		truncateBytes = truncateSize;
		return self;
	} 
    else 
    {
		return nil;
	}
#else
    return nil;
#endif

}


- (void) writeToLog:(NSInteger) logLevel entry:(NSString *)logData
{
	NSData *logEntry =  [[logData stringByAppendingString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding];
	NSFileManager *fm = [[NSFileManager alloc] init];
	
	if(![fm fileExistsAtPath:logFilePath])
    {
		[fm createFileAtPath:logFilePath contents:logEntry attributes:nil];
	}
    else
    {
		NSDictionary *attrs = [fm attributesOfItemAtPath:logFilePath error:nil];
		NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
		if ([attrs fileSize] > truncateBytes)
        {
			[file truncateFileAtOffset:0];
		}
		
		[file seekToEndOfFile];
		[file writeData:logEntry];
		[file closeFile];
	}
	
	
}
@end
