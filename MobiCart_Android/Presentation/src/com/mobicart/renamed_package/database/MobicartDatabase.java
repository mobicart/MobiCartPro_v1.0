package com.mobicart.renamed_package.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import com.mobicart.android.model.CartItemVO;

/**
 * @author mobicart
 * 
 */
public class MobicartDatabase {

	private SQLiteDatabase database;
	static int counter = 4;

	/**
	 * @param context
	 */
	public MobicartDatabase(Context context) {
	}

	/***/
	public void insertToCartList() {
		ContentValues values = new ContentValues();
		values.put(CartItemVO.QUANTITY, 5);
		values.put(CartItemVO.PRODUCT_OPTIONS_ID, counter++);
		values.put(CartItemVO.PRODUCT_ID, 111);

		database.insert(CartItemVO.CART_TABLE_NAME, null, values);
	}
}
