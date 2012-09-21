package com.mobicart.renamed_package.database;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.CursorIndexOutOfBoundsException;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteStatement;

import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.model.IModelVo;

/**
 * This Activity class is used for accessing the database related queries.
 * 
 * @author mobicart
 * 
 */

@SuppressWarnings("static-access")
public class DataBaseAccess {
	@SuppressWarnings("unused")
	private Context context;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;
	private static SQLiteDatabase db;
	private DataBaseHelper ObjDataBaseHelper;

	/**
	 * @param context
	 */

	public DataBaseAccess(Context context) {
		this.context = context;
		objMobicartLogger=new MobicartLogger("MobicartServiceLogger");
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		ObjDataBaseHelper = new DataBaseHelper(context);
		try {
			ObjDataBaseHelper.createDataBase();
			ObjDataBaseHelper.openDataBase();
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		}
		this.db = ObjDataBaseHelper.myDataBase;
	}

	/**
	 * Convenience method for inserting row in cartlist.
	 * 
	 * @param pid
	 * @param pOptId
	 * @param qn
	 * @param dis
	 * @return
	 */
	public long insertCartList(int pid, String pOptId, int qn, int avaQn) {
		int rowId = 0;
		try {
			if (!db.isOpen()) {
				ObjDataBaseHelper.openDataBase();
				this.db = ObjDataBaseHelper.myDataBase;
				long insert;
				String sql = "select max(rowId) from "
						+ MobicartDbConstants.TBL_CART;
				SQLiteStatement sqt = db.compileStatement(sql);
				rowId = (int) sqt.simpleQueryForLong();
				ContentValues initialValues = new ContentValues();
				initialValues.put(MobicartDbConstants.KEY_ROWID, ++rowId);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_ID, pid);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_OPTION_ID,
						pOptId);
				initialValues.put(MobicartDbConstants.KEY_QUANTITY, qn);
				initialValues.put(MobicartDbConstants.KEY_AVAILABLEQUANTITY,
						avaQn);
				insert = db.insert(MobicartDbConstants.TBL_CART, null,
						initialValues);
				return insert;
			}
		} catch (SQLException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return 0;
	}

	/**
	 * Convenience method for inserting row in wishlist.
	 * 
	 * @param pid
	 * @param pOptId
	 * @param qn
	 * @return
	 */
	public long insertWishList(int pid, String pname, double actualPrice,
			double price, String pimage, String status, double rating,
			int availQty, String pOptionId) {
		ObjDataBaseHelper.openDataBase();
		this.db = ObjDataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				long insert;
				ContentValues initialValues = new ContentValues();
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_ID, pid);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_RATING,
						rating);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_NAME,
						actualPrice);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_PRICE, price);
				initialValues
						.put(MobicartDbConstants.KEY_PRODUCT_IMAGE, pimage);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_NAME, pname);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_STATUS,
						status);
				initialValues.put(MobicartDbConstants.KEY_AVAILQTY, availQty);
				initialValues.put(MobicartDbConstants.KEY_PRODUCT_OPTION_ID,
						pOptionId);
				insert = db.insert(MobicartDbConstants.TBL_WISHLIST, null,
						initialValues);
				return insert;
			}
		} catch (SQLException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return 0;
	}

	/**
	 * Convenience method for inserting row in account details.
	 * 
	 * @param sUserName
	 * @param eMailAddress
	 * @param sPassword
	 * @param sStreetAddress
	 * @param sCity
	 * @param sState
	 * @param sPinCode
	 * @param sCountry
	 * @param sDelievryStreetAddress
	 * @param sDelievryCity
	 * @param sDelievryState
	 * @param sDelievryPincode
	 * @param sDelievryCountry
	 * @return
	 */
	public long insertAccountDetails(int rowId, String sUserName,
			String eMailAddress, String sStreetAddress, String sCity,
			String sState, String sPinCode, String sCountry,
			String sDelievryStreetAddress, String sDelievryCity,
			String sDelievryState, String sDelievryPincode,
			String sDelievryCountry) {
		long insert;
		try {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
			if (db.isOpen()) {

				ContentValues initialValues = new ContentValues();
				initialValues.put(MobicartDbConstants.KEY_ROWID, rowId);
				initialValues.put(MobicartDbConstants.KEY_USERNAME, sUserName);
				initialValues.put(MobicartDbConstants.KEY_EMAIL_ADDRESS,
						eMailAddress);
				initialValues.put(MobicartDbConstants.KEY_STREETADDRESS,
						sStreetAddress);
				initialValues.put(MobicartDbConstants.KEY_CITY, sCity);
				initialValues.put(MobicartDbConstants.KEY_STATE, sState);
				initialValues.put(MobicartDbConstants.KEY_PINCODE, sPinCode);
				initialValues.put(MobicartDbConstants.KEY_COUNTRY, sCountry);
				initialValues.put(
						MobicartDbConstants.KEY_DELIEVERY_STREETADDRESS,
						sDelievryStreetAddress);
				initialValues.put(MobicartDbConstants.KEY_DELIEVERY_CITY,
						sDelievryCity);
				initialValues.put(MobicartDbConstants.KEY_DELIEVERY_STATE,
						sDelievryState);
				initialValues.put(MobicartDbConstants.KEY_DELIEVERY_PINCODE,
						sDelievryPincode);
				initialValues.put(MobicartDbConstants.KEY_DELIEVERY_COUNTRY,
						sDelievryCountry);
				insert = db.insert(MobicartDbConstants.TBL_ACCOUNT_DETAILS,
						null, initialValues);
				return insert;
			}
		} catch (SQLException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return 0;
	}

	/**
	 * Method for inserting option details of product in Product Option table.
	 * 
	 * @param optionName
	 * @param optionId
	 * @param title
	 * @param toBeShippedQuantity
	 * @param productId
	 * @param quantity
	 * @param availableQuantity
	 * @return
	 */
	public long insertProductOptions(String optionName, String optionId,
			String title, int toBeShippedQuantity, int productId, int quantity,
			int availableQuantity) {
		long insert;
		try {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
			if (db.isOpen()) {
				ContentValues initialValues = new ContentValues();
				initialValues.put(MobicartDbConstants.KEY_OPTIONNAME,
						optionName);
				initialValues.put(MobicartDbConstants.KEY_OPTIONID, optionId);
				initialValues.put(MobicartDbConstants.KEY_TITLE, title);
				initialValues.put(MobicartDbConstants.KEY_TOBESHIPPEDQUANTITY,
						toBeShippedQuantity);
				initialValues
						.put(MobicartDbConstants.KEY_PRODUCT_ID, productId);
				initialValues.put(MobicartDbConstants.KEY_QUANTITY, quantity);
				initialValues.put(MobicartDbConstants.KEY_AVAILABLEQUANTITY,
						availableQuantity);
				insert = db.insert(MobicartDbConstants.TBL_PRODUCT_OPTIONS,
						null, initialValues);
				return insert;
			}
		} catch (SQLException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return 0;
	}

	/**
	 * Method for inserting option details of product in Wishlist Product Option
	 * table.
	 * 
	 * @param optionName
	 * @param optionId
	 * @param title
	 * @param toBeShippedQuantity
	 * @param productId
	 * @param quantity
	 * @param availableQuantity
	 * @return
	 */
	public long insertWishlistOptions(String optionName, String optionId,
			String title, int toBeShippedQuantity, int productId, int quantity,
			int availableQuantity) {
		long insert;
		try {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
			if (db.isOpen()) {
				ContentValues initialValues = new ContentValues();
				initialValues.put(MobicartDbConstants.KEY_OPTIONNAME,
						optionName);
				initialValues.put(MobicartDbConstants.KEY_OPTIONID, optionId);
				initialValues.put(MobicartDbConstants.KEY_TITLE, title);
				initialValues.put(MobicartDbConstants.KEY_TOBESHIPPEDQUANTITY,
						toBeShippedQuantity);
				initialValues
						.put(MobicartDbConstants.KEY_PRODUCT_ID, productId);
				initialValues.put(MobicartDbConstants.KEY_QUANTITY, quantity);
				initialValues.put(MobicartDbConstants.KEY_AVAILABLEQUANTITY,
						availableQuantity);
				insert = db.insert(
						MobicartDbConstants.TBL_WISHLIST_PRODUCT_OPTIONS, null,
						initialValues);
				return insert;
			}
		} catch (SQLException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return 0;
	}

	/**
	 * 
	 * Convenience method for updating Account Details
	 * 
	 * @param rowId
	 * @param eMailAddress
	 * @param sStreetAddress
	 * @param sCity
	 * @param sState
	 * @param sPinCode
	 * @param sCountry
	 * @param sDelievryStreetAddress
	 * @param sDelievryCity
	 * @param sDelievryState
	 * @param sDelievryPincode
	 * @param sDelievryCountry
	 * @return
	 */
	public int updateAccountDetails(int rowId, String eMailAddress,
			String sStreetAddress, String sCity, String sState,
			String sPinCode, String sCountry, String sDelievryStreetAddress,
			String sDelievryCity, String sDelievryState,
			String sDelievryPincode, String sDelievryCountry) {
		try {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
			if (db.isOpen()) {
				@SuppressWarnings("unused")
				int open;
				ContentValues args = new ContentValues();
				args.put(MobicartDbConstants.KEY_ROWID, rowId);
				args.put(MobicartDbConstants.KEY_EMAIL_ADDRESS, eMailAddress);
				args.put(MobicartDbConstants.KEY_STREETADDRESS, sStreetAddress);
				args.put(MobicartDbConstants.KEY_CITY, sCity);
				args.put(MobicartDbConstants.KEY_STATE, sState);
				args.put(MobicartDbConstants.KEY_PINCODE, sPinCode);
				args.put(MobicartDbConstants.KEY_COUNTRY, sCountry);
				args.put(MobicartDbConstants.KEY_DELIEVERY_STREETADDRESS,
						sDelievryStreetAddress);
				args.put(MobicartDbConstants.KEY_DELIEVERY_CITY, sDelievryCity);
				args.put(MobicartDbConstants.KEY_DELIEVERY_STATE,
						sDelievryState);
				args.put(MobicartDbConstants.KEY_DELIEVERY_PINCODE,
						sDelievryPincode);
				args.put(MobicartDbConstants.KEY_DELIEVERY_COUNTRY,
						sDelievryCountry);
				open = db.update(MobicartDbConstants.TBL_ACCOUNT_DETAILS, args,
						MobicartDbConstants.KEY_ROWID + "=" + rowId, null);
				return 1;
			}
		} catch (SQLException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return 0;
	}

	/**
	 * Convenience method for deleting rows in cartlist.
	 * 
	 * @param rowId
	 * @return the number of rows affected if a whereClause is passed in, 0
	 *         otherwise. To remove all rows and get a count pass "1" as the
	 *         whereClause.
	 */
	public boolean deleteCartItem(long rowId) {
		ObjDataBaseHelper.openDataBase();
		this.db = ObjDataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				boolean open;
				open = db.delete(MobicartDbConstants.TBL_CART,
						MobicartDbConstants.KEY_ROWID + "=" + rowId, null) > 0;
				return open;
			}
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return false;
	}

	/**
	 * Convenience method for deleting cart table.
	 * 
	 * @param rowId
	 * @return
	 */
	public boolean deleteCartTable() {
		ObjDataBaseHelper.openDataBase();
		this.db = ObjDataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				boolean open;
				open = db.delete(MobicartDbConstants.TBL_CART, null, null) > 0;
				return open;
			}
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return false;
	}

	/**
	 * Convenience method for deleting rows in wishlist.
	 * 
	 * @param rowId
	 * @return the number of rows affected if a whereClause is passed in, 0
	 *         otherwise. To remove all rows and get a count pass "1" as the
	 *         whereClause.
	 */
	public boolean deleteWishListItem(long rowId) {
		ObjDataBaseHelper.openDataBase();
		this.db = ObjDataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				boolean open;
				open = db.delete(MobicartDbConstants.TBL_WISHLIST,
						MobicartDbConstants.KEY_ROWID + "=" + rowId, null) > 0;
				return open;
			}
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return false;
	}

	/**
	 * Convenience method for updating rows in cart
	 * 
	 * @param rowId
	 * @param pid
	 * @param pOptId
	 * @param qn
	 * @return
	 */
	public boolean updateCartList(long rowId, int pid, String pOptId, int qn) {
		ObjDataBaseHelper.openDataBase();
		this.db = ObjDataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				boolean open;
				ContentValues args = new ContentValues();
				args.put(MobicartDbConstants.KEY_PRODUCT_ID, pid);
				args.put(MobicartDbConstants.KEY_PRODUCT_OPTION_ID, pOptId);
				args.put(MobicartDbConstants.KEY_QUANTITY, qn);
				open = db.update(MobicartDbConstants.TBL_CART, args,
						MobicartDbConstants.KEY_ROWID + "=" + rowId, null) > 0;
				return open;
			}
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return true;
	}

	/**
	 * Convenience method for getting rows from table.
	 * 
	 * @param <E>
	 * @param sql
	 * @param modelVo
	 */
	public <E> void GetRow(String sql, E modelVo) {
		Cursor cursor = null;
		if (!db.isOpen()) {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
		}
		try {
			cursor = db.rawQuery(sql, null);
			if (cursor.moveToFirst()) {
				((IModelVo) modelVo).FillVo(cursor);
			}
		} catch (CursorIndexOutOfBoundsException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (cursor != null && !cursor.isClosed()) {
				cursor.close();
			}
			if (db.isOpen())
				db.close();
		}
	}

	/**
	 * Convenience method to check item is already exists or not.
	 * 
	 * @param sql
	 * @return
	 */
	public boolean checkIfItemExists(String sql) {
		if (!ObjDataBaseHelper.isOpen()) {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
		}
		Cursor cursor = null;
		try {
			cursor = db.rawQuery(sql, null);
			if (cursor != null && cursor.getCount() > 0) {
				return true;
			}
		} catch (CursorIndexOutOfBoundsException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (cursor != null && !cursor.isClosed()) {
				cursor.close();
				db.close();
			}
		}
		return false;
	}

	/**
	 * Convenience method to check item with option id is already exists in
	 * table or not.
	 * 
	 * @param sql
	 * @return
	 */
	public boolean checkIfItemIdwithOptionId(String sql) {
		if (!ObjDataBaseHelper.isOpen()) {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
		}
		Cursor cursor = null;
		try {
			cursor = db.rawQuery(sql, null);
			if (cursor != null && cursor.getCount() > 0) {

				return true;
			}
		} catch (CursorIndexOutOfBoundsException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (cursor != null && !cursor.isClosed()) {
				cursor.close();
				db.close();
			}
		}
		return false;
	}

	/**
	 * Convenience method to check item id is already exists in table or not.
	 * 
	 * @param sql
	 * @return
	 */
	public boolean checkIfItemIdExists(String sql) {
		if (!ObjDataBaseHelper.isOpen()) {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
		}
		Cursor cursor = null;
		try {
			cursor = db.rawQuery(sql, null);
			cursor.moveToFirst();
			if (cursor != null && cursor.getCount() > 0) {
				return true;
			}
		} catch (CursorIndexOutOfBoundsException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (cursor != null && !cursor.isClosed()) {
				cursor.close();
				db.close();
			}
		}
		return false;
	}

	/**
	 * Convenience method to check selected options match occurs or not.
	 * 
	 * @param sql
	 * @return
	 */
	public int GetSelectedOptionsMatch(String sql, int prodId) {
		if (!ObjDataBaseHelper.isOpen()) {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
		}
		try {
			SQLiteStatement sqlstatement = db.compileStatement(sql);
			int count = (int) sqlstatement.simpleQueryForLong();
			return count;
		} catch (CursorIndexOutOfBoundsException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			db.close();
		}
		return 0;
	}

	/**
	 * Convenience method for getting rows from selected table.
	 * 
	 * @param <E>
	 * @param rawquery
	 * @param modelVo
	 * @return
	 */
	public <E> ArrayList<E> GetRows(String rawquery, E modelVo) {
		Cursor cursor = null;
		ArrayList<E> arrIModelVo = new ArrayList<E>();
		if (!db.isOpen()) {
			ObjDataBaseHelper.openDataBase();
			this.db = ObjDataBaseHelper.myDataBase;
		}
		try {
			cursor = db.rawQuery(rawquery, null);
			cursor.moveToFirst();
			do {
				E obj = ((IModelVo) modelVo).CreateInstance(modelVo);
				if (cursor.getCount() != 0) {
					((IModelVo) obj).FillVo(cursor);
					arrIModelVo.add((obj));
				}
			} while (cursor.moveToNext());
		} catch (CursorIndexOutOfBoundsException e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (cursor != null && !cursor.isClosed()) {
				cursor.close();
				db.close();
			}
			db.close();
		}
		return arrIModelVo;
	}

	/**
	 * Convenience method for deleting wishlist item with option id from
	 * wishlist option id.
	 * 
	 * @param rowId
	 * @return
	 */
	public boolean deleteWishListItemFromOptionTable(int rowId) {
		ObjDataBaseHelper.openDataBase();
		DataBaseAccess.db = DataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				@SuppressWarnings("unused")
				int open;
				open = db.delete(
						MobicartDbConstants.TBL_WISHLIST_PRODUCT_OPTIONS,
						MobicartDbConstants.KEY_ROWID + "=" + rowId, null);
				return true;
			}
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return false;
	}

	/**
	 * Convenience method for deleting wishlist item with option id from
	 * wishlist table.
	 * 
	 * @param productId
	 * @return
	 */
	public boolean deleteWishListItemFromOptionTableWithProductId(int productId) {
		ObjDataBaseHelper.openDataBase();
		DataBaseAccess.db = DataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				@SuppressWarnings("unused")
				int open;
				open = db.delete(
						MobicartDbConstants.TBL_WISHLIST_PRODUCT_OPTIONS,
						MobicartDbConstants.KEY_PRODUCT_ID + "=" + productId,
						null);
				return true;
			}
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return false;
	}

	/**
	 * Convenience method for deleting wishlist item from wishlist table.
	 * 
	 * @param productId
	 * @return
	 */
	public boolean deleteWishListItemWithProductId(int productId) {
		ObjDataBaseHelper.openDataBase();
		DataBaseAccess.db = DataBaseHelper.myDataBase;
		try {
			if (db.isOpen()) {
				@SuppressWarnings("unused")
				int open;
				open = db.delete(MobicartDbConstants.TBL_WISHLIST,
						MobicartDbConstants.KEY_PRODUCT_ID + "=" + productId,
						null);
				return true;
			}
		} catch (Exception e) {
			objMobicartLogger.LogDBException(reqDateFormat.format(new Date()),e.getMessage());
		} finally {
			if (db.isOpen())
				db.close();
		}
		return false;
	}
}