package com.mobicart.renamed_package;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.AccountVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetProductOrder;

/**
 * This Activity class is used for showing list of order.
 * @author mobicart
 * 
 */
public class OrderHistoryAct extends Activity implements OnClickListener {
	
	private ListView orderListView;
	private MyCommonView backButton, cartBtn, tv,cartEditBtn;
	private DataBaseAccess objDataBaseAccess;
	private AccountVO objAccountVO = new AccountVO();
	private ImageView titleIV;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	
		setContentView(R.layout.order_list);
		prepareControlViews();
		backButton.setOnClickListener(this);
		cartBtn.setOnClickListener(this);
		objDataBaseAccess.GetRow("Select * from tblAccountDetails where _id=1", objAccountVO);
		if (objAccountVO.geteMailAddress() == null) {
			AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
			builder.setTitle(MobicartCommonData.keyValues.getString(
					"key.iphone.nointernet.title", "Alert"));
			builder.setMessage(MobicartCommonData.keyValues.getString(
					"key.iphone.OrderHistoryDialog",
					"Please fill User Account Details"));
			builder.setCancelable(false).setPositiveButton(
					MobicartCommonData.keyValues.getString(
							"key.iphone.nointernet.cancelbutton", "ok"),
					new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							AccountTabGroupAct parentActivity = (AccountTabGroupAct) getParent();
							Intent signupAct = new Intent(OrderHistoryAct.this, SignUpAct.class);
							signupAct.putExtra("IsFrom","OrderHistoryAct");
							signupAct.putExtra("backBtn",MobicartCommonData.keyValues.getString(
									"key.iphone.tabbar.account", "Account"));
							parentActivity.startChildActivity("SignUpAct", signupAct);
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

		} else {
			bindOrderList(objAccountVO.geteMailAddress());
		}
	}
	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareControlViews() {
		titleIV = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);
		tv = (MyCommonView) findViewById(R.id.common_nav_bar_heading_TV);
		orderListView = (ListView) findViewById(R.id.order_LV);
		objDataBaseAccess = new DataBaseAccess(this);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		
		backButton = TabHostAct.prepareSoftBackButton(this);
		cartBtn = TabHostAct.prepareCartButton(this);
		titleIV.setVisibility(View.GONE);
		backButton.setVisibility(View.VISIBLE);
		backButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.account", "Account"));
		backButton.setBackgroundResource(R.drawable.account_btn_bg);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText(""+CartItemCount.getCartCount(this));
		tv.setText("  "+MobicartCommonData.keyValues.getString(
				"key.iphone.myaccount.orderhistory", "View Order History"));
	}

	/**
	 * 
	 * @param email
	 */
	private void bindOrderList(String email) {
		GetProductOrder productOrder = new GetProductOrder(this.getParent(), orderListView,
				email);
		productOrder.execute("");
	}
	
	@Override
	protected void onResume() {
		cartBtn.setText(""+CartItemCount.getCartCount(this));
		backButton.setVisibility(View.VISIBLE);
		backButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.account", "Account"));
		backButton.setOnClickListener(this);
		super.onResume();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart="NotSplash";
		backButton.setVisibility(View.INVISIBLE);
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.universal_back_btn: {
			AccountTabGroupAct parentActivity = (AccountTabGroupAct) getParent();
			Intent intent = new Intent(parentActivity.getApplicationContext(),
					MyAccountTabAct.class);
			parentActivity.startChildActivity("MyAccountTabAct", intent);
			break;
		}
		case R.id.navigation_bar_cart_btn:
			AccountTabGroupAct parentAct = (AccountTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = tv.getText().toString();
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "4");
			parentAct.startChildActivity("CartAct", cartAct);
			break;
		}
	}
	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart="NotSplash";
		super.onPause();
	}
}