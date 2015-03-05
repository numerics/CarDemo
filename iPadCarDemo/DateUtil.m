//
//  DateUtil.m
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.

#import "DateUtil.h"

@implementation DateUtil

#define SECOND  1
#define MINUTE  (SECOND * 60)
#define HOUR    (MINUTE * 60)
#define DAY     (HOUR   * 24)
#define WEEK    (DAY    * 7)
#define MONTH   (DAY    * 31)
#define YEAR    (DAY    * 365.24)

static NSTimeZone* TIME_ZONE_GMT = nil;
static NSDateFormatter* DATE_FORMATTER_DATE_FROM_STRING = nil;
static NSDateFormatter* DATE_FORMATTER_STRING_FROM_DATE = nil;
static NSDate* NEXT_MONDAY = nil;
static NSDate* FIRSTDAY_YEAR = nil;
static NSDate* LASTDAY_YEAR = nil;
static NSDate* FIRSTDAY_MONTH = nil;
static NSDate* LASTDAY_MONTH = nil;
static NSDate* FIRSTDAY_QUARTER = nil;
static NSDate* LASTDAY_QUARTER = nil;
static NSDate* FIRSTDAY_WEEK = nil;
static NSDate* LASTDAY_WEEK = nil;

static NSDate* FIRSTDAY_CQUARTER = nil;
static NSDate* LASTDAY_CQUARTER = nil;
static NSDate* FIRSTDAY_CYEAR = nil;
static NSDate* LASTDAY_CYEAR = nil;

+(NSInteger) lengthOfMonth:(NSDate*)date
{
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSRange daysRange =  [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
	
	// daysRange.length will contain the number of the last day
	// of the month containing curDate
	
	//NSLog(@"%i", daysRange.length);
	return daysRange.length;
}

+ (NSDate*) getDateByIgnoringTimeComponant:(NSDate*)date
{
	NSCalendar *myCalendar = [NSCalendar currentCalendar];
	
	NSCalendarUnit dateComponentsMask = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* dateComponents = [myCalendar components: dateComponentsMask fromDate: date];
	dateComponents.hour = 0;
	dateComponents.minute = 0;
	dateComponents.second = 0;
	return  [myCalendar dateFromComponents: dateComponents];
}

//
// Class initializer. Called only once before the class receives its first message.
//
+ (void)initialize
{
	TIME_ZONE_GMT = [NSTimeZone timeZoneWithName:@"GMT"];
	
	DATE_FORMATTER_DATE_FROM_STRING = [[NSDateFormatter alloc] init];
	[DATE_FORMATTER_DATE_FROM_STRING setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
	[DATE_FORMATTER_DATE_FROM_STRING setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:@"gregorian"]];
	
	DATE_FORMATTER_STRING_FROM_DATE = [[NSDateFormatter alloc] init];
	[DATE_FORMATTER_STRING_FROM_DATE setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
	[DATE_FORMATTER_STRING_FROM_DATE setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:@"gregorian"]];
	
	//
	// Get the date for this coming Monday at 12:00 AM.
	//
	
	NSDate* today = [NSDate date];
	
	NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents* weekdayComponents = [gregorianCalendar components:(NSWeekdayCalendarUnit) fromDate:today];
	NSDateComponents* yearComponents = [gregorianCalendar components:(NSYearCalendarUnit) fromDate:today];
	NSDateComponents* monthComponents = [gregorianCalendar components:(NSMonthCalendarUnit) fromDate:today];
	
	
	NSInteger thisYear = [yearComponents year];
	NSInteger thisMonth = [monthComponents month];
	
	NSInteger lastDMN = [self lengthOfMonth:today];
	
	NSString *firstD = [NSString stringWithFormat: @"01/01/%ld", (long)thisYear];
	NSString *lastD = [NSString stringWithFormat: @"12/31/%ld", (long)thisYear];
	FIRSTDAY_YEAR = [DateUtil dateFromString:firstD dateFormat:@"MM/dd/yyyy" defaultDate:nil];
	LASTDAY_YEAR  = [DateUtil dateFromString:lastD dateFormat:@"MM/dd/yyyy" defaultDate:nil];
	
	NSString *firstDM = [NSString stringWithFormat: @"%ld/01/%ld", (long)thisMonth,(long)thisYear];
	NSString *lastDM = [NSString stringWithFormat: @"%ld/%ld/%ld", (long)thisMonth,(long)lastDMN,(long)thisYear];
	FIRSTDAY_MONTH = [DateUtil dateFromString:firstDM dateFormat:@"MM/dd/yyyy" defaultDate:nil];
	LASTDAY_MONTH  = [DateUtil dateFromString:lastDM dateFormat:@"MM/dd/yyyy" defaultDate:nil];
	
	NSInteger currQuarter = (thisMonth - 1) / 3 + 1;
	NSInteger endMonth = 3 * currQuarter;
	NSInteger startMonth = endMonth - 2;
	
	NSString *qrtfirstDayLastMonth = [NSString stringWithFormat: @"%ld/01/%ld", (long)endMonth,(long)thisYear];
	NSInteger lastDayOfQrt = [self lengthOfMonth:[DateUtil dateFromString:qrtfirstDayLastMonth dateFormat:@"MM/dd/yyyy" defaultDate:nil]];
	NSString *qrtFirstDay = [NSString stringWithFormat: @"%ld/01/%ld", (long)startMonth,(long)thisYear];
	NSString *qrtLastDay = [NSString stringWithFormat: @"%ld/%ld/%ld", (long)endMonth,(long)lastDayOfQrt,(long)thisYear];
	FIRSTDAY_QUARTER = [DateUtil dateFromString:qrtFirstDay dateFormat:@"MM/dd/yyyy" defaultDate:nil];
	LASTDAY_QUARTER = [DateUtil dateFromString:qrtLastDay dateFormat:@"MM/dd/yyyy" defaultDate:nil];
	
	
	// Sunday is represented by 1., Sat Day 7
	NSInteger weekdayToday = [weekdayComponents weekday];
	NSTimeInterval secondsInOneDay = 86400;
	NSTimeInterval secondsTillFirstDay = 0;
	NSTimeInterval secondsTillLastDay = 0;
	switch (weekdayToday)
	{
			// Sunday
		case 1:
			secondsTillFirstDay = 1;
			secondsTillLastDay = secondsInOneDay * 7;
			break;
			
			// Monday
		case 2:
			secondsTillFirstDay = -1*secondsInOneDay;
			secondsTillLastDay = secondsInOneDay * 6;
			break;
			
			// Tuesday
		case 3:
			secondsTillFirstDay = -2*secondsInOneDay;
			secondsTillLastDay = secondsInOneDay * 5;
			break;
			
			// Wednesday
		case 4:
			secondsTillFirstDay = -3*secondsInOneDay;
			secondsTillLastDay = secondsInOneDay * 4;
			break;
			
			// Thursday
		case 5:
			secondsTillFirstDay = -4*secondsInOneDay;
			secondsTillLastDay = secondsInOneDay * 3;
			break;
			
			// Friday
		case 6:
			secondsTillFirstDay = -5*secondsInOneDay;
			secondsTillLastDay = secondsInOneDay * 2;
			break;
			
			// Saturday
		case 7:
			secondsTillFirstDay = -6*secondsInOneDay;
			secondsTillLastDay = secondsInOneDay * 1;
			break;
	}
	FIRSTDAY_WEEK = [NSDate dateWithTimeIntervalSinceNow:secondsTillFirstDay];
	LASTDAY_WEEK = [NSDate dateWithTimeIntervalSinceNow:secondsTillLastDay];
	
	// There's probably a cleaner way to do this but this is pretty clear.
	//
	NSTimeInterval secondsTillMonday = 1;
	switch (weekdayToday)
	{
			// Sunday
		case 1:
			secondsTillMonday = secondsInOneDay * 1;
			break;
			
			// Monday
		case 2:
			secondsTillMonday = secondsInOneDay * 7;
			break;
			
			// Tuesday
		case 3:
			secondsTillMonday = secondsInOneDay * 6;
			break;
			
			// Wednesday
		case 4:
			secondsTillMonday = secondsInOneDay * 5;
			break;
			
			// Thursday
		case 5:
			secondsTillMonday = secondsInOneDay * 4;
			break;
			
			// Friday
		case 6:
			secondsTillMonday = secondsInOneDay * 3;
			break;
			
			// Saturday
		case 7:
			secondsTillMonday = secondsInOneDay * 2;
			break;
	}
	
	//
	// Calculate the next coming Monday at EXACTLY midnight 12:00 AM.
	//
	
	//NSTimeInterval secondsSinceRefDate = [today timeIntervalSinceReferenceDate];
	//NSTimeInterval secondsSinceMidnightToday = abs((NSInteger)secondsSinceRefDate % (NSInteger)secondsInOneDay);
	//NSLog(@"secondsSinceRefDate [%f], secondsInOneDay [%f], secondsSinceMidnightToday [%f]", secondsSinceRefDate, secondsInOneDay, secondsSinceMidnightToday);
	//NEXT_MONDAY = [[NSDate dateWithTimeIntervalSinceNow:secondsTillMonday - secondsSinceMidnightToday] retain];
	
	NEXT_MONDAY = [NSDate dateWithTimeIntervalSinceNow:secondsTillMonday];
	NSString* nextMondayAtMidnightStr = [NSString stringWithFormat:@"%@ 00:00:00", [DateUtil stringFromDate:NEXT_MONDAY dateFormat:@"MM/dd/yyyy"]];
	//NSLog(@"nextMondayAtMidnightStr [%@]", nextMondayAtMidnightStr);
	NEXT_MONDAY = [DateUtil dateFromString:nextMondayAtMidnightStr dateFormat:@"MM/dd/yyyy HH:mm:ss" defaultDate:NEXT_MONDAY];
	
	//NSLog(@"Next Monday at EXACTLY midnight is [%@]", [DateUtil stringFromDate:NEXT_MONDAY dateFormat:@"MM/dd/yyyy HH:mm:ss"]);
}



//
// Based on the current date/time returns the date of the this coming monday at exactly 12:00 AM.
//
+ (NSDate*) nextMonday
{
	return NEXT_MONDAY;
}
//
// Based on the current date/time returns the date of the first day of the present year.
//
+ (NSDate*) firstDayOfYear
{
	return FIRSTDAY_YEAR;
}
//
// Based on the current date/time returns the date of the last day of the present year.
//
+ (NSDate*) lastDayOfYear
{
	return LASTDAY_YEAR;
}
//
// Based on the current date/time returns the date of the first day of the Calendar year.
//
+ (NSDate*) firstDayOfCalendarYear
{
	return FIRSTDAY_CYEAR;
}
//
// Based on the current date/time returns the date of the last day of the Calendar year.
//
+ (NSDate*) lastDayOfCalendarYear
{
	return LASTDAY_CYEAR;
}
//
// Based on the current date returns the date of the first day of the present Week.
//
+ (NSDate*) firstDayOfWeek
{
	return FIRSTDAY_WEEK;
}
//
// Based on the current date returns the date of the last day of the present Week.
//
+ (NSDate*) lastDayOfWeek
{
	return LASTDAY_WEEK;
}
//
// Based on the current date returns the date of the first day of the present month.
//
+ (NSDate*) firstDayOfMonth
{
	return FIRSTDAY_MONTH;
}
//
// Based on the current date returns the date of the last day of the present month.
//
+ (NSDate*) lastDayOfMonth;
{
	return LASTDAY_MONTH;
}
//
// Based on the current date returns the date of the first day of the present quarter.
//
+ (NSDate*) firstDayOfQuarter
{
	return FIRSTDAY_QUARTER;
}
//
// Based on the current date returns the date of the last day of the present quarter.
//
+ (NSDate*) lastDayOfQuarter
{
	return LASTDAY_QUARTER;
}
//
// Based on the current date returns the date of the first day of the Calendar quarter.
//
+ (NSDate*) firstDayOfCalendarQuarter
{
	return FIRSTDAY_CQUARTER;
}
//
// Based on the current date returns the date of the last day of the Calendar quarter.
//
+ (NSDate*) lastDayOfCalendarQuarter
{
	return LASTDAY_CQUARTER;
}

//
// Converts the given NSString into an NSDate using the given date pattern string.
//
+ (NSDate*) dateFromString:(NSString*)str dateFormat:(NSString*)dateFormat defaultDate:(NSDate*)defaultDate
{
	NSDate* toReturn = nil;
	
	if (str != nil && dateFormat != nil)
	{
		@synchronized (DATE_FORMATTER_DATE_FROM_STRING)
		{
			[DATE_FORMATTER_DATE_FROM_STRING setDateFormat:dateFormat];
			toReturn = [DATE_FORMATTER_DATE_FROM_STRING dateFromString:str];
		}
	}
	
	return (toReturn == nil ? defaultDate : toReturn);
	
}

//
// Converts the given NSDate into an NSString using the given date pattern string.
//
+ (NSString*) stringFromDate:(NSDate*)date dateFormat:(NSString*)dateFormat
{
	NSString* toReturn = nil;
	
	if (date != nil && dateFormat != nil)
	{
		@synchronized (DATE_FORMATTER_STRING_FROM_DATE)
		{
			[DATE_FORMATTER_STRING_FROM_DATE setDateFormat:dateFormat];
			toReturn = [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:date];
		}
	}
	
	return toReturn;
	
}
/// FROM https://github.com/nikilster/NSDate-Time-Ago
//  NSDate+NVTimeAgo.m
//  Adventures
//
//  Created by Nikil Viswanathan on 4/18/13.
//  Copyright (c) 2013 Nikil Viswanathan. All rights reserved.
/*
 ========================== Formatting Methods ==========================
 
 */
+ (NSString *)formattedAsTimeAgo:(NSDate *)date
{
	//Now
	NSDate *now = [NSDate date];
	NSTimeInterval secondsSince = -(int)[date timeIntervalSinceDate:now];
	
	//Should never hit this but handle the future case
	if(secondsSince < 0)
		return @"In The Future";
	
	
	// < 1 minute = "Just now"
	if(secondsSince < MINUTE)
		return @"Just now";
	
	
	// < 1 hour = "x minutes ago"
	if(secondsSince < HOUR)
		return [DateUtil formatMinutesAgo:secondsSince];
	
	
	// Today = "x hours ago"
	if([self isSameDayAs:date now:now])
		return [DateUtil formatAsToday:secondsSince];
	
	
	// Yesterday = "Yesterday at 1:28 PM"
	if([self isYesterday:date now:now])
		return [DateUtil formatAsYesterday:date];
	
	
	// < Last 7 days = "Friday at 1:48 AM"
	if([self isLastWeek:secondsSince])
		return [DateUtil formatAsLastWeek:date];
	
	
	// < Last 30 days = "March 30 at 1:14 PM"
	if([self isLastMonth:secondsSince])
		return [DateUtil formatAsLastMonth:date];
	
	// < 1 year = "September 15"
	if([self isLastYear:secondsSince])
		return [DateUtil formatAsLastYear:date];
	
	// Anything else = "September 9, 2011"
	return [DateUtil formatAsOther:date];
	
}
/*
 Is Same Day As
 Checks to see if the dates are the same calendar day
 */
+ (BOOL)isSameDayAs:(NSDate *)comparisonDate now:(NSDate *)now
{
	//Check by matching the date strings
	//NSDateFormatter *dateComparisonFormatter = [[NSDateFormatter alloc] init];
	[DATE_FORMATTER_STRING_FROM_DATE setDateFormat:@"yyyy-MM-dd"];
	
	//    NSString *day1 = [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:comparisonDate];
	//    NSString *dayN = [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:now];
	
	//Return true if they are the same
	return [[DATE_FORMATTER_STRING_FROM_DATE stringFromDate:comparisonDate] isEqualToString:[DATE_FORMATTER_STRING_FROM_DATE stringFromDate:now ]];
}
/*
 If the current date is yesterday relative to now
 Pasing in now to be more accurate (time shift during execution) in the calculations
 */
+ (BOOL)isYesterday:(NSDate *)comparisonDate now:(NSDate *)now
{
	NSInteger delta = [DateUtil noOfDaysBetween:now toDate:comparisonDate];
	if( delta == 1)
		return YES;
	else
		return NO;
	
	//return [self isSameDayAs:[self dateBySubtractingDays:1 now:now] now:now];
}
/*
 Is Last Week
 We want to know if the current date object is the first occurance of
 that day of the week (ie like the first friday before today
 - where we would colloquially say "last Friday")
 ( within 6 of the last days)
 
 */
+ (BOOL)isLastWeek:(NSTimeInterval)secondsSince
{
	return secondsSince < WEEK;
}


/*
 Is Last Month
 Previous 31 days?
 */
+ (BOOL)isLastMonth:(NSTimeInterval)secondsSince
{
	return secondsSince < MONTH;
}


/*
 Is Last Year
 */

+ (BOOL)isLastYear:(NSTimeInterval)secondsSince
{
	return secondsSince < YEAR;
}

//From https://github.com/erica/NSDate-Extensions/blob/master/NSDate-Utilities.m
+ (NSDate *) dateBySubtractingDays: (NSInteger) numDays now:(NSDate *)now
{
	NSTimeInterval aTimeInterval = [now timeIntervalSinceReferenceDate] + DAY * -numDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

// Yesterday = "Yesterday at 1:28 PM"
+ (NSString *)formatAsYesterday:(NSDate *)date
{
	//Create date formatter
	// NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	//Format
	[DATE_FORMATTER_STRING_FROM_DATE setDateFormat:@"h:mm a"];
	return [NSString stringWithFormat:@"Yesterday at %@", [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:date]];
}

// < 1 hour = "x minutes ago"
+ (NSString *)formatMinutesAgo:(NSTimeInterval)secondsSince
{
	//Convert to minutes
	int minutesSince = (int)secondsSince / MINUTE;
	
	//Handle Plural
	if(minutesSince == 1)
		return @"1 minute ago";
	else
		return [NSString stringWithFormat:@"%d minutes ago", minutesSince];
}


// Today = "x hours ago"
+ (NSString *)formatAsToday:(NSTimeInterval)secondsSince
{
	//Convert to hours
	int hoursSince = (int)secondsSince / HOUR;
	
	//Handle Plural
	if(hoursSince == 1)
		return @"1 hour ago";
	else
		return [NSString stringWithFormat:@"%d hours ago", hoursSince];
}


// < Last 7 days = "Friday at 1:48 AM"
+ (NSString *)formatAsLastWeek:(NSDate *)date
{
	//Create date formatter
	//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	//Format
	[DATE_FORMATTER_STRING_FROM_DATE setDateFormat:@"EEEE 'at' h:mm a"];
	return [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:date];
}


// < Last 30 days = "March 30 at 1:14 PM"
+ (NSString *)formatAsLastMonth:(NSDate *)date
{
	//Create date formatter
	//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	//Format
	[DATE_FORMATTER_STRING_FROM_DATE setDateFormat:@"MMMM d 'at' h:mm a"];
	return [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:date];
}


// < 1 year = "September 15"
+ (NSString *)formatAsLastYear:(NSDate *)date
{
	//Create date formatter
	//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	//Format
	[DATE_FORMATTER_STRING_FROM_DATE setDateFormat:@"MMMM d"];
	return [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:date];
}


// Anything else = "September 9, 2011"
+ (NSString *)formatAsOther:(NSDate *)date
{
	//Create date formatter
	//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	//Format
	[DATE_FORMATTER_STRING_FROM_DATE setDateFormat:@"LLLL d, yyyy"];
	return [DATE_FORMATTER_STRING_FROM_DATE stringFromDate:date];
}

//
// Converts the given business date into the "friendly" day of the week. E.g., "Today", "Tomorrow", "Wednesday", etc.
//
+ (NSString*) businessDateDayOfWeek:(NSDate*)businessDate
{
	NSDate* today = [NSDate date];
	
	NSString* todayStr = [self stringFromDate:today dateFormat:@"yyyy-MM-dd"];
	NSString* tomorrowStr = [self stringFromDate:[today dateByAddingTimeInterval:SECONDS_PER_DAY] dateFormat:@"yyyy-MM-dd"];
	NSString* dateStr = [self stringFromDate:businessDate dateFormat:@"yyyy-MM-dd"];
	
	if ([todayStr isEqualToString:dateStr])
	{
		return @"today";
	}
	else if ([tomorrowStr isEqualToString:dateStr])
	{
		return @"tomorrow";
	}
	else
	{
		return [self stringFromDate:businessDate dateFormat:@"EEEE"];
	}
}

//
// Returns the time zone object identified by a given abbreviation. Returns nil if the given abbreviation is unknown.
//
+ (NSTimeZone*) timeZoneWithAbbreviation:(NSString*)abbr
{
	if (abbr != nil)
	{
		abbr = [abbr uppercaseString];
		
		NSTimeZone* toReturn = nil;
		
		if ([abbr isEqualToString:@"PST"] || [abbr isEqualToString:@"PDT"]) // [PST] -> [America/Los_Angeles]
		{
			toReturn = [NSTimeZone timeZoneWithName:@"America/Los_Angeles"];
		}
		else if ([abbr isEqualToString:@"MST"] || [abbr isEqualToString:@"MDT"]) // [MST] -> [America/Denver]
		{
			toReturn = [NSTimeZone timeZoneWithName:@"America/Denver"];
		}
		else if ([abbr isEqualToString:@"CST"] || [abbr isEqualToString:@"CDT"]) // [CST] -> [America/Chicago]
		{
			toReturn = [NSTimeZone timeZoneWithName:@"America/Chicago"];
		}
		else if ([abbr isEqualToString:@"EST"] || [abbr isEqualToString:@"EDT"]) // [EST] -> [America/New_York]
		{
			toReturn = [NSTimeZone timeZoneWithName:@"America/New_York"];
		}
		
		// We still dont have a timezone? Then use the NSTimeZone's static methods.
		if (toReturn == nil)
		{
			toReturn = [NSTimeZone timeZoneWithAbbreviation:abbr];
		}
		if (toReturn == nil)
		{
			toReturn = [NSTimeZone timeZoneWithName:abbr];
		}
		
		return toReturn;
	}
	return nil;
}

//
// Returns the shared/cached timezone object representing GMT.
//
+ (NSTimeZone*) timeZoneGMT
{
	return TIME_ZONE_GMT;
}

//
// Converts the given date in the given timezone to GMT/UTC.
//
+ (NSDate*) convertDateToGMT:(NSDate*)date fromTimeZone:(NSTimeZone*)fromTimeZone
{
	if (TIME_ZONE_GMT != nil)
	{
		return [DateUtil convertDate:(NSDate*)date fromTimeZone:(NSTimeZone*)fromTimeZone toTimeZone:TIME_ZONE_GMT];
	}
	
	return date;
}

//
// Converts the given date specified in one time zone to another time zone. Returns the given date unchanged if any of
// the parameters are invalid.
//
+ (NSDate*) convertDate:(NSDate*)date fromTimeZone:(NSTimeZone*)fromTimeZone toTimeZone:(NSTimeZone*)toTimeZone
{
	if (date != nil && fromTimeZone != nil && toTimeZone != nil)
	{
		NSInteger timeInterval = 0;
		
		// Get the time interval from the date to GMT.
		timeInterval += -([fromTimeZone secondsFromGMT]);
		
		// Next add the time interval from GMT to the target timezone.
		timeInterval += [toTimeZone secondsFromGMT];
		
		// Now convert the date.
		//		if ([date respondsToSelector:@selector(dateByAddingTimeInterval:)])
		//		{
		//			return [date dateByAddingTimeInterval:timeInterval];
		//		}
		return [date dateByAddingTimeInterval:timeInterval];
	}
	
	return date;
}

//
// Returns YES if date1 and date2 are equal. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isEqualToDate:(NSDate*)date2 includeTime:(BOOL)includeTime
{
	if (date1 != nil && date2 != nil)
	{
		if (includeTime)
		{
			return [date1 isEqualToDate:date2];
		}
		else
		{
			NSString* date1Str = [DateUtil stringFromDate:date1 dateFormat:@"yyyy-MM-dd"];
			NSString* date2Str = [DateUtil stringFromDate:date2 dateFormat:@"yyyy-MM-dd"];
			
			return [date1Str isEqualToString:date2Str];
		}
	}
	
	return NO;
}

//
// Returns YES if date1 is earler than date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isEarlierThanDate:(NSDate*)date2 includeTime:(BOOL)includeTime
{
	if (date1 != nil && date2 != nil)
	{
		if (includeTime)
		{
			return ([date1 compare:date2] == NSOrderedDescending);
		}
		else
		{
			NSDate *d1 = [DateUtil getDateByIgnoringTimeComponant:date1];  // for debugging
			NSDate *d2 = [DateUtil getDateByIgnoringTimeComponant:date2];
			return ([d1 compare:d2] == NSOrderedAscending);
			
			//return ([[DateUtil getDateByIgnoringTimeComponant:date1] compare:[DateUtil getDateByIgnoringTimeComponant:date2]] == NSOrderedAscending);
		}
	}
	
	return NO;
}

//
// Returns YES if date1 is earler than or equat to date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isEarlierOrEqualToDate:(NSDate*)date2 includeTime:(BOOL)includeTime
{
	
	if( [DateUtil date:date1 isEqualToDate:date2 includeTime:includeTime] )
	{
		return YES;
	}
	else if ([DateUtil date:date1 isEarlierThanDate:date2 includeTime:includeTime])
	{
		return YES;
	}
	
	
	return NO;
}

//
// Returns YES if date1 is later than date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isLaterThanDate:(NSDate*)date2 includeTime:(BOOL)includeTime
{
	if (date1 != nil && date2 != nil)
	{
		if (includeTime)
		{
			return ([date1 compare:date2] == NSOrderedDescending);
		}
		else
		{
			NSDate *d1 = [DateUtil getDateByIgnoringTimeComponant:date1];  // for debugging
			NSDate *d2 = [DateUtil getDateByIgnoringTimeComponant:date2];
			return ([d1 compare:d2] == NSOrderedDescending);
			
			// return ([[DateUtil getDateByIgnoringTimeComponant:date1] compare:[DateUtil getDateByIgnoringTimeComponant:date2]] == NSOrderedAscending);
		}
	}
	
	return NO;
}

//
// Returns YES if date1 is earler than or equat to date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isLaterOrEqualToDate:(NSDate*)date2 includeTime:(BOOL)includeTime
{
	
	if( [DateUtil date:date1 isEqualToDate:date2 includeTime:includeTime] )
	{
		return YES;
	}
	else if ([DateUtil date:date1 isLaterThanDate:date2 includeTime:includeTime])
	{
		return YES;
	}
	
	
	return NO;
}

+ (NSInteger) getDayOfWeekForDate:(NSDate *)date {
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
	long dayOfWeek = [components weekday];
	return dayOfWeek;
}

+ (NSInteger) noOfDaysBetween:(NSDate*)fromDate toDate:(NSDate*)toDate
{
	if ([fromDate isEqualToDate:toDate])
		return 0;
	
	NSCalendar * gregorian =[NSCalendar currentCalendar];
	
	NSDate * dateToRound = [fromDate earlierDate:toDate];
	int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit);
	NSDateComponents * dateComponents =
	[gregorian components:flags fromDate:dateToRound];
	
	
	NSDate * roundedDate = [gregorian dateFromComponents:dateComponents];
	
	NSDate * otherDate = (dateToRound == fromDate) ? toDate : fromDate ;
	
	NSInteger diff = abs([roundedDate timeIntervalSinceDate:otherDate]);
	
	NSInteger daysDifference = floor(diff/(24 * 60 * 60));
	
	return daysDifference;
}

+ (NSArray *) getRangeOfDays:(NSDate*)fromDate toDate:(NSDate*)toDate
{
	NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSMutableArray *dayArray = [[NSMutableArray alloc] initWithCapacity:1];
	
	NSCalendarUnit dateComponentsMask = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* dateComponents = [gregorianCalendar components: dateComponentsMask fromDate: fromDate];
	dateComponents.hour = 0;
	dateComponents.minute = 0;
	dateComponents.second = 0;
	NSDate *day = [[NSCalendar currentCalendar] dateFromComponents: dateComponents];
	[dayArray addObject:day];
	
	NSDateComponents *components = [[NSDateComponents alloc] init];
	
	NSInteger lastDMN = [DateUtil noOfDaysBetween:fromDate toDate:toDate];
	for (int i = 1; i <= lastDMN; i++)
	{
		[components setDay: i];
		NSDate *Day = [gregorianCalendar dateByAddingComponents: components toDate: fromDate options: 0];
		[dayArray addObject:Day];
	}
	return (NSArray *)dayArray;
}

+ (BOOL) isInCurrentMonth:(NSDate*)calDate dateToCheck:(NSDate*)chkDate
{
	NSCalendar* gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *calComp = [gregorianCalendar components: (NSMonthCalendarUnit) fromDate: calDate];
	NSInteger calMonth = [calComp month];
	NSInteger calYear = [calComp year];
	NSDateComponents *chkComp = [gregorianCalendar components: (NSMonthCalendarUnit) fromDate: chkDate];
	NSInteger chkMonth = [chkComp month];
	NSInteger chkYear = [chkComp year];
	
	
	if(calYear == chkYear )
	{
		if( calMonth == chkMonth)
			return YES;
		else
			return NO;
	}
	else
		return NO;
}

@end
