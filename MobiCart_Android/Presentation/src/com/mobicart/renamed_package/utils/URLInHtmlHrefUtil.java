package com.mobicart.renamed_package.utils;

import java.net.MalformedURLException;
import java.net.URL;

import com.mobicart.android.model.MobicartCommonData;

/** 
 * @author mobicart
	This is utility class to convert the given string into HTML HREF Codes
	For Example: www.google.com into <a href="www.google.com">www.google.com</a>
 * @return
 */

public class URLInHtmlHrefUtil {
    public static String getStringInHtmlHrefFormat(String data) {
     
    	data=data.replaceAll("\n", "<br/>");
        String [] enterSplit = data.split("<br/>");

		String hrefCodeURL="";
		for(String s:enterSplit){
			 String [] spaceSplit = s.split(" ");
         
        for( String item : spaceSplit ){
        	try {
			if(item.startsWith("www.")){
				URL url = new URL("http://"+item);
				hrefCodeURL=hrefCodeURL+" <a style=\"color:" + "#"
						+ MobicartCommonData.colorSchemeObj.getSubHeaderColor()
						+ "\"" + "  target='_blank' href=\"" + url + "\">"+ item + "</a> ";
			}
			else if(item.startsWith("(")&&(item.indexOf("www.")==1) || (item.indexOf("https://")==1) || (item.indexOf("https://")==1)){
				URL url=null;
				String append="";
				item=item.substring(1,item.length());
				hrefCodeURL=hrefCodeURL+"(";
				if(item.contains(")")){
					if(item.endsWith(")")){
						item=item.substring(0,item.length()-2);
						append=")";
					}
					else{
						append=")"+item.charAt(item.length()-2);
						item=item.substring(0,item.length()-3);
						
					}
				}
											
				if(item.contains("www")){
					 url = new URL("http://"+item);
				}
				else
					url = new URL(item);
				hrefCodeURL=hrefCodeURL+"<a style=\"color:" + "#"
						+ MobicartCommonData.colorSchemeObj.getSubHeaderColor()
						+ "\"" + " target='_blank' href=\"" + url + "\">"+ item + "</a>"+append+" ";
				
			}
			else{
				URL url = new URL(item);
					hrefCodeURL=hrefCodeURL+" <a style=\"color:" + "#"
						+ MobicartCommonData.colorSchemeObj.getSubHeaderColor()
						+ "\"" + " target='_blank' href=\"" + url + "\">"+ item + "</a> ";
			}
        } catch (MalformedURLException e) {
            hrefCodeURL=hrefCodeURL+item+" ";
        }	
        }
        hrefCodeURL=hrefCodeURL+"<br/>";
		}
		System.out.println(hrefCodeURL);
		return hrefCodeURL;
    }
}

