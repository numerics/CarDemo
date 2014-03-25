//
//  UIFactory.m
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFactory.h"
#import "UIUtil.h"
#import "StringFunctions.h"
#import <objc/runtime.h>
#import "NSString+Additions.h"
#import "UIDevice+Additions.h"

@interface UIFactory()

@property (nonatomic, strong) UILabel* titleLabelPrototypeLarge;
@property (nonatomic, strong) UILabel* titleLabelPrototypeSmall;
@property (nonatomic ) BOOL iPad;

@end

@implementation UIFactory

@synthesize appPrefix,backgroundColor,commonDict,abstractObjects;
@synthesize dividerImage,appProduct;

@synthesize titleLineHeightLarge;
@synthesize titleLineHeightSmall;
@synthesize titleMaxHeight;

@synthesize loadingBackgroundImage;
@synthesize appSuffix,iPad;

@synthesize linkColorNormal, linkColorHighlight, greyTextColor, lightGreyTextColor;

static UIFactory* UI_FACTORY_INSTANCE = nil;

static CGFloat xiPadScale = 2.40;
static CGFloat yiPadScale = 2.48;


//
// Class initializer. Called only once before the class receives its first message.
//
+ (void)initialize
{
	UI_FACTORY_INSTANCE  = [[UIFactory alloc] init];
}

- (id)init
{
	if (self = [super init])
	{
        if( ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad))
        {
            self.appSuffix = @"_iPad";
            self.iPad = YES;
        }
        else
        {
            self.appSuffix = nil;
            self.iPad = NO;
        }
		
		self.appPrefix = @"CD";//[[NSBundle mainBundle] objectForInfoDictionaryKey: @"APP_PREFIX"];
		self.appProduct = @"CD";//[[NSBundle mainBundle] objectForInfoDictionaryKey: @"APP_PRODUCT"];
//        self.abstractObjects = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"AbstractObjects" ofType:@"plist"]];
//        self.commonDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Common" ofType:@"plist"]];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bkg_light"]];
		
		self.dividerImage = [UIImage imageNamed:@"divider_horizontal.png"];
		self.linkColorNormal    = [UIColor colorWithRed:(39.0 / 255.0) green:(86.0 / 255.0) blue:(179.0 / 255.0) alpha:1.0f];
		self.linkColorHighlight = [UIColor colorWithRed:0.30f green:0.70f blue:1.0f alpha:1.0f];
		self.greyTextColor	    = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.0f];
		self.lightGreyTextColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.0f];
		
		self.titleLabelPrototypeLarge = [self labelWithColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:21.0 bold:NO];
		self.titleLabelPrototypeSmall = [self labelWithColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:18.0 bold:NO];
        [self createColorDictionary];
        [self createFontDictionary];
        [self createFontColorDictionary];
	}
	
	return self;
}

//
// Returns the singleton reference to the UIFactory.
//
+ (UIFactory*) sharedInstance
{
	return UI_FACTORY_INSTANCE;
}

+ (NSDictionary *) dictionaryFromPlistWithBaseName: (NSString *) aBaseName
{
    NSString *fullName = [NSString stringWithFormat: @"%@.plist", aBaseName];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    
    plistPath = [bundlePath stringByAppendingPathComponent: fullName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource: aBaseName ofType: @"plist"];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath: plistPath];
    NSDictionary *propertiesDictionary = (NSDictionary *)[NSPropertyListSerialization propertyListFromData: plistXML
                                                                                          mutabilityOption: NSPropertyListMutableContainersAndLeaves
                                                                                                    format: &format
                                                                                          errorDescription: &errorDesc];
    
    
    return propertiesDictionary;
}
- (UIColor *)grayColor:(CGFloat)gray alpha:(CGFloat)alpha
{
    return ([UIColor colorWithRed:(gray/255.0) green:(gray/255.0) blue:(gray/255.0) alpha:alpha]);
}

- (UIColor *) colorAtKey: (NSString *) keyName
{
    return [_colorDictionary objectForKey: keyName];
}

- (UIFont *) fontAtKey: (NSString *) keyName
{
    return [_fontDictionary objectForKey: keyName];
}

- (UIColor *) fontColorAtKey: (NSString *) keyName
{
    return [_fontColorDictionary objectForKey: keyName];
}

- (UIImage *) imageAtKey: (NSString *) keyName
{
    return [_imageDictionary objectForKey: keyName];
}

// This isn't actually required to be a string, but we are *probably* only
// going to have strings in the plist dictionary.
- (NSString *) stringAtKey: (NSString *) keyName
{
    if (_propertiesDictionary) {
        if ([_propertiesDictionary isKindOfClass: [NSDictionary class ]])
        {
            return [_propertiesDictionary objectForKey: keyName];
        }
        else
        {
            NSLog(@"[%@] *** ERROR *** -- properties dictionary is not a dictionary, it is a %@", self.class, [_propertiesDictionary class ]);
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

/*
 *  Returns a UIColor from a given hex string representation of a color (RGB).
 *  Assumptions:
 *      - 6 characters in string (RGB format)
 *      - no 0x in front of the string
 */
- (UIColor *) colorFromHexString: (NSString *) hexString
{
    UIColor *color = [UIColor blackColor];
    
    if (!hexString)
    {
        return color;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString: hexString];
    [scanner setCharactersToBeSkipped: [NSCharacterSet characterSetWithCharactersInString: @"#"]];
    
    unsigned int value = 0;
    if ([scanner scanHexInt: &value])
    {
        int red = (value >> 16) & 0xFF;
        int green = (value >> 8) & 0xFF;
        int blue = value & 0xFF;
        color = [UIColor colorWithRed: red / 255.0 green: green / 255.0 blue: blue / 255.0 alpha: 1.0];
    }
    
    return color;
}

- (void) setBundle: (NSString *) aBundle
{
    _bundleName = aBundle;
}

- (NSString *) setBundleName: (NSString *) keyName
{
    return @"Bundle Name";
}

#pragma mark -
#pragma mark Create Dictionaries

- (void) createColorDictionary
{
    if (_colorDictionary == nil)
    {
        _colorDictionary = [NSMutableDictionary dictionary];
    }
    [_colorDictionary setObject: [UIColor blackColor] forKey: @"Black"];
    [_colorDictionary setObject: [UIColor whiteColor] forKey: @"White"];
    [_colorDictionary setObject: [UIColor blueColor]  forKey: @"Blue"];
    
    [_colorDictionary setObject: [UIColor colorWithRed: 50.0f / 255.0f green: 50.0f / 255.0f blue: 50.0f / 255.0f alpha: 1] forKey: @"Dark Gray"];
    [_colorDictionary setObject: [UIColor colorWithRed: 95.0f / 255.0f green: 95.0f / 255.0f blue: 95.0f / 255.0f alpha: 1] forKey: @"Gray"];
    [_colorDictionary setObject: [UIColor colorWithRed: 150.0f / 255.0f green: 150.0f / 255.0f blue: 150.0f / 255.0f alpha: 1] forKey: @"Light Gray"];
    [_colorDictionary setObject: [UIColor colorWithRed: 224.0f / 255.0f green: 224.0f / 255.0f blue: 224.0f / 255.0f alpha: 1] forKey: @"Gray Cell"];
    [_colorDictionary setObject: [UIColor colorWithRed: 236.0f / 255.0f green: (236.0f / 255.0f) blue: (236.0f / 255.0f) alpha: 1] forKey: @"Bone"];
    [_colorDictionary setObject: [UIColor colorWithRed: 38.0f / 255.0f green: (38.0f / 255.0f) blue: (38.0f / 255.0f) alpha: 1] forKey: @"Cell Background"];
    [_colorDictionary setObject: [UIColor colorWithRed: 27.0f / 255.0f green: (27.0f / 255.0f) blue: (27.0f / 255.0f) alpha: 1] forKey: @"defaultDayBkgColor"];
}

- (void) createFontDictionary
{
    if (_fontDictionary == nil)
    {
        _fontDictionary = [NSMutableDictionary dictionary];
    }
    CGFloat y = (self.iPad) ? yiPadScale : 1.0;
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*10] forKey: @"HB10"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*11] forKey: @"HB11"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*12] forKey: @"HB12"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*13] forKey: @"HB13"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*14] forKey: @"HB14"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*15] forKey: @"HB15"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*16] forKey: @"HB16"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*18] forKey: @"HB18"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*22] forKey: @"HB22"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*27] forKey: @"HB27"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*28] forKey: @"HB28"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica-Bold" size: y*34] forKey: @"HB34"];
	
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*10] forKey: @"H10"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*11] forKey: @"H11"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*13] forKey: @"H13"];
	[_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*14] forKey: @"H14"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*15] forKey: @"H15"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*16] forKey: @"H16"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*18] forKey: @"H18"];
    [_fontDictionary setObject: [UIFont fontWithName: @"Helvetica" size: y*20] forKey: @"H20"];
    
}

- (void) createFontColorDictionary
{
    if (_fontColorDictionary == nil)
    {
        _fontColorDictionary = [NSMutableDictionary dictionary];
    }
    
    //*************************************************************************************
    // NOTE: Fonts here match up with the GDS, hence the naming convention used
    //*************************************************************************************
    
    UIColor *percent60Black = [UIColor colorWithRed: 0.6 green: 0.6 blue: 0.6 alpha: 1.0];
    UIColor *percent75Black = [UIColor colorWithRed: 0.75 green: 0.75 blue: 0.75 alpha: 1.0];
    UIColor *primary = [UIColor colorWithRed: 0.4 green: 0.625 blue: 0.766 alpha: 1.0];
    UIColor *white = [UIColor whiteColor];
    UIColor *black = [UIColor blackColor];
    
    
    [_fontColorDictionary setObject: percent60Black forKey: @"HB10"];
    [_fontColorDictionary setObject: percent75Black forKey: @"HB11"];
    [_fontColorDictionary setObject: black forKey: @"HB12"];
    
    
    [_fontColorDictionary setObject: percent60Black forKey: @"HB13"];
    [_fontColorDictionary setObject: percent60Black forKey: @"HB14"];
    
    
    [_fontColorDictionary setObject: black forKey: @"HB15"];
    [_fontColorDictionary setObject: percent75Black forKey: @"HB16"];
    [_fontColorDictionary setObject: black forKey: @"HB18"];
    
    
    [_fontColorDictionary setObject: white forKey: @"HB22"];
    [_fontColorDictionary setObject: primary forKey: @"HB27"];
    [_fontColorDictionary setObject: black forKey: @"HB28"];
    [_fontColorDictionary setObject: white forKey: @"HB34"];
    
    
    [_fontColorDictionary setObject: black forKey: @"H10"];
    [_fontColorDictionary setObject: percent75Black forKey: @"H11"];
    [_fontColorDictionary setObject: primary forKey: @"H13"];
    
    
    [_fontColorDictionary setObject: white forKey: @"H14"];
    [_fontColorDictionary setObject: percent75Black forKey: @"H15"];
    
    
    [_fontColorDictionary setObject: black forKey: @"H16"];
    
    
    [_fontColorDictionary setObject: percent60Black forKey: @"H18"];
    [_fontColorDictionary setObject: black forKey: @"H20"];
}

#pragma mark -
#pragma mark background Color Methods

- (UIImage *)viewBackground
{
    UIImage *image = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? [UIImage imageNamed:@"background-568h"] : [UIImage imageNamed:@"background"];
	
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}


- (UIImage *)viewBackgroundForOrientation:(UIInterfaceOrientation)orientation
{
    UIImage *image;
    if (UIInterfaceOrientationIsPortrait(orientation))
	{
        image = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? [UIImage imageNamed:@"background-568h"] : [UIImage imageNamed:@"background"];
    } else
	{
        image = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? [UIImage imageNamed:@"backgroundLandscape-568h"] : [UIImage imageNamed:@"backgroundLandscape"];
    }
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = @"navigationBackground";
    if (metrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 8.0, 10.0, 8.0)];
    
    CGFloat height = 64;
    CGFloat width = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 320 : (metrics == UIBarMetricsLandscapePhone ? 1024 : 768);
    UIImage *bottomImage = metrics == UIBarMetricsLandscapePhone ? [self viewBackgroundForOrientation:UIInterfaceOrientationLandscapeLeft] : [self viewBackground];
    
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext( newSize );
    
    [bottomImage drawInRect:CGRectMake(0, 0, newSize.width, bottomImage.size.height)];
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)navigationBackgroundForIPadAndOrientation:(UIInterfaceOrientation)orientation
{
    NSString *name = @"navigationBackgroundRight";
    if (UIInterfaceOrientationIsLandscape(orientation))
	{
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

#pragma mark -
#pragma mark Plist Parsing Methods

-(NSDictionary *) getTargetDict:(NSString *)viewController
{
    NSDictionary *viewItem = [self.commonDict objectForKey:viewController];
    NSDictionary *target = [viewItem objectForKey:self.appPrefix];
    return target;
}


-(NSString *) getClassTitle:(NSString *)viewController
{
    NSString *newViewController = nil;
    NSDictionary *targetDict = [self getTargetDict:viewController];
    
    newViewController = [targetDict objectForKey:@"sClass"];
    if( newViewController)
        return newViewController;
    else
        return viewController;
}

-(id) loadClazz:(NSString *)viewController
{
    NSString *newViewController = [self getClassTitle:viewController];
    Class clazz = nil;
    
    if( newViewController)
        clazz = [NSClassFromString(newViewController) class];
    else
        clazz = [NSClassFromString(viewController) class];
    
    return clazz;
}

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
			return ""; // dont want primitives
            //return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
        {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@')
        {
            // it's another ObjC object type:
            char *answer = (char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
			answer[(strlen(attribute) - 4)]  = 0;
            return answer;
        }
    }
    return "";
}

-(NSString *)inspectPropertyType:(objc_property_t) property
{
	const char *attributes = property_getAttributes(property);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL)
	{
		if (attribute[0] == 'T' && attribute[1] != '@')
		{
			// it's a C primitive type:
			return @""; // dont want primitives
		}
		else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
		{
			// it's an ObjC id type:
			return @"id";
		}
		else if (attribute[0] == 'T' && attribute[1] == '@')
		{
			// it's another ObjC object type:
//			NSString *type = [[NSString alloc] initWithUTF8String:&attribute[2]];
//			NSString *type2 = [StringFunctions string:type byReplacingBadCharactersWithString:@"\""];
			NSString *type = [[[NSString alloc] initWithUTF8String:&attribute[2]] stringByReplacingOccurrencesOfString:@"\"" withString:@""];

			return type;
		}
	}
	return @"";
}

-(id) loadProperty: (NSString*)viewController property:(NSString *)key
{
    NSDictionary *targetDict = [self getTargetDict:viewController];
    return (id)([targetDict objectForKey:key]);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
// removes warning due to ARC not handling PerfomSelector abstraction methods
// See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

-(NSDictionary *)fetchPropertyNamesForKeys: (id)aObj jsonDict:(NSDictionary*)jdict excludeTypes:(NSString *)excluded
{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([aObj class], &propertyCount);
    NSMutableArray *arrNames = [NSMutableArray array];
    NSMutableArray *arrTypes = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        if( name)
        {
            //const char *propType = getPropertyType(property);
			//NSString *pType = [NSString stringWithUTF8String:propType];
			
			NSString *pType = [self inspectPropertyType:property];
			NSString *pName = [NSString stringWithUTF8String:name];
			if( [pType length] > 3 && ![excluded containsString:pType ignoringCase:YES] )
			{
				if( [pType isEqualToString:@"NSString"] || [pType isEqualToString:@"NSNumber"] )
				{
					[arrNames addObject:pName];
					[arrTypes addObject:pType];
				}
				else		// should be another Object to fetch
				{
					id pObj = [aObj valueForKey:pName];
					NSString *classKey = [pObj debugDescription];

					NSDictionary *pDict = [jdict objectForKey:classKey];
					[self addValuesToObjfromJsonDict:pObj jsonDict:pDict excludeTypes:excluded];
				}
			}
        }
    }
    free(properties);
	[dict setObject:arrNames forKey:@"KeyPropNames"];
	[dict setObject:arrTypes forKey:@"KeyPropTypes"];
	
	return dict;
}
#pragma clang diagnostic pop

-(void)addValuesToObjfromJsonDict:(id)aObj jsonDict:(NSDictionary*)dict excludeTypes:(NSString *)excluded
{
	NSDictionary *propertyKeys = [self fetchPropertyNamesForKeys:aObj jsonDict:dict excludeTypes:@"MKObjectView,CLLocationCoordinate2D"];
	
	NSArray *keyNames = [propertyKeys objectForKey:@"KeyPropNames"];
	NSArray *types = [propertyKeys objectForKey:@"KeyPropTypes"];
	for( int i = 0; i < [keyNames count]; i++)
	{
		NSString *keyName = [keyNames objectAtIndex:i];
		NSString *valueType = [types objectAtIndex:i];
		if( [valueType isEqualToString:@"NSString"] )
		{
			NSString *value = [dict objectForKey:keyName];
			if( value )
				[aObj setValue:value forKey:keyName];
		}
		else if ([valueType isEqualToString:@"NSNumber"])
		{
			NSNumber *fvalue = [dict objectForKey:keyName];
			if( fvalue )
				[aObj setValue:fvalue forKey:keyName];
		}
	}
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
// removes warning due to ARC not handling PerfomSelector abstraction methods
// See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

-(void) loadDefaultPropertyValues: (id)aObj
{
    const char * cName = class_getName([aObj class]);
    NSString *objName = [NSString stringWithUTF8String:cName];
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([aObj class], &propertyCount);
    NSMutableArray *arrNames = [NSMutableArray array];
    NSMutableArray *arrTypes = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        if( name)
        {
            const char *propType = getPropertyType(property);
            [arrNames addObject:[NSString stringWithUTF8String:name]];
            [arrTypes addObject:[NSString stringWithUTF8String:propType]];
        }
    }
    free(properties);
    
    NSDictionary *targetDict = [self getTargetDict:objName];
    
    for (int i = 0; i < [arrNames count]; i++)
    {
        NSString* pName = [arrNames objectAtIndex:i];
        id newValue = (id)[targetDict valueForKey:pName];
		if( newValue)
		{
            NSString* tName = [arrTypes objectAtIndex:i];
            if( [tName isEqualToString:@"UITextView"] || [tName isEqualToString:@"UILabel"] || [tName isEqualToString:@"UITextField"])
            {
                [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
            }
            else if ([tName isEqualToString:@"UIImageView"])
            {
                UIImage *im = [UIImage imageNamed: newValue];
                [aObj setValue:im forKeyPath:[NSString stringWithFormat:@"%@.image",pName]];
            }
            else
                [aObj setValue:newValue forKey:pName];
		}
    }
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
// removes warning due to ARC not handling PerfomSelector abstraction methods
// See: http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown

-(void) loadDefaultPropertyValues:(id)aObj ObjectName:(NSString *)objName
{
    Class clazz = nil;
	clazz = [NSClassFromString(objName) class];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([clazz class], &propertyCount);
    NSDictionary *targetDict = [self getTargetDict:objName];
    
    for (unsigned int i = 0; i < propertyCount; ++i)
    {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        if( name)
        {
            NSString* pName = [NSString stringWithUTF8String:name];
            id newValue = (id)[targetDict valueForKey:pName];
            if( newValue)
            {
                const char *attributes = property_getAttributes(property);
                NSString *type = [NSString stringWithUTF8String:attributes];
                if( [type occurencesOfSubstring:@"UITextView"] )
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
                }
                else if( [type occurencesOfSubstring:@"UILabel"])
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
                }
                else if( [type occurencesOfSubstring:@"UITextField"])
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.text",pName]];
                }
                else if( [type occurencesOfSubstring:@"UIImageView"])
                {
                    UIImage *im = [UIImage imageNamed: newValue];
                    [aObj setValue:im forKeyPath:[NSString stringWithFormat:@"%@.image",pName]];
                }
                else if( [type occurencesOfSubstring:@"UIButton"])
                {
                    [aObj setValue:newValue forKeyPath:[NSString stringWithFormat:@"%@.titleLabel.text",pName]];
                }
                else
                {
                    [aObj setValue:newValue forKey:pName];
                }
            }
        }
    }
    free(properties);
}

#pragma clang diagnostic pop
- (void)loadButtonProperties:(NSDictionary *)buttonInfo button:(UIButton *)btn
{
	CGRect rect = CGRectZero;
	id obj = nil;
	
	obj = [buttonInfo objectForKey:@"x"];
	if( obj )										// test if frame is being set
	{
		rect.origin.x = [obj intValue];
		rect.origin.y =  [[buttonInfo objectForKey: @"y"] intValue];
		rect.size.width = [[buttonInfo objectForKey: @"width"] intValue];
		rect.size.height = [[buttonInfo objectForKey: @"height"] intValue];
        if( self.iPad)
        {
            rect = [self CGRectMake:rect CGRectAdjust:kAdjustALLPAD];
        }
		btn.frame = rect;
	}
	
	NSString *imageName = [buttonInfo objectForKey: @"image"];
	if(imageName)
	{
		UIImage *image = [[UIImage imageNamed: imageName] stretchableImageWithLeftCapWidth: 3.5 topCapHeight: 0.0];
		[btn setBackgroundImage:image forState:UIControlStateNormal];
	}
	
	NSString *title = [buttonInfo objectForKey: @"title"];
	if(title)
	{
		[btn setTitle:title forState:UIControlStateNormal];
	}
	
	NSString *color = [buttonInfo objectForKey: @"titleColor"];
	if(color)
	{
		[btn setTitleColor:[self colorAtKey:color] forState:UIControlStateNormal];
	}
	
	NSString *bcolor = [buttonInfo objectForKey: @"backgroundColor"];
	if(bcolor)
	{
		btn.backgroundColor = [self colorAtKey:bcolor];
	}
}

- (void)loadLabelProperties:(NSDictionary *)labelInfo label:(UILabel *)lbl
{
	CGRect rect = CGRectZero;
	id obj = nil;
	
	obj = [labelInfo objectForKey:@"x"];
	if( obj )										// test if frame is being set
	{
		rect.origin.x = [obj intValue];
		rect.origin.y =  [[labelInfo objectForKey: @"y"] intValue];
		rect.size.width = [[labelInfo objectForKey: @"width"] intValue];
		rect.size.height = [[labelInfo objectForKey: @"height"] intValue];
        if( self.iPad)
        {
            rect = [self CGRectMake:rect CGRectAdjust:kAdjustALLPAD];
        }
		lbl.frame = rect;
	}
	
	int i = [[labelInfo objectForKey: @"textAlignment"] intValue];
	lbl.textAlignment = i;												// NSTextAlignmentLeft, default
	
	NSString *text = [labelInfo objectForKey: @"text"];
	if(text)
	{
		lbl.text = text;
	}
	
	NSString *color = [labelInfo objectForKey: @"titleColor"];
	if(color)
	{
		[lbl setTextColor:[self colorAtKey:color]];
	}
	
	NSString *bcolor = [labelInfo objectForKey: @"backgroundColor"];
	if(bcolor)
	{
		lbl.backgroundColor = [self colorAtKey:bcolor];
	}
}

- (void)loadImageViewProperties:(NSDictionary *)imageViewInfo imageView:(UIImageView *)imv
{
	CGRect rect = CGRectZero;
	id obj = nil;
	
	NSString *imageName = [imageViewInfo objectForKey:@"image"];
	imv.image = [UIImage imageNamed: imageName];
	
	obj = [imageViewInfo objectForKey:@"x"];
	if( obj )																	// test if frame is being set
	{
		rect.origin.x = [obj intValue];
		rect.origin.y =  [[imageViewInfo objectForKey: @"y"] intValue];
		rect.size.width = [[imageViewInfo objectForKey: @"width"] intValue];
		rect.size.height = [[imageViewInfo objectForKey: @"height"] intValue];
        if( self.iPad)
        {
            rect = [self CGRectMake:rect CGRectAdjust:kAdjustALLPAD];
        }
		imv.frame = rect;
	}
}

- (UIView *)loadViewWithFactory:(NSString *)viewName withFrame:(CGRect)frame
{
    Class clazz = [self loadClazz:viewName];
	
	UIView *instance = [[clazz alloc] initWithFrame:frame];
	return instance;
}

- (UIViewController *)loadControllerWithFactory:(NSString *)controllerName                  // example, "AboutViewController"
{
    Class clazz = nil;
    UIViewController *instance = nil;
    NSString *nibName = [self getClassTitle:controllerName];                                // will return the subclass name if one exist, eg: "BBAboutViewController"
    
    if( ![controllerName isEqualToString:nibName] )                                         // if we have a subclass, test if its using a subclassed Nib
    {
        if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil)            // test, see if the nib file exist for eg: "BBAboutViewController"
        {                                                                                   // the nib file "BBAboutViewController" is found
			clazz = [NSClassFromString(nibName) class];										// will get the ViewController's Sub-Class, BBAboutViewController
            instance = [[clazz alloc] initWithNibName:nibName bundle:nil];                  // and initialize an instance of "BBAboutViewController" with "BBAboutViewController.xib" file
        }
        else                                                                                // The nib file BBAboutViewController was NOT found
        {
 			clazz = [NSClassFromString(nibName) class];										// will get the ViewController's Sub-Class, BBAboutViewController
            instance = [[clazz alloc] initWithNibName:controllerName bundle:nil];           // So, initialize an instance of "BBAboutViewController" with "AboutViewController.xib" file
        }
    }
    else
    {
		clazz = [NSClassFromString(controllerName) class];									// will get the ViewController's Class, AboutViewController
        instance = [[clazz alloc] initWithNibName:nibName bundle:nil];                      // initialize an instance of "AboutViewController" with "AboutViewController.xib" file
    }
	
    return instance;
}

- (void)modFrame:(id)aObj theRect:(CGRect)rekt
{
    if ([aObj respondsToSelector:@selector(tag)])
    {
        int nTag = [aObj tag];
        if( nTag >= 0)
        {
            nTag = (nTag == 0) ? -1 : -1 * nTag;                                            // mark that the obj was reSized
            [aObj setTag:nTag];
            if ([aObj respondsToSelector:@selector(frame)])
            {
                [aObj setFrame:rekt];
            }
        }
    }
}

/*
 - (CGRect)CGRectMake:(CGRect)rekt CGRectAdjust:(int)adjustment
 {
 
 if( [UIDevice deviceType] == UIDeviceType_iPhone568 )
 {
 if( adjustment & kAdjustY568 && !(adjustment & kAdjustALLPAD) )        // iPAD only, bit is 5
 {
 rekt.origin.y = rekt.origin.y + kiPhone568HeightPadding;
 }
 if( adjustment & kAdjustHeight  && !(adjustment & kAdjustALLPAD))
 {
 rekt.size.height = rekt.size.height + kiPhone568HeightPadding;
 }
 }
 else if( self.iPad && (adjustment < kAdjust568))
 {
 CGFloat xScale = xiPadScale;         // default scales against a 768 * 911 ipad area
 CGFloat yScale = yiPadScale;
 
 if( adjustment & kAdjustALL || adjustment & kAdjustALLPAD)
 {
 rekt.origin.x = xScale * rekt.origin.x;
 rekt.origin.y = yScale * rekt.origin.y;
 if( rekt.size.width == 320)
 rekt.size.width = 768;
 else
 rekt.size.width = xScale * rekt.size.width;
 
 if( rekt.size.height == 480)
 rekt.size.height = 1024;
 else if( rekt.size.height == 460)
 rekt.size.height = 1004;
 else
 rekt.size.height = yScale * rekt.size.height;
 }
 else
 {
 if( adjustment & kAdjustX  || adjustment & kAdjustXPAD)
 {
 rekt.origin.x = xScale * rekt.origin.x;
 }
 if( adjustment & kAdjustY || adjustment & kAdjustYPAD)
 {
 rekt.origin.y = yScale * rekt.origin.y;
 }
 if( adjustment & kAdjustWidth || adjustment & kAdjustWPAD )
 {
 if( rekt.size.width == 320)
 rekt.size.width = 768;
 else
 rekt.size.width = xScale * rekt.size.width;
 }
 if( adjustment & kAdjustHeight || adjustment & kAdjustHPAD)
 {
 if( rekt.size.height == 480)
 rekt.size.height = 1024;
 else if( rekt.size.height == 460)
 rekt.size.height = 1004;
 else
 rekt.size.height = yScale * rekt.size.height;
 }
 }
 }
 return rekt;
 }
 */
#define AROUND(X,V) (X == V) ? TRUE : ( X > (V - 0.01*V) && X < (V + 0.01*V) ) ? TRUE : FALSE
- (CGRect)CGRectMake:(CGRect)rekt CGRectAdjust:(int)options
{
    CGFloat xScale = xiPadScale;         // default scales against a 768 * 911 ipad area
    CGFloat yScale = yiPadScale;
	
    int adjustment;
    if( options > kAdjustCELL)
    {
        yScale = 2.4;
        adjustment = options - kAdjustCELL;
    }
    else
        adjustment = options;
    
    BOOL X = (adjustment == kAdjustX || adjustment == kAdjustXY || adjustment == kAdjustXPAD || adjustment == kAdjustXYPAD) ? YES : NO;
    BOOL Y = (adjustment == kAdjustY || adjustment == kAdjustXY || adjustment == kAdjustYPAD || adjustment == kAdjustXYPAD  || adjustment == kAdjustY568) ? YES : NO;
    BOOL W = (adjustment == kAdjustWidth || adjustment == kAdjustWH || adjustment == kAdjustWHPAD || adjustment == kAdjustWPAD) ? YES : NO;
    BOOL H = (adjustment == kAdjustHeight || adjustment == kAdjustHPAD || adjustment == kAdjustWHPAD || adjustment == kAdjustWH || adjustment == kAdjustH568) ? YES : NO;
    
    BOOL PAD = (adjustment > kAdjustBASEPAD && adjustment <= kAdjustALLPAD) ? YES : NO;
    BOOL P568= (adjustment >= kAdjust568 && adjustment <= kAdjustH568 ) ? YES : NO;
    
    BOOL ALL = (adjustment == kAdjustALL || adjustment == kAdjustALLPAD || (X && Y && W && H) ) ? YES : NO;
    
    if( [UIDevice deviceType] == UIDeviceType_iPhone568 )
    {
        if( Y && !PAD )
        {
            rekt.origin.y = rekt.origin.y + kiPhone568HeightPadding;
        }
        if( H && !PAD)
        {
            rekt.size.height = rekt.size.height + kiPhone568HeightPadding;
        }
    }
    else if( self.iPad && (adjustment < kAdjust568))
    {
        
        if( ALL && !P568 )
        {
            rekt.origin.x = xScale * rekt.origin.x;
            if( AROUND((rekt.origin.y + rekt.size.height),460) && (options < kAdjustCELL))
            {
                yScale = yScale - 0.3;              // should scale to 2.18, which is 1004/460 ratio
            }
            rekt.origin.y = yScale * rekt.origin.y;
            
            if( rekt.size.width == 320)
                rekt.size.width = 768;
            else
                rekt.size.width = xScale * rekt.size.width;
            
            if( rekt.size.height == 480)
                rekt.size.height = 1024;
            else if( rekt.size.height == 460)
                rekt.size.height = 1004;
            else
            {
                rekt.size.height = yScale * rekt.size.height;
            }
        }
        else
        {
            if( Y && H && !P568 )
            {
                if( AROUND((rekt.origin.y + rekt.size.height),460)  && (options < kAdjustCELL))
                {
                    yScale = yScale - 0.3;
                }
            }
            
            if( X && !P568 )
            {
                rekt.origin.x = xScale * rekt.origin.x;
            }
            if( Y && !P568 )
            {
                rekt.origin.y = yScale * rekt.origin.y;
            }
            if( W && !P568 )
            {
                if( rekt.size.width == 320)
                    rekt.size.width = 768;
                else
                    rekt.size.width = xScale * rekt.size.width;
            }
            if( H && !P568 )
            {
                if( rekt.size.height == 480)
                    rekt.size.height = 1024;
                else if( rekt.size.height == 460)
                    rekt.size.height = 1004;
                else
                    rekt.size.height = yScale * rekt.size.height;
            }
        }
    }
    return rekt;
	
}

- (NSString *)properNibName:(NSString *)nibName
{
    NSString *rValue = nibName;
    
    if (self.iPad)
    {
        NSArray *listItems = [nibName componentsSeparatedByString:@"_iPAD"];
        if( [listItems count] == 1)                                                      // not designated with iPAD suffix
        {
            rValue = [nibName stringByAppendingString:@"_iPAD"];
        }
    }
    
    return rValue;
}


- (UIImage *) imageWithContentsOfFile:(NSString *)path
{
	UIImage* pImage = nil;
    
    if (path)
    {
        BOOL jpg = ( [path hasSuffix:@".jpg"] ) ? YES : NO;
        BOOL png = ( [path hasSuffix:@".png"] ) ? YES : NO;
        
        if( jpg || png )        // looking for a suffix
        {
            if( [UIDevice deviceType] == UIDeviceType_iPhone568 )                           // look for iPhone 5 images
            {
                NSArray *listItems = [path componentsSeparatedByString:(png) ? @".png" : @".jpg"];
                NSString *newPath = [[listItems objectAtIndex:0] stringByAppendingString:(png) ? @"568.png" : @"568.jpg"];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                if(fileExists)
                    pImage = [UIImage imageWithContentsOfFile: newPath];
            }
            else if ( self.iPad)
            {
                NSArray *listItems = [path componentsSeparatedByString:(png) ? @".png" : @".jpg"];
                NSString *newPath = [[listItems objectAtIndex:0] stringByAppendingString:(png) ? @"_iPAD.png" : @"_iPAD.jpg"];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                if(fileExists)
                    pImage = [UIImage imageWithContentsOfFile: newPath];
            }
        }
        else // no suffix
        {
            if( [UIDevice deviceType] == UIDeviceType_iPhone568 )                           // look for iPhone 5 images
            {
                NSString *newPath = [path stringByAppendingString:@"568.png"];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                if(fileExists)
                    pImage = [UIImage imageWithContentsOfFile: newPath];
                else
                {
                    NSString *newPath = [path stringByAppendingString:@"568.jpg"];
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                    if(fileExists)
                        pImage = [UIImage imageWithContentsOfFile: newPath];
                }
            }
            else if ( self.iPad)
            {
                NSString *newPath = [path stringByAppendingString:@"_iPAD.png"];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                if(fileExists)
                    pImage = [UIImage imageWithContentsOfFile: newPath];
                else
                {
                    NSString *newPath = [path stringByAppendingString:@"_iPAD.jpg"];
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                    if(fileExists)
                        pImage = [UIImage imageWithContentsOfFile: newPath];
                }
            }
        }
        // fell thru...=> not a iPhone 5, and not an iPad
		
        if (pImage == nil)
        {
            if( png )
            {
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
                if(fileExists)
                {
                    pImage = [UIImage imageWithContentsOfFile: path];
                }
                else
                {
                    NSArray *listItems = [path componentsSeparatedByString:@".png"];
                    NSString *newPath = [[listItems objectAtIndex:0] stringByAppendingString:@".jpg"];
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                    if(fileExists)
                        pImage = [UIImage imageWithContentsOfFile: newPath];
					
                }
            }
            else // assuming jpg
            {
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
                if(fileExists)
                {
                    pImage = [UIImage imageWithContentsOfFile: path];
                }
                else
                {
                    NSArray *listItems = [path componentsSeparatedByString:@".jpg"];
                    NSString *newPath = [[listItems objectAtIndex:0] stringByAppendingString:@".png"];
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:newPath];
                    if(fileExists)
                        pImage = [UIImage imageWithContentsOfFile: newPath];
                }
            }
        }
    }
	
    return pImage;
}

- (UIImage *) imageNamed:(NSString *)name                                                   // must NOT be a path, and NO periods except to end in the suffix .png
{
	UIImage* pImage = nil;
    
    if( name )
    {
        BOOL jpg = ( [name hasSuffix:@".jpg"] ) ? YES : NO;
        BOOL png = ( [name hasSuffix:@".png"] ) ? YES : NO;
        
        if( jpg || png )                                                                    // a specific file type
        {
            if( [UIDevice deviceType] == UIDeviceType_iPhone568 )                           // look for iPhone 5 images
            {
                NSArray *listItems = [name componentsSeparatedByString:@"."];
                NSString *newName = [[listItems objectAtIndex:0] stringByAppendingString:(png) ? @"568.png" : @"568.jpg"];
                pImage = [UIImage imageNamed:newName];
                if(pImage)
                    return pImage;
                else
                {
                    pImage = [UIImage imageNamed:name];
                    return pImage;
                }
            }
            else if ( self.iPad)
            {
                NSArray *listItems = [name componentsSeparatedByString:@"."];
                NSString *newName = [[listItems objectAtIndex:0] stringByAppendingString:(png) ? @"_iPAD.png" : @"_iPAD.jpg"];
                pImage = [UIImage imageNamed:newName];
                if(pImage)
                    return pImage;
                else
                {
                    pImage = [UIImage imageNamed:name];
                    return pImage;
                }
            }
        }
        else        // no suffix
        {
            if( [UIDevice deviceType] == UIDeviceType_iPhone568 )                           // look for iPhone 5 images
            {
                NSString *newName = [name stringByAppendingString:@"568.png"];
                pImage = [UIImage imageNamed:newName];
                if(pImage)
                {
                    return pImage;
                }
                else
                {
                    NSString *jName = [name stringByAppendingString:@"568.jpg"];            // test for jpeg image
                    pImage = [UIImage imageNamed:jName];
                    if(pImage)
                    {
                        return pImage;
                    }
                    else                                                                    // just retrieve non-568 image
                    {
                        pImage = [UIImage imageNamed:name];
                        return pImage;
                    }
                }
            }
            else if ( self.iPad)
            {
                NSString *newName = [name stringByAppendingString:@"_iPAD.png"];
                pImage = [UIImage imageNamed:newName];
                if(pImage)
                    return pImage;
                else
                {
                    NSString *jName = [name stringByAppendingString:@"_iPAD.jpg"];            // test for jpeg image
                    pImage = [UIImage imageNamed:jName];
                    if(pImage)
                    {
                        return pImage;
                    }
                    else                                                                    // just retrieve non-iPAD image
                    {
                        pImage = [UIImage imageNamed:name];
                        return pImage;
                    }
                }
            }
        }
        
        // fell thru...=> not a iPhone 5, and not an iPad
        
        if (pImage == nil)
        {
            if( png )
            {
                pImage = [UIImage imageNamed:name];
                if(!pImage)
                {
                    NSArray *listItems = [name componentsSeparatedByString:@".png"];
                    NSString *newName = [[listItems objectAtIndex:0] stringByAppendingString:@".jpg"];
                    pImage = [UIImage imageNamed:newName];
                }
            }
            else // assuming jpg
            {
                pImage = [UIImage imageWithContentsOfFile: name];
                if(!pImage)
                {
                    NSArray *listItems = [name componentsSeparatedByString:@".jpg"];
                    NSString *newName = [[listItems objectAtIndex:0] stringByAppendingString:@".png"];
                    pImage = [UIImage imageNamed:newName];
                }
            }
        }
    }
    return pImage;
}


-(UIColor *) getBackgroundFromProperties:(NSString *)property
{
    NSDictionary *target;
    UIColor *result = nil;
    
    target = [self getTargetDict:property];
    
    NSString *value = [target objectForKey:@"backgroundColor"];
    if( value )
    {
        if( [value hasSuffix:@".png"] )         // a specific file
        {
            if( [UIDevice deviceType] == UIDeviceType_iPhone568 )       // look for iPhone 5 images
            {
                NSArray *listItems = [value componentsSeparatedByString:@"."];
                NSString *newValue = [[listItems objectAtIndex:0] stringByAppendingString:@"568.png"];
                result = [UIColor colorWithPatternImage:[UIImage imageNamed: newValue]];
            }
            else
                result = [UIColor colorWithPatternImage:[UIImage imageNamed: value]];
        }
        else
        {
            SEL selector = NSSelectorFromString(value);
            if ([UIColor respondsToSelector:selector])
            {
                result = [UIColor performSelector:selector withObject:nil];
            }
            else                // fails, default to clearColor
                result = [UIColor clearColor];
        }
        
    }
    return result;
}

- (BOOL) isPortraitOrientation
{
	return UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL) isLandscapeOrientation
{
	return !UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (UIFont*) fontWithSize:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic
{
    //	NSArray* familyNames = [UIFont familyNames];
    //	NSArray* fontNames = [UIFont fontNamesForFamilyName:@"Helvetica"];
    //	NSArray* fontNames = [UIFont fontNamesForFamilyName:@"Helvetica Neue"];
	
    //	return [UIFont fontWithName:@"Courier New" size:fontSize];
    //	return [UIFont fontWithName:@"Helvetica Neue" size:fontSize];
	
	if (bold && italic)
	{
		return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:fontSize];
	}
	else if (bold)
	{
		return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
	}
	else if (italic)
	{
		return [UIFont fontWithName:@"HelveticaNeue-Italic" size:fontSize];
	}
	
	return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

- (UILabel *) stdTitleLabelWithText:(NSString*)text
{
	return [self
			labelWithColor:[UIColor orangeColor]
			selectedColor:[UIColor whiteColor]
			fontSize:18
			bold:YES
			italic:NO
			text:text];
}

- (UILabel *) stdLabelWithText:(NSString*)text
{
	return [self
			labelWithColor:[UIColor redColor]
			selectedColor:[UIColor whiteColor]
			fontSize:13
			bold:NO
			italic:NO
			text:text];
}

- (UILabel *) labelWithColor:(UIColor *)color selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	return [self labelWithColor:color selectedColor:selectedColor fontSize:fontSize bold:bold italic:NO text:nil];
}

- (UILabel *) labelWithColor:(UIColor *)color
			   selectedColor:(UIColor *)selectedColor
					fontSize:(CGFloat)fontSize
						bold:(BOOL)bold
						text:(NSString*)text
{
	return [self labelWithColor:color
				  selectedColor:selectedColor
					   fontSize:fontSize
						   bold:bold
						 italic:NO
						   text:text];
}

- (UILabel *) labelWithColor:(UIColor *)color
			   selectedColor:(UIColor *)selectedColor
					fontSize:(CGFloat)fontSize
						bold:(BOOL)bold
					  italic:(BOOL)italic
						text:(NSString*)text
{
	//Create and configure a label.
    UIFont *font = [self fontWithSize:fontSize bold:bold italic:italic];
	
    // Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection
	// properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in
	// setSelected:animated:.
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
	//label.backgroundColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textColor = color;
	label.highlightedTextColor = selectedColor;
	label.font = font;
	label.numberOfLines = 0;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	
	if (text != nil)
	{
		label.text = text;
	}
	
    //	DebugLog(@"Using font %@", font.fontName);
	
	return label;
}

//
// Returns a new, autoreleased UITextView. The caller is reponsible for retaining ownership.
//
- (UITextView *) textViewWithColor:(UIColor *)Color fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	//Create and configure a TextView.
	UIFont *font;
	
    if (bold)
	{
        font = [UIFont boldSystemFontOfSize:fontSize];
    }
	else
	{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    
	// Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection
	// properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in
	// setSelected:animated:.
	UITextView* textView = [[UITextView alloc] initWithFrame:CGRectZero];
	textView.backgroundColor = [UIColor whiteColor];
	textView.opaque = YES;
	textView.textColor = Color;
	textView.font = font;
	
	return textView;
}

//
// Creates a new text field. The caller is responsible for retaining ownership.
//
- (UITextField*) textFieldWithFrame:(CGRect)frame
{
	UITextField* textField = [[UITextField alloc] initWithFrame:frame];
	textField.font = [UIFont systemFontOfSize:14.0f];
	textField.clearButtonMode = UITextFieldViewModeWhileEditing; // UITextFieldViewModeAlways;
	//textField.borderStyle = UITextBorderStyleBezel;
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.textAlignment = NSTextAlignmentLeft;
	textField.textColor = [UIColor blackColor];
	textField.backgroundColor = [UIColor whiteColor];
	textField.opaque = YES;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	textField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	textField.returnKeyType = UIReturnKeyDone;
	textField.enablesReturnKeyAutomatically = NO;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//textField.delegate = self;
	
	return textField;
}

- (NSString *) getFormattedRuntimeString:(NSInteger) runtime
{
	NSString* hoursString = @"";
	NSString* minutesString = @"";
	
	NSInteger hours = runtime / 60;
	NSInteger minutes = runtime % 60;
	
	if (hours == 1)
	{
		hoursString = @"1 hr.";
	}
	else if (hours > 1)
	{
		hoursString = [NSString stringWithFormat:@"%d hrs.", hours];
	}
	
	if (minutes == 1)
	{
		minutesString = @"1 min.";
	}
	else if (minutes > 1)
	{
		minutesString = [NSString stringWithFormat:@"%d mins.", minutes];
	}
	
	return [NSString stringWithFormat:@"%@ %@", hoursString, minutesString];
}

- (NSString *) stringWithTimeInterval:(NSTimeInterval) timeInterval
{
	NSString* hoursString = @"";
	NSString* minutesString = @"";
	
	NSInteger hours = timeInterval / 3600;
	NSInteger minutes = (NSInteger)(timeInterval / 60) % 60;
	
	if (hours == 1)
	{
		hoursString = @"1 hr.";
	}
	else if (hours > 1)
	{
		hoursString = [NSString stringWithFormat:@"%d hrs.", hours];
	}
	
	if (minutes == 1)
	{
		minutesString = @"1 min.";
	}
	else if (minutes > 1)
	{
		minutesString = [NSString stringWithFormat:@"%d mins.", minutes];
	}
	
	if ([hoursString isEqualToString:@""] && [minutesString isEqualToString:@""])
	{
		return @"less than 1 min.";
	}
	return [NSString stringWithFormat:@"%@ %@", hoursString, minutesString];
}


//
// Returns the size of the given title taking into account a font size reduction
// if the title needs to wrap.
//
- (CGSize) titleSize:(NSString*)title withWidth:(CGFloat)width outFont:(UIFont**)outFont
{
	CGSize sizeToReturn = CGSizeZero;
	UIFont* finalFont = self.titleLabelPrototypeLarge.font;
	
	if (title != nil)
	{
		//CGSize titleSize = [title sizeWithFont:finalFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
		CGSize titleSize = [title sizeWithFont:finalFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];       // iOS 6
		
		// Cast the size to NSInteger to avoid fractional offsets.
		titleSize = CGSizeMake((NSInteger)titleSize.width, (NSInteger)titleSize.height);
		
		if (titleSize.height > self.titleLineHeightLarge)
		{
			finalFont = self.titleLabelPrototypeSmall.font;
			//titleSize = [title sizeWithFont:finalFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
			titleSize = [title sizeWithFont:finalFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];       // iOS 6
			
			// Do not let the title wrap passed the max lines.
			if (titleSize.height > self.titleMaxHeight)
			{
				titleSize.height = self.titleMaxHeight;
			}
		}
		
		sizeToReturn = titleSize;
	}
	
	if (outFont != nil)
	{
		*outFont = finalFont;
	}
	
	return sizeToReturn;
}

//
// Lays out the given title label at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) layoutTitleLabel:(UILabel*)titleLabel atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth
{
	// Cast the origin to NSInteger to avoid a fractional offset.
	CGRect toReturn = CGRectMake((NSInteger)point.x, (NSInteger)point.y, 0.0f, 0.0f);
	
	if (titleLabel != nil)
	{
		if (![StringFunctions isEmptyString:titleLabel.text])
		{
			UIFont* labelFont = nil;
			CGSize labelSize = [self titleSize:titleLabel.text withWidth:maxWidth outFont:&labelFont];
			
			// Apple the new font.
			titleLabel.font = labelFont;
			
			// Set the alignment.
			titleLabel.textAlignment = NSTextAlignmentLeft;
			
			// Set the line break mode.
			titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
			
			// Update the size.
			toReturn.size = labelSize;
		}
		
		// Position the label.
		titleLabel.frame = toReturn;
	}
	
	return toReturn;
}

//
// Draws the given title at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) drawTitle:(NSString*)title atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth
{
	// Cast the origin to NSInteger to avoid a fractional offset.
	CGRect toReturn = CGRectMake((NSInteger)point.x, (NSInteger)point.y, 0.0f, 0.0f);
	
	if (![StringFunctions isEmptyString:title])
	{
		UIFont* outFont = nil;
		toReturn.size = [self titleSize:title withWidth:maxWidth outFont:&outFont];
		[title drawInRect:toReturn withFont:outFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
	}
	
	return toReturn;
}



//
// Toggles the selected state of a checkbox button.
//
- (void) checkboxToggleSelection:(id)source
{
	if (source != nil && [source isKindOfClass:[UIButton class]])
	{
		((UIButton*)source).selected = !((UIButton*)source).selected;
	}
}

//
// Toggles the selected state of a checkbox button.
//
- (void) checkboxSetSelection:(id)source selected:(BOOL)selected
{
	if (source != nil && [source isKindOfClass:[UIButton class]])
	{
		((UIButton*)source).selected = selected;
	}
}


//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button
{
	[UIUtil adjustButtonSizeToFitText:(UIButton*)button];
}

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets
{
	[UIUtil adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets];
}

//
// Corrects the width and height of the given UILabel to accomodate its text on a single line.
//
- (void) adjustLabelSizeToFitText:(UILabel*)label
{
	[UIUtil adjustLabelSizeToFitText:(UILabel*)label];
}

//
// Corrects the height of the given UILabel to accomodate its text content relative to its current width.
//
- (void) adjustLabelHeightToFitText:(UILabel*)label
{
	[UIUtil adjustLabelHeightToFitText:(UILabel*)label];
}

//
// Returns the ideal height for the given text string.
//
- (CGFloat) idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font
{
	return [UIUtil idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font];
}

//
// Returns the ideal size for the given text string.
//
- (CGSize) idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font
{
	return [UIUtil idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font];
}

//
// A helper method to set just the x-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setX:(CGFloat)xPos
{
	return [UIUtil view:(UIView*)view setX:(CGFloat)xPos];
}

//
// A helper method to set just the y-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setY:(CGFloat)yPos
{
	return [UIUtil view:(UIView*)view setY:(CGFloat)yPos];
}

//
// A helper method to set just the origin of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setOrigin:(CGPoint)origin
{
	return [UIUtil view:(UIView*)view setOrigin:(CGPoint)origin];
}

//
// A helper method to set just the width of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setWidth:(CGFloat)width
{
	return [UIUtil view:(UIView*)view setWidth:(CGFloat)width];
}

//
// A helper method to set just the height of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setHeight:(CGFloat)height
{
	return [UIUtil view:(UIView*)view setHeight:(CGFloat)height];
}

//
// A helper method to set just the size of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setSize:(CGSize)size
{
	return [UIUtil view:(UIView*)view setSize:(CGSize)size];
}

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint
{
	[UIUtil view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint];
}

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value
{
	[UIUtil view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value];
}

//
// A helper method to convert the string into an accessible string such that each letter is spoken separately.
//
- (NSString*) letterizeString:(NSString*)str
{
	return [UIUtil letterizeString:(NSString*)str];
}

//
// Splits the given string on words and capitalizes each word.
//
- (NSString*) capitalizeWordsInString:(NSString*)str
{
	return [UIUtil capitalizeWordsInString:(NSString*)str];
}

//
// A helper method to set just the line break mode of the given UIButton.
//
- (void) button:(UIButton*)button setLineBreakMode:(UILineBreakMode)lineBreakMode
{
	[UIUtil button:(UIButton*)button setLineBreakMode:(UILineBreakMode)lineBreakMode];
}

//
// A helper method to set just the text alignment of the given UIButton.
//
- (void) button:(UIButton*)button setTextAlignment:(UITextAlignment)textAlignment
{
	[UIUtil button:(UIButton*)button setTextAlignment:(UITextAlignment)textAlignment];
}

//
// A helper method to set just the font of the given UIButton.
//
- (void) button:(UIButton*)button setFont:(UIFont*)font
{
	[UIUtil button:(UIButton*)button setFont:(UIFont*)font];
}

//
// A helper method to return the font of a UIButton (this is done to reduce the number of compiler warnings).
//
- (UIFont*) buttonGetFont:(UIButton*)button
{
	return [UIUtil buttonGetFont:(UIButton*)button];
}

//
// Loads the nib with the given name and return the first UIView.
//
- (UIView*) loadViewFromNibNamed:(NSString*)nibName owner:(id)owner
{
	return [UIUtil loadViewFromNibNamed:(NSString*)nibName owner:(id)owner];
}

- (UIButton*) replaceButton:(UIButton*)src withButton:(UIButton*)replacement
{
	return [UIUtil replaceButton:(UIButton*)src withButton:(UIButton*)replacement];
}

- (UIView*) replaceView:(UIView*)src withView:(UIView*)replacement
{
	return [UIUtil replaceView:(UIView*)src withView:(UIView*)replacement];
}

//
// Returns an autoreleased UIAccessibilityElement.
//
- (id) accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint
{
	return [UIUtil accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint];
}

//
// A helper method to defocus all subviews of a view
//
+ (void) resignFirstRespondersOf:(UIView*)parentView
{
	[UIUtil resignFirstRespondersOf:(UIView*)parentView];
}

//
// A helper method to defocus all subviews of a view and a given class.  For example [UITextEntry class] if you only want to close onscreen keyboards.
//
+ (void) resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass
{
	[UIUtil resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass];
}

//
// Displays the following message in a standard UIAlertView.
//
- (void) alertMessage:(NSString*)message
{
	[UIUtil alertMessage:(NSString*)message];
}

//
// A generic handler to deal with not implemented features.
//
- (void) notYetImplementedHandler:(id)source
{
	[UIUtil notYetImplementedHandler:(id)source];
}

@end

@implementation UIMutableFont

//
// Constructor.
//
- (id) initWithFont:(UIFont*)font
{
	if (self = [super init])
	{
		_ascender = font.ascender;
		_capHeight = font.capHeight;
		_descender = font.descender;
		_familyName = font.familyName;
		_fontName = font.fontName;
		_leading = font.leading;
		_pointSize = font.pointSize;
		_xHeight = font.xHeight;
	}
	
	return self;
}

//
// Destructor
//
- (void) dealloc
{
	_familyName = nil;
	_fontName = nil;
	
}

//
// Specifies the top y-coordinate, offset from the baseline, of the receiver’s longest ascender. (read-only)
//
- (CGFloat) ascender
{
	return _ascender;
}

//
// Specifies the receiver’s cap height information. (read-only)
//
- (CGFloat) capHeight
{
	return _capHeight;
}

//
// Specifies the bottom y-coordinate, offset from the baseline, of the receiver’s longest descender. (read-only)
//
- (CGFloat) descender
{
	return _descender;
}

//
// Specifies the receiver’s family name. (read-only)
//
- (NSString*) familyName
{
	return _familyName;
}

//
// Specifies the font face name. (read-only)
//
- (NSString*) fontName
{
	return _fontName;
}

//
// Specifies the receiver’s leading information. (read-only)
//
- (CGFloat) leading
{
	return _leading;
}

//
// Specifies receiver’s point size, or the effective vertical point size for a font with a nonstandard matrix. (read-only)
//
- (CGFloat) pointSize
{
	return _pointSize;
}

//
// Specifies the x-height of the receiver. (read-only)
//
- (CGFloat) xHeight
{
	return _xHeight;
}



@end

