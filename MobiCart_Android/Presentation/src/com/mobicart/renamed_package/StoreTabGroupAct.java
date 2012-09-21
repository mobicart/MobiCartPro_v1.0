package com.mobicart.renamed_package;

import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This Activity is extending ParentActivityGroup and used to start first
 * activity of Store Tab.
 * 
 * @author mobicart
 */
public class StoreTabGroupAct extends ParentActivityGroup {

	public static final int TYPE_DEPARTMENTS = 0x11334;
	public static final int TYPE_CATEGORIES = 0x11335;
	public static final int TYPE_SUBCATEGORIES = 0x11346;
	public static final int TYPE_PRODUCTS = 0x11336;
	public static boolean FLAG_BACK_KEY = false;
	private MyCommonView backBtn;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.GONE);
		startChildActivity("StoreTabAct", new Intent(this, StoreTabAct.class));
	}

	@Override
	protected void onUserLeaveHint() {
		StoreTabGroupAct.this.finish();
	}

	@Override
	protected void onStart() {
		if (StoreTabAct.DEPARTMENTS == 87) {
			backBtn.setVisibility(View.GONE);
		}
		super.onStart();
	}

	@Override
	protected void onPause() {
		backBtn.setVisibility(View.GONE);
		super.onPause();
	}

	@Override
	protected void onResume() {
		navigateStoreActivities();
		super.onResume();
	}

	@Override
	protected void onRestart() {
		super.onRestart();
	}

	@Override
	protected void onDestroy() {
		if (StoreTabAct.DEPARTMENTS == 87) {
			backBtn.setVisibility(View.GONE);
		}
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

	@Override
	protected void onStop() {
		super.onStop();
	}

	/**
	 * This Method is used to handle the navigation for store related
	 * activities.
	 */
	private void navigateStoreActivities() {
		switch (StoreTabAct.currentOrder) {
		case StoreTabAct.PRODUCT_LIST:
			backBtn.setVisibility(View.VISIBLE);
			break;
		case StoreTabAct.DEPARTMENTS:
			backBtn.setVisibility(View.GONE);
			break;
		case StoreTabAct.CATEGORY:
			backBtn.setVisibility(View.VISIBLE);
			break;
		default:
			backBtn.setVisibility(View.GONE);
			break;
		}
		switch (HomeTabAct.currentOrder) {
		case HomeTabAct.ORDER_PRODUCT_DETAIL: {
			ProductVO currentProduct = MobicartCommonData.featuredPrducts
					.get(HomeTabAct.seclectedFeturedProductPosition);
			Intent productIntent = new Intent(this, ProductDetailAct.class);
			productIntent.putExtra("ProductID", currentProduct.getId());
			productIntent.putExtra("seclectedFeturedProductPosition",
					HomeTabAct.seclectedFeturedProductPosition);
			productIntent.putExtra("FromHome", true);
			startChildActivity("ProductDetailAct", productIntent);
			break;
		}
		case HomeTabAct.ORDER_PRODUCT_CART: {
			break;
		}
		case HomeTabAct.ORDER_PRODUCT_LIST: {
			ProductVO currentProduct = MobicartCommonData.featuredPrducts
					.get(HomeTabAct.seclectedFeturedProductPosition);
			Intent productListIntent = new Intent(this, ProductsListAct.class);
			productListIntent.putExtra("categoryId", currentProduct
					.getCategoryId());
			startChildActivity("ProductsListAct", productListIntent);
			break;
		}
		case HomeTabAct.ORDER_PRODUCT_SEARCH: {
		    if(MobicartCommonData.featuredPrducts!=null&&MobicartCommonData.featuredPrducts.size()>0){
			ProductVO currentProduct = MobicartCommonData.featuredPrducts
					.get(HomeTabAct.seclectedFeturedProductPosition);
			Intent departmentIntent = new Intent(this, StoreTabAct.class);
			startChildActivity("StoreTabAct", departmentIntent);
			if (currentProduct.getCategoryId() > 0) {
				Intent categoryintent = new Intent(this, CategoryTabAct.class);
				categoryintent.putExtra("departmentId", currentProduct
						.getDepartmentId());
				startChildActivity("CategoryTabAct", categoryintent);
			}
			Intent productListIntent = new Intent(this, ProductsListAct.class);
			productListIntent.putExtra("IsFrom", 1);
			productListIntent.putExtra("deparmentId", currentProduct.getDepartmentId());
			productListIntent.putExtra("categoryId", currentProduct.getCategoryId());
			startChildActivity("ProductsListAct", productListIntent);
           }
           else{
        	Intent productListIntent = new Intent(this, ProductsListAct.class);
			productListIntent.putExtra("IsFrom", 1);
			productListIntent.putExtra("deparmentId", 0);
			productListIntent.putExtra("categoryId", 0);
			startChildActivity("ProductsListAct", productListIntent);
           }
			break;
		}
		case HomeTabAct.ORDER_FEATURED_PRODUCT_DETAIL: {
			ProductVO currentProduct = MobicartCommonData.featuredPrducts
					.get(HomeTabAct.seclectedFeturedProductPosition);
			Intent departmentIntent = new Intent(this, StoreTabAct.class);
			startChildActivity("StoreTabAct", departmentIntent);
			Intent categoryintent = new Intent(this, CategoryTabAct.class);
			categoryintent.putExtra("departmentId", currentProduct
					.getDepartmentId());
			startChildActivity("CategoryTabAct", new Intent(this,
					CategoryTabAct.class));
			Intent productListIntent = new Intent(this, ProductsListAct.class);
			productListIntent.putExtra("categoryId", currentProduct
					.getCategoryId());
			startChildActivity("ProductsListAct", new Intent(this,
					ProductsListAct.class));
			Intent productIntent = new Intent(this, ProductDetailAct.class);
			productIntent.putExtra("ProductID", currentProduct.getId());
			productIntent.putExtra("currentProductPosition",
					HomeTabAct.seclectedFeturedProductPosition);
			startChildActivity("ProductDetailAct", productIntent);
			break;
		}
		default:
			break;
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			if (FLAG_BACK_KEY) {
				return true;
			} else {
			}
		}
		return super.onKeyDown(keyCode, event);
	}
}
