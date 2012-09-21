package com.mobicart.renamed_package;

import java.util.ArrayList;
import org.json.JSONException;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.core.Product;
import com.mobicart.android.core.Shipping;
import com.mobicart.android.core.Tax;
import com.mobicart.android.core.TaxShipping;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.android.model.ShippingVO;
import com.mobicart.android.model.TaxShippingVO;
import com.mobicart.android.model.TaxVO;
import com.mobicart.android.model.TerritoryVO;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.ProductTax;
import com.mobicart.renamed_package.utils.AsyncTasks.GetCartItemTask;
import com.mobicart.renamed_package.utils.adapters.CartListAdapter;

/**
 * This Activity Class List all the items added in Cart by user.
 * 
 * @author mobicart
 * 
 */
public class CartAct extends Activity implements OnClickListener,
		OnItemSelectedListener {

	private String stateSelected = "", currencySelected = "",
			countrySelected = "";
	private String isFrom, parentAct;
	private ListView cartLV;
	private ImageView titleIV;
	private MyCommonView chkoutBt, backBtn, cartButton, cartEditBtn,
			selectCountryTV, selectStateTV, subTotalMV, taxMV, shippingMV,
			taxShippingMV, totalMV;
	private TextView subTotalTV, taxTV, shippingTV, shippingTaxTV,
			totalPriceTV, titleTV;
	private GetCountryNStateAct getCountryNState;
	private ArrayAdapter<String> cAdapter;
	private ArrayAdapter<String> sAdapter;
	private ProgressDialog dialog;
	private Handler handler;
	private ArrayList<String> countryStateNotAvaliable = new ArrayList<String>();
	private boolean isNetworkNotAvailable = false;
	private GradientDrawable gradienatCheckoutBtnDrawable;
	@SuppressWarnings("unused")
	private GetCartItemTask cartItem;
	private ArrayList<String> statesAL = new ArrayList<String>();
	private ArrayList<String> countries = new ArrayList<String>();
	private double subTotal, tax, grandTotal, shipping, shippingTax;
	private int stateId = 0, countryId;
	private int territoryId;
	public static Spinner countrySpinner, stateSpinner;
	public final static int CART_BUTTON_MODE_CART = 11888;
	public final static int CART_BUTTON_MODE_EDIT = 11889;
	public final static int CART_BUTTON_MODE_DONE = 11890;
	public static int cartButtonMode = CART_BUTTON_MODE_EDIT;
	public static RelativeLayout footerLayout;
	public static boolean URL_HIT_MODE = false;
	private Double fPrice = 0.0;
	@SuppressWarnings("unused")
	private double sum = 0;
	private double actualPrice = 0;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		this.dialog = ProgressDialog.show(this.getParent(), null,
				MobicartCommonData.keyValues.getString("key.iphone.LoaderText",
						"Loading..."));
		handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				switch (msg.what) {
				case 0:
					try {
						CartAct.this.dialog.cancel();
						CartAct.this.dialog = null;
					} catch (Exception e) {
						CartAct.this.dialog = null;
					}
					break;
				default:
					break;
				}
			}
		};
		setContentView(R.layout.yourcart_layout);
		Bundle extra = getIntent().getExtras();
		isFrom = extra.getString("IsFrom");
		parentAct = extra.getString("ParentAct");
		backBtn = TabHostAct.prepareSoftBackButton(this);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartButton = TabHostAct.prepareCartEditButton(this);
		if (!parentAct.equalsIgnoreCase("0")) {
			backBtn.setBackgroundResource(R.drawable.account_btn_bg);
		}
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(isFrom);
		gradienatCheckoutBtnDrawable = (GradientDrawable) this.getResources()
				.getDrawable(R.drawable.rounded_button);
		gradienatCheckoutBtnDrawable.setColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getThemeColor()));
		getCountryNState = new GetCountryNStateAct(this);
		cartEditBtn.setVisibility(View.GONE);
		backBtn.setOnClickListener(this);
		cartButton.setVisibility(View.VISIBLE);
		cartButton.setBackgroundResource(R.drawable.button_without_color);
		cartButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.edit", "Edit"));
		if (cartButton
				.getText()
				.toString()
				.equalsIgnoreCase(
						MobicartCommonData.keyValues.getString(
								"key.iphone.shoppingcart.edit", "Edit"))) {
			cartButton.setGravity(Gravity.CENTER);
			cartButton.setPadding(0, 0, 0, 0);
		} else {
			cartButton.setText("" + CartItemCount.getCartCount(this));
			cartButton.setGravity(Gravity.RIGHT);
			if (MobicartUrlConstants.resolution == 3)
				cartButton.setPadding(0, 6, 14, 0);
			else
				cartButton.setPadding(0, 7, 18, 0);
		}
		prepareViewControls();
		prepareFooterViewControls();
		chkoutBt.setOnClickListener(this);
		countrySpinner.setOnItemSelectedListener(CartAct.this);
		if (CartItemCount.getCartCount(this) == 0) {
			footerLayout.setVisibility(View.GONE);
			chkoutBt.setVisibility(View.GONE);
			subTotalTV.setVisibility(View.GONE);
			taxTV.setVisibility(View.GONE);
			shippingTV.setVisibility(View.GONE);
			shippingTaxTV.setVisibility(View.GONE);
			totalPriceTV.setVisibility(View.GONE);
			cartButton.setVisibility(View.GONE);
		} else {
			cartLV.addFooterView(footerLayout);
		}
		stateSpinner.setOnItemSelectedListener(new OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				stateSelected = (String) stateSpinner.getSelectedItem();
				if (!stateSelected.equalsIgnoreCase("")) {
					final ProgressDialog dialog = new ProgressDialog(
							getParent());
					dialog.setCancelable(false);
					dialog.setMessage(MobicartCommonData.keyValues.getString(
							"key.iphone.LoaderText", "Loading...") + "...");
					dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
					dialog.show();
					Handler handlerThST = new Handler();
					handlerThST.postDelayed(new Runnable() {

						@Override
						public void run() {
							stateId = getCountryNState
									.checkstateId(stateSelected);
							tax = getTaxTV(countryId, stateId, subTotal);
							taxTV.setText(""
									+ MobicartCommonData.currencySymbol
									+ String.format("%.2f", tax));

							shipping = getShippingTV(countryId, stateId);
							shippingTV.setText(""
									+ MobicartCommonData.currencySymbol
									+ String.format("%.2f", shipping));

							shippingTax = getShippingTaxTV(countryId, stateId,
									shipping);
							shippingTaxTV.setText(""
									+ MobicartCommonData.currencySymbol
									+ String.format("%.2f", shippingTax));

							grandTotal = (double) (actualPrice + shipping
									+ shippingTax + tax);
							totalPriceTV.setText(""
									+ MobicartCommonData.currencySymbol
									+ String.format("%.2f", grandTotal));

							if (MobicartCommonData.objAccountVO.get_id() > 0) {
								if (MobicartCommonData.objAccountVO
										.getsDeliveryCountry()
										.equalsIgnoreCase(countrySelected)
										&& MobicartCommonData.objAccountVO
												.getsDeliveryState()
												.equalsIgnoreCase(stateSelected)) {
									MobicartCommonData.objCostVO.actualTax = tax;
									MobicartCommonData.objCostVO.actualSubTotal = actualPrice;
									MobicartCommonData.objCostVO.actualShippingTax = shippingTax;
									MobicartCommonData.objCostVO.actualShipping = shipping;
									MobicartCommonData.objCostVO.actualGrandTotal = grandTotal;
								}
							}
							try {
								dialog.cancel();
							} catch (Exception e) {
							}
						}
					}, 1000);
				}
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
			}
		});
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		titleIV = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);
		titleIV.setImageDrawable(getResources().getDrawable(
				R.drawable.cart_image));
		titleTV = (MyCommonView) findViewById(R.id.common_nav_bar_heading_TV);
		titleTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.yourcart", "YourCart"));
		cartLV = (ListView) findViewById(R.id.yourcart_items_ListView);
		footerLayout = (RelativeLayout) getParent().getLayoutInflater()
				.inflate(R.layout.cart_list_checkoutfooter_layout, null);
	}

	/**
	 * This Method is used to show Server Errors.
	 */
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				CartAct.this.getParent()).create();
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

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareFooterViewControls() {
		chkoutBt = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_checkout_Btn);
		countrySpinner = (Spinner) footerLayout
				.findViewById(R.id.cartList_footer_country_Spinner);
		stateSpinner = (Spinner) footerLayout
				.findViewById(R.id.cartList_footer_state_Spinner);
		selectCountryTV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_chooseCountry_TV);
		selectStateTV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_state_TV);
		subTotalMV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_subTotal_TV);
		taxMV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_tax_TV);
		shippingMV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_shipping_TV);
		taxShippingMV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_shippingTax_TV);
		totalMV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_total_TV);
		subTotalTV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_subValue_TV);
		taxTV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_taxValue_TV);
		shippingTV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_shippingValue_TV);
		shippingTaxTV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_shippingTaxValue_TV);
		totalPriceTV = (MyCommonView) footerLayout
				.findViewById(R.id.cartList_footer_totalValue_TV);

		selectCountryTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country")
				+ ": ");
		selectStateTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choose.state", "Choose State") + ": ");
		subTotalMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.subtotal", "Sub Total") + ": ");
		taxMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.tax", "Tax") + ": ");
		shippingMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.shipping", "Shipping") + ": ");
		taxShippingMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.tax.shipping", "Shipping") + ": ");
		totalMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.total", "Total") + ": ");
		chkoutBt.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.checkout", "Checkout"));
		chkoutBt.setBackgroundDrawable(gradienatCheckoutBtnDrawable);
	}

	/**
	 * Method is used to fetch and create dropdown for countries and state for
	 * shipping. 
	 * @param territoryVO
	 */
	public void getCountryData(ArrayList<TerritoryVO> territoryVO) {
		if (MobicartCommonData.shippingObj != null
				|| MobicartCommonData.taxObj != null) {
			countries.clear();
			countries = getCountryNState.GetDCountryInfo();
			if (countries.size() > 0) {
				cAdapter = new ArrayAdapter<String>(CartAct.this,
						android.R.layout.simple_spinner_item, countries);
				cAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
			}
		} else {
			countryStateNotAvaliable.add("  -  ");
			cAdapter = new ArrayAdapter<String>(CartAct.this,
					android.R.layout.simple_spinner_item,
					countryStateNotAvaliable);
			cAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		}
		countrySpinner.setPrompt(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.choosecountry", "Choose Country"));
		countrySpinner.setAdapter(cAdapter);
		countrySpinner.setPadding(10, 0, 30, 0);
		if (MobicartCommonData.objAccountVO.get_id() > 0) {
			if (countries.contains(MobicartCommonData.objAccountVO
					.getsDeliveryCountry())) {
				countrySpinner.setSelection(countries
						.indexOf(MobicartCommonData.objAccountVO
								.getsDeliveryCountry()));
				countrySelected = MobicartCommonData.objAccountVO
						.getsDeliveryCountry();
			}
		} else {
			if (countries.contains(MobicartCommonData.storeVO
					.getTerritoryName())) {
				countrySpinner
						.setSelection(countries
								.indexOf(MobicartCommonData.storeVO
										.getTerritoryName()));
			}
		}
	}

	@Override
	public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2,
			long arg3) {
		final ProgressDialog dialog = new ProgressDialog(getParent());
		dialog.setCancelable(false);
		dialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", "Loading...") + "...");
		dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		dialog.show();
		Handler handlerTh = new Handler();

		handlerTh.postDelayed(new Runnable() {

			@Override
			public void run() {
				countrySelected = (String) countrySpinner.getSelectedItem();
				territoryId = getCountryNState.checkId(countrySelected);
				countryId = territoryId;

				statesAL.clear();
				statesAL = getCountryNState.getDStateByCountryId(territoryId);

				sAdapter = new ArrayAdapter<String>(
						CartAct.this,
						android.R.layout.simple_spinner_item,
						MobicartCommonData.shippingObj == null
								&& MobicartCommonData.taxObj == null ? countryStateNotAvaliable
								: statesAL);
				sAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
				stateSpinner
						.setPrompt(MobicartCommonData.keyValues.getString(
								"key.iphone.shoppingcart.choose.state",
								"Choose State"));
				stateSpinner.setAdapter(sAdapter);
				stateSpinner.setPadding(10, 0, 30, 0);
				if (MobicartCommonData.objAccountVO.get_id() > 0) {
					if (statesAL.contains(MobicartCommonData.objAccountVO
							.getsDeliveryState())) {
						stateSpinner.setSelection(statesAL
								.indexOf(MobicartCommonData.objAccountVO
										.getsDeliveryState()));
						stateSelected = MobicartCommonData.objAccountVO
								.getsDeliveryState();
					}
				} else {
					if (MobicartCommonData.storeVO.getTaxList() != null) {
						for (int pos = 0; pos < MobicartCommonData.storeVO
								.getTaxList().size(); pos++) {
							if (MobicartCommonData.storeVO.getTaxList()
									.get(pos).getsState()
									.equalsIgnoreCase("Other"))
								if (statesAL
										.contains(MobicartCommonData.storeVO
												.getTaxList().get(pos)
												.getsState()))
									stateSpinner.setSelection(statesAL
											.indexOf(MobicartCommonData.storeVO
													.getTaxList().get(pos)
													.getsState()));
						}
					}
				}
				stateSelected = (String) stateSpinner.getSelectedItem();
				try {
					dialog.cancel();
				} catch (Exception e) {
					dialog.cancel();
				}
			}
		}, 2000);
	}

	@Override
	public void onNothingSelected(AdapterView<?> arg0) {
	}

	/**
	 * Method is used to calculate Tax depending upon Country and state selected
	 * by user.
	 * 
	 * @param cId
	 * @param sId
	 */
	public static float getTaxTV(int cId, int sId, double subTotal) {
		Tax tax = new Tax();
		TaxVO taxStoreCountryState = new TaxVO();
		double t = 0;
		if (MobicartCommonData.storeVO.isbIncludeTax()) {
			try {
				taxStoreCountryState = tax.findTaxByCountryStateStore(
						MobicartCommonData.appIdentifierObj.getStoreId(), cId,
						sId);

			} catch (NullPointerException e) {
				return 0;
			} catch (JSONException e) {
				return 0;
			}
			t = taxStoreCountryState.getfTax();
			t = (subTotal * taxStoreCountryState.getfTax()) / 100.0;
		}
		return (float) t;
	}

	/**
	 * Method is used to calculate Shipping Tax depending upon Country and state
	 * selected by user.
	 * 
	 * @param cId
	 * @param sId
	 * @return
	 */
	public float getShippingTaxTV(int cId, int sId, double shipping2) {
		TaxShipping tax = new TaxShipping();
		TaxShippingVO taxStoreCountryState = new TaxShippingVO();
		if (MobicartCommonData.storeVO.isbIncludeTax()) {
			try {
				taxStoreCountryState = tax.findTaxShippingByCountryStateStore(
						CartAct.this,
						MobicartCommonData.appIdentifierObj.getStoreId(), cId,
						sId);

			} catch (NullPointerException e) {
				showServerError();
				return 0;
			} catch (JSONException e) {
				showServerError();
				return 0;
			} catch (CustomException e) {
				showNetworkError();
				return 0;
			} catch (Exception e) {
				showServerError();
				return 0;
			}
			return (float) (taxStoreCountryState.getTaxVO().getfTax()
					* (shipping2) / 100.0);
		} else {
			return 0;
		}
	}

	/**
	 * This Method is used to show Server Errors.
	 */
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(CartAct.this)
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
						CartAct.this.startActivity(intent);
						CartAct.this.finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * Method is used to calculate Shipping depending upon Country and state
	 * selected by user.
	 * 
	 * @param cId
	 * @param sId
	 * @return
	 */
	public float getShippingTV(int cId, int sId) {
		Shipping tax = new Shipping();
		ShippingVO taxStoreCountryState = new ShippingVO();
		float sTax = 0;
		try {
			taxStoreCountryState = tax.findShippingByCountryStateStore(
					CartAct.this,
					MobicartCommonData.appIdentifierObj.getStoreId(), cId, sId);

		} catch (NullPointerException e) {
			showServerError();
		} catch (JSONException e) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
		if (CartItemCount.getCartCount(this) == 0) {
			sTax = 0;
		} else if (CartItemCount.getCartCount(this) > 1
				|| MobicartCommonData.objCartList.get(0).getQuantity() > 1) {
			sTax = taxStoreCountryState.getfOther();
		} else {

			sTax = taxStoreCountryState.getfAlone();
		}
		return sTax;
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	@Override
	protected void onStop() {
		cartButton.setGravity(Gravity.RIGHT);
		if (MobicartUrlConstants.resolution == 3)
			cartButton.setPadding(0, 6, 14, 0);
		else
			cartButton.setPadding(0, 7, 18, 0);
		super.onStop();
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		cartEditBtn.setVisibility(View.VISIBLE);
		cartButton.setVisibility(View.GONE);
		cartButton.setText("" + CartItemCount.getCartCount(this));
		cartButton.setGravity(Gravity.RIGHT);
		if (MobicartUrlConstants.resolution == 3)
			cartButton.setPadding(0, 6, 14, 0);
		else
			cartButton.setPadding(0, 7, 18, 0);
		backBtn.setVisibility(View.GONE);
		cartButtonMode = CART_BUTTON_MODE_CART;
		cartButtonMode = CART_BUTTON_MODE_DONE;
		chkoutBt.setOnClickListener(this);
		cartButton.setBackgroundResource(R.drawable.cart_icon_selector);
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		cartEditBtn.setVisibility(View.VISIBLE);
		cartEditBtn.setText("" + CartItemCount.getCartCount(this));
		cartButton.setVisibility(View.GONE);
		if (parentAct.equalsIgnoreCase("0")) {
			backBtn.setVisibility(View.INVISIBLE);
		} else if (parentAct.equalsIgnoreCase("6")) {
			backBtn.setVisibility(View.INVISIBLE);
		} else if (parentAct.equalsIgnoreCase("5")) {
			backBtn.setVisibility(View.VISIBLE);
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.more", "More"));
		} else if (parentAct.equalsIgnoreCase("4")) {
			backBtn.setVisibility(View.VISIBLE);
			backBtn.setBackgroundResource(R.drawable.account_btn_bg);
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.account", "Account"));
		} else if (parentAct.equalsIgnoreCase("3")) {
			backBtn.setVisibility(View.VISIBLE);
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.News", "News"));
		} else if (parentAct.equalsIgnoreCase("2")) {
			backBtn.setVisibility(View.VISIBLE);
			backBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.department.store", "Store"));
		}
		cartButton.setText("" + CartItemCount.getCartCount(this));
		cartButton.setGravity(Gravity.RIGHT);
		if (MobicartUrlConstants.resolution == 3) {
			cartButton.setPadding(0, 4, 12, 0);
		} else {
			cartButton.setPadding(0, 7, 18, 0);
		}
		cartButtonMode = CART_BUTTON_MODE_DONE;
		cartButton.setBackgroundResource(R.drawable.cart_icon_selector);
		super.onDestroy();
	}

	@Override
	protected void onResume() {
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setOnClickListener(this);
		cartEditBtn.setVisibility(View.GONE);
		cartButton.setVisibility(View.VISIBLE);
		cartButton.setGravity(Gravity.CENTER);
		cartButton.setPadding(0, 0, 0, 0);
		cartButtonMode = CART_BUTTON_MODE_DONE;
		if (cartButtonMode == CART_BUTTON_MODE_EDIT) {
			doEditButtonWork();
		} else if (cartButtonMode == CART_BUTTON_MODE_DONE) {
			doDoneButtonWork();
		}
		cartButton.setBackgroundResource(R.drawable.button_without_color);
		cartButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (cartButtonMode == CART_BUTTON_MODE_EDIT) {
					doEditButtonWork();
				} else if (cartButtonMode == CART_BUTTON_MODE_DONE) {
					doDoneButtonWork();
				}
			}
		});
		super.onResume();
	}

	@Override
	protected void onRestart() {
		super.onRestart();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.cartList_footer_checkout_Btn: {
			if (!countrySelected.equalsIgnoreCase("Not Available")) {
				if (MobicartCommonData.objAccountVO.get_id() > 0) {
					if (cartButtonMode != CART_BUTTON_MODE_DONE) {
						String backStr = backBtn.getText().toString();
						ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
						Intent intent = new Intent(getParent(),
								CheckoutAct.class);
						intent.putExtra("backString", backStr);
						intent.putExtra("subTotal",
								MobicartCommonData.objCostVO.actualSubTotal);
						intent.putExtra("Tax",
								MobicartCommonData.objCostVO.actualTax);
						intent.putExtra("Shipping",
								MobicartCommonData.objCostVO.actualShipping);
						intent.putExtra("ShippingTax",
								MobicartCommonData.objCostVO.actualShippingTax);
						intent.putExtra("GrandTotal",
								MobicartCommonData.objCostVO.actualGrandTotal);
						intent.putExtra("CountryName", countrySelected);
						intent.putExtra("StateName", stateSelected);
						intent.putExtra("CurrencySelected", currencySelected);
						parentActivity
								.startChildActivity("checkoutAct", intent);
					} else {
					}
				} else {
					requireFillDeatils();
				}
			} else {
				AlertDialog.Builder builder = new AlertDialog.Builder(
						getParent());
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
							public void onClick(DialogInterface dialog,
									int which) {
								dialog.cancel();
							}
						});
				builder.show();
			}
			break;
		}
		case R.id.universal_back_btn: {
			finish();
			break;
		}
		}
	}

	/**
	 * This Method is used to get Account Information from user by giving Alert
	 * for Login.
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
						intent.putExtra("IsFrom", "CartAct");
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
	 * Method is called when edit button is pressed by user on Cart Screen.
	 */
	private void doEditButtonWork() {
		cartButtonMode = CART_BUTTON_MODE_DONE;
		CartListAdapter cartListAdapter = new CartListAdapter(this,
				this.getParent(), MobicartCommonData.objCartList);
		cartLV.setAdapter(cartListAdapter);
		cartButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.done", "Done"));
	}

	/**
	 * Method is called when done button is pressed by user on Cart Screen.
	 */
	private void doDoneButtonWork() {
		cartButtonMode = CART_BUTTON_MODE_EDIT;
		MobicartCommonData.cartProductsList.clear();
		cartItem = (GetCartItemTask) new GetCartItemTask(this.getParent(),
				getParent(), cartLV).execute("");
		if (CartItemCount.getCartCount(this) == 0) {
			cartLV.removeFooterView(footerLayout);
			cartButton.setVisibility(View.GONE);
		}
		@SuppressWarnings("unused")
		GetCartFooterData getfooterTask = (GetCartFooterData) new GetCartFooterData()
				.execute("");
		cartButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.edit", "Edit"));
		cartButton.setGravity(Gravity.CENTER);
	}

	/**
	 * This class is used to add footer details to cart screen and refresh
	 * footer details.
	 * 
	 * @return
	 */
	public class GetCartFooterData extends AsyncTask<String, String, String> {
		public double sum = 0, disPrice = 0;
		boolean error = false;

		public GetCartFooterData() {
		}

		@Override
		protected String doInBackground(String... params) {
			if (!getTerritorySize()) {
				return "FALSE";
			} else {
				sum = getTotalPrice();
				return "TRUE";
			}
		}

		/**
		 * Method is used to check size of Territory Model Vo.
		 * 
		 * @return
		 */
		public boolean getTerritorySize() {
			if (MobicartCommonData.objAccountVO.get_id() > 0) {
				try {
					MobicartCommonData.territoryVO.size();
					return true;
				} catch (NullPointerException e) {
					return false;
				}
			} else {
				try {
					MobicartCommonData.territoryVO.size();
					return true;
				} catch (NullPointerException e1) {
					return false;
				}
			}
		}

		/**
		 * This Method is used to calculate Total Price for all products added
		 * in cart including tax,shipping and shipping tax.
		 * 
		 * @return
		 */
		public double getTotalPrice() {
			double sum = 0;

			actualPrice = 0;
			if (MobicartCommonData.objCartList != null) {
				for (int i = 0; i < MobicartCommonData.objCartList.size(); i++) {
					fPrice = 0.0;
					int GetProductId = MobicartCommonData.objCartList.get(i)
							.getProductId();
					Product product = new Product();
					ProductVO cartProduct = new ProductVO();
					try {
						cartProduct = product.getProductDetails(CartAct.this,
								GetProductId);
						if ((!cartProduct.getsStatus().equals("active"))
								|| (cartProduct.getiAggregateQuantity() == 0)) {
							if (cartProduct.getProductOptions() == null
									&& cartProduct.getProductOptions().size() <= 0)
								continue;
						}
						Double finalPrice;
						finalPrice = ProductTax
								.calculateFinalPriceByUserLocation(cartProduct);
						finalPrice = finalPrice
								* MobicartCommonData.objCartList.get(i)
										.getQuantity();
						String[] optionIDList = null;
						if (MobicartCommonData.objCartList.get(i)
								.getProductOptionId() != null) {
							optionIDList = MobicartCommonData.objCartList
									.get(i).getProductOptionId().split(",");
						}
						if (cartProduct.getProductOptions() != null
								&& optionIDList != null) {

							for (int j = 0; j < cartProduct.getProductOptions()
									.size(); j++) {

								for (int k = 0; k < optionIDList.length; k++) {

									if ((float) Double
											.parseDouble(optionIDList[k]) == cartProduct
											.getProductOptions().get(j).getId()) {
										fPrice = fPrice
												+ (double) cartProduct
														.getProductOptions()
														.get(j).getsPrice();
									}
								}
							}
						}

						else {
							fPrice = 0.0;
						}
						if (cartProduct.getfDiscountedPrice() != 0) {
							sum = sum
									+ +cartProduct.getfDiscountedPrice()
									* MobicartCommonData.objCartList.get(i)
											.getQuantity();
							actualPrice = actualPrice
									+ +(cartProduct.getfDiscountedPrice() + fPrice)
									* MobicartCommonData.objCartList.get(i)
											.getQuantity();
						} else {
							sum = sum
									+ cartProduct.getfPrice()
									* MobicartCommonData.objCartList.get(i)
											.getQuantity();
							actualPrice = actualPrice
									+ (cartProduct.getfPrice() * fPrice)
									* MobicartCommonData.objCartList.get(i)
											.getQuantity();
						}

					} catch (NullPointerException e1) {
						error = true;
					} catch (JSONException e1) {
						error = true;
					} catch (CustomException e) {
						isNetworkNotAvailable = true;
						error = false;
					}
				}
			}
			return sum;
		}

		@Override
		protected void onPostExecute(String result) {
			if (error == false) {
				if (isNetworkNotAvailable)
					showNetworkError();
				else {
					subTotalTV.setText(MobicartCommonData.currencySymbol
							+ String.format("%.2f", actualPrice));
					subTotal = sum;
					getCountryData(MobicartCommonData.territoryVO);
				}
			}
			CartAct.this.handler.sendEmptyMessage(0);
			super.onPostExecute(result);
		}
	}
}