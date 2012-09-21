package com.mobicart.renamed_package;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
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

import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.DepartmentVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetProductsTask;
import com.mobicart.renamed_package.utils.adapters.DepartmentsListAdapter;

/**
 * This activity group is for store tab. Displays list of
 * department->categories and products.
 * 
 * @author mobicart
 * 
 */

public class StoreTabAct extends Activity implements OnClickListener,
		OnEditorActionListener {

	public static final int ORDER_PRODUCT_CART = 0x77;
	public static boolean isCheckout;
	public static final int PRODUCT_LIST = 89;
	public static final int CATEGORY = 88;
	public static final int DEPARTMENTS = 87;
	public static int currentOrder = DEPARTMENTS;
	private ListView departmentsLV;
	private DepartmentVO[] searchedList;
	private EditText localSearchET;
	private RelativeLayout store_tab_RL;
	private String isFromPaypal = null;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;
	private MyCommonView listHeaderTV, searchButton, backBtn, cartBtn,cartEditBtn;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.store_tab_layout);
		Bundle extra = new Bundle();
		isFromPaypal = extra.getString("isFromPayapl");
		initializeViewControls();
		GetProductsTask departmentsTask = new GetProductsTask(this.getParent(),
				departmentsLV, StoreTabGroupAct.TYPE_DEPARTMENTS);
		localSearchET.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				localSearchET.setHint("");
				searchedList = searchList(s.toString());
				departmentsLV.setAdapter(new DepartmentsListAdapter(
						StoreTabAct.this, StoreTabGroupAct.TYPE_DEPARTMENTS,
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
	
	
		
		localSearchET.setOnKeyListener(new OnKeyListener() {
			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				if (keyCode == KeyEvent.KEYCODE_BACK) {
					localSearchET
							.setBackgroundResource(R.drawable.search_bar_dpi);
					localSearchET.setHint(MobicartCommonData.keyValues
							.getString("key.iphone.common.search",
									"Enter Keyword To Search"));
					searchButton.setVisibility(View.GONE);
					departmentsLV.setAdapter(new DepartmentsListAdapter(
							StoreTabAct.this,
							StoreTabGroupAct.TYPE_DEPARTMENTS, searchedList));
				}
				return false;
			}
		});
		localSearchET.setOnEditorActionListener(new OnEditorActionListener() {
			@Override
			public boolean onEditorAction(TextView v, int actionId,
					KeyEvent event) {
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
				if (actionId == EditorInfo.IME_ACTION_SEARCH) {
					imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
					localSearchET
							.setBackgroundResource(R.drawable.search_bar_dpi);
					searchButton.setVisibility(View.GONE);
					return true;
				}

				localSearchET.setBackgroundResource(R.drawable.search_bar_dpi);
				localSearchET.setText("");
				searchButton.setVisibility(View.GONE);
				departmentsLV.setAdapter(new DepartmentsListAdapter(
						StoreTabAct.this, StoreTabGroupAct.TYPE_DEPARTMENTS,
						searchedList));
				localSearchET.setText("");
				return false;
			}
		});

		departmentsLV.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View view, int arg2,
					long arg3) {

				if (MobicartCommonData.departmentsList.get(arg2)
						.getiCategoryCount() != 0) {
					StoreTabGroupAct parentActivity = (StoreTabGroupAct) getParent();
					Intent intent = new Intent(parentActivity
							.getApplicationContext(), CategoryTabAct.class);
					intent.putExtra("departmentId", (Integer) view.getTag());
					parentActivity.startChildActivity("CategoryTabAct", intent);
				} else {
					if (MobicartCommonData.departmentsList.get(arg2)
							.getiProductCount() != 0) {
						StoreTabGroupAct parentActivity = (StoreTabGroupAct) getParent();
						Intent intent = new Intent(parentActivity
								.getApplicationContext(), ProductsListAct.class);
						intent
								.putExtra("departmentId", (Integer) view
										.getTag());
						intent.putExtra("IsFrom", 2);
						intent.putExtra("categoryId",
								MobicartCommonData.departmentsList.get(arg2)
										.getId());
						parentActivity.startChildActivity("ProductsListAct",
								intent);
					} else {
						final AlertDialog alertDialog = new AlertDialog.Builder(
								getParent()).create();
						alertDialog.setTitle(MobicartCommonData.keyValues
								.getString("key.iphone.nointernet.title",
										"Alert"));
						alertDialog.setMessage(MobicartCommonData.keyValues
								.getString("key.iphone.NoProductMessage",
										"No Item Found"));
						alertDialog.setButton(MobicartCommonData.keyValues
								.getString(
										"key.iphone.nointernet.cancelbutton",
										"Ok"),
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
		});
		try {
			departmentsTask.execute("");
		} catch (NullPointerException e) {
			showServerError();
		}
	}

	/**
	 * This method is used to show Server errors.
	 */
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				StoreTabAct.this).create();
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
	protected void onRestart() {
		if (MobicartCommonData.isFromStart != "") {
			startActivity(new Intent(this, SplashAct.class));
		}
		super.onRestart();
	}

	@Override
	protected void onStart() {
		backBtn.setVisibility(View.GONE);
		super.onStart();
	}

	@Override
	protected void onResume() {
		backBtn.setVisibility(View.GONE);
		cartBtn.setVisibility(View.VISIBLE);
		if (isFromPaypal == "" || isFromPaypal == null) {
			cartBtn.setText("" + CartItemCount.getCartCount(this));
		} else {
			cartBtn.setText("" + 0);
		}
		super.onResume();
	}

	@Override
	protected void onPause() {
		cartBtn.setVisibility(View.VISIBLE);
		backBtn.setVisibility(View.GONE);
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	@Override
	protected void onStop() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.GONE);
		super.onStop();
	}

	@Override
	protected void onDestroy() {
		backBtn.setVisibility(View.GONE);
		super.onDestroy();
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void initializeViewControls() {
		localSearchET = (EditText) findViewById(R.id.store_search_et);
		localSearchET.setHint(MobicartCommonData.keyValues.getString(
				"key.iphone.common.search", ""));
		localSearchET.setOnClickListener(this);
		searchButton = (MyCommonView) findViewById(R.id.store_search_button);
		listHeaderTV = (MyCommonView) findViewById(R.id.store_departments_list_header_tv);
		listHeaderTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.department.selectdepartment", ""));
		departmentsLV = (ListView) findViewById(R.id.store_departments_lv);
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
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.GONE);
		localSearchET.setOnEditorActionListener(this);
		store_tab_RL = (RelativeLayout) findViewById(R.id.storeTab_top_RL);
		searchButton.setText(" "
				+ MobicartCommonData.keyValues.getString("key.iphone.cancel",
						"") + " ");
		searchButton.setOnClickListener(this);
		try {
			if (MobicartCommonData.colorSchemeObj.getSearchColor()
					.equalsIgnoreCase(null)
					|| MobicartCommonData.colorSchemeObj.getSearchColor()
							.equalsIgnoreCase(""))

			{
			} else {
				store_tab_RL.setBackgroundColor(Color.parseColor("#"
						+ MobicartCommonData.colorSchemeObj.getSearchColor()));
			}
			String s = null;
			
			Log.e("TAG",""+s.length());
		} catch (Exception e) {
			reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
			objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
			objMobicartLogger.LogExceptionMsg(reqDateFormat
					.format(new Date()), e.getMessage());
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.store_search_button:
			localSearchET.setText("");
			changeSearchBarAppearance(true);
			InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
			imm.hideSoftInputFromWindow(localSearchET.getWindowToken(), 0);
			break;
		case R.id.store_search_et:
			localSearchET.setHint("");
			localSearchET.setCursorVisible(true);
			changeSearchBarAppearance(false);
			break;
		case R.id.navigation_bar_cart_btn:
			ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.department.store", "Store");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "0");
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		default:
			break;
		}
	}

	/**
	 * This method is used for changing the background of search bar with cancel
	 * or without cancel button.
	 * 
	 * @param expand
	 */
	private void changeSearchBarAppearance(boolean expand) {
		if (expand) {
			localSearchET.setText("");
			localSearchET.setHint(MobicartCommonData.keyValues.getString(
					"key.iphone.common.search", ""));
			localSearchET.setBackgroundResource(R.drawable.search_bar_dpi);
			searchButton.setVisibility(View.GONE);
			localSearchET.setCursorVisible(false);
		} else {
			localSearchET.setHint("");
			localSearchET
					.setBackgroundResource(R.drawable.search_bar_withoutbtn_dpi);
			searchButton.setVisibility(View.VISIBLE);
			localSearchET.setCursorVisible(true);
		}
	}

	@Override
	public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
		if (v.getId() == R.id.store_search_et) {
			if (event == null) {
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
				localSearchET.setBackgroundResource(R.drawable.search_bar_dpi);
				localSearchET.setHint(MobicartCommonData.keyValues.getString(
						"key.iphone.common.search", ""));
				searchButton.setVisibility(View.GONE);
			}
		}
		return false;
	}

	/**
	 * This method is used for getting list of departments after implementing
	 * search on a list.
	 * 
	 * @param query
	 * @return
	 */
	private DepartmentVO[] searchList(String query) {
		ArrayList<DepartmentVO> searchedList = new ArrayList<DepartmentVO>();
		for (int i = 0; i < MobicartCommonData.departmentsList.size(); i++) {
			if (MobicartCommonData.departmentsList.get(i).getsName()
					.toUpperCase().startsWith(query.toUpperCase())
					|| MobicartCommonData.departmentsList.get(i).getsName()
							.toLowerCase().startsWith(query.toLowerCase())) {
				searchedList.add(MobicartCommonData.departmentsList.get(i));
			}
		}
		return searchedList.toArray(new DepartmentVO[] {});
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			MobicartCommonData.isFromStart = "NotSplash";
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}
}
