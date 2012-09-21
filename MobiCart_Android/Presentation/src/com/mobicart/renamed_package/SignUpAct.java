package com.mobicart.renamed_package;

import java.util.ArrayList;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.CompoundButton.OnCheckedChangeListener;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetAppIdentifierTask;

/**
 * This Activity Class is used for creating Account.
 * 
 * @author mobicart
 * 
 */

public class SignUpAct extends Activity implements OnClickListener {

	private String stateSelected = "", countrySelected = "",
			dCountrySelected = "", dStateSelected = "";
	private String sUserName, eMailAddress, sStreetAddress, sState, sCountry,
			sPinCode, sCity, sDeliveryState, sDeliveryStreetAddress,
			sDeliveryCity, sDeliveryCountry, sDeliveryPincode;
	private int _id;
	private Boolean isChk, valid = true;
	private MyCommonView submitBtn, backBtn, cartBtn, cartEditBtn, submitBtn2;
	private TextView submitBottomSpace;
	private EditText nameET, emailET, streetET, cityET, zipET,
			deliveryStreetET, deliveryCityET, deliveryZipET;
	private RelativeLayout deliveryLayout;
	private ScrollView countrySV, stateSV, dCountrySV, dStateSV;
	private CheckBox deliveryAddChk;
	private DataBaseAccess objDataBaseAccess;
	private ChkLoginStatusAct chkLoginStatus;
	private GetCountryNStateAct getCountryNState;
	private int territoryId, dterritoryId;
	private String IsFrom, backStr;
	private GradientDrawable gredientButtonDrawable;
	private ArrayAdapter<String> adapter, dAdapter;
	private ArrayAdapter<String> sAdapter1, dSAdapter;
	private ArrayList<String> statesAL = new ArrayList<String>();
	private ArrayList<String> countries = new ArrayList<String>();
	private ArrayList<String> dCountries = new ArrayList<String>();
	private ArrayList<String> dStatesAL = new ArrayList<String>();
	private ArrayList<String> countryStateNotAvaliable = new ArrayList<String>();
	private ArrayList<String> dcountryStateNotAvaliable = new ArrayList<String>();
	public static boolean isLogged = false;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.sign_up_layout);
		Bundle extra = getIntent().getExtras();
		IsFrom = extra.getString("IsFrom");

		backStr = extra.getString("backBtn");
		gredientButtonDrawable = (GradientDrawable) this.getResources()
				.getDrawable(R.drawable.rounded_button);
		gredientButtonDrawable.setColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getThemeColor()));
		prepareViewControls();
		chkLoginStatus = new ChkLoginStatusAct(this);
		getCountryNState = new GetCountryNStateAct(this);
		try {
			prepareCountrySpinner();
		} catch (NullPointerException e) {
		}
		submitBtn.setBackgroundDrawable(gredientButtonDrawable);
		submitBtn.setOnClickListener(this);
		if (IsFrom.equalsIgnoreCase("CartAct")) {
			String backStrTitle = MobicartCommonData.keyValues.getString(
					"key.iphone.home.back", "Back");
			backBtn.setText(backStrTitle);
		} else {
			backBtn.setText(backStr);
		}
		backBtn.setOnClickListener(this);
		deliveryAddChk
				.setOnCheckedChangeListener(new OnCheckedChangeListener() {
					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						try {
							if (!chkBoxIsChked()) {
								getDeliveryInfo();
							}
						} catch (NullPointerException e) {
						}
					}
				});
	}

	/**
	 * used to fill the country and state spinner after getting country list.
	 */
	private void prepareCountrySpinner() {
		getCountryInfo();
		setCountrySpinner();
	}

	/**
	 * This method is used to get list of available countries.
	 */
	private void getCountryInfo() {
		if (MobicartCommonData.shippingObj != null
				|| MobicartCommonData.taxObj != null) {
			countries.clear();
			countries = getCountryNState.GetCountryInfo();
			if (countries.size() > 0) {
				adapter = new ArrayAdapter<String>(SignUpAct.this,
						android.R.layout.simple_spinner_item, countries);
				adapter
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			} else
				showDialog();
		} else {
			countryStateNotAvaliable.add("  -  ");
			adapter = new ArrayAdapter<String>(SignUpAct.this,
					android.R.layout.simple_spinner_item,
					countryStateNotAvaliable);
			adapter
					.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		}
	}

	/**
	 * This method is used to generate dropdown for countries filled with list
	 * of available countries.
	 */
	private void setCountrySpinner() {
		final Spinner countrySpinner = new Spinner(getParent());
		countrySpinner.setBackgroundResource(R.drawable.dropdown_selector);
		countrySpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country"));
		countrySpinner.setAdapter(adapter);
		countrySpinner.setPadding(10, 0, 0, 0);

		if (countries.contains(MobicartCommonData.storeVO.getTerritoryName())) {
			countrySpinner.setSelection(countries
					.indexOf(MobicartCommonData.storeVO.getTerritoryName()));
			countrySelected = MobicartCommonData.storeVO.getTerritoryName();
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
				sAdapter1 = new ArrayAdapter<String>(
						getParent(),
						android.R.layout.simple_spinner_item,
						(MobicartCommonData.shippingObj == null) ? countryStateNotAvaliable
								: statesAL);
				sAdapter1
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

				stateSpinner
						.setBackgroundResource(R.drawable.dropdown_selector);
				stateSpinner
						.setPrompt(MobicartCommonData.keyValues.getString(
								"key.iphone.shoppingcart.choose.state",
								"Choose State"));
				stateSpinner.setAdapter(sAdapter1);
				stateSpinner.setPadding(10, 0, 49, 0);
				if (MobicartCommonData.storeVO.getTaxList() != null) {
					for (int pos = 0; pos < MobicartCommonData.storeVO
							.getTaxList().size(); pos++) {
						if (MobicartCommonData.storeVO.getTaxList().get(pos)
								.getsState().equalsIgnoreCase("Other")) {
							if (statesAL.contains(MobicartCommonData.storeVO
									.getTaxList().get(pos).getsState())) {
								stateSpinner.setSelection(statesAL
										.indexOf(MobicartCommonData.storeVO
												.getTaxList().get(pos)
												.getsState()));
							}
						}
					}
				}
				stateSV.removeAllViews();
				stateSpinner
						.setOnItemSelectedListener(new OnItemSelectedListener() {
							@Override
							public void onItemSelected(AdapterView<?> arg0,
									View arg1, int arg2, long arg3) {
								if (MobicartCommonData.shippingObj != null) {
									stateSelected = (String) stateSpinner
											.getSelectedItem();
								}
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
		countrySV.addView(countrySpinner);
	}

	/**
	 * This method is used to check user wants same delivery address or
	 * different.
	 * 
	 * @return
	 */
	private Boolean chkBoxIsChked() {
		if (deliveryAddChk.isChecked()) {
			deliveryLayout.setVisibility(View.GONE);
			submitBtn.setVisibility(View.VISIBLE);
			isChk = true;
		} else {
			deliveryLayout.setVisibility(View.VISIBLE);
			submitBtn.setVisibility(View.INVISIBLE);
			prepareDeliveryViewControls();
			submitBtn2.setVisibility(View.VISIBLE);
			submitBottomSpace.setVisibility(View.VISIBLE);
			submitBtn2.setOnClickListener(this);
			isChk = false;
		}
		return isChk;
	}

	/**
	 * This method is used to get delivery information from user, if user wants
	 * different delivery address.
	 */

	private void getDataFromUser() {
		getAccountInfo();
		if (!chkBoxIsChked()) {
			getDeliveryInfo();
		} else {
			getDeliveryInfoSame();
		}
	}

	/**
	 * This method is used to setting delivery information for user, if user
	 * wants same delivery address.
	 */

	private void getDeliveryInfoSame() {
		sDeliveryCity = cityET.getText().toString();
		sDeliveryState = stateSelected;
		sDeliveryCountry = countrySelected;
		sDeliveryStreetAddress = streetET.getText().toString();
		sDeliveryPincode = zipET.getText().toString();
	}

	/**
	 * This Method is used For getting Delivery information from user.
	 */

	private void getDeliveryInfo() {
		sDeliveryCity = deliveryCityET.getText().toString();
		sDeliveryState = dStateSelected;
		sDeliveryCountry = dCountrySelected;
		sDeliveryStreetAddress = deliveryStreetET.getText().toString();
		sDeliveryPincode = deliveryZipET.getText().toString();
	}

	/**
	 * This Method is used to fill the dropdown for country and state after
	 * getting delivery country list.
	 */

	private void preparedCountrySpinner() {
		getdCountryInfo();
		setdCountrySpinner();
	}

	/**
	 * This Method is used for getting delivery country information from
	 * service.
	 */
	private void getdCountryInfo() {
		if (MobicartCommonData.shippingObj != null
				|| MobicartCommonData.taxObj != null) {
			dCountries.clear();
			dCountries = getCountryNState.GetDCountryInfo();
			if (dCountries.size() > 0) {
				dAdapter = new ArrayAdapter<String>(SignUpAct.this,
						android.R.layout.simple_spinner_item, dCountries);
				dAdapter
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			} else
				showDialog();
		} else {
			dcountryStateNotAvaliable.add("  -  ");
			dAdapter = new ArrayAdapter<String>(SignUpAct.this,
					android.R.layout.simple_spinner_item,
					dcountryStateNotAvaliable);
			dAdapter
					.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		}
	}

	/**
	 * This Method is used for setting dropdown for delivery country so that
	 * user can select one from them.
	 */
	private void setdCountrySpinner() {

		final Spinner dCountrySpinner = new Spinner(getParent());
		dCountrySpinner.setBackgroundResource(R.drawable.dropdown_selector);
		dCountrySpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country"));
		dCountrySpinner.setAdapter(dAdapter);
		dCountrySpinner.setPadding(10, 0, 0, 0);
		if (countries.contains(MobicartCommonData.storeVO.getTerritoryName())) {
			dCountrySpinner.setSelection(countries
					.indexOf(MobicartCommonData.storeVO.getTerritoryName()));
			countrySelected = MobicartCommonData.storeVO.getTerritoryName();
		}
		dCountrySpinner.setOnItemSelectedListener(new OnItemSelectedListener() {

			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				dCountrySelected = (String) dCountrySpinner.getSelectedItem();
				dterritoryId = getCountryNState.checkId(dCountrySelected);
				dStatesAL.clear();
				dStatesAL = getCountryNState.getDStateByCountryId(dterritoryId);
				dSAdapter = new ArrayAdapter<String>(
						getParent(),
						android.R.layout.simple_spinner_item,
						(MobicartCommonData.shippingObj == null && MobicartCommonData.taxObj == null) ? dcountryStateNotAvaliable
								: dStatesAL);
				dSAdapter
						.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
				final Spinner dStateSpinner = new Spinner(getParent());
				dStateSpinner
						.setBackgroundResource(R.drawable.dropdown_selector);
				dStateSpinner
						.setPrompt(MobicartCommonData.keyValues.getString(
								"key.iphone.shoppingcart.choose.state",
								"Choose State"));
				dStateSpinner.setAdapter(dSAdapter);
				dStateSpinner.setPadding(10, 0, 49, 0);
				if(MobicartCommonData.storeVO.getTaxList()!=null){
				for (int pos = 0; pos < MobicartCommonData.storeVO.getTaxList()
						.size(); pos++) {
					if (MobicartCommonData.storeVO.getTaxList().get(pos)
							.getsState().equalsIgnoreCase("Other")) {
						if (statesAL.contains(MobicartCommonData.storeVO
								.getTaxList().get(pos).getsState())) {
							dStateSpinner
									.setSelection(statesAL
											.indexOf(MobicartCommonData.storeVO
													.getTaxList().get(pos)
													.getsState()));
						}
					}
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
				dStateSelected = (String) dStateSpinner.getSelectedItem();
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
			}
		});
		dCountrySV.removeAllViews();
		dCountrySV.addView(dCountrySpinner);
	}

	/**
	 * This method is used for getting account information from user.
	 */
	private void getAccountInfo() {
		sUserName = nameET.getText().toString();
		eMailAddress = emailET.getText().toString();
		sStreetAddress = streetET.getText().toString();
		sPinCode = zipET.getText().toString();
		sCity = cityET.getText().toString();
		sState = stateSelected;
		sCountry = countrySelected;
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		MyCommonView cityMV, signTitleMV, nameMV, emailMV, streetMV, chechBoxDataMV, countryMV, stateMV, zipMV;
		cityMV = (MyCommonView) findViewById(R.id.signup_city_TV);
		signTitleMV = (MyCommonView) findViewById(R.id.signup_title_TV);
		nameMV = (MyCommonView) findViewById(R.id.signup_name_TV);
		emailMV = (MyCommonView) findViewById(R.id.signup_email_TV);
		streetMV = (MyCommonView) findViewById(R.id.signup_street_TV);
		countryMV = (MyCommonView) findViewById(R.id.signup_country_TV);
		stateMV = (MyCommonView) findViewById(R.id.signup_state_TV);
		zipMV = (MyCommonView) findViewById(R.id.signup_zip_TV);
		chechBoxDataMV = (MyCommonView) findViewById(R.id.signup_checkdata_TV);
		submitBtn = (MyCommonView) findViewById(R.id.signup_submit_Btn);
		cityMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.city", "City"));
		signTitleMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.signup", "SIGN UP"));
		nameMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.name", "Name"));
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
		chechBoxDataMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.deliveryaddr", "Same Delivery Address?"));
		submitBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.submit", "Submit"));

		submitBtn.setBackgroundDrawable(gredientButtonDrawable);
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
		nameET = (EditText) findViewById(R.id.signup_name_ET);
		emailET = (EditText) findViewById(R.id.signup_email_ET);
		streetET = (EditText) findViewById(R.id.signup_street_ET);
		zipET = (EditText) findViewById(R.id.signup_zip_ET);
		cityET = (EditText) findViewById(R.id.signup_city_ET);
		countrySV = (ScrollView) findViewById(R.id.signup_country_SV);
		stateSV = (ScrollView) findViewById(R.id.signup_state_SV);
		deliveryLayout = (RelativeLayout) findViewById(R.id.delivery_layout);
		deliveryAddChk = (CheckBox) findViewById(R.id.signup_CB);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setBackgroundResource(R.drawable.account_btn_bg);
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareDeliveryViewControls() {
		MyCommonView deliveryTitleMV, streetMV, cityMV, countryMV, stateMV, zipMV;
		deliveryTitleMV = (MyCommonView) findViewById(R.id.Delivery_title_TV);
		streetMV = (MyCommonView) findViewById(R.id.Delivery_street_TV);
		cityMV = (MyCommonView) findViewById(R.id.Delivery_city_TV);
		countryMV = (MyCommonView) findViewById(R.id.Delivery_country_TV);
		stateMV = (MyCommonView) findViewById(R.id.Delivery_state_TV);
		zipMV = (MyCommonView) findViewById(R.id.Delivery_zip_TV);
		submitBtn2 = (MyCommonView) findViewById(R.id.signup_submit2_Btn);
		submitBottomSpace = (TextView) findViewById(R.id.signUp_submit_bottomSpace_TV);

		deliveryTitleMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.daddr", "DELIVERY ADDRESS"));
		streetMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.street", "Street"));
		cityMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.city", "City"));
		countryMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.country", "Country"));
		stateMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.state", "State"));
		zipMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.zip", "Zip Code"));
		submitBtn2.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.submit", "Submit"));

		submitBtn2.setBackgroundDrawable(gredientButtonDrawable);
		deliveryCityET = (EditText) findViewById(R.id.Delivery_city_ET);
		dCountrySV = (ScrollView) findViewById(R.id.Delivery_country_SV);
		dStateSV = (ScrollView) findViewById(R.id.Delivery_state_SV);
		deliveryZipET = (EditText) findViewById(R.id.Delivery_zip_ET);
		deliveryStreetET = (EditText) findViewById(R.id.Delivery_zip_ET);
		preparedCountrySpinner();
	}

	/**
	 * This Method is used to show alert to user when country is Available.
	 */
	public void showDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
		builder.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.review.rating.posted.title", "Message"));
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

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.signup_submit2_Btn: {
			getDataFromUser();
			valid = ValidateCredentials(sUserName, eMailAddress,
					sStreetAddress, sCity, sState, sPinCode, sCountry,
					sDeliveryStreetAddress, sDeliveryCity, sDeliveryState,
					sDeliveryPincode, sDeliveryCountry);
			if (valid) {
				_id = 1;
				objDataBaseAccess = new DataBaseAccess(this);
				objDataBaseAccess.insertAccountDetails(_id, sUserName,
						eMailAddress, sStreetAddress, sCity, sState, sPinCode,
						sCountry, sDeliveryStreetAddress, sDeliveryCity,
						sDeliveryState, sDeliveryPincode, sDeliveryCountry);
				chkLoginStatus.chkUserExistOrNot();
				isLogged = true;
				MobicartCommonData.currencySymbol = GetAppIdentifierTask.applicationCurrency;
				finish();
			} else {
			}
			break;
		}
		case R.id.signup_submit_Btn: {

			getDataFromUser();

			valid = ValidateCredentials(sUserName, eMailAddress,
					sStreetAddress, sCity, sState, sPinCode, sCountry,
					sDeliveryStreetAddress, sDeliveryCity, sDeliveryState,
					sDeliveryPincode, sDeliveryCountry);
			if (valid) {
				_id = 1;
				objDataBaseAccess = new DataBaseAccess(this);
				objDataBaseAccess.insertAccountDetails(_id, sUserName,
						eMailAddress, sStreetAddress, sCity, sState, sPinCode,
						sCountry, sDeliveryStreetAddress, sDeliveryCity,
						sDeliveryState, sDeliveryPincode, sDeliveryCountry);
				chkLoginStatus.chkUserExistOrNot();
				isLogged = true;
				MobicartCommonData.currencySymbol = GetAppIdentifierTask.applicationCurrency;
				if (IsFrom.equalsIgnoreCase("CartAct")) {
					CartAct.countrySpinner.setAdapter(adapter);
					CartAct.stateSpinner.setAdapter(sAdapter1);
					CartAct.stateSpinner.setSelection(statesAL
							.indexOf(MobicartCommonData.objAccountVO
									.getsDeliveryState()));
					CartAct.countrySpinner.setSelection(countries
							.indexOf(MobicartCommonData.objAccountVO
									.getsDeliveryCountry()));
				}
				finish();
			}
			break;
		}
		case R.id.navigation_bar_cart_btn:
			ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
			Intent cartAct = new Intent(SignUpAct.this, CartAct.class);
			if (IsFrom.equalsIgnoreCase("CartAct")) {
				String backStrTitle = MobicartCommonData.keyValues.getString(
						"key.iphone.home.back", "Back");
				cartAct.putExtra("IsFrom", backStrTitle);
				cartAct.putExtra("ParentAct", "2");
			} else {
				String backBtn = MobicartCommonData.keyValues.getString(
						"key.iphone.signup.signup", "SIGN UP");
				cartAct.putExtra("IsFrom", backBtn);
				cartAct.putExtra("ParentAct", "4");
			}
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		case R.id.universal_back_btn:
			finish();
			break;
		default:
			break;
		}
	}

	/**
	 * This Method is used for validating data entered by user for each field.
	 * 
	 * @param sUserName
	 * @param eMailAddress
	 * @param sStreetAddress
	 * @param sCity
	 * @param sState
	 * @param sPinCode
	 * @param sCountry
	 * @param sDeliveryStreetAddress
	 * @param sDeliveryCity
	 * @param sDeliveryState
	 * @param sDeliveryPincode
	 * @param sDeliveryCountry
	 * @return
	 */
	private boolean ValidateCredentials(String sUserName, String eMailAddress,
			String sStreetAddress, String sCity, String sState,
			String sPinCode, String sCountry, String sDeliveryStreetAddress,
			String sDeliveryCity, String sDeliveryState,
			String sDeliveryPincode, String sDeliveryCountry) {

		if (sUserName.length() == 0 || eMailAddress.length() == 0
				|| sStreetAddress.length() == 0 || sCity.length() == 0
				|| sPinCode.length() == 0) {
			Toast.makeText(
					SignUpAct.this,
					MobicartCommonData.keyValues.getString(
							"key.iphone.textfield.notempty.text",
							"Text Field must not be empty."),
					Toast.LENGTH_SHORT).show();
			return false;
		}
		
		if (!deliveryAddChk.isChecked()) {
			if (sDeliveryCity.length() == 0 || sDeliveryPincode.length() == 0
					|| sDeliveryStreetAddress.length() == 0) {
				Toast.makeText(
						SignUpAct.this,
						MobicartCommonData.keyValues.getString(
								"key.iphone.textfield.notempty.text",
								"Text Field must not be empty."),
						Toast.LENGTH_SHORT).show();
				return false;
			}
		}
		if (sCountry.length()==0) {
			Toast.makeText(
						SignUpAct.this,
						MobicartCommonData.keyValues.getString(
								"key.iphone.textfield.notempty.text",
								"Text Field must not be empty."),
						Toast.LENGTH_SHORT).show();
				return false;
		}
		if (sState.length()==0) {
			Toast.makeText(
					SignUpAct.this,
					MobicartCommonData.keyValues.getString(
							"key.iphone.textfield.notempty.text",
							"Text Field must not be empty."),
					Toast.LENGTH_SHORT).show();
			return false;
	}
		if (sUserName.length() != 0) {
			if (!sUserName.matches("[a-zA-Z ]*")) {
				Toast.makeText(
						this,
						MobicartCommonData.keyValues.getString(
								"key.iphone.AccountDetailValidation",
								"Enter valid")
								+ " "
								+ MobicartCommonData.keyValues.getString(
										"key.iphone.signup.name", "Name"),
						Toast.LENGTH_SHORT).show();
				return false;
			}
		}
		if (eMailAddress.length() != 0) {
			Pattern pattern = Pattern.compile(".+@.+\\.[a-z]+");
			Matcher matcher = pattern.matcher(eMailAddress);
			boolean matchFound = matcher.matches();
			if (!matchFound) {
				Toast.makeText(
						this,
						MobicartCommonData.keyValues.getString(
								"key.iphone.invalid.email.text",
								"Invalid E-mail Address."), Toast.LENGTH_SHORT)
						.show();
			}
			return matchFound;
		}
		return true;
	}

	@Override
	protected void onResume() {
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backBtn.setVisibility(View.VISIBLE);
		if (IsFrom.equalsIgnoreCase("CartAct")) {
			String backStrTitle = MobicartCommonData.keyValues.getString(
					"key.iphone.home.back", "Back");
			backBtn.setText(backStrTitle);
		} else {
			backBtn.setText(backStr);
		}
		backBtn.setOnClickListener(this);
		super.onResume();
	}

	@Override
	protected void onDestroy() {
		if (IsFrom.equalsIgnoreCase("CartAct")) {
			cartBtn = TabHostAct.prepareCartButton(this);
			cartBtn.setVisibility(View.GONE);
			cartEditBtn = TabHostAct.prepareCartEditButton(this);
			cartEditBtn.setVisibility(View.VISIBLE);
			cartEditBtn.setBackgroundResource(R.drawable.button_without_color);
			cartEditBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.shoppingcart.edit", "Edit"));
			if (cartEditBtn.getText().toString().equalsIgnoreCase(
					MobicartCommonData.keyValues.getString(
							"key.iphone.shoppingcart.edit", "Edit"))) {
				cartEditBtn.setGravity(Gravity.CENTER);
				cartEditBtn.setPadding(0, 0, 0, 0);
			}
		}
		MobicartCommonData.isFromStart = "NotSplash";
		if (IsFrom.equalsIgnoreCase("MyAccountTabAct")) {
			backBtn.setVisibility(View.INVISIBLE);
		} else {
			backBtn.setVisibility(View.VISIBLE);

		}
		CartAct.cartButtonMode = CartAct.CART_BUTTON_MODE_EDIT;
		super.onDestroy();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		return false;
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}
}