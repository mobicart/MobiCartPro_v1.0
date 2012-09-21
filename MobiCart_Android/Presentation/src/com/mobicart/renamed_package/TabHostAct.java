package com.mobicart.renamed_package;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.TabActivity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TabHost;
import android.widget.TextView;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.utils.ImageLoader;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This Activity is used to host all TabGroup Activities.
 * 
 * @author mobicart
 * 
 */
@SuppressWarnings("unused")
public class TabHostAct extends TabActivity {

	private RelativeLayout companyLogoIV;
	private MyCommonView cartButton, cartEditBtn, backButton;
	static TabHost tabHost;
	public static boolean brandingStatus = true;
	public static RelativeLayout navigationBarRL;
	public static int cartItemsCounter;
	private DataBaseAccess dataBase;
	public static boolean checkNews = false;
	private Resources res;
	private TabHost.TabSpec spec;
	private Intent tabIntent;
	public ImageLoader imageLoader;
	private AlertDialog alertDialog;
	private TextView title;
	public static int noOfTabs = 0;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.tab_host_layout);
		imageLoader = new ImageLoader(this.getApplicationContext());
		prepareViewControls();
		res = getResources();
		navigationBarRL.setVisibility(View.VISIBLE);

		tabHost = getTabHost();
		String imageUrl = MobicartCommonData.appVitalsObj.getCompanyLogoUrl();
		ImageView productIV = null;
		productIV = new ImageView(this);
		productIV.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT,
				LayoutParams.WRAP_CONTENT));
		productIV.setTag(MobicartUrlConstants.baseUrl.substring(0,
				MobicartUrlConstants.baseUrl.length() - 1)
				+ imageUrl);
		imageLoader.DisplayImage(MobicartUrlConstants.baseUrl.substring(0,
				MobicartUrlConstants.baseUrl.length() - 1)
				+ imageUrl, this, productIV);
		companyLogoIV.addView(productIV);
		try {
			if (MobicartCommonData.colorSchemeObj.getThemeColor().length() > 0) {
				navigationBarRL.setBackgroundColor(Color.parseColor("#"
						+ MobicartCommonData.colorSchemeObj.getThemeColor()));
			}
		} catch (Exception e) {
			navigationBarRL.setVisibility(View.GONE);
			showServerError();
		}
		MobicartCommonData.keyValues = this.getSharedPreferences("KeyValue",
				Context.MODE_PRIVATE);
		prepareAllTabs();
	}

	/**
	 * This method is used to show Server Errors.
	 */
	private void showServerError() {
		alertDialog = new AlertDialog.Builder(TabHostAct.this).create();
		MobicartCommonData.keyValues = this.getSharedPreferences("KeyValue",
				Context.MODE_PRIVATE);
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.title.error", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.text", "Server not Responding"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "OK"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						alertDialog.cancel();
						finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		dataBase = new DataBaseAccess(this);
		navigationBarRL = (RelativeLayout) findViewById(R.id.nav_bar);
		companyLogoIV = (RelativeLayout) findViewById(R.id.navigation_bar_logo_iv);
		cartButton = (MyCommonView) findViewById(R.id.navigation_bar_cart_btn);
		cartEditBtn = (MyCommonView) findViewById(R.id.navigation_cart_btn);
		backButton = (MyCommonView) findViewById(R.id.universal_back_btn);
	}

	/**
	 * This Method is used to create customized tabs as per data received from
	 * server.
	 */
	private void prepareAllTabs() {
		noOfTabs = 0;
		if (MobicartCommonData.appVitalsObj.getFeaturesList().size() <= 5) {
			for (int i = 0; i < MobicartCommonData.appVitalsObj
					.getFeaturesList().size(); i++) {
				createTab(MobicartCommonData.appVitalsObj.getFeaturesList()
						.get(i).getId());
			}
		} else {
			for (int i = 0; i < MobicartCommonData.appVitalsObj
					.getFeaturesList().size(); i++) {
				if (i != 4) {
					createTab(MobicartCommonData.appVitalsObj.getFeaturesList()
							.get(i).getId());

				} else {
					if (!MobicartCommonData.appVitalsObj.getFeaturesList().get(
							2).getName().equalsIgnoreCase("News"))
						createTab(MobicartCommonData.appVitalsObj
								.getFeaturesList().get(i).getId());
				}
			}
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@SuppressWarnings("static-access")
	private void createTab(int i) {
		switch (i) {
		case 1:
			tabIntent = new Intent().setClass(this, HomeTabGroupAct.class);
			tabIntent.addFlags(tabIntent.FLAG_ACTIVITY_CLEAR_TOP);
			addTab(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.home", "Home"),
					R.drawable.tab_home_selector, tabIntent);
			break;
		case 2:
			tabIntent = new Intent().setClass(this, StoreTabGroupAct.class);
			tabIntent.addFlags(tabIntent.FLAG_ACTIVITY_CLEAR_TOP);
			addTab(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.store", "Store"),
					R.drawable.tab_store_selector, tabIntent);
			break;
		case 3:
			tabIntent = new Intent().setClass(this, NewsTabGroup.class);
			tabIntent.addFlags(tabIntent.FLAG_ACTIVITY_CLEAR_TOP);
			addTab(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.news", "News"),
					R.drawable.tab_news_selector, tabIntent);
			break;
		case 4:
			tabIntent = new Intent().setClass(this, AccountTabGroupAct.class);
			tabIntent.addFlags(tabIntent.FLAG_ACTIVITY_CLEAR_TOP);
			addTab(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.account", "Account"),
					R.drawable.tab_account_selector, tabIntent);
			break;
		case 5:
			tabIntent = new Intent().setClass(this, AboutUsGroupAct.class);
			tabIntent.addFlags(tabIntent.FLAG_ACTIVITY_CLEAR_TOP);
			addTab(MobicartCommonData.keyValues.getString(
					"key.iphone.aboutus.aboutus", "About Us"),
					R.drawable.tab_about_us_selector, tabIntent);
			break;
		case 6:
			tabIntent = new Intent().setClass(this, MoreTabGroupAct.class);
			tabIntent.addFlags(tabIntent.FLAG_ACTIVITY_CLEAR_TOP);
			addTab(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.more", "More"),
					R.drawable.tab_more_selector, tabIntent);
			break;
		default:
			break;
		}
	}

	/**
	 * @param string
	 * @param addToCartBtnSelector
	 * @param tabIntent2
	 */
	private void addTab(String string, int addToCartBtnSelector,
			Intent tabIntent2) {
		RelativeLayout.LayoutParams xhdpi = new RelativeLayout.LayoutParams(144,
				150);
		RelativeLayout.LayoutParams xhdpiNew = new RelativeLayout.LayoutParams(
				180, 150);
		RelativeLayout.LayoutParams hdpi = new RelativeLayout.LayoutParams(96,
				100);
		RelativeLayout.LayoutParams hdpiNew = new RelativeLayout.LayoutParams(
				120, 100);
		RelativeLayout.LayoutParams ldpi = new RelativeLayout.LayoutParams(48,
				45);
		RelativeLayout.LayoutParams ldpiNew = new RelativeLayout.LayoutParams(
				60, 45);
		RelativeLayout.LayoutParams mdpi = new RelativeLayout.LayoutParams(64,
				65);
		RelativeLayout.LayoutParams mdpiNew = new RelativeLayout.LayoutParams(
				80, 65);
		TabHost.TabSpec spec = tabHost.newTabSpec("tab" + string);
		View tabIndicator = LayoutInflater.from(this).inflate(
				R.layout.tab_background_layout, getTabWidget(), false);
		RelativeLayout rl = (RelativeLayout) tabIndicator
				.findViewById(R.id.tabsLayout);
		if (MobicartCommonData.appVitalsObj.getFeaturesList().size() < 5) {
			rl.setLayoutParams(MobicartUrlConstants.resolution == 6 ? SplashAct.xhdpi?xhdpiNew:hdpiNew
					: MobicartUrlConstants.resolution == 4 ? mdpiNew : ldpiNew);
		} else
			rl.setLayoutParams(MobicartUrlConstants.resolution == 6 ?SplashAct.xhdpi?xhdpi: hdpi
					: MobicartUrlConstants.resolution == 4 ? mdpi : ldpi);

		ImageView icon = (ImageView) tabIndicator.findViewById(R.id.icon1);
		icon.setImageResource(addToCartBtnSelector);
		title = (TextView) tabIndicator.findViewById(R.id.tab_backround_tv);
		if (string.equals(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.news", "News"))) {
			title.setPadding(0, 9, 0, 0);
		}
		title.setText(string);
		title.setSingleLine(true);
		spec.setIndicator(tabIndicator);
		spec.setContent(tabIntent2);
		tabHost.addTab(spec);
		noOfTabs++;
	}

	/**
	 * This method returns view for back button that can be used on any sub
	 * activities.
	 * 
	 * @return
	 */
	synchronized public View getBackButton() {
		return backButton;
	}

	/**
	 * This method returns view for cart button that can be used on any sub
	 * activities.
	 * 
	 * @return
	 */
	synchronized public View getCartButton() {
		return cartButton;
	}

	/**
	 * This method is used to create back button that can be used on any sub
	 * activities.
	 * 
	 * @param activity
	 * @return
	 */
	public static MyCommonView prepareSoftBackButton(Activity activity) {
		Activity parentActivity = activity.getParent();
		MyCommonView backBtn = null;
		if (parentActivity instanceof TabHostAct) {
			backBtn = (MyCommonView) ((TabHostAct) parentActivity)
					.getBackButton();
		} else {
			Activity parentToParent = parentActivity.getParent();
			if (parentToParent instanceof TabHostAct) {
				backBtn = (MyCommonView) ((TabHostAct) parentToParent)
						.getBackButton();
			}
		}
		return backBtn;
	}

	/**
	 * This method is used to create cart button that can be used on any sub
	 * activities.
	 * 
	 * @param activity
	 * @return
	 */

	public static MyCommonView prepareCartButton(Activity activity) {
		Activity parentActivity = activity.getParent();
		MyCommonView cartBtn = null;
		if (parentActivity instanceof TabHostAct) {

			cartBtn = (MyCommonView) ((TabHostAct) parentActivity)
					.getCartButton();
		} else {
			Activity parentToParent = parentActivity.getParent();
			if (parentToParent instanceof TabHostAct) {
				cartBtn = (MyCommonView) ((TabHostAct) parentToParent)
						.getCartButton();
			}
		}
		return cartBtn;
	}

	/**
	 * This method returns view for cart Edit button that can be used on any sub
	 * activities.
	 * 
	 * @return
	 */
	private MyCommonView getCartEditButton() {
		return cartEditBtn;
	}

	/**
	 * This method is used to create cart Edit button that can be used on any
	 * sub activities.
	 * 
	 * @param activity
	 * @return
	 */
	public static MyCommonView prepareCartEditButton(Activity activity) {
		Activity parentActivity = activity.getParent();
		MyCommonView cartEditBtn = null;
		if (parentActivity instanceof TabHostAct) {
			cartEditBtn = ((TabHostAct) parentActivity).getCartEditButton();
		} else {
			Activity parentToParent = parentActivity.getParent();
			if (parentToParent instanceof TabHostAct) {
				cartEditBtn = ((TabHostAct) parentToParent).getCartEditButton();
			}
		}
		return cartEditBtn;
	}

	@Override
	protected void onResume() {
		cartButton.setGravity(Gravity.RIGHT);
		if (MobicartUrlConstants.resolution == 3) {
			cartButton.setPadding(0, 4, 12, 0);
		} else {
			cartButton.setPadding(0, 8, 23, 0);
		}
		super.onResume();
	}

	@Override
	protected void onPause() {
		cartButton.setGravity(Gravity.RIGHT);
		if (MobicartUrlConstants.resolution == 3) {
			cartButton.setPadding(0, 4, 12, 0);
		} else {
			cartButton.setPadding(0, 8, 23, 0);
		}
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	@Override
	protected void onRestart() {
		if (MobicartCommonData.isFromStart != "") {
			finish();
			startActivity(new Intent(this, SplashAct.class));
			MobicartCommonData.isFromStart = "";
		}
		super.onRestart();
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	@Override
	protected void onStop() {
		super.onStop();
	}


}
