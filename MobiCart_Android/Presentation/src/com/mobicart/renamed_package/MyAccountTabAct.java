package com.mobicart.renamed_package;

import java.util.ArrayList;

import android.app.ActivityGroup;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.WishListVO;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.database.MobicartDbConstants;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This activity class is used for the Account tab section which manage Login
 * functionality,Account Details,Order Details and Wishlist Details.
 * 
 * @author mobicart
 * 
 */

public class MyAccountTabAct extends ActivityGroup implements OnClickListener {

	private MyCommonView backBtn, viewWishlistBtn, accountBtn, orderHistoryBtn,
			cartBtn,cartEditBtn;
	private DataBaseAccess database;
	private ArrayList<WishListVO> wishList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.account_layout);
		prepareViewControls();
		accountBtn.setOnClickListener(MyAccountTabAct.this);
		viewWishlistBtn.setOnClickListener(MyAccountTabAct.this);
		orderHistoryBtn.setOnClickListener(MyAccountTabAct.this);
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onClick(View v) {
		AccountTabGroupAct parentActivity = (AccountTabGroupAct) getParent();
		switch (v.getId()) {
		case R.id.account_viewWishlist_Btn: {
			if (!chkwishListEmptyOrNot()) {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						getParent());
				builder.setMessage(MobicartCommonData.keyValues.getString(
						"key.iphone.NoProductMessage", "No item found"));
				builder.setCancelable(false).setPositiveButton(
						MobicartCommonData.keyValues.getString(
								"key.iphone.nointernet.cancelbutton", "Ok"),
						new DialogInterface.OnClickListener() {
							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								dialog.cancel();
							}
						});
				builder.show();
			} else {
				parentActivity.startChildActivity("WishlistAct", new Intent(
						MyAccountTabAct.this, WishlistAct.class));
			}
		}
			break;
		case R.id.account_myAccount_Btn:
			if (MobicartCommonData.objAccountVO.get_id() > 0) {
				Intent accountDetail = new Intent(this, MyAcountDetails.class);
				parentActivity.startChildActivity("MyAcountDetails",
						accountDetail);
				break;
			} else {
				Intent signupAct = new Intent(this, SignUpAct.class);
				signupAct.putExtra("IsFrom", "MyAccountTabAct");
				signupAct.putExtra("backBtn", MobicartCommonData.keyValues
						.getString("key.iphone.tabbar.account", "Account"));
				parentActivity.startChildActivity("SignUpAct", signupAct);
				break;
			}
		case R.id.account_orderHistory_Btn:
			if (MobicartCommonData.objAccountVO.get_id() > 0) {
				Intent orderHistoryIntent = new Intent(MyAccountTabAct.this,
						OrderHistoryAct.class);
				parentActivity.startChildActivity("OrderHistoryAct",
						orderHistoryIntent);
			} else {
				fillAccountDetails();
			}
			break;
		case R.id.navigation_bar_cart_btn:
			AccountTabGroupAct parentAct = (AccountTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.account", "Account");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "0");
			parentAct.startChildActivity("CartAct", cartAct);
			break;
		default:
		}
	}

	/**
	 * This method is used to show alert for user to fill Account Information if
	 * user is not logged in.
	 */
	private void fillAccountDetails() {
		AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
		builder.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.title", "Alert"));
		builder.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.OrderHistoryDialog",
				"Please fill User Account Details"));
		builder.setCancelable(false).setPositiveButton(
				MobicartCommonData.keyValues.getString(
						"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
						Intent intent = new Intent(parentActivity
								.getApplicationContext(), SignUpAct.class);
						intent.putExtra("IsFrom", "MyAccountTabAct");
						intent.putExtra("backBtn", MobicartCommonData.keyValues
								.getString("key.iphone.tabbar.account",
										"Account"));
						parentActivity.startChildActivity("SignUpAct", intent);
					}
				});
		builder.setNegativeButton(MobicartCommonData.keyValues.getString(
				"key.iphone.cancel", "Cancel"),
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
					}
				});
		builder.show();
	}

	/**
	 * This method is used to check Items Available in Wishlist Or not.
	 * 
	 * @return
	 */
	private boolean chkwishListEmptyOrNot() {
		database = new DataBaseAccess(this);
		wishList = database.GetRows("SELECT * from "
				+ MobicartDbConstants.TBL_WISHLIST, new WishListVO());
		if (wishList.size() == 0)
			return false;
		else
			return true;
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		MyCommonView titleTV;
		backBtn = TabHostAct.prepareSoftBackButton(this);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		titleTV = (MyCommonView) findViewById(R.id.account_title_TV);
		viewWishlistBtn = (MyCommonView) findViewById(R.id.account_viewWishlist_Btn);
		accountBtn = (MyCommonView) findViewById(R.id.account_myAccount_Btn);
		orderHistoryBtn = (MyCommonView) findViewById(R.id.account_orderHistory_Btn);
		titleTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.myaccount.myaccount", "My Account"));
		try {
			viewWishlistBtn.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			accountBtn.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			orderHistoryBtn.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		} catch (Exception e) {
		}
		viewWishlistBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.myaccount.wishlist", "View Wishlist"));
		accountBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.myaccount.myaccount", "My Account"));
		orderHistoryBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.myaccount.orderhistory", "View Order History"));
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setOnClickListener(this);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
	}

	@Override
	protected void onResume() {
		ParentActivityGroup.fromAccount = true;
		backBtn.setVisibility(View.GONE);
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		super.onResume();
	}

	@Override
	protected void onPause() {
		ParentActivityGroup.fromAccount = false;
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		ParentActivityGroup.fromHome = false;
		ParentActivityGroup.fromAccount = false;
		super.onDestroy();
	}
}
