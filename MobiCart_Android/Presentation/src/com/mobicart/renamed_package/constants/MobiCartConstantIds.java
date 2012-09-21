package com.mobicart.renamed_package.constants;

import com.mobicart.android.communication.Oauth;

/**
 * This class contains MobiCart Constants used in whole appLication.
 * 
 * @author mobicart
 * 
 */

public class MobiCartConstantIds {

	public static final String userName = Oauth.consumerKey;

	/** PayPal Constants **/
	public static String PAYPAL_APP_ID = null;
	public static String PAYPAL_EMAIL_ID = null;
	public static String PAYPAL_SERVER_MODE;
	public static String PAYPAL_APP_ID_LIVE = null;
	
	/**ZooZ Constants**/
	public static String ZOOZ_TRX_ID=null;
	public static String ZOOZ_ERROR_CODE=null;
	public static String ZOOZ_ERROR_MSG=null;
	
	/** Push Notification Constants **/
	public static String GCM_API_KEY = null;
	public static String GCM_SENDER_ID = null;
	public static String NOTIFICATION_SENDER_ID = null;

	/** NewsTabAct Constants **/
	public static final String[] suffixes =
	// 0 1 2 3 4 5 6 7 8 9
	{ "th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th",
	// 10 11 12 13 14 15 16 17 18 19
			"th", "th", "th", "th", "th", "th", "th", "th", "th", "th",
			// 20 21 22 23 24 25 26 27 28 29
			"th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th",
			// 30 31
			"th", "st" };
}
