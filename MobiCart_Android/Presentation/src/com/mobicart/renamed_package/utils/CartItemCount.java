/**
 * 
 */
package com.mobicart.renamed_package.utils;

import android.content.Context;

import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.android.model.CartItemVO;
import com.mobicart.android.model.MobicartCommonData;

/**
 * This Class is used to get count of cart items.
 * 
 * @author mobicart
 * 
 */
public class CartItemCount {

	static DataBaseAccess dataBase;

	public static int getCartCount(Context context) {
		dataBase = new DataBaseAccess(context);
		MobicartCommonData.objCartList = dataBase.GetRows("SELECT * from "
				+ CartItemVO.CART_TABLE_NAME, new CartItemVO());
		return MobicartCommonData.cartCount = MobicartCommonData.objCartList
				.size();
	}
}
