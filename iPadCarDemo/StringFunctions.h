//
//  StringFunctions.h
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.
//



@interface StringFunctions : NSObject
{

}

//
// Tests if the given input is an empty string and, if so, returns defaultStr,
// otherwise param input is returned unchanged.
//
+ (NSString*) emptyStringDefault:(NSString*)input defaultStr:(NSString*)defaultStr;

//
// Returns true if the given string is empty after trimming.
//
+(BOOL)isEmptyStringTrimmed:(NSString *)str;

//
// Returns true if the given string is empty.
//
+ (BOOL) isEmptyString:(NSString *)str;

//
// Returns a new string with whitespace character set trimmed from both ends.
//
+(NSString *)trim:(NSString *)str;

//
// Returns true if the two strings are equal ignoring case and after trimming.
//
+(BOOL)equalsIgnoreCaseTrim:(NSString *)str1 str2:(NSString *)str2;

//
// Returns true if the two strings are equal ignoring case.
//
+ (BOOL) equalsIgnoreCase:(NSString *)str1 str2:(NSString *)str2;

+ (NSUInteger)wordCount:(NSString *) string;
+ (NSUInteger) countWords: (NSString *) string;
+ (NSString*) getWordByCount:(NSString*)string WordNumber:(int)wn;
//
// Replaces all "bad" characters in the given string with the given replacement.
// "Bad" characters are control characters, illegal characters and tabs.
// However spaces and newlines are allowed.
//
+ (NSString*) string:(NSString*)string byReplacingBadCharactersWithString:(NSString*)replacement;


//
// Strip HTML tags from the given string.
//
+ (NSString*) stripHtmlCodes:(NSString*) string;

//
// Strip HTML tags from the given string.
//
+ (NSString*) stripHtmlCodesWithFormatting:(NSString*) string;

//
// Decodes any HTML entities contained within the string.
//
//+ (NSString*) stringWithHTMLEntitiesDecoded:(NSString*)input;

//
// Unescape & command strings... 
//
+ (NSString*) unescape:(NSString*)string;

//
// Replaces the non-alphanumeric characters in the given string with the replacement string.
//
+ (NSString*) replaceNonAlphanumericChars:(NSString*)str withString:(NSString*)replacement;

//
// Replaces the non-numeric characters in the given string with the replacement string.
//
+ (NSString*) replaceNonNumericChars:(NSString*)str withString:(NSString*)replacement;

//
// Converts the given object to a string.
//
+ (NSString*) convertString:(NSObject*)obj defaultString:(NSString*)defaultString;

//
// Returns true if the given string is numeric.
//
+ (BOOL) isNumeric:(NSString*)str;

//
// Converts the given object to an integer.
//
+ (NSInteger) convertInt:(NSObject*)obj defaultInt:(NSInteger)defaultInt;

//
// Converts the given object to a float.
//
+ (CGFloat) convertFloat:(NSObject*)obj defaultFloat:(CGFloat)defaultFloat;

//
// Converts the given object to an NSDate.
//
+ (NSDate*) convertDate:(NSObject*)obj dateFormat:(NSString*)dateFormat defaultDate:(NSDate*)defaultDate;

//
// Converts the given object to a BOOL.
//
+ (BOOL) convertBool:(NSObject*)obj defaultBool:(BOOL)defaultBool;

//
// Converts a BOOL to its string representation.
//
+ (NSString*) convertBoolToString:(BOOL)aBool;

//
// Converts a CGRect to its string representation.
//
+ (NSString*) convertRectToString:(CGRect)aRect;

//
// Converts a CGSize to its string representation.
//
+ (NSString*) convertSizeToString:(CGSize)aSize;

//
// Returns YES if the given object is empty.
//
+ (BOOL) isEmpty:(id)obj;

//
// Returns YES if the given array is empty.
//
+ (BOOL) isEmptyArray:(NSArray*)array;

//
// Returns YES if the given dictionary is empty.
//
+ (BOOL) isEmptyDictionary:(NSDictionary*)dictionary;

//
// Returns YES if the given data is empty.
//
+ (BOOL) isEmptyData:(NSData*)data;

//
// Simply passes the parameters to DebugLog if DEBUG_LOG_ENABLED is true.
//
//void DebugLog(NSString* format, ...);

@end
