package com.mobicart.renamed_package;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RatingBar;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.core.Product;
import com.mobicart.android.model.AccountVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This activity class is used for Posting Reviews on Product.
 * 
 * @author mobicart
 * 
 */
public class PostReviewAct extends Activity implements OnClickListener {

	private MyCommonView postBtn, backBtn, cartBtn,cartEditBtn;
	private EditText reviewET;
	private String reviewText;
	private InputMethodManager imm;
	private RatingBar ratingBar;
	private int productId, currentProductId;
	private String email, uName;
	private float ratingstar;
	private boolean isChked, isWishlist = false;
	private AccountVO objAccountVO = new AccountVO();

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		imm = (InputMethodManager) this
				.getSystemService(Context.INPUT_METHOD_SERVICE);
		if (imm != null) {
			imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
		}
		setContentView(R.layout.postreview_layout);
		Bundle extra = getIntent().getExtras();
		currentProductId = extra.getInt("Id");
		isWishlist = extra.getBoolean("Wishlist");
		prepareViewControls();
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setOnClickListener(this);
		cartBtn.setVisibility(View.VISIBLE);
		backBtn.setVisibility(View.VISIBLE);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
		backBtn.setOnClickListener(this);
		reviewET.setOnClickListener(this);
		reviewET.setFocusable(true);
		reviewET.setCursorVisible(true);
		reviewET.setHighlightColor(000000);
		postBtn.setOnClickListener(this);
	}

	/**
	 * This method is used for checking the database for knowing user is logged
	 * in or not.
	 * 
	 * @return
	 */
	private boolean chkUserExistOrNot() {
		DataBaseAccess objDataBaseAccess = new DataBaseAccess(this);
		objDataBaseAccess.GetRow("Select * from tblAccountDetails where _id=1",
				objAccountVO);
		if (objAccountVO.get_id() > 0) {
			isChked = true;
		} else {
			isChked = false;
		}
		return isChked;
	}

	private void hideKeyBoard() {
		imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(reviewET.getWindowToken(), 0);
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		MyCommonView reviewTitleTV, rateItTV;
		reviewTitleTV = (MyCommonView) findViewById(R.id.postReview_title_TV);
		rateItTV = (MyCommonView) findViewById(R.id.postReview_title_rateIt_TV);
		postBtn = (MyCommonView) findViewById(R.id.postReview_Btn);
		postBtn = (MyCommonView) findViewById(R.id.postReview_Btn);
		reviewET = (EditText) findViewById(R.id.postReview_ET);
		ratingBar = (RatingBar) findViewById(R.id.postReview_Ratingbar);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		
		reviewTitleTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.postreview.postreview", "Post Review"));
		rateItTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.postreview.rateit", "Rate It")
				+ ":");
		postBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.postreview.postreview", "Post Review"));
		reviewET.requestFocus();
	}

	@Override
	protected void onResume() {
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
		if (isWishlist == true) {
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.wishlist", "Wishlist"));
			backBtn.setVisibility(View.VISIBLE);
		} else {
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.department.store", "Store"));
			backBtn.setVisibility(View.VISIBLE);
		}
		hideKeyBoard();
		MobicartCommonData.isFromStart = "NotSplash";
		super.onDestroy();
	}

	@Override
	protected void onPause() {
		hideKeyBoard();
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.postReview_ET:
			imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
			imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
			break;
		case R.id.postReview_Btn:
			chkUserExistOrNot();
			if (isChked) {
				email = objAccountVO.geteMailAddress();
				uName = objAccountVO.getsUserName();
				hideKeyBoard();
				prepareToPost(email, uName);
				prePareDialog();
			} else {
				requireFillDeatils();
			}
			break;
		case R.id.universal_back_btn:
			finish();
			break;
		case R.id.navigation_bar_cart_btn:
			StoreTabGroupAct parentActivity = (StoreTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.home.back", "Back");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "2");
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		default:
			break;
		}
	}

	/**
	 * This method showing alert for user to please fill the account details.
	 */
	private void requireFillDeatils() {
		AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
		builder.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.title", "Alert"));
		builder.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.OrderHistoryDialog",
				"Please Fill User Account Details"));
		builder.setCancelable(false).setPositiveButton(
				MobicartCommonData.keyValues.getString(
						"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
						Intent intent = new Intent(parentActivity
								.getApplicationContext(), SignUpAct.class);
						intent.putExtra("Id", productId);
						intent.putExtra("IsFrom", "PostReviewAct");
						intent.putExtra("backBtn", MobicartCommonData.keyValues
								.getString("key.iphone.home.back", "Back"));
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
	 * This method is used for displaying alert when rating is successfully
	 * posted on server.
	 */
	private void prePareDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
		builder.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.review.rating.posted.title", "Message"));
		builder.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.review.rating.posted.text",
				"Review and rating posted."));
		builder.setCancelable(true).setPositiveButton(
				MobicartCommonData.keyValues.getString(
						"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						ProductDetailAct.getRatingReview();
						ReviewListAct.setReviewListAapter();
						finish();
					}
				});
		builder.show();
	}

	/**
	 * This method is used for preparing Json to send it to server.
	 * 
	 * @param email
	 * @param uName
	 */
	private void prepareToPost(String email, String uName) {
		reviewText = reviewET.getText().toString();
		ratingstar = ratingBar.getRating();
		Product product = new Product();
		JSONObject OBj = new JSONObject();
		try {
			OBj.put("productId", currentProductId);
			OBj.put("sReveiwerName", uName);
			OBj.put("sReviewerEmail", email);
			OBj.put("iRating", ratingstar);
			OBj.put("sReview", reviewText);
			OBj.toString();
			try {
				product.createProductReview(PostReviewAct.this, OBj.toString());
			} catch (CustomException e) {
				showNetworkError();
			}
		} catch (JSONException e) {
		}
	}

	/**
	 * This Method Shows Network related errors.
	 */
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(PostReviewAct.this)
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
						PostReviewAct.this.startActivity(intent);
						PostReviewAct.this.finish();
					}
				});
		alertDialog.show();
	}
}
