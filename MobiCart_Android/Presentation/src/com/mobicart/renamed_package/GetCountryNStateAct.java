package com.mobicart.renamed_package;

import java.util.ArrayList;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.States;
import com.mobicart.android.core.Territory;
import com.mobicart.android.model.MobicartCommonData;

/**
 * This Activity is used to fetch list of countries and states.
 * 
 * @author mobicart
 * 
 */

public class GetCountryNStateAct {

	private States states = new States();
	private ArrayList<String> countries = new ArrayList<String>();
	private ArrayList<String> statesAL = new ArrayList<String>();
	private ArrayList<String> dCountries = new ArrayList<String>();
	private ArrayList<String> dStatesAL = new ArrayList<String>();
	private Territory territoryObj = new Territory();
	public static Activity mainContext;

	public GetCountryNStateAct(Activity context) {
		mainContext = context;
	}

	/**
	 * This method call service to get list of countries.
	 */
	public void findAllcountries() {
		try {
			MobicartCommonData.territoryVO = territoryObj
					.findAllCountries(mainContext);
		} catch (NullPointerException e) {
			showServerError();
		} catch (JSONException e) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
	}

	/**
	 * This method is used to show Network related errors.
	 */
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(mainContext).create();
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
						mainContext.startActivity(intent);
						mainContext.finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * This method is used to show Server errors.
	 */
	private void showServerError() {
		AlertDialog alertDialog = new AlertDialog.Builder(mainContext).create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.title.error", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.text", "Server not Responding"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						mainContext.finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * This method is used to prepare list of countries (including Shipping or
	 * Tax).
	 * 
	 * @return
	 */
	public ArrayList<String> GetCountryInfo() {
		if (MobicartCommonData.shippingObj != null) {
			for (int i = 0; i < MobicartCommonData.shippingObj.size(); i++) {
				if (!countries.contains(MobicartCommonData.shippingObj.get(i)
						.getsCountry())) {
					countries.add(MobicartCommonData.shippingObj.get(i)
							.getsCountry());
				}
			}
		}
		if (MobicartCommonData.taxObj != null) {
			for (int i = 0; i < MobicartCommonData.taxObj.size(); i++) {
				if (!countries.contains(MobicartCommonData.taxObj.get(i)
						.getsCountry())) {
					countries.add(MobicartCommonData.taxObj.get(i)
							.getsCountry());
				}
			}
		}
		return countries;
	}

	/**
	 * This method is used to prepare list of delivery countries (including
	 * Shipping or Tax).
	 * 
	 * @return
	 */
	public ArrayList<String> GetDCountryInfo() {
		if (MobicartCommonData.shippingObj != null) {
			for (int i = 0; i < MobicartCommonData.shippingObj.size(); i++) {
				if (!dCountries.contains(MobicartCommonData.shippingObj.get(i)
						.getsCountry())) {
					dCountries.add(MobicartCommonData.shippingObj.get(i)
							.getsCountry());
				}
			}
		}
		if (MobicartCommonData.taxObj != null) {
			for (int i = 0; i < MobicartCommonData.taxObj.size(); i++) {
				if (!dCountries.contains(MobicartCommonData.taxObj.get(i)
						.getsCountry())) {
					dCountries.add(MobicartCommonData.taxObj.get(i)
							.getsCountry());
				}
			}
		}
		return dCountries;
	}

	/**
	 * This method is used to prepare list of delivery states of selected
	 * country by passing country Id.
	 */
	public ArrayList<String> getDStateByCountryId(int countryId) {
		try {
			MobicartCommonData.statesVO = states.findAllStatesByCountry(
					mainContext, countryId);
		} catch (NullPointerException e) {
			showServerError();
		} catch (JSONException e) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
		for (int i = 0; i < MobicartCommonData.statesVO.size(); i++) {
			ArrayList<String> allStates = new ArrayList<String>();
			allStates.add(MobicartCommonData.statesVO.get(i).getsName());
			if (MobicartCommonData.shippingObj != null) {
				for (int j = 0; j < MobicartCommonData.shippingObj.size(); j++) {
					if (allStates.contains(MobicartCommonData.shippingObj
							.get(j).getsState())) {
						if (!dStatesAL.contains(MobicartCommonData.shippingObj
								.get(j).getsState())) {
							dStatesAL.add(MobicartCommonData.shippingObj.get(j)
									.getsState());
						}
					}
				}
			}
			if (MobicartCommonData.taxObj != null) {
				for (int k = 0; k < MobicartCommonData.taxObj.size(); k++) {
					if (allStates.contains(MobicartCommonData.taxObj.get(k)
							.getsState())) {
						if (!dStatesAL.contains(MobicartCommonData.taxObj
								.get(k).getsState())) {
							dStatesAL.add(MobicartCommonData.taxObj.get(k)
									.getsState());
						}
					}
				}
			}
		}
		return dStatesAL;
	}

	/**
	 * This Method can fetch country Id for selected Country.
	 * 
	 * @param dCountrySelected
	 * @return
	 */
	public int checkId(String dCountrySelected) {
		if(MobicartCommonData.territoryVO!=null)
		{
			if (MobicartCommonData.territoryVO.size() <= 0) {
			findAllcountries();
		}
		for (int i = 0; i < MobicartCommonData.territoryVO.size(); i++) {
			if (MobicartCommonData.territoryVO.get(i).getSname()
					.equalsIgnoreCase(dCountrySelected)) {
				return MobicartCommonData.territoryVO.get(i).getId();
			}
		}
		}
		return 0;
	}

	/**
	 * This method can fetch state Id for selected State.
	 * 
	 * @param stateSelected
	 * @return
	 */
	public int checkstateId(String stateSelected) {
		if(MobicartCommonData.statesVO!=null){
		if (MobicartCommonData.statesVO.size() <= 0) {
			try {
				MobicartCommonData.statesVO = states.findAllStatesByCountry(
						mainContext, MobicartCommonData.territoryId);
			} catch (NullPointerException e) {
				showServerError();
			} catch (JSONException e) {
				showServerError();
			} catch (CustomException e) {
				showNetworkError();
			}
		}
		for (int i = 0; i < MobicartCommonData.statesVO.size(); i++) {
			if (MobicartCommonData.statesVO.get(i).getsName().equalsIgnoreCase(
					stateSelected)) {
				return MobicartCommonData.statesVO.get(i).getId();
			}
		}
		}
		return 0;
	}

	/**
	 * This method is used to prepare list of states of selected Country by
	 * passing Territory Id.
	 * 
	 * @param territoryId
	 * @return
	 */
	public ArrayList<String> getcStateByCountryId(int territoryId) {
		try {
			MobicartCommonData.statesVO = states.findAllStatesByCountry(
					mainContext, territoryId);
		} catch (NullPointerException e) {
			showServerError();
		} catch (JSONException e) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
		for (int i = 0; i < MobicartCommonData.statesVO.size(); i++) {
			ArrayList<String> allStates = new ArrayList<String>();
			allStates.add(MobicartCommonData.statesVO.get(i).getsName());
			if (MobicartCommonData.shippingObj != null) {
				for (int j = 0; j < MobicartCommonData.shippingObj.size(); j++) {
					if (allStates.contains(MobicartCommonData.shippingObj
							.get(j).getsState())) {
						if (statesAL.contains(MobicartCommonData.shippingObj
								.get(j).getsState())) {
						} else
							statesAL.add(MobicartCommonData.shippingObj.get(j)
									.getsState());
					}
				}
			}
			if (MobicartCommonData.taxObj != null) {
				for (int k = 0; k < MobicartCommonData.taxObj.size(); k++) {
					if (allStates.contains(MobicartCommonData.taxObj.get(k)
							.getsState())) {
						if (statesAL.contains(MobicartCommonData.taxObj.get(k)
								.getsState())) {
						} else {
							statesAL.add(MobicartCommonData.taxObj.get(k)
									.getsState());
						}
					}
				}
			}
		}
		return statesAL;
	}
}
