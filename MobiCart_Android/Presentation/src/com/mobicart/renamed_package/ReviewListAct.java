package com.mobicart.renamed_package;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.RatingBar;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.adapters.ReviewListAdapter;

/**
 * This Activity Class displays the Reviews for a product Given By Users.
 * 
 * @author mobicart
 * 
 */

public class ReviewListAct extends Activity implements OnClickListener {

	private ListView reviewLV;
	private MyCommonView reviewBtn, backBtn, cartBtn,cartEditBtn;
	private MyCommonView rProductTitle;
	private int getCurrentProductId;
	private String productName;
	private boolean isWishlist = false;
	public static int count;
	public static MyCommonView reviewCount;
	public static RatingBar rViews;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.review_layout);
		prepareViewControls();
		Bundle extra = getIntent().getExtras();
		getCurrentProductId = extra.getInt("Id");
		isWishlist = extra.getBoolean("Wishlist");
		productName = extra.getString("ProductName");
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
		reviewCount.setText(ProductDetailAct.iRating
				+ " "
				+ MobicartCommonData.keyValues.getString(
						"key.iphone.reviews.reviews", "Review(s)"));
		rViews.setRating(ProductDetailAct.fAvRating);
		rViews.setStepSize((float) 0.5);
		rProductTitle.setText(productName);
		backBtn.setOnClickListener(this);
		setReviewListAapter();
		try {
			reviewLV
					.setAdapter(new ReviewListAdapter(this, getCurrentProductId));
		} catch (NullPointerException e) {
			showServerError();
		} catch (JSONException e) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
		reviewBtn.setOnClickListener(this);
	}

	/**
	 * This Method shows Network related errors.
	 */
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(ReviewListAct.this)
				.create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.title", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.text", "Network Error"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent intent = new Intent(Intent.ACTION_MAIN);
						intent.addCategory(Intent.CATEGORY_HOME);
						intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						ReviewListAct.this.startActivity(intent);
						ReviewListAct.this.finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * This method shows Server errors.
	 */
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				ReviewListAct.this).create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.title.error", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.text", "Server not Responding"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "OK"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						alertDialog.cancel();
					}
				});
		alertDialog.show();
	}

	public static void setReviewListAapter() {
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		rViews = (RatingBar) findViewById(R.id.review_Ratingbar);
		rProductTitle = (MyCommonView) findViewById(R.id.review_title_TV);
		reviewBtn = (MyCommonView) findViewById(R.id.review_writeReview_Btn);
		reviewLV = (ListView) findViewById(R.id.review_LV);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.VISIBLE);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
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
		reviewCount = (MyCommonView) findViewById(R.id.review_count_TV);
		reviewCount.setClickable(false);
		reviewBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.reviews.writereview", "Write Review"));
	}

	@Override
	protected void onResume() {
		try {
			reviewLV
					.setAdapter(new ReviewListAdapter(this, getCurrentProductId));
		} catch (NullPointerException e) {
			showServerError();
		} catch (JSONException e) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
		backBtn.setVisibility(View.VISIBLE);
		super.onResume();
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		if (isWishlist == true) {
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.wishlist", "Wishlist"));
			backBtn.setVisibility(View.VISIBLE);
		} else {
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.department.store", "Store"));
			backBtn.setVisibility(View.VISIBLE);
		}
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.review_writeReview_Btn:
			ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
			Intent intent = new Intent(parentActivity.getApplicationContext(),
					PostReviewAct.class);
			intent.putExtra("Id", getCurrentProductId);
			intent.putExtra("isFromParent", "Review");
			parentActivity.startChildActivity("PostReviewAct", intent);
			break;
		case R.id.universal_back_btn:
			finish();
			break;
		case R.id.review_count_TV:
			try {
				reviewLV.setAdapter(new ReviewListAdapter(this,
						getCurrentProductId));
			} catch (NullPointerException e) {
				showServerError();
			} catch (JSONException e) {
				showServerError();
			} catch (CustomException e) {
				showNetworkError();
			}
			break;
		case R.id.navigation_bar_cart_btn:
			StoreTabGroupAct parentActivity1 = (StoreTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.home.back", "Back");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "2");
			parentActivity1.startChildActivity("CartAct", cartAct);
			break;
		default:
			break;
		}
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}
}
