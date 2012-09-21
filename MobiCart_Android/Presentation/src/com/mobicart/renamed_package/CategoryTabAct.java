package com.mobicart.renamed_package;

import java.util.ArrayList;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.TextView.OnEditorActionListener;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.CategoryVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetProductsTask;
import com.mobicart.renamed_package.utils.adapters.DepartmentsListAdapter;

/**
 * This Activity class shows all categories of Department selected by user.
 * 
 * @author mobicart
 * 
 */
public class CategoryTabAct extends Activity implements OnClickListener,
		OnEditorActionListener, OnItemClickListener {

	private ListView categoriesLV;
	private EditText localSearchET;
	private MyCommonView listHeaderTV, searchBtn, backBtn, cartBtn,cartEditBtn;
	private RelativeLayout store_tab_RL;
	private InputMethodManager imm;
	public static final int DEPARTMENTS = 87;
	public static boolean isOrderForward = false;
	public static float currentDepartmentId;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.store_tab_layout);
		prepareControldViews();
		imm.hideSoftInputFromWindow(localSearchET.getWindowToken(), 0);
		currentDepartmentId = getIntent().getIntExtra("departmentId", -1);
		localSearchET.setOnKeyListener(new OnKeyListener() {
			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				if (keyCode == KeyEvent.KEYCODE_BACK) {
					localSearchET
							.setBackgroundResource(R.drawable.search_bar_dpi);
					localSearchET.setHint(MobicartCommonData.keyValues
							.getString("key.iphone.common.search",
									"Enter keyword to search"));
					searchBtn.setVisibility(View.GONE);
				}
				return false;
			}
		});

		localSearchET.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				CategoryVO[] searchedList = searchList(s.toString());
				categoriesLV.setAdapter(new DepartmentsListAdapter(
						CategoryTabAct.this, StoreTabGroupAct.TYPE_CATEGORIES,
						searchedList));
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
			}
		});
	}

	@Override
	protected void onResume() {
		StoreTabGroupAct.FLAG_BACK_KEY = false;
		changeSearchBarAppearance(true);
		backBtn.setVisibility(View.VISIBLE);
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.department.store", "Store"));
		backBtn.setOnClickListener(this);
		GetProductsTask categoryTask = new GetProductsTask(this, categoriesLV,
				StoreTabGroupAct.TYPE_CATEGORIES);
		categoryTask.execute("");
		super.onResume();
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.department.store", "Store"));
		backBtn.setOnClickListener(this);
		SharedPreferences prefs = getSharedPreferences("X", MODE_PRIVATE);
		Editor editor = prefs.edit();
		editor.putString("lastActivity", getClass().getName());
		editor.commit();
		super.onPause();
	}

	@Override
	protected void onStop() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onStop();
	}

	@Override
	protected void onDestroy() {
		StoreTabGroupAct.FLAG_BACK_KEY = true;
		backBtn.setVisibility(View.GONE);
		MobicartCommonData.isFromStart = "";
		super.onDestroy();
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareControldViews() {
		imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		store_tab_RL = (RelativeLayout) findViewById(R.id.storeTab_top_RL);
		listHeaderTV = (MyCommonView) findViewById(R.id.store_departments_list_header_tv);
		localSearchET = (EditText) findViewById(R.id.store_search_et);
		localSearchET.setHint(MobicartCommonData.keyValues.getString(
				"key.iphone.common.search", "Enter keyword to search"));
		searchBtn = (MyCommonView) findViewById(R.id.store_search_button);
		if (MobicartCommonData.colorSchemeObj.getSearchColor().equals(null)
				|| MobicartCommonData.colorSchemeObj.getSearchColor()
						.equalsIgnoreCase("")) {
		} else {
			store_tab_RL.setBackgroundColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getSearchColor()));
		}
		categoriesLV = (ListView) findViewById(R.id.store_departments_lv);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setOnClickListener(this);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setOnClickListener(this);
		searchBtn.setOnClickListener(this);
		localSearchET.setOnClickListener(this);
		localSearchET.setOnEditorActionListener(this);
		categoriesLV.setOnItemClickListener(this);
		listHeaderTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.select.category", "Select Category"));
		searchBtn.setText(" "
				+ MobicartCommonData.keyValues.getString("key.iphone.cancel",
						"Cancel") + " ");
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.universal_back_btn: {
			finish();
			break;
		}
		case R.id.store_search_button: {
			changeSearchBarAppearance(true);
			imm.hideSoftInputFromWindow(localSearchET.getWindowToken(), 0);
			localSearchET.setHint(MobicartCommonData.keyValues.getString(
					"key.iphone.common.search", "Enter Keyword To Search"));
			break;
		}
		case R.id.store_search_et: {
			localSearchET.setHint("");
			imm.showSoftInputFromInputMethod(localSearchET.getWindowToken(), 0);
			changeSearchBarAppearance(false);
			break;
		}
		case R.id.navigation_bar_cart_btn:
			StoreTabGroupAct parentActivity = (StoreTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.home.back", "Back");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "2");
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		}
	}

	/**
	 * Method to change Search bar background.
	 * 
	 * @param expand
	 */
	private void changeSearchBarAppearance(boolean expand) {
		if (expand) {
			localSearchET.setText("");
			localSearchET.setHint(MobicartCommonData.keyValues.getString(
					"key.iphone.common.search", "Enter Keyword To Search"));
			localSearchET.setBackgroundResource(R.drawable.search_bar_dpi);
			searchBtn.setVisibility(View.GONE);
		} else {
			localSearchET.setHint("");
			localSearchET
					.setBackgroundResource(R.drawable.search_bar_withoutbtn_dpi);
			searchBtn.setVisibility(View.VISIBLE);
		}
	}

	@Override
	public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
		if (v.getId() == R.id.store_search_et) {
			imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
			if (actionId == EditorInfo.IME_ACTION_SEARCH) {
				imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
				return true;
			}
			localSearchET.setBackgroundResource(R.drawable.search_bar_dpi);
			localSearchET.setText("");
			searchBtn.setVisibility(View.GONE);
			localSearchET.setHint(MobicartCommonData.keyValues.getString(
					"key.iphone.common.search", "Enter Keyword To Search"));
			categoriesLV.setAdapter(new DepartmentsListAdapter(
					CategoryTabAct.this, StoreTabGroupAct.TYPE_CATEGORIES));
		}
		return false;
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int position,
			long arg3) {
		if (MobicartCommonData.categoriesList.get(position).getiCategoryCount() != 0) {
			StoreTabGroupAct parentActivity = (StoreTabGroupAct) getParent();
			Intent intent = new Intent(parentActivity.getApplicationContext(),
					SubCategoryTabAct.class);
			intent.putExtra("departmentId", (Integer) arg1.getTag());
			intent.putExtra("categoryId", MobicartCommonData.categoriesList
					.get(position).getId());
			parentActivity.startChildActivity("subCategoryTabAct", intent);

		} else {
			if (MobicartCommonData.categoriesList.get(position)
					.getiProductCount() != 0) {
				StoreTabGroupAct parentActivity = (StoreTabGroupAct) getParent();
				Intent intent = new Intent(parentActivity
						.getApplicationContext(), ProductsListAct.class);
				intent.putExtra("departmentId", (Integer) arg1.getTag());
				intent.putExtra("categoryId", MobicartCommonData.categoriesList
						.get(position).getId());
				intent.putExtra("IsFrom", 0);
				parentActivity.startChildActivity("ProductsListAct", intent);
			} else {
				final AlertDialog alertDialog = new AlertDialog.Builder(
						getParent()).create();
				alertDialog.setTitle(MobicartCommonData.keyValues.getString(
						"key.iphone.nointernet.title", "Alert"));
				alertDialog.setMessage(MobicartCommonData.keyValues.getString(
						"key.iphone.NoProductMessage", "No Item Found"));
				alertDialog.setButton(MobicartCommonData.keyValues.getString(
						"key.iphone.nointernet.cancelbutton", "Ok"),
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
								alertDialog.dismiss();
							}
						});
				alertDialog.show();
			}
		}
	}

	/**
	 * This method is used to Search Category entered by user from list of
	 * available categories.
	 * 
	 * @param query
	 * @return
	 */
	private CategoryVO[] searchList(String query) {
		ArrayList<CategoryVO> searchedList = new ArrayList<CategoryVO>();
		try {
			for (int i = 0; i < MobicartCommonData.categoriesList.size(); i++) {
				if (MobicartCommonData.categoriesList.get(i).getsName()
						.toUpperCase().startsWith(query.toUpperCase())
						|| MobicartCommonData.categoriesList.get(i).getsName()
								.toLowerCase().startsWith(query.toLowerCase())) {
					searchedList.add(MobicartCommonData.categoriesList.get(i));
				}
			}
		} catch (NullPointerException e) {
		}
		return searchedList.toArray(new CategoryVO[] {});
	}

	@Override
	protected void onRestart() {
		if (MobicartCommonData.isFromStart != "") {
			startActivity(new Intent(this, SplashAct.class));
		}
		super.onRestart();
	}
}
