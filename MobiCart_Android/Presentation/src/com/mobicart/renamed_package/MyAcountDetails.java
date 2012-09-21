package com.mobicart.renamed_package;

import java.util.ArrayList;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.app.ActivityGroup;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.AccountVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetAppIdentifierTask;

/**
 * This Activity class is used to display all account related details of
 * user,and User can view or update details.
 * 
 * @author mobicart
 * 
 */
public class MyAcountDetails extends ActivityGroup implements OnClickListener {

	public static boolean isUpdated = false;
	private boolean valid;
	private MyCommonView edit, backBtn, cartBtn,cartEditBtn;
	private ScrollView countrySV, stateSV, dCountrySV, dStateSV;
	private EditText emailET, streetET, cityET, zipET, deliveryCityET,
			deliveryStreetET, deliveryZipET;
	private String sCountry, eMailAddress, sCity, sPinCode, sStreetAddress,
			sState, sDeliveryCity, sDeliveryCountry, sDeliveryStreetAddress,
			sDeliveryState, sDeliveryPincode;
	private String stateSelected = "", countrySelected = "",
			dCountrySelected = "", dStateSelected = "";
	private String[] countries, dcountries, state, dstate;
	private int _id, territoryId, dterritoryId;
	private ArrayAdapter<String> adapter1, dAdapter1;
	private ArrayAdapter<String> adapter, dAdapter;
	private ArrayList<String> countriesAL = new ArrayList<String>();
	private ArrayList<String> dCountriesAL = new ArrayList<String>();
	private ArrayList<String> statesAL = new ArrayList<String>();
	private ArrayList<String> dStatesAL = new ArrayList<String>();
	private ArrayList<String> countryStateNotAvaliable = new ArrayList<String>();
	private ArrayList<String> dcountryStateNotAvaliable = new ArrayList<String>();
	private Spinner dCountrySpinner, dStateSpinner, stateSpinner,
			countrySpinner;
	private DataBaseAccess objDataBaseAccess;
	private AccountVO objAccountVO = new AccountVO();
	private GetCountryNStateAct getCountryNState;
	private GradientDrawable gradientButtonDrawable;
	private ChkLoginStatusAct chkLoginStatus = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.account_details);
		prepareViewControls();
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.account", ""));
		backBtn.setOnClickListener(this);
		GetAccountInfo();
		edit.setOnClickListener(this);
	}

	/**
	 * This method is used for getting account details from database.
	 */
	private void GetAccountInfo() {
		objDataBaseAccess = new DataBaseAccess(this);
		objDataBaseAccess.GetRow("Select * from tblAccountDetails where _id=1",
				objAccountVO);
		emailET.setText(objAccountVO.geteMailAddress());
		cityET.setText(objAccountVO.getsCity());
		streetET.setText(objAccountVO.getsStreetAddress());
		zipET.setText(objAccountVO.getsPincode());
		deliveryStreetET.setText(objAccountVO.getsDeliveryStreetAddress());
		deliveryCityET.setText(objAccountVO.getsDeliveryCity());
		deliveryZipET.setText(objAccountVO.getsPincode());
		getCountrySpinner();
		getStateSpinner();
		getDCountrySpinner();
		getDStateSpinner();
		setEditTextFocusableFalse();
	}

	/**
	 * This method is used for generating dropdown for countries and displaying
	 * selected country of user.
	 */
	private void getCountrySpinner() {
		countries = new String[1];
		countries[0] = objAccountVO.getsCountry();
		adapter = new ArrayAdapter<String>(MyAcountDetails.this,
				android.R.layout.simple_spinner_item, countries);
		countrySpinner = new Spinner(getParent());
		countrySpinner.setBackgroundResource(R.drawable.dropdown_selector);
		countrySpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country"));
		countrySpinner.setAdapter(adapter);
		countrySV.removeAllViews();
		countrySV.addView(countrySpinner);
	}

	/**
	 * This method is used for generating dropdown for States and displaying
	 * selected state of user.
	 */
	private void getStateSpinner() {
		state = new String[1];
		state[0] = objAccountVO.getsState();
		adapter = new ArrayAdapter<String>(MyAcountDetails.this,
				android.R.layout.simple_spinner_item, state);
		stateSpinner = new Spinner(getParent());
		stateSpinner.setBackgroundResource(R.drawable.dropdown_selector);
		stateSpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choose.state", "Choose State"));
		stateSpinner.setAdapter(adapter);
		stateSV.removeAllViews();
		stateSV.addView(stateSpinner);
	}

	/**
	 * This method is used for generating dropdown for delivery countries and
	 * displaying selected delivery country of user.
	 */
	private void getDCountrySpinner() {
		dcountries = new String[1];
		dcountries[0] = objAccountVO.getsDeliveryCountry();
		adapter = new ArrayAdapter<String>(MyAcountDetails.this,
				android.R.layout.simple_spinner_item, dcountries);
		dCountrySpinner = new Spinner(getParent());
		dCountrySpinner.setBackgroundResource(R.drawable.dropdown_selector);
		dCountrySpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country"));
		dCountrySpinner.setAdapter(adapter);
		dCountrySV.removeAllViews();
		dCountrySV.addView(dCountrySpinner);
	}

	/**
	 * This method is used for generating dropdown for delivery states and
	 * displaying selected delivery country of user.
	 */
	private void getDStateSpinner() {
		dstate = new String[1];
		dstate[0] = objAccountVO.getsDeliveryState();
		adapter = new ArrayAdapter<String>(MyAcountDetails.this,
				android.R.layout.simple_spinner_item, dstate);
		dStateSpinner = new Spinner(getParent());
		dStateSpinner.setBackgroundResource(R.drawable.dropdown_selector);
		dStateSpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choose.state", "Choose State"));
		dStateSpinner.setAdapter(adapter);
		dStateSV.removeAllViews();
		dStateSV.addView(dStateSpinner);
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		MyCommonView titleMV, cityMV, emailMV, streetMV, countryMV, stateMV, zipMV;
		MyCommonView dTitleMV, dStreetMV, dCityMV, dCountryMV, dStateMV, dZipMV;

		titleMV = (MyCommonView) findViewById(R.id.myAccount_title_TV);
		cityMV = (MyCommonView) findViewById(R.id.myAccountcity_TV);
		emailMV = (MyCommonView) findViewById(R.id.myAccountemail_TV);
		streetMV = (MyCommonView) findViewById(R.id.myAccountstreet_TV);
		countryMV = (MyCommonView) findViewById(R.id.myAccountCountry_TV);
		stateMV = (MyCommonView) findViewById(R.id.myAccountState_TV);
		zipMV = (MyCommonView) findViewById(R.id.myAccountZip_TV);

		dTitleMV = (MyCommonView) findViewById(R.id.Delivery_title_TV);
		dStreetMV = (MyCommonView) findViewById(R.id.Delivery_street_TV);
		dCityMV = (MyCommonView) findViewById(R.id.Delivery_city_TV);
		dCountryMV = (MyCommonView) findViewById(R.id.Delivery_country_TV);
		dStateMV = (MyCommonView) findViewById(R.id.Delivery_state_TV);
		dZipMV = (MyCommonView) findViewById(R.id.Delivery_zip_TV);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		
		gradientButtonDrawable = (GradientDrawable) this.getResources()
				.getDrawable(R.drawable.rounded_button);
		gradientButtonDrawable.setColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getThemeColor()));
		getCountryNState = new GetCountryNStateAct(this);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setBackgroundResource(R.drawable.account_btn_bg);

		dTitleMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.daddr", "DELIVERY ADDRESS"));
		dStreetMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.street", "Street"));
		dCityMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.city", "City"));
		dCountryMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.country", "Country"));
		dStateMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.state", "State"));
		dZipMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.zip", "Zip Code"));

		titleMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.account.info", "Account Info"));
		cityMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.city", "City"));
		emailMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.email", "Email"));
		streetMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.street", "Street"));
		countryMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.country", "Country"));
		stateMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.state", "State"));
		zipMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.zip", "Zip Code"));

		emailET = (EditText) findViewById(R.id.myAccountemail_ET);
		streetET = (EditText) findViewById(R.id.myAccountstreet_ET);
		stateSV = (ScrollView) findViewById(R.id.myAccountState_SV);
		zipET = (EditText) findViewById(R.id.myAccountZip_ET);
		cityET = (EditText) findViewById(R.id.myAccountcity_ET);
		countrySV = (ScrollView) findViewById(R.id.myAccountCountry_SV);
		edit = (MyCommonView) findViewById(R.id.myAccountEdit_Btn);
		deliveryCityET = (EditText) findViewById(R.id.Delivery_city_ET);
		dCountrySV = (ScrollView) findViewById(R.id.Delivery_country_SV);
		deliveryStreetET = (EditText) findViewById(R.id.Delivery_street_ET);
		dStateSV = (ScrollView) findViewById(R.id.Delivery_state_SV);
		deliveryZipET = (EditText) findViewById(R.id.Delivery_zip_ET);
		edit.setBackgroundDrawable(gradientButtonDrawable);
		edit.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.createaccount.edit", "Edit"));
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

	/**
	 * This method calls another methods for getting list of delivery countries
	 * and generating dropdown for country.
	 */
	private void prepareDCountrySpinner() {
		getDCountryInfo();
		setDCountrySpinner();
	}

	/**
	 * This method is used to get list of available delivery countries.
	 */
	private void getDCountryInfo() {
		if (MobicartCommonData.shippingObj != null
				|| MobicartCommonData.taxObj != null) {
			dCountriesAL.clear();
			dCountriesAL = getCountryNState.GetDCountryInfo();
			if (dCountriesAL.size() > 0) {
				dAdapter = new ArrayAdapter<String>(MyAcountDetails.this,
						android.R.layout.simple_spinner_item, dCountriesAL);
				dAdapter
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			} else
				showDialog();
		} else {
			dcountryStateNotAvaliable.add("   -   ");
			adapter = new ArrayAdapter<String>(MyAcountDetails.this,
					android.R.layout.simple_spinner_item,
					dcountryStateNotAvaliable);
			adapter
					.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		}
	}

	/**
	 * This method is used to generate dropdown for delivery countries filled
	 * with list of delivery countries .
	 */
	private void setDCountrySpinner() {
		final Spinner dCountrySpinner = new Spinner(getParent());
		dCountrySpinner.setBackgroundResource(R.drawable.dropdown_selector);
		dCountrySpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country"));
		dCountrySpinner.setAdapter(dAdapter);
		dCountrySpinner.setPadding(10, 0, 0, 0);
		if (MobicartCommonData.objAccountVO.get_id() > 0) {
			String territory = "";
			territory = MobicartCommonData.objAccountVO.getsDeliveryCountry();
			if (countriesAL.contains(territory)) {
				dCountrySpinner.setSelection(dCountriesAL.indexOf(territory));
			}
		}
		dCountrySpinner.setOnItemSelectedListener(new OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
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
							TimeUnit.SECONDS.sleep(1);
						} catch (InterruptedException e) {
						}
						dialog.dismiss();
					}
				});
				myThread.start();
				dCountrySelected = (String) dCountrySpinner.getSelectedItem();
				dterritoryId = getCountryNState.checkId(dCountrySelected);
				dStatesAL.clear();
				dStatesAL = getCountryNState.getDStateByCountryId(dterritoryId);
				dAdapter1 = new ArrayAdapter<String>(
						getParent(),
						android.R.layout.simple_spinner_item,
						(MobicartCommonData.shippingObj == null && MobicartCommonData.taxObj == null) ? dcountryStateNotAvaliable
								: dStatesAL);
				dAdapter1
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
				final Spinner dStateSpinner = new Spinner(getParent());
				dStateSpinner
						.setBackgroundResource(R.drawable.dropdown_selector);
				dStateSpinner
						.setPrompt(MobicartCommonData.keyValues.getString(
								"key.iphone.shoppingcart.choose.state",
								"Choose State"));
				dStateSpinner.setAdapter(dAdapter1);
				dStateSpinner.setPadding(10, 0, 49, 0);
				if (MobicartCommonData.objAccountVO.get_id() > 0) {
					String state = "";
					state = MobicartCommonData.objAccountVO.getsDeliveryState();
					if (statesAL.contains(state)) {
						dStateSpinner.setSelection(statesAL.indexOf(state));
					}
				}
				dStateSpinner
						.setOnItemSelectedListener(new OnItemSelectedListener() {
							@Override
							public void onItemSelected(AdapterView<?> arg0,
									View arg1, int arg2, long arg3) {
								dStateSelected = (String) dStateSpinner
										.getSelectedItem();
							}
							@Override
							public void onNothingSelected(AdapterView<?> arg0) {
							}
						});
				dStateSV.removeAllViews();
				dStateSV.addView(dStateSpinner);
			}
			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
			}
		});
		dCountrySV.removeAllViews();
		dCountrySV.addView(dCountrySpinner);
	}

	
	private void prepareCountrySpinner() {
		getCountryInfo();
		setCountrySpinner();
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	/**
	 * This Method is used for getting information about Countries.
	 */
	private void getCountryInfo() {
		if (MobicartCommonData.shippingObj != null
				|| MobicartCommonData.taxObj != null) {
			countriesAL.clear();
			countriesAL = getCountryNState.GetCountryInfo();
			if (countriesAL.size() > 0) {
				adapter = new ArrayAdapter<String>(MyAcountDetails.this,
						android.R.layout.simple_spinner_item, countriesAL);
				adapter
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			} else
				showDialog();
		} else {
			countryStateNotAvaliable.add("   -   ");
			adapter = new ArrayAdapter<String>(MyAcountDetails.this,
					android.R.layout.simple_spinner_item,
					countryStateNotAvaliable);
			adapter
					.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		}
	}

	/**
	 * This Method is used for displaying alert if country is not Available.
	 */
	private void showDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
		builder.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.title", "Alert"));
		builder.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.nocountry.avail.text", "No country available."));
		builder.setCancelable(false).setPositiveButton(
				MobicartCommonData.keyValues.getString(
						"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						dialog.cancel();
					}
				});
		builder.show();
	}

	private void setCountrySpinner() {
		final Spinner countrySpinner = new Spinner(getParent());
		countrySpinner.setBackgroundResource(R.drawable.dropdown_selector);
		countrySpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country"));
		countrySpinner.setAdapter(adapter);
		countrySpinner.setPadding(10, 0, 0, 0);
		if (MobicartCommonData.objAccountVO.get_id() > 0) {
			String territory = "";
			territory = MobicartCommonData.objAccountVO.getsCountry();
			if (countriesAL.contains(territory)) {
				countrySpinner.setSelection(countriesAL.indexOf(territory));
			}
		}
		final Spinner stateSpinner = new Spinner(getParent());
		countrySpinner.setOnItemSelectedListener(new OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {

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
							TimeUnit.SECONDS.sleep(1);
						} catch (InterruptedException e) {
						}
						dialog.dismiss();
					}
				});
				myThread.start();
				countrySelected = countrySpinner.getItemAtPosition(arg2)
						.toString();
				territoryId = getCountryNState.checkId(countrySelected);
				statesAL.clear();
				statesAL = getCountryNState.getcStateByCountryId(territoryId);
				adapter1 = new ArrayAdapter<String>(
						getParent(),
						android.R.layout.simple_spinner_item,
						(MobicartCommonData.shippingObj == null && MobicartCommonData.taxObj == null) ? countryStateNotAvaliable
								: statesAL);
				adapter1
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

				stateSpinner
						.setBackgroundResource(R.drawable.dropdown_selector);
				stateSpinner
						.setPrompt(MobicartCommonData.keyValues.getString(
								"key.iphone.shoppingcart.choose.state",
								"Choose State"));
				stateSpinner.setAdapter(adapter1);
				stateSpinner.setPadding(10, 0, 49, 0);
				if (MobicartCommonData.objAccountVO.get_id() > 0) {
					String state = "";
					state = MobicartCommonData.objAccountVO.getsState();
					if (statesAL.contains(state)) {
						stateSpinner.setSelection(statesAL.indexOf(state));
					}
				}
				stateSV.removeAllViews();
				stateSpinner
						.setOnItemSelectedListener(new OnItemSelectedListener() {
							@Override
							public void onItemSelected(AdapterView<?> arg0,
									View arg1, int arg2, long arg3) {
								stateSelected = (String) stateSpinner
										.getSelectedItem();
							}
							@Override
							public void onNothingSelected(AdapterView<?> arg0) {
							}
						});
				stateSV.addView(stateSpinner);
			}
			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
			}
		});
		countrySV.removeAllViews();
		countrySV.addView(countrySpinner);
	}

	/**
	 * This Method is used to disable all edittext so that user can't able to
	 * modify values.
	 */
	private void setEditTextFocusableFalse() {
		emailET.setFocusable(false);
		streetET.setFocusable(false);
		stateSpinner.setEnabled(false);
		countrySpinner.setEnabled(false);
		cityET.setFocusable(false);
		zipET.setFocusable(false);
		deliveryCityET.setFocusable(false);
		deliveryStreetET.setFocusable(false);
		deliveryZipET.setFocusable(false);
		dCountrySpinner.setEnabled(false);
		dStateSpinner.setEnabled(false);
	}

	@Override
	protected void onResume() {
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.account", "Account"));
		backBtn.setOnClickListener(this);
		super.onResume();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.INVISIBLE);
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.myAccountEdit_Btn:
			if (edit.getText().toString().equalsIgnoreCase(
					MobicartCommonData.keyValues.getString(
							"key.iphone.createaccount.edit", "Edit"))) {
				emailET.setFocusableInTouchMode(false);
				stateSpinner.setEnabled(true);
				streetET.setFocusableInTouchMode(true);
				cityET.setFocusableInTouchMode(true);
				countrySpinner.setEnabled(true);
				zipET.setFocusableInTouchMode(true);
				deliveryCityET.setFocusableInTouchMode(true);
				dCountrySpinner.setEnabled(true);
				dStateSpinner.setEnabled(true);
				deliveryStreetET.setFocusableInTouchMode(true);
				deliveryZipET.setFocusableInTouchMode(true);
				prepareCountrySpinner();
				prepareDCountrySpinner();
				sCity = cityET.getText().toString();
				sCountry = countrySpinner.getSelectedItem().toString();
				sState = stateSpinner.getSelectedItem().toString();
				sStreetAddress = streetET.getText().toString();
				sPinCode = zipET.getText().toString();
				eMailAddress = emailET.getText().toString();
				sDeliveryCity = deliveryCityET.getText().toString();
				sDeliveryCountry = dCountrySpinner.getSelectedItem().toString();
				sDeliveryState = dStateSpinner.getSelectedItem().toString();
				sDeliveryPincode = deliveryZipET.getText().toString();
				sDeliveryStreetAddress = deliveryStreetET.getText().toString();
				edit.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.createaccount.update", "Upadte"));
			} else if (edit.getText().toString().equalsIgnoreCase(
					MobicartCommonData.keyValues.getString(
							"key.iphone.createaccount.update", "Upadte"))) {
				sCity = cityET.getText().toString();
				sCountry = countrySelected;
				sState = stateSelected;
				sStreetAddress = streetET.getText().toString();
				sPinCode = zipET.getText().toString();
				eMailAddress = emailET.getText().toString();
				sDeliveryCity = cityET.getText().toString();
				sDeliveryCountry = dCountrySelected;
				sDeliveryState = dStateSelected;
				sDeliveryPincode = deliveryZipET.getText().toString();
				sDeliveryStreetAddress = deliveryStreetET.getText().toString();
				valid = ValidateCredentials(eMailAddress, sStreetAddress,
						sCity, sPinCode, sDeliveryStreetAddress, sDeliveryCity,
						sDeliveryPincode);
				if (valid) {
					_id = 1;

					objDataBaseAccess.updateAccountDetails(_id, eMailAddress,
							sStreetAddress, sCity, sState, sPinCode, sCountry,
							sDeliveryStreetAddress, sDeliveryCity,
							sDeliveryState, sDeliveryPincode, sDeliveryCountry);
					isUpdated = true;
					MobicartCommonData.currencySymbol = GetAppIdentifierTask.applicationCurrency;
					final AlertDialog alertDialog = new AlertDialog.Builder(
							getParent()).create();
					alertDialog.setTitle(MobicartCommonData.keyValues
							.getString("key.iphone.nointernet.title", "Alert"));
					alertDialog.setMessage(MobicartCommonData.keyValues
							.getString("key.iphone.info.update.text",
									"Information updated."));
					alertDialog.setButton(MobicartCommonData.keyValues
							.getString("key.iphone.nointernet.cancelbutton",
									"Ok"),
							new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog,
										int which) {
									alertDialog.dismiss();
									edit
											.setText(MobicartCommonData.keyValues
													.getString(
															"key.iphone.createaccount.edit",
															"Edit"));
								}
							});
					alertDialog.show();
					chkLoginStatus = new ChkLoginStatusAct(this);
					chkLoginStatus.chkUserExistOrNot();
					setEditTextFocusableFalse();
				}
			}
			break;
		case R.id.universal_back_btn:
			finish();
			break;
		case R.id.navigation_bar_cart_btn:
			AccountTabGroupAct parentAct = (AccountTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.account", "Account");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "4");
			parentAct.startChildActivity("CartAct", cartAct);
			break;
		default:
			break;
		}
	}

	/**
	 * This Method is used for validating data entered by user for each field.
	 * 
	 * @param eMailAddress
	 * @param sStreetAddress
	 * @param sCity
	 * @param sPinCode
	 * @param sDeliveryStreetAddress
	 * @param sDeliveryCity
	 * @param sDeliveryPincode
	 * @return
	 */
	private boolean ValidateCredentials(String eMailAddress,
			String sStreetAddress, String sCity, String sPinCode,
			String sDeliveryStreetAddress, String sDeliveryCity,
			String sDeliveryPincode) {
		if (eMailAddress.length() == 0 || sStreetAddress.length() == 0
				|| sCity.length() == 0 || sPinCode.length() == 0
				|| sDeliveryCity.length() == 0
				|| sDeliveryPincode.length() == 0
				|| sDeliveryStreetAddress.length() == 0) {
			Toast.makeText(
					this,
					MobicartCommonData.keyValues.getString(
							"key.iphone.textfield.notempty.text",
							"Text Field must not be empty."),
					Toast.LENGTH_SHORT).show();
			return false;
		} else {
			if (eMailAddress.length() != 0) {
				Pattern pattern = Pattern.compile(".+@.+\\.[a-z]+");
				Matcher matcher = pattern.matcher(eMailAddress);
				boolean matchFound = matcher.matches();
				if (!matchFound) {
					Toast.makeText(
							this,
							MobicartCommonData.keyValues.getString(
									"key.iphone.invalid.email.text",
									"Invalid E-mail Address."),
							Toast.LENGTH_SHORT).show();
				}
				return matchFound;
			}
		return false;
		}
	}
}