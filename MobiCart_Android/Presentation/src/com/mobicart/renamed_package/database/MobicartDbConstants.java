/**
 * 
 */
package com.mobicart.renamed_package.database;

/**
 * This class contains MobiCart DB Constants used in whole appLication.
 * 
 * @author mobicart
 * 
 */
public class MobicartDbConstants {

	/**
	 * Keys for cart and wishlist Details
	 */
	public static final String KEY_ROWID = "_id";
	public static final String KEY_OPTION_ID = "optionId";
	public static final String KEY_PRODUCT_OPTION_ID = "productOptionId";
	public static final String KEY_PRODUCT_ID = "productId";
	public static final String KEY_QUANTITY = "quantity";
	public static final String KEY_AVAILQTY = "availableQty";
	public static final String KEY_PRODUCT_NAME = "productName";
	public static final String KEY_PRODUCT_ACTUALPRICE = "actualPrice";
	public static final String KEY_PRODUCT_PRICE = "fPrice";
	public static final String KEY_PRODUCT_RATING = "fAverageRating";
	public static final String KEY_PRODUCT_IMAGE = "productImage";
	public static final String KEY_PRODUCT_STATUS = "sStatus";

	/**
	 * Keys for Account Details
	 */
	public static final String KEY_USERNAME = "sUserName";
	public static final String KEY_EMAIL_ADDRESS = "eMailAddress";
	public static final String KEY_PASSWORD = "sPassword";
	public static final String KEY_STREETADDRESS = "sStreetAddress";
	public static final String KEY_CITY = "sCity";
	public static final String KEY_STATE = "sState";
	public static final String KEY_PINCODE = "sPinCode";
	public static final String KEY_COUNTRY = "sCountry";
	public static final String KEY_DELIEVERY_STREETADDRESS = "sDelievryStreetAddress";
	public static final String KEY_DELIEVERY_CITY = "sDelievryCity";
	public static final String KEY_DELIEVERY_STATE = "sDelievryState";
	public static final String KEY_DELIEVERY_PINCODE = "sDelievryPincode";
	public static final String KEY_DELIEVERY_COUNTRY = "sDelievryCountry";
	public static final String KEY_OPTIONNAME = "optionName";
	public static final String KEY_OPTIONID = "optionId";
	public static final String KEY_TITLE = "title";
	public static final String KEY_TOBESHIPPEDQUANTITY = "toBeShippedQuantity";
	public static final String KEY_AVAILABLEQUANTITY = "availableQuantity";

	/** Database Name **/
	public static final String DB_NAME = "DbMobicartAndroid.sqlite";

	/** Database Path **/
	public static final String DB_PATH = "/data/data/com.mobicart.renamed_package/databases/";

	/** Table Wishlist **/
	public static final String TBL_WISHLIST = "tblWishList";

	/** Wishlist Product Option Table **/
	public static final String TBL_WISHLIST_PRODUCT_OPTIONS = "tblWishlistOptions";

	/** Table Cart **/
	public static final String TBL_CART = "tblCartList";

	/** Table User Details **/
	public static final String TBL_ACCOUNT_DETAILS = "tblAccountDetails";

	/** Product Option Table **/
	public static final String TBL_PRODUCT_OPTIONS = "tblProductOptions";
}
