package com.mobicart.renamed_package;

import android.app.ActivityGroup;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetStaticPagesTask;

/**
 * This activity class is for the More tab section which hosts the Static pages:
 * About Us,Contact Us,Terms and Conditions,Privacy and Delivery/Size Charts.
 * 
 * @author mobicart
 * 
 */
public class MoreTabAct extends ActivityGroup implements OnItemClickListener,
		OnClickListener {

	private ListView moreListView;
	private MyCommonView backButton, cartBtn,cartEditBtn;
	private String statcPages, title, details;
	public static boolean brandingStatus = true;
	public static final int ORDER_PRODUCT_CART = 0x7;
	public static final int ORDER_DEPARTMENTS = 0x8;
	public static int currentOrder = ORDER_DEPARTMENTS;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.more_layout);
		prepareViewControls();
		getSaticPage();
		moreListView.setOnItemClickListener(MoreTabAct.this);
	}

	/**
	 * This Method calls Async task to get list of static pages to show in More
	 * tab.
	 */
	private void getSaticPage() {
		@SuppressWarnings("unused")
		GetStaticPagesTask sPageTask = (GetStaticPagesTask) new GetStaticPagesTask(
				this.getParent(), moreListView).execute("");
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		String saticListPages = (String) arg1.getTag();
		getPages(saticListPages);
	}

	/**
	 * This Method is used fetch details of static pages and navigate to that
	 * page.
	 * 
	 * @param saticListPages
	 */
	private void getPages(String saticListPages) {
		MoreTabGroupAct parentActivity = (MoreTabGroupAct) getParent();
		statcPages = saticListPages;
		if (statcPages.equals("About Us")) {
			int image = R.drawable.about_us;
			title = MobicartCommonData.keyValues.getString(
					"key.iphone.more.aboutus", "About Us");
			details = MobicartCommonData.sPagesVO.get(0).getsDescription();
			Intent about = new Intent(this, AboutUsAct.class);
			about.putExtra("Title", title);
			about.putExtra("Descripition", details);
			about.putExtra("Image", image);
			parentActivity.startChildActivity("AboutUsAct", about);
		}
		if (statcPages.equals("Contact Us")) {
			int image = R.drawable.contact_us;
			title = MobicartCommonData.keyValues.getString(
					"key.iphone.more.contactus", "Contact Us");
			details = MobicartCommonData.sPagesVO.get(1).getsDescription();
			Intent contact = new Intent(this, ContactUsAct.class);
			contact.putExtra("Title", title);
			contact.putExtra("Image", image);
			contact.putExtra("Descripition", details);
			parentActivity.startChildActivity("ContactUsAct", contact);
		}
		if (statcPages.equals("Terms")) {
			int image = R.drawable.term_w;
			title = MobicartCommonData.keyValues.getString(
					"key.iphone.more.tandc", "Terms And Conditions");
			details = MobicartCommonData.sPagesVO.get(2).getsDescription();
			Intent about = new Intent(this, AboutUsAct.class);
			about.putExtra("Title", title);
			about.putExtra("Image", image);
			about.putExtra("Descripition", details);
			parentActivity.startChildActivity("AboutUsAct", about);
		}
		if (statcPages.equals("Privacy")) {
			int image = R.drawable.privacy_w;
			title = MobicartCommonData.keyValues.getString(
					"key.iphone.more.privacy", "Privacy");
			details = MobicartCommonData.sPagesVO.get(3).getsDescription();
			Intent about = new Intent(this, AboutUsAct.class);
			about.putExtra("Title", title);
			about.putExtra("Image", image);
			about.putExtra("Descripition", details);
			parentActivity.startChildActivity("AboutUsAct", about);
		}
		if (statcPages.equals("Page 1")) {
			int image = R.drawable.delievery;
			if (MobicartCommonData.sPagesVO != null) {
				title = MobicartCommonData.sPagesVO.get(4).getsTitle();
				details = MobicartCommonData.sPagesVO.get(4).getsDescription();
				Intent about = new Intent(this, AboutUsAct.class);
				about.putExtra("Title", title);
				about.putExtra("Image", image);
				about.putExtra("Descripition", details);
				parentActivity.startChildActivity("AboutUsAct", about);
			}
		}
		if (statcPages.equals("Page 2")) {
			int image = R.drawable.delievery;
			if (MobicartCommonData.sPagesVO != null) {
				title = MobicartCommonData.sPagesVO.get(5).getsTitle();
				details = MobicartCommonData.sPagesVO.get(5).getsDescription();
				Intent about = new Intent(this, AboutUsAct.class);
				about.putExtra("Title", title);
				about.putExtra("Image", image);
				about.putExtra("Descripition", details);
				parentActivity.startChildActivity("AboutUsAct", about);
			}
		}
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		moreListView = (ListView) findViewById(R.id.more_LV);
		backButton = TabHostAct.prepareSoftBackButton(this);
		backButton.setVisibility(View.GONE);
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
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backButton.setVisibility(View.GONE);
		super.onDestroy();
	}

	@Override
	protected void onResume() {
		cartBtn.setOnClickListener(this);
		backButton.setVisibility(View.GONE);
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		super.onResume();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	@Override
	public void onClick(View v) {
		MoreTabGroupAct parentActivity = (MoreTabGroupAct) getParent();
		Intent cartAct = new Intent(this, CartAct.class);
		String backBtn = MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.more", "more");
		cartAct.putExtra("IsFrom", backBtn);
		cartAct.putExtra("ParentAct", "0");
		parentActivity.startChildActivity("CartAct", cartAct);
	}
}