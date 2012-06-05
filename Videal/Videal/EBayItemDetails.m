//
//  EBayItemDetails.m
//  Videal
//
//  Created by Eunmo Yang on 5/28/12.
//  Copyright (c) 2012 dStanford University. All rights reserved.
//

#import "EBayItemDetails.h"

@implementation EBayItemDetails

- (NSString *) getVerifyAddItemRequestBody
{
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<VerifyAddItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<ErrorLanguage>en_US</ErrorLanguage>"
                      "<WarningLevel>High</WarningLevel>"
                      "<Item>"
                      "<Title>%@</Title>"
                      "<Description>%@</Description>"
                      "<PrimaryCategory>"
                      "<CategoryID>%@</CategoryID>"
                      "</PrimaryCategory>"
                      "<StartPrice>%@</StartPrice>"
                      "<CategoryMappingAllowed>true</CategoryMappingAllowed>"
                      "<ConditionID>1000</ConditionID>"
                      "<Country>US</Country>"
                      "<Currency>USD</Currency>"
                      "<DispatchTimeMax>%@</DispatchTimeMax>"
                      "<ListingDuration>%@</ListingDuration>"
                      "<ListingType>%@</ListingType>"
                      "<Quantity>1</Quantity>"
                      "<PaymentMethods>PayPal</PaymentMethods>"
                      "<PayPalEmailAddress>%@</PayPalEmailAddress>"
                      "<PostalCode>%@</PostalCode>"
                      "<ReturnPolicy>%@</ReturnPolicy>"
                      "<ShippingDetails>"
                      "<ShippingType>Flat</ShippingType>"
                      "<ShippingServiceOptions>"
                      "<ShippingServicePriority>1</ShippingServicePriority>"
                      "<ShippingService>%@</ShippingService>"
                      "<ShippingServiceCost>%@</ShippingServiceCost>"
                      "</ShippingServiceOptions>"
                      "</ShippingDetails>"
                      "<Site>US</Site>"
                      "</Item>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</VerifyAddItemRequest>",
                      title,
                      desc,
                      category,
                      price,
                      dispatch,
                      duration,
                      auction,
                      paypal,
                      zipcode,
                      returnPolicy,
                      shipping,
                      shippingCost,
                      authKey];
    
    return body;
}

- (NSString *) getAddItemRequestBody
{
    NSString *body = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<AddItemRequest xmlns=\"urn:ebay:apis:eBLBaseComponents\">"
                      "<ErrorLanguage>en_US</ErrorLanguage>"
                      "<WarningLevel>High</WarningLevel>"
                      "<Item>"
                      "<Title>%@</Title>"
                      "<Description>"
                      "<![CDATA["
                      "%@<p align=\"center\">"
                      "<object height=\"385\" width=\"640\"><param name=\"movie\" "
                      "value=\"http://www.youtube.com/v/%@?fs=1&amp;hl=en_US\">"
                      "<param name=\"allowFullScreen\" value=\"true\">"
                      "<param name=\"allowscriptaccess\" value=\"always\">"
                      "<embed src=\"http://www.youtube.com/v/%@?fs=1&amp;hl=en_US\" "
                      "type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" "
                      "allowfullscreen=\"true\" height=\"385\" width=\"640\"></object></span></strong></p>"
                      "<p><a href=\"http://www.youtube.com/watch?v=%@\">"
                      "Video Link (for those on Safari without Flash)</a></p>]]></Description>"
                      "<PrimaryCategory>"
                      "<CategoryID>%@</CategoryID>"
                      "</PrimaryCategory>"
                      "<StartPrice>%@</StartPrice>"
                      "<CategoryMappingAllowed>true</CategoryMappingAllowed>"
                      "<ConditionID>1000</ConditionID>"
                      "<Country>US</Country>"
                      "<Currency>USD</Currency>"
                      "<DispatchTimeMax>%@</DispatchTimeMax>"
                      "<ListingDuration>%@</ListingDuration>"
                      "<ListingType>%@</ListingType>"
                      "<Quantity>1</Quantity>"
                      "<PaymentMethods>PayPal</PaymentMethods>"
                      "<PayPalEmailAddress>%@</PayPalEmailAddress>"
                      "<PostalCode>%@</PostalCode>"
                      "<ReturnPolicy>%@</ReturnPolicy>"
                      "<ShippingDetails>"
                      "<ShippingType>Flat</ShippingType>"
                      "<ShippingServiceOptions>"
                      "<ShippingServicePriority>1</ShippingServicePriority>"
                      "<ShippingService>%@</ShippingService>"
                      "<ShippingServiceCost>%@</ShippingServiceCost>"
                      "</ShippingServiceOptions>"
                      "</ShippingDetails>"
                      "<Site>US</Site>"
                      "</Item>"
                      "<RequesterCredentials>"
                      "<eBayAuthToken>%@</eBayAuthToken>"
                      "</RequesterCredentials>"
                      "<WarningLevel>High</WarningLevel>"
                      "</AddItemRequest>",
                      title,
                      desc,
                      video,
                      video,
                      video,
                      category,
                      price,
                      dispatch,
                      duration,
                      auction,
                      paypal,
                      zipcode,
                      returnPolicy,
                      shipping,
                      shippingCost,
                      authKey];
    
    return body;
}

@end