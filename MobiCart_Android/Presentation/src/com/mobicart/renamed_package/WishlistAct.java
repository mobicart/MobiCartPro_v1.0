package com.mobicart.renamed_package;

import java.util.concurrent.TimeUnit;
import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetWishListProductTask;

/**
 * This Activity Class shows the list of products which are added to wishlist by
 * user.
 * 
 * @author mobicart
 * 
 */
public class WishlistAct extends Activity implements OnClickListener {

	private ListView wishlistLV;
	private TextView TitleTV;
	private ImageView TitleIV;
	private MyCommonView backButton, cartButton, cartEditBtn;
	public static int wishlist = 1;
	public static int currentStatus = wishlist;
	public static int WISHLIST_BUTTON_MODE_EDIT = 2;
	public static int WISHLIST_BUTTON_MODE_CART = 1;
	public static int WishListButtonMode = WISHLIST_BUTTON_MODE_CART;
	public static int WISHLIST_BUTTON_MODE_DONE = 3;
	@SuppressWarnings("unused")
	private GetWishListProductTask getWishListData;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.wishlist_layout);
		prepareViewControls();
		backButton.setOnClickListener(this);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		currentStatus = wishlist;
		if (cartButton.getText().toString().equalsIgnoreCase(
				MobicartCommonData.keyValues.getString(
						"key.iphone.shoppingcart.edit", "Edit"))) {
			cartButton.setGravity(Gravity.CENTER);
			cartButton.setPadding(0, 0, 0, 0);
		} else {
			cartButton.setText("" + TabHostAct.cartItemsCounter);
			cartButton.setGravity(Gravity.RIGHT);
			cartButton.setPadding(0, 7, 18, 0);
		}
		cartButton.setBackgroundResource(R.drawable.button_without_color);
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		TitleIV = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);
		TitleTV = (TextView) findViewById(R.id.common_nav_bar_heading_TV);
		wishlistLV = (ListView) findViewById(R.id.wishlist_LV);
		backButton = TabHostAct.prepareSoftBackButton(this);
		cartButton = TabHostAct.prepareCartEditButton(this);

		backButton.setVisibility(View.VISIBLE);
		TitleIV.setImageDrawable(getResources().getDrawable(
				R.drawable.whishlist_star));
		TitleTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.wishlist.wishlist", "Wishlist"));
		backButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.account", "Account"));
		backButton.setBackgroundResource(R.drawable.account_btn_bg);
		cartButton.setVisibility(View.VISIBLE);
		cartButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.edit", "Edit"));
	}

	@Override
	protected void onResume() {
		backButton.setVisibility(View.VISIBLE);
		backButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.account", "Account"));
		backButton.setOnClickListener(this);

		doDoneButtonWork();
		cartButton.setBackgroundResource(R.drawable.button_without_color);
		cartButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (WishListButtonMode == WISHLIST_BUTTON_MODE_EDIT) {
					doEditButtonWork();
				} else if (WishListButtonMode == WISHLIST_BUTTON_MODE_DONE) {
					doDoneButtonWork();
				}
			}
		});
		super.onResume();
	}

	/**
	 * Method is called when edit button is pressed by user on Wishlist Screen.
	 */
	private void doEditButtonWork() {
		WishListButtonMode = WISHLIST_BUTTON_MODE_DONE;
		getWishListData = (GetWishListProductTask) new GetWishListProductTask(
				this.getParent(), wishlistLV).execute("");
		final ProgressDialog dialog = new ProgressDialog(getParent());
		dialog.setCancelable(false);
		dialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", "Loading")
				+ "...");
		dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		dialog.show();
		Thread myThread = new Thread(new Runnable() {
			public void run() {
				try {
					TimeUnit.SECONDS.sleep(2);
				} catch (InterruptedException e) {
				}
				dialog.dismiss();
			}
		});
		myThread.start();
		cartButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.done", "Done"));
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		cartEditBtn.setVisibility(View.VISIBLE);
		cartButton.setVisibility(View.GONE);
		cartEditBtn.setText("" + CartItemCount.getCartCount(this));
		cartEditBtn.setGravity(Gravity.RIGHT);
		cartEditBtn.setPadding(0, 7, 18, 0);
		backButton.setVisibility(View.GONE);
		cartEditBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		super.onPause();
	}

	/**
	 * Method is called when done button is pressed by user on Wishlist Screen.
	 */
	private void doDoneButtonWork() {
		WishListButtonMode = WISHLIST_BUTTON_MODE_EDIT;
		getWishListData = (GetWishListProductTask) new GetWishListProductTask(
				this.getParent(), wishlistLV).execute("");
		final ProgressDialog dialog = new ProgressDialog(getParent());
		dialog.setCancelable(false);
		dialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", "Loading")
				+ "...");
		dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		dialog.show();
		Thread myThread = new Thread(new Runnable() {
			public void run() {
				try {
					TimeUnit.SECONDS.sleep(2);
				} catch (InterruptedException e) {
				}
				dialog.dismiss();
			}
		});
		myThread.start();
		cartButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.edit", "Edit"));
		cartButton.setGravity(Gravity.CENTER);
		cartButton.setPadding(0, 0, 0, 0);
		cartButton.setBackgroundResource(R.drawable.button_without_color);
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backButton.setVisibility(View.INVISIBLE);
		cartButton.setVisibility(View.GONE);
		cartEditBtn.setVisibility(View.VISIBLE);
		cartButton.setGravity(Gravity.RIGHT);
		cartButton.setPadding(0, 7, 18, 0);
		cartButton.setText("" + TabHostAct.cartItemsCounter);
		cartButton.setBackgroundResource(R.drawable.cart_icon_selector);
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.universal_back_btn: {
			finish();
			break;
		}
		}
	}
}
