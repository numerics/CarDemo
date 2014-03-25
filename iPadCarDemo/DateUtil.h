//
//  DateUtil.h
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.



@interface DateUtil : NSObject
{

}

// The number of seconds in one day.
#define SECONDS_PER_DAY 86400
+ (NSDate*) getDateByIgnoringTimeComponant:(NSDate*)date;

//
// Based on the current date/time returns the date of the this coming monday at exactly 12:00 AM.
//
+ (NSDate*) nextMonday;

//
// Based on the current date/time returns the date of the first day of the present year.
//
+ (NSDate*) firstDayOfYear;

//
// Based on the current date/time returns the date of the last day of the present year.
//
+ (NSDate*) lastDayOfYear;

//
// Based on the current date/time returns the date of the first day of the Calendar year.
//
+ (NSDate*) firstDayOfCalendarYear;

//
// Based on the current date/time returns the date of the last day of the Calendar year.
//
+ (NSDate*) lastDayOfCalendarYear;

//
// Based on the current date returns the date of the first day of the present month.
//
+ (NSDate*) firstDayOfMonth;

//
// Based on the current date returns the date of the last day of the present month.
//
+ (NSDate*) lastDayOfMonth;

//
// Based on the current date returns the date of the first day of the present Week.
//
+ (NSDate*) firstDayOfWeek;

//
// Based on the current date returns the date of the last day of the present Week.
//
+ (NSDate*) lastDayOfWeek;

//
// Based on the current date returns the date of the first day of the present quarter.
//
+ (NSDate*) firstDayOfQuarter;

//
// Based on the current date returns the date of the last day of the present quarter.
//
+ (NSDate*) lastDayOfQuarter;

//
// Based on the current date returns the date of the first day of the Calendar quarter.
//
+ (NSDate*) firstDayOfCalendarQuarter;

//
// Based on the current date returns the date of the last day of the Calendar quarter.
//
+ (NSDate*) lastDayOfCalendarQuarter;

//
// Converts the given NSString into an NSDate using the given date pattern string.
//
+ (NSDate*) dateFromString:(NSString*)str dateFormat:(NSString*)dateFormat defaultDate:(NSDate*)defaultDate;

//
// Converts the given NSDate into an NSString using the given date pattern string.
//
+ (NSString*) stringFromDate:(NSDate*)date dateFormat:(NSString*)dateFormat;

//
// Converts the given business date into the "friendly" day of the week. E.g., "Today", "Tomorrow", "Wednesday", etc.
//
+ (NSString*) businessDateDayOfWeek:(NSDate*)businessDate;

//
// Returns the time zone object identified by a given abbreviation. Returns nil if the given abbreviation is unknown.
//
+ (NSTimeZone*) timeZoneWithAbbreviation:(NSString*)abbr;

//
// Returns the shared/cached timezone object representing GMT.
//
+ (NSTimeZone*) timeZoneGMT;

//
// Converts the given date in the given timezone to GMT/UTC.
//
+ (NSDate*) convertDateToGMT:(NSDate*)date fromTimeZone:(NSTimeZone*)fromTimeZone;

//
// Converts the given date specified in one time zone to another time zone. Returns the given date unchanged if any of
// the parameters are invalid.
//
+ (NSDate*) convertDate:(NSDate*)date fromTimeZone:(NSTimeZone*)fromTimeZone toTimeZone:(NSTimeZone*)toTimeZone;

//
// Returns YES if date1 is later than date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
//
+ (BOOL) date:(NSDate*)date1 isLaterThanDate:(NSDate*)date2 includeTime:(BOOL)includeTime;

//
// Returns YES if date1 is earler than date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isEarlierThanDate:(NSDate*)date2 includeTime:(BOOL)includeTime;


// Returns YES if date1 and date2 are equal. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isEqualToDate:(NSDate*)date2 includeTime:(BOOL)includeTime;

//
// Returns YES if date1 is earler than or equat to date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isEarlierOrEqualToDate:(NSDate*)date2 includeTime:(BOOL)includeTime;

//
// Returns YES if date1 is earler than or equat to date2. If includeTime is YES then the time component
// of each date is checked as well, otherwise only the date/day is compared.
//
+ (BOOL) date:(NSDate*)date1 isLaterOrEqualToDate:(NSDate*)date2 includeTime:(BOOL)includeTime;

+(NSInteger) lengthOfMonth:(NSDate*)date;

+ (NSInteger) getDayOfWeekForDate:(NSDate *)date;
+ (NSInteger) noOfDaysBetween:(NSDate*)fromDate toDate:(NSDate*)toDate;
+ (NSArray *) getRangeOfDays:(NSDate*)fromDate toDate:(NSDate*)toDate;
+ (BOOL) isInCurrentMonth:(NSDate*)calDate dateToCheck:(NSDate*)chkDate;
@end
