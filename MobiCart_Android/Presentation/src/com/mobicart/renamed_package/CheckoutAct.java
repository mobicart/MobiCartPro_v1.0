package com.mobicart.renamed_package;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.json.JSONException;
import org.json.JSONObject;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.ProductOrder;
import com.mobicart.android.core.ProductOrderItem;
import com.mobicart.android.model.AccountVO;
import com.mobicart.android.model.CartItemVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.AsyncTasks.GetCheckoutCartItemTask;
import com.mobicart.renamed_package.utils.adapters.CheckoutListAdapter;
import com.mobicart.renamed_package.R;
import com.zooz.android.lib.CheckoutActivity;
import com.zooz.android.lib.model.TrxItems;

/**
 * This Activity Class contains detail of all products added to cart by user and
 * used to checkout by initialising zooz Lib.
 * 
 * @author mobicart
 * 
 */

public class CheckoutAct extends Activity implements OnClickListener {

	private ListView checkoutLV;
	private MyCommonView backBtn, cartBtn, TitleTV, subTotalTV, taxTV,
			shippingTV, shippingTaxTV, grandTotalTV, cartEditBtn,payNow;
	private MyCommonView paypalCheckout, subTotalMV, taxMV, shippingMV,
			taxShippingMV, grandTotalMV, countryMV, stateMV, countrySelectedTV,
			stateSelectedTV;
	protected static final int INITIALIZE_SUCCESS = 0;
	protected static final int INITIALIZE_FAILURE = 1;
	private MyCommonView nameMV, qtyMV, optionsMV, totalCostMV;
	public static final String build = "10.12.09.8053";
	public static String resultTitle;
	public static String resultInfo;
	public static String resultExtra;
	public String sCurrencyCode, countrySelected, stateSelected, backStr;
	private boolean codEnabled=false;
	private ArrayList<CartItemVO> checkOutList;
	private double subTotal, tax, shippingTax, shipping, grandTotal;
	private DataBaseAccess objDataBaseAccess;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;
	public static boolean isCheckoutClicked=false,isBackPressed=false;
	private GradientDrawable gradienatCheckoutBtnDrawable;
	private AccountVO objAccountVO = new AccountVO();
	public static String[] optionDetail;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.checkout_layout);
		nameMV = (MyCommonView) findViewById(R.id.checkout_Name_TV);
		nameMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.name", "Name")
				+ ": ");
		qtyMV = (MyCommonView) findViewById(R.id.checkout_Qty_TV);
		qtyMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.qty", "Qty")
				+ ": ");
		totalCostMV = (MyCommonView) findViewById(R.id.checkout_totalCost_TV);
		totalCostMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.totalcost", "Total Cost")
				+ ": ");
		optionsMV = (MyCommonView) findViewById(R.id.checkout_Options_TV);
		optionsMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.options", "Options")
				+ ": ");
		gradienatCheckoutBtnDrawable = (GradientDrawable) this.getResources()
				.getDrawable(R.drawable.rounded_button);
		gradienatCheckoutBtnDrawable.setColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getThemeColor()));
		cartEditBtn = TabHostAct.prepareCartEditButton(this);
		cartEditBtn.setVisibility(View.INVISIBLE);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setVisibility(View.GONE);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setOnClickListener(this);
		Bundle extra = getIntent().getExtras();
		subTotal = extra.getDouble("subTotal");
		backStr = extra.getString("backString");
		tax = extra.getDouble("Tax");
		objDataBaseAccess = new DataBaseAccess(this);
		String sql = "Select * from tblAccountDetails where _id=1";
		objDataBaseAccess.GetRow(sql, objAccountVO);
		countrySelected = objAccountVO.getsDeliveryCountry();
		stateSelected = objAccountVO.getsDeliveryState();
		shipping = extra.getDouble("Shipping");
		shippingTax = extra.getDouble("ShippingTax");
		grandTotal = extra.getDouble("GrandTotal");
		checkoutLV = (ListView) findViewById(R.id.checkout_Items_LV);
		isCheckoutClicked=false;
		RelativeLayout CheckoutFooterLayout = (RelativeLayout) getParent()
				.getLayoutInflater().inflate(
						R.layout.checkout_list_footer_layout, null);
		checkoutLV.addFooterView(CheckoutFooterLayout);
		sCurrencyCode = MobicartCommonData.storeVO.getsCurrencyCode();

		subTotalMV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listSubTotal_TV);
		taxMV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listTax_TV);
		shippingMV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listShipping_TV);
		taxShippingMV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listShippingTax_TV);
		grandTotalMV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listTotal_TV);
		countryMV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_list_footer_chooseCountry_TV);
		stateMV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_list_footer_chooseState_TV);
		countrySelectedTV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_list_footer_country_TV);
		stateSelectedTV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_list_footer_state_TV);
		countryMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.country", "Country")
				+ ": ");
		stateMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.signup.state", "State")
				+ ": ");
		countrySelectedTV.setText("" + countrySelected);
		stateSelectedTV.setText("" + stateSelected);
		subTotalMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.sub-total", "Sub Total")
				+ ": ");
		taxMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.tax", "Tax")
				+ ": ");
		shippingMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.shipping", "Shipping")
				+ ": ");
		taxShippingMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.tax.shipping", "Tax Shipping")
				+ ": ");
		grandTotalMV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.total", "Total")
				+ ": ");
		subTotalTV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listSubTotalValue_TV);
		taxTV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listTaxValue_TV);
		shippingTV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listShipping_value_TV);
		shippingTaxTV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listShipingTaxValue_TV);
		grandTotalTV = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listTotalvalue_TV);
		
		subTotalTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", subTotal));
		taxTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", tax));
		shippingTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", shipping));
		shippingTaxTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", shippingTax));
		grandTotalTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", grandTotal));
		ImageView imageView = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);
		imageView.setImageDrawable(getResources().getDrawable(
				R.drawable.cart_image));
		TitleTV = (MyCommonView) findViewById(R.id.common_nav_bar_heading_TV);
	
		paypalCheckout = (MyCommonView) CheckoutFooterLayout
				.findViewById(R.id.checkout_listPayZooZ_Btn);
		payNow=(MyCommonView)CheckoutFooterLayout.findViewById(R.id.checkout_listPayCash_Btn);
		TitleTV.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.checkout", ""));
		GetCheckoutCartItemTask checkoutItem = new GetCheckoutCartItemTask(this
				.getParent(), checkoutLV);
		checkoutItem.execute("");
		checkOutList = objDataBaseAccess.GetRows("SELECT * from "
				+ CartItemVO.CART_TABLE_NAME, new CartItemVO());
		paypalCheckout.setBackgroundDrawable(gradienatCheckoutBtnDrawable);
		if(MobiCartConstantIds.PAYPAL_EMAIL_ID.equalsIgnoreCase(null)||MobiCartConstantIds.PAYPAL_EMAIL_ID.equalsIgnoreCase("")){
			paypalCheckout.setVisibility(View.GONE);
		}else
		{
			paypalCheckout.setVisibility(View.VISIBLE);
			paypalCheckout.setText(MobicartCommonData.keyValues.getString("key.iphone.PayWithPaypal","Pay by card/PayPal"));
			paypalCheckout.setOnClickListener(CheckoutAct.this);
		}
		if(!MobicartCommonData.storeVO.getbCOD()){
			payNow.setVisibility(View.GONE);
		}
		else
		{
			payNow.setVisibility(View.VISIBLE);
			payNow.setBackgroundDrawable(gradienatCheckoutBtnDrawable);
			payNow.setText(MobicartCommonData.keyValues.getString("key.iphone.CashOnDelivery","Pay by cash on delivery"));
			codEnabled=true;
			payNow.setOnClickListener(this);
		}
	}

	/**
	 * This Method is used to initialise paypal library.
	 */

	@Override
	protected void onRestart() {
		super.onRestart();
	}

	@Override
	protected void onDestroy() {
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText("" + backStr);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setVisibility(View.GONE);
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
		CartAct.cartButtonMode = CartAct.CART_BUTTON_MODE_EDIT;
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.universal_back_btn:
			finish();
			break;
		case R.id.checkout_listPayCash_Btn:
			 codEnabled=true;
        	 resultTitle = "SUCCESS";
        	 try {
				checkPaypalStatus();
			} catch (JSONException e) {
				//e.printStackTrace();
			}
			break;
		case R.id.checkout_listPayZooZ_Btn:
			codEnabled=false;
			payWithPaypal();
			break;
		default:
			break;
		}
	}
	
	private void payWithPaypal() {
		isCheckoutClicked=true;
		String appKey="null";
		String isSandBox="null";
		appKey=MobiCartConstantIds.PAYPAL_APP_ID;
		isSandBox=MobiCartConstantIds.PAYPAL_SERVER_MODE;
		ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
		Intent intent = new Intent(this, CheckoutActivity.class);
    		// supply app-key on the intent
    		intent.putExtra(CheckoutActivity.APP_KEY, appKey);
    		// supply transaction details (amount, currency)
    		intent.putExtra(CheckoutActivity.PAY_AMOUNT, grandTotal);
    		intent.putExtra(CheckoutActivity.FIRST_NAME, objAccountVO.getsUserName());
    		
    		TrxItems objTrxItems=new TrxItems();
    		
    		for (int iIndex = 0; iIndex <CheckoutListAdapter.checkOutList.size(); iIndex++) {
    			objTrxItems.addItem(CheckoutListAdapter.checkOutList.get(iIndex).getProductName(), (double)CheckoutListAdapter.checkOutList.get(iIndex).getQuantity(),CheckoutListAdapter.checkOutList.get(iIndex).getProductPrice(), String.valueOf(CheckoutListAdapter.checkOutList.get(iIndex).getProductId()),optionDetail[iIndex]);
    		}
    		intent.putExtra(CheckoutActivity.TRANSACTION_ITEMS, objTrxItems);
    		intent.putExtra(CheckoutActivity.EMAIL_ADDRESS,objAccountVO.geteMailAddress());
    		intent.putExtra(CheckoutActivity.CURRENCY_CODE, MobicartCommonData.storeVO.getsCurrencyCode());
    		// supply environment mode (sandbox or production)
    			if(isSandBox.equals("true")){
    		intent.putExtra(CheckoutActivity.IS_SANDBOX, false);}
    		else
    		intent.putExtra(CheckoutActivity.IS_SANDBOX, true);
    		// start CheckoutActivity and wait to the activity result.
    		parentActivity.startActivityForResult(intent,1);
   	}

	@SuppressLint("NewApi")
	@Override
	public void onBackPressed() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.GONE);
		backBtn.setText(backStr);
		finish();
		super.onBackPressed();
	}

	@Override
	protected void onPause() {
		isBackPressed=true;
		MobicartCommonData.isFromStart = "NotSplash";
		SharedPreferences prefs = getSharedPreferences("X", MODE_PRIVATE);
		Editor editor = prefs.edit();
		editor.putString("lastActivity", getClass().getName());
		editor.commit();
		super.onPause();
	}

	@Override
	protected void onResume() {
		isBackPressed=false;
		if(isCheckoutClicked){
		if(MobiCartConstantIds.ZOOZ_TRX_ID!=null){
			resultTitle = "SUCCESS";
			resultInfo = "You have successfully completed this ";
			resultExtra = "Transaction ID: "
					+MobiCartConstantIds.ZOOZ_TRX_ID;
			try {
				checkPaypalStatus();
			} catch (JSONException e) {
				e.printStackTrace();
			}
			MobiCartConstantIds.ZOOZ_TRX_ID=null;
		}else{
			resultTitle = "CANCELED";
			resultInfo = "The transaction has been cancelled.";
			resultExtra = "";
			try {
				checkPaypalStatus();
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		isCheckoutClicked=false;
		codEnabled=false;
		}
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
		backBtn.setOnClickListener(this);
		super.onResume();
	}

	/**
	 * This Method is used for Check Paypal status,transaction is completed
	 * successfully or not.
	 * 
	 * @throws JSONException
	 */
	private void checkPaypalStatus() throws JSONException {
		if (CheckoutAct.resultTitle.equalsIgnoreCase("SUCCESS")) {
			payPalStatusDailogOk();
		}
		if (CheckoutAct.resultTitle.equalsIgnoreCase("CANCELED")) {
			payPalStatusDailog();
		}
		if (CheckoutAct.resultTitle.equalsIgnoreCase("FAILURE")) {
			payPalStatusDailog();
		}
	}

	/**
	 * This method is used to send order to server by sending all Account
	 * information of user.
	 * 
	 * @throws JSONException
	 */
	private void sendPaypalStaus_toSever() throws JSONException {
		int merchantId = MobicartCommonData.appIdentifierObj.getUserId();
		double fTaxAmount, fShippingAmount, fTotalAmount, fAmount;
		objDataBaseAccess = new DataBaseAccess(CheckoutAct.this);

		String sBuyerName = objAccountVO.getsUserName();
		String sBuyerEmail = objAccountVO.geteMailAddress();
		String iBuyerPhone = null;
		String sShippingStreet = objAccountVO.getsDeliveryStreetAddress();
		String sShippingCity = objAccountVO.getsDeliveryCity();
		String sShippingCountry = objAccountVO.getsDeliveryCountry();
		String sShippingState = objAccountVO.getsDeliveryState();
		String sShippingPostalCode = objAccountVO.getsDeliveryPincode();
		String sBillingStreet = objAccountVO.getsStreetAddress();
		String sBillingState = objAccountVO.getsState();
		String sBillingCity = objAccountVO.getsCity();
		String sBillingPostalCode = objAccountVO.getsPincode();
		String sBillingCountry = objAccountVO.getsCountry();
		fTaxAmount = tax;
		fShippingAmount = shippingTax+shipping;
		fTotalAmount = grandTotal;
		fAmount = subTotal;
		long storeId = MobicartCommonData.appIdentifierObj.getStoreId();
		long appId = MobicartCommonData.appIdentifierObj.getAppId();
		String merchantemail = MobiCartConstantIds.PAYPAL_EMAIL_ID;
		ProductOrder productOrder = new ProductOrder();
		JSONObject OBj = new JSONObject();
		OBj.put("merchantId", merchantId);
		OBj.put("storeId", storeId);
		OBj.put("appId", appId);
		OBj.put("iBuyerPhone", iBuyerPhone);
		OBj.put("orderCurrency", MobicartCommonData.storeVO.getsCurrency());
		OBj.put("sShippingStreet", sShippingStreet);
		OBj.put("sShippingCity", sShippingCity);
		OBj.put("sShippingState", sShippingState);
		OBj.put("sShippingPostalCode", sShippingPostalCode);
		OBj.put("sBillingStreet", sBillingStreet);
		OBj.put("sBillingState", sBillingState);
		OBj.put("sBillingCity", sBillingCity);
		OBj.put("sBillingPostalCode", sBillingPostalCode);
		OBj.put("sBillingCountry", sBillingCountry);
		OBj.put("fTaxAmount", fTaxAmount);
		OBj.put("fShippingAmount", fShippingAmount);
		OBj.put("fTotalAmount", fTotalAmount);
		OBj.put("sBuyerName", sBuyerName);
		OBj.put("sMerchantPaypalEmail", merchantemail);
		OBj.put("sBuyerEmail", sBuyerEmail);
		OBj.put("fAmount", fAmount);
		OBj.put("sShippingCountry", sShippingCountry);
		OBj.put("codEnabled", codEnabled);
		int orderId;
		try {
			orderId = productOrder.postOrder(CheckoutAct.this, OBj.toString());
			if (orderId != 0) {
				sendOrederItemJson_toSever(orderId);
			}
		} catch (CustomException e) {
			showNetworkError();
		}
	}

	/**
	 * This Method is used for send order for multiple Items to server.
	 * 
	 * @param orderId2
	 * @throws JSONException
	 */
	private void sendOrederItemJson_toSever(int orderId2) throws JSONException {
		JSONObject OBj = null;
		for (int iIndex = 0; iIndex < checkOutList.size(); iIndex++) {
			OBj = new JSONObject();
			OBj.put("id", 0);
			OBj.put("orderId", orderId2);
			OBj.put("productId", checkOutList.get(iIndex).getProductId());
			OBj.put("fAmount", CheckoutListAdapter.finalPrice);
			OBj.put("iQuantity", checkOutList.get(iIndex).getQuantity());
			if (checkOutList.get(iIndex).getProductOptionId() == null) {
				OBj.put("productOptionId", "0");
			} else {
				OBj.put("productOptionId", checkOutList.get(iIndex)
						.getProductOptionId());
			}
			ProductOrderItem pOrderMultopleItem = new ProductOrderItem();
			try {
				pOrderMultopleItem.postOrderMultipleItem(CheckoutAct.this, OBj
						.toString());
			} catch (CustomException e) {
				showNetworkError();
			}
		}
		ProductOrderItem productOrderNotify = new ProductOrderItem();
		try {
			productOrderNotify.postOrderNotify(CheckoutAct.this, orderId2);
		} catch (CustomException e) {
			showNetworkError();
		} catch (Exception e) {
		}
		//showOrderStatusDialog();
	}

	/**
	 * This method shows Network related errors.
	 */
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(this).create();
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
						CheckoutAct.this.startActivity(intent);
						CheckoutAct.this.finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * This Class is used for sending order status to server in json form.
	 * @author rajni.johar
	 *
	 */
	public class SendStatusToServerTask extends AsyncTask<String, String, String> {
		private ProgressDialog progressDialog;
		private Activity currentactivity;
		
		public SendStatusToServerTask(Activity checkoutAct) {
			this.currentactivity=checkoutAct;
			progressDialog = new ProgressDialog(currentactivity.getParent());
			progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
			progressDialog.setMessage(MobicartCommonData.keyValues.getString(
					"key.iphone.LoaderText", ""));
			progressDialog.setCancelable(false);
		}

		@Override
		protected void onPreExecute() {
			progressDialog.show();
			super.onPreExecute();
		}
		@Override
		protected String doInBackground(String... params) {
			try {
				sendPaypalStaus_toSever();
			} catch (JSONException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
			}
			return null;
		}
		@Override
		protected void onPostExecute(String result) {
			progressDialog.dismiss();
			AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
			builder.setTitle(MobicartCommonData.keyValues.getString(
					"key.iphone.review.rating.posted.title", ""));
			builder.setMessage(MobicartCommonData.keyValues.getString(
					"key.iphone.order.completed.sucess.text", ""));
			builder.setCancelable(false).setPositiveButton(
					MobicartCommonData.keyValues.getString(
							"key.iphone.nointernet.cancelbutton", ""),
					new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							deleteCartItem();
							dialog.dismiss();
						}
					});
			builder.show();
			super.onPostExecute(result);
		}
	}

	/**
	 * This Method is used for displaying dialog to show paypal status.
	 */
	private void payPalStatusDailogOk() {
		@SuppressWarnings("unused")
		SendStatusToServerTask objSendStatusToServerTask = (SendStatusToServerTask) new SendStatusToServerTask(this)
		.execute("");
		
	}

	private void payPalStatusDailog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(getParent());
		builder.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.review.rating.posted.title", ""));
		builder.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.order.cancel.text", ""));
		builder.setCancelable(false).setPositiveButton(
				MobicartCommonData.keyValues.getString(
						"key.iphone.nointernet.cancelbutton", ""),
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						CheckoutAct.resultTitle = null;
					}
				});
		builder.show();
	}

	/**
	 * This method is used to delete cart table when order is successfully
	 * completed.
	 */
	private void deleteCartItem() {
		objDataBaseAccess.deleteCartTable();
		ArrayList<CartItemVO> cartItem = objDataBaseAccess
				.GetRows("SELECT * from " + CartItemVO.CART_TABLE_NAME,
						new CartItemVO());
		TabHostAct.cartItemsCounter = cartItem.size();
		CheckoutAct.resultTitle = null;
		ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
		Intent intent = new Intent(parentActivity.getApplicationContext(),
				StoreTabAct.class);
		intent.putExtra("cartsize", cartItem.size());
		intent.putExtra("isFromPayapl", "PayPal");
		parentActivity.startChildActivity("StoreTabAct", intent);
	}
}