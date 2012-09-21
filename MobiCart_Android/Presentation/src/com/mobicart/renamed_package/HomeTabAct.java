package com.mobicart.renamed_package;

import java.io.IOException;

import android.app.ActivityGroup;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.Gallery;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.ViewFlipper;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.TextView.OnEditorActionListener;

import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetBannersTask;
import com.mobicart.renamed_package.utils.AsyncTasks.GetColorSchemeTask;
import com.mobicart.renamed_package.utils.AsyncTasks.GetImagesTask;
import com.mobicart.renamed_package.utils.listeners.HomeBannersGestureListener;

/**
 * This activity class is for the home tab section which hosts the banners and
 * the featured products gallery.
 * @author mobicart
 * 
 */
public class HomeTabAct extends ActivityGroup implements OnClickListener {

	public static final int ORDER_PRODUCT_LIST = 0x7789;
	public static final int ORDER_PRODUCT_DETAIL = 0x7788;
	public static final int ORDER_PRODUCT_CART = 0x7787;
	public static final int ORDER_DEPARTMENTS = 0x7786;
	public static final int ORDER_PRODUCT_SEARCH = 0x7785;
	public static final int ORDER_FEATURED_PRODUCT_DETAIL = 0x7784;
	public static String searchQuery = "";
	public static int territoryId = 1;
	public static int stateId = 1;
	public static int currentOrder = ORDER_DEPARTMENTS;
	public static int orderedProductId = 0;
	public static int seclectedFeturedProductPosition;
	private EditText homeSearchET;
	private RelativeLayout homeTopRL;
	public ViewFlipper bannerVF;
	private Gallery homeGallery;
	private MyCommonView searchButton, backBtn, cartBtn, cartEditBtn;
	private InputMethodManager imm;
	private boolean isInSearchMode = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.home_tab_layout);
		prepareAllControls();
		GetColorSchemeTask getColorTask = new GetColorSchemeTask(this,
				homeTopRL, homeSearchET, searchButton);
		getColorTask.execute("");
		MobicartCommonData.isFromStart = "";
		
	}

	/**
	 * This Method is used to shows Server Errors.
	 */
	public void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(HomeTabAct.this)
				.create();
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

	@Override
	protected void onStart() {
		super.onStart();
	}

	@Override
	protected void onResume() {
		if (SignUpAct.isLogged) {
			addGalleryImages();
		}
		if (MyAcountDetails.isUpdated) {
			addGalleryImages();
		}
		if (MobicartCommonData.isFromStart.equalsIgnoreCase("")) {
			addGalleryImages();
		}
		prepareBannersVF();
		cartEditBtn = TabHostAct.prepareCartEditButton(this);
		cartEditBtn.setVisibility(View.GONE);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		changeSearchBarAppearance(true);
		backBtn.setVisibility(View.GONE);
		super.onResume();
	}

	@Override
	protected void onPause() {
		ParentActivityGroup.fromHome = true;
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		ParentActivityGroup.fromHome = false;
		backBtn.setVisibility(View.GONE);
		MobicartCommonData.isFromStart = "NotSplash";
		super.onDestroy();
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
	}

	@Override
	protected void onRestoreInstanceState(Bundle savedInstanceState) {
		super.onRestoreInstanceState(savedInstanceState);
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareAllControls() {
		imm = (InputMethodManager) this
				.getSystemService(Context.INPUT_METHOD_SERVICE);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.GONE);
		homeSearchET = (EditText) findViewById(R.id.home_tab_search_et);
		homeSearchET.setBackgroundResource(R.drawable.search_bar_dpi);
		homeSearchET.setHintTextColor(Color.parseColor("#b4b4b4"));
		homeSearchET.setHint(MobicartCommonData.keyValues.getString(
				"key.iphone.common.search", "Enter Keyword To Search"));
		bannerVF = (ViewFlipper) findViewById(R.id.home_tab_banners_view_flipper);
		searchButton = (MyCommonView) findViewById(R.id.home_tab_search_button);
		searchButton.setText(" "
				+ MobicartCommonData.keyValues.getString("key.iphone.cancel",
						"Cancel") + " ");
		homeGallery = (Gallery) findViewById(R.id.home_tab_gallery_view);
		homeTopRL = (RelativeLayout) findViewById(R.id.home_tab_Top_RL);
		searchButton.setOnClickListener(this);
		homeSearchET.setOnClickListener(this);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		cartBtn.setOnClickListener(this);
		homeSearchET.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				homeSearchET.setHint("");
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {

			}
		});
		homeSearchET.setOnEditorActionListener(new OnEditorActionListener() {
			@Override
			public boolean onEditorAction(TextView v, int actionId,
					KeyEvent event) {
				searchQuery = homeSearchET.getText().toString();
				homeSearchET.setText("");
				homeSearchET.setHint("");
				if (searchQuery.equalsIgnoreCase("")) {
					changeSearchBarAppearance(true);
					imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
					if (actionId == EditorInfo.IME_ACTION_SEARCH) {
						imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
						return true;
					}
				} else {
					currentOrder = ORDER_PRODUCT_SEARCH;
					TabHostAct.tabHost.setCurrentTab(1);
					imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
					if (actionId == EditorInfo.IME_ACTION_SEARCH) {
						imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
						return true;
					}
				}
				return false;
			}
		});
		try {
			@SuppressWarnings("unused")
			SQLiteDatabase database;
			getAssets().open("DBMobicart.sqlite3");
		} catch (IOException e) {
		}
		homeGallery.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				currentOrder = ORDER_PRODUCT_DETAIL;
				seclectedFeturedProductPosition = arg2;
				final ProgressDialog dialog = ProgressDialog.show(
						HomeTabAct.this.getParent(), null,
						MobicartCommonData.keyValues.getString(
								"key.iphone.LoaderText", "Loading..."));
				Handler handler = new Handler();
				handler.postDelayed(new Runnable() {
					@Override
					public void run() {
						TabHostAct.tabHost.setCurrentTab(1);
						dialog.cancel();
					}
				}, 1000);
			}
		});
	}

	/**
	 * This method is used to Async task to get gallery images from server.
	 */
	private void addGalleryImages() {
		GetImagesTask ImagesTask = new GetImagesTask(this.getParent(),
				homeGallery);
		ImagesTask.execute("");
	}

	/**
	 * This method is used to add images to view flipper and implement onTouch
	 * listener of Flipper in this.
	 */
	private void prepareBannersVF() {
		addImagesToBanners();
		final GestureDetector gestDetector = new GestureDetector(this,
				new HomeBannersGestureListener(bannerVF));
		bannerVF.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				gestDetector.onTouchEvent(event);
				return true;
			}
		});
	}

	/**
	 * This method is used to call Async task to get banner images from server.
	 */
	private void addImagesToBanners() {
		GetBannersTask bannerTask = new GetBannersTask(this.getParent(),
				bannerVF);
		bannerTask.execute("");
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.home_tab_search_button:
			homeSearchET.setText("");
			changeSearchBarAppearance(true);
			InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
			imm.hideSoftInputFromWindow(homeSearchET.getWindowToken(), 0);
			break;
		case R.id.home_tab_search_et:
			homeSearchET.setHint("");
			homeSearchET.setCursorVisible(true);
			changeSearchBarAppearance(false);
			break;
		case R.id.navigation_bar_cart_btn:
			HomeTabGroupAct parentActivity = (HomeTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.home", "Home");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "0");
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		default:
			break;
		}
	}

	/**
	 * to either contract or expand the search bar with cancel button.
	 */
	private void changeSearchBarAppearance(boolean expand) {
		if (expand) {
			homeSearchET.setHint(MobicartCommonData.keyValues.getString(
					"key.iphone.common.search", "Enter Keyword To Search"));
			homeSearchET.setBackgroundResource(R.drawable.search_bar_dpi);
			searchButton.setVisibility(View.GONE);
			homeSearchET.setCursorVisible(false);
			isInSearchMode = false;
		} else {
			homeSearchET.setHint("");
			homeSearchET
					.setBackgroundResource(R.drawable.search_bar_withoutbtn_dpi);
			searchButton.setVisibility(View.VISIBLE);
			homeSearchET.setCursorVisible(true);
			isInSearchMode = true;
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		return false;
	}

	@Override
	public void onBackPressed() {
		if (isInSearchMode) {
			changeSearchBarAppearance(true);
			searchButton.setVisibility(View.GONE);
			imm.hideSoftInputFromWindow(homeSearchET.getWindowToken(), 0);
		}
		super.onBackPressed();
	}
}
