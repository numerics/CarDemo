//
//  abstractionTool.m
//  ChinUp
//
//  Created by John Basile on 7/17/12.
//  Copyright (c) 2012 Numerics, All rights reserved.
//

#import "abstractionTool.h"
#import "UIUtil.h"
#import "StringFunctions.h"
#import <objc/runtime.h>

@implementation abstractionTool


static const char * getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL)
    {
        if (attribute[0] == 'T' && attribute[1] != '@')
        {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
        {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@')
        {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

+ (void)createCommonPlistforController:(NSString *)nibName fileName:(NSString *)fileName prefix:(NSString *)prefix
{
    Class clazz = nil;
    UIViewController *instance = nil;
    NSString *properNib = [nibName stringByDeletingPathExtension];
    NSString *properName = [[nibName substringFromIndex:2] stringByDeletingPathExtension];			// The Abstracted ViewController Name
	NSMutableDictionary *targetDict = [[NSMutableDictionary alloc] initWithCapacity:0];

    NSMutableDictionary *controllerDict = [[NSMutableDictionary alloc] initWithCapacity:0];			// Create a Controller Dictionary
    
    [targetDict setObject:controllerDict forKey:properName ];										// eg: would be "AboutViewController" Dictionary
    NSMutableDictionary *AppDict = [[NSMutableDictionary alloc] initWithCapacity:0];				// create Application Dictionary based on the Prefix
    [controllerDict setObject:AppDict forKey:prefix];
    
    if( ![properNib isEqualToString:@"CHDayViewController"] && ![properNib isEqualToString:@"CHCalendarViewController"] &&
       ![properNib isEqualToString:@"CHPhotosViewController"] && ![properNib isEqualToString:@"CHPhotoPreviewViewController"] &&
       ![properNib isEqualToString:@"CHMyProgramsViewController"] && ![properNib isEqualToString:@"SkmFBConnectViewController"] &&
       ![properNib isEqualToString:@"UISkmMediaDetailsViewController"] && ![properNib isEqualToString:@"SkmTwitterTweetViewController"] && ![properNib isEqualToString:@"CHMainWindowViewController"])
    {
        clazz = [NSClassFromString(properNib) class];
        NSLog(@"ViewController: %@", clazz); //
        instance = [[clazz alloc] initWithNibName:properNib bundle:nil];
        if( instance )
        {
            [[NSBundle mainBundle] loadNibNamed:properNib owner:instance options:nil];
            
            unsigned int propertyCount = 0;
            objc_property_t *properties = class_copyPropertyList([clazz class], &propertyCount);
            NSMutableArray *arrNames = [NSMutableArray array];
            NSMutableArray *arrTypes = [NSMutableArray array];
            for (unsigned int i = 0; i < propertyCount; ++i)
            {
                objc_property_t property = properties[i];
                const char * name = property_getName(property);
                if( name)
                {
                    [arrNames addObject:[NSString stringWithUTF8String:name]];
                    const char *propType = getPropertyType(property);
                    NSString *pType = [NSString stringWithUTF8String:propType];
                    if( pType )
                        [arrTypes addObject:pType];
                    else
                        [arrTypes addObject:@""];
                }
            }
            free(properties);
            [AppDict setObject:@"" forKey:@"backgroundColor"];
            [AppDict setObject:@"" forKey:@"backgroundImage"];
            
            for (int i = 0; i < [arrNames count]; i++)
            {
                NSString* pName = [arrNames objectAtIndex:i];
                NSString* tName = [arrTypes objectAtIndex:i];
                if( [tName isEqualToString:@"UITextView"] || [tName isEqualToString:@"UILabel"] || [tName isEqualToString:@"UITextField"] )
                {
                    UILabel *label = [instance valueForKey:pName];
                    NSString *text = label.text;
                    ( text) ? [AppDict setObject:text forKey:pName ]: [AppDict setObject:@"" forKey:pName ];
                }
                else if( [tName isEqualToString:@"UIButton"] )
                {
                    UIButton *ib = (id)[instance valueForKey:pName];
                    NSString *source = ib.titleLabel.text;
                    ( source) ? [AppDict setObject:source forKey:pName ] : [AppDict setObject:@"" forKey:pName ] ;
                }
                else if([tName isEqualToString:@"UIImageView"] || [tName isEqualToString:@"UIImage"])
                {
                    //UIImageView *im = (id)[instance valueForKey:pName];
                    [AppDict setObject:@"" forKey:pName ];
                }
            }
        }
    }
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
	
	NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:targetDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData)
        [plistData writeToFile:plistPath atomically:YES];
   
}

+ (void)createCommonPlistforApp:(NSString *)fileName prefix:(NSString *)prefix
{
    Class clazz = nil;
    UIViewController *instance = nil;    
	
	NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
	NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH 'ViewController.nib' && self BEGINSWITH 'CH'"];
	NSArray *onlyVC1 = [dirContents filteredArrayUsingPredicate:fltr];
    
	NSString *nibPath = [bundleRoot stringByAppendingPathComponent:@"en.lproj/"];
	NSArray *enContents = [fm contentsOfDirectoryAtPath:nibPath error:nil];
	NSArray *onlyVC2 = [enContents filteredArrayUsingPredicate:fltr];
	NSArray *onlyVC = [onlyVC1 arrayByAddingObjectsFromArray:onlyVC2];
	NSMutableDictionary *targetDict = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	for( NSString *nibName in onlyVC)
	{
		NSString *properNib = [nibName stringByDeletingPathExtension];
		NSString *properName = [[nibName substringFromIndex:2] stringByDeletingPathExtension];			// The Abstracted ViewController Name
		NSMutableDictionary *controllerDict = [[NSMutableDictionary alloc] initWithCapacity:0];			// Create a Controller Dictionary
		[targetDict setObject:controllerDict forKey:properName ];										// eg: would be "AboutViewController" Dictionary
        // now create a Dictionary for every Product
		NSMutableDictionary *AppDict = [[NSMutableDictionary alloc] initWithCapacity:0];				// create Application Dictionary based on the Prefix
		[controllerDict setObject:AppDict forKey:prefix];
		
		if( ![properNib isEqualToString:@"CHDayViewController"] && ![properNib isEqualToString:@"CHCalendarViewController"] && ![properNib isEqualToString:@"InstructionsViewController"] &&
           ![properNib isEqualToString:@"CHPhotosViewController"] && ![properNib isEqualToString:@"CHPhotoPreviewViewController"] && ![properNib isEqualToString:@"InstructionListViewController"] &&
           ![properNib isEqualToString:@"CHMyProgramsViewController"] && ![properNib isEqualToString:@"SkmFBConnectViewController"] &&
           ![properNib isEqualToString:@"UISkmMediaDetailsViewController"] && ![properNib isEqualToString:@"SkmTwitterTweetViewController"] && ![properNib isEqualToString:@"CHMainWindowViewController"])
		{
			clazz = [NSClassFromString(properNib) class];
            if( [properNib isEqualToString:@"CHProfileViewController"])
            {
                NSLog(@"ViewController: %@", clazz); //
                
            }
            NSLog(@"ViewController: %@", clazz); // 
			instance = [[clazz alloc] initWithNibName:properNib bundle:nil];
            if( instance )
            {
                [[NSBundle mainBundle] loadNibNamed:properNib owner:instance options:nil];
                
                unsigned int propertyCount = 0;
                objc_property_t *properties = class_copyPropertyList([clazz class], &propertyCount);
                NSMutableArray *arrNames = [NSMutableArray array];
                NSMutableArray *arrTypes = [NSMutableArray array];
                for (unsigned int i = 0; i < propertyCount; ++i)
                {
                    objc_property_t property = properties[i];
                    const char * name = property_getName(property);
                    if( name)
                    {
                        [arrNames addObject:[NSString stringWithUTF8String:name]];
                        const char *propType = getPropertyType(property);
                        NSString *pType = [NSString stringWithUTF8String:propType];
                        if( pType )
                            [arrTypes addObject:pType];
                        else
                            [arrTypes addObject:@""];
                    }
                }
                free(properties);
                [AppDict setObject:@"" forKey:@"backgroundColor"];
                [AppDict setObject:@"" forKey:@"backgroundImage"];
                
                for (int i = 0; i < [arrNames count]; i++)
                {
                    NSString* pName = [arrNames objectAtIndex:i];
                    NSString* tName = [arrTypes objectAtIndex:i];
                    if( [tName isEqualToString:@"UITextView"] || [tName isEqualToString:@"UILabel"] || [tName isEqualToString:@"UITextField"] )
                    {
                        UILabel *label = [instance valueForKey:pName];
                        NSString *text = label.text;
                        ( text) ? [AppDict setObject:text forKey:pName ]: [AppDict setObject:@"" forKey:pName ];
                    }
                    else if( [tName isEqualToString:@"UIButton"] )
                    {
                        UIButton *ib = (id)[instance valueForKey:pName];
                        NSString *source = ib.titleLabel.text;
                        ( source) ? [AppDict setObject:source forKey:pName ] : [AppDict setObject:@"" forKey:pName ] ;
                    }
                    else if([tName isEqualToString:@"UIImageView"] || [tName isEqualToString:@"UIImage"])
                    {
                        //UIImageView *im = (id)[instance valueForKey:pName];
                        [AppDict setObject:@"" forKey:pName ];
                    }
                }
            }
		}
	}
	
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
	
	NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:targetDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData)
        [plistData writeToFile:plistPath atomically:YES];
	
}


@end
