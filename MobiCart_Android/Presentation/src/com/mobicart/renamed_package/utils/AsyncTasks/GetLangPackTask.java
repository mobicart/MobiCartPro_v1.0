package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.widget.Toast;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.Labels;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.TabHostAct;

/**
 * @author mobicart
 * 
 */
public class GetLangPackTask extends AsyncTask<String, String, String> {

	private Activity activity;
	private String timestamp = "";
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * 
	 * @param activity
	 */
	public GetLangPackTask(Activity activity) {
		this.activity = activity;
	}

	/**
	 * 
	 * @param activity2
	 * @param TimeStamp
	 */
	public GetLangPackTask(Activity activity2, String TimeStamp) {
		this.activity = activity2;
		this.timestamp = TimeStamp;
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
	}

	@Override
	protected String doInBackground(String... params) {
		if (timestamp.equalsIgnoreCase("")) {
			if (!getLangPack()) {
				return "FALSE";
			} else {
				fillSharedPreferences();
				return "TRUE";
			}
		} else {
			if (!chkLangPackWithTimeStamp()) {
				return "FALSE";
			} else {
				return "TRUE";
			}
		}
	}

	private boolean chkLangPackWithTimeStamp() {
		Labels labels = new Labels();
		timestamp = timestamp.trim();
		if (timestamp.contains(" ")) {
			timestamp = timestamp.replaceAll(" ", "%20");
		}
		Boolean timeStampLabel = false;
		try {
			timeStampLabel = labels.getLablesByMerchantIdAndTimeStamp(activity,
					MobicartCommonData.appIdentifierObj.getUserId(), timestamp);
			if (timeStampLabel.booleanValue() == true) {
			} else {
				getLangPack();
				fillSharedPreferences();
			}
			return true;
		} catch (NullPointerException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			return false;
		} catch (JSONException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			return false;
		} catch (CustomException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			isNetworkNotAvailable = true;
			return false;
		}
	}

	private boolean getLangPack() {
		Labels labels = new Labels();
		try {
			MobicartCommonData.labelsVO = labels.getLablesByMerchantId(
					activity, MobicartCommonData.appIdentifierObj.getUserId());
			return true;
		} catch (JSONException e) {
			return false;
		} catch (NullPointerException e) {
			return false;
		} catch (CustomException e) {
			isNetworkNotAvailable = true;
			return false;
		}
	}

	private void fillSharedPreferences() {
		MobicartCommonData.keyValues = activity.getSharedPreferences(
				"KeyValue", Context.MODE_PRIVATE);
		SharedPreferences.Editor keyValuesEditor = MobicartCommonData.keyValues
				.edit();
		keyValuesEditor.putString("filled", "True");
		keyValuesEditor.putString("key.iphone.checkout.paypal",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutPaypal());
		keyValuesEditor.putString("key.iphone.signup.billing",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupBilling());
		keyValuesEditor.putString("key.iphone.paypaltokenmsg",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphonePaypalTokenMsg());
		keyValuesEditor.putString("key.iphone.createaccount.update",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCreateaccountUpdate());
		keyValuesEditor.putString("key.iphone.reviews.reviews",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReviewsReviews());
		keyValuesEditor.putString("key.iphone.more.delivery",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMoreDelivery());
		keyValuesEditor.putString("key.iphone.product.alreadyadded.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductAlreadyaddedText());
		keyValuesEditor.putString("key.iphone.wishlist.comming.soon",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneWishlistCommingSoon());
		keyValuesEditor.putString("key.iphone.signup.email",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupEmail());
		keyValuesEditor.putString("key.iphone.wishlist.wishlist",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneWishlistWishlist());
		keyValuesEditor.putString("key.iphone.account.info",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneAccountInfo());
		keyValuesEditor.putString("key.iphone.server.notresp.title.error",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneServerNotRespTitleError());
		keyValuesEditor.putString("key.iphone.nostate.avail.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNoStateAvailText());
		keyValuesEditor.putString("key.iphone.tabbar.home",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTabBarHome());
		keyValuesEditor.putString("key.iphone.nointernet.cancelbutton",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNoInternetCancelbutton());
		keyValuesEditor.putString("key.iphone.textfield.notempty.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTextFieldNotEmptyText());
		keyValuesEditor.putString("key.iphone.order.completed.sucess.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderCompletedSucessText());
		keyValuesEditor.putString("key.iphone.checkout.ccv",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutCcv());
		keyValuesEditor.putString("key.iphone.signup.password",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupPassword());
		keyValuesEditor.putString("key.iphone.loginto.account",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneLoginToAccount());
		keyValuesEditor.putString("key.iphone.contactus.telephone",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneContactUsTelephone());
		keyValuesEditor.putString("key.iphone.contactus.account",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneContactUsAccount());
		keyValuesEditor.putString("key.iphone.order.completed.sucess.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderCompletedSucessTitle());
		keyValuesEditor.putString("key.iphone.checkout.checkout",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutCheckout());
		keyValuesEditor.putString("key.iphone.mainproduct.watchvideo",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainProductWatchVideo());
		keyValuesEditor
				.putString("key.iphone.cancel", MobicartCommonData.labelsVO
						.getLabelsMap().getKeyIphoneCancel());
		keyValuesEditor.putString("key.iphone.selectopt.product.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSelectoptProductText());
		keyValuesEditor.putString("key.iphone.productlist.status",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductListStatus());
		keyValuesEditor.putString("key.iphone.myaccount.logout",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMyAccountLogout());
		keyValuesEditor.putString("key.iphone.postreview.postreview",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphonePostReviewPostReview());
		keyValuesEditor.putString("key.iphone.aboutus.aboutus",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneAboutUsAboutUs());
		keyValuesEditor.putString("key.iphone.more.aboutus",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMoreAboutUs());
		keyValuesEditor.putString("key.iphone.account.notfound.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneAccountNotFoundText());
		keyValuesEditor.putString("key.iphone.checkout.paywithcc",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutPayWithCc());
		keyValuesEditor.putString("key.iphone.shoppingcart.total",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartTotal());
		keyValuesEditor.putString("key.iphone.signup.deliveryaddr",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignUpDeliveryAddr());
		keyValuesEditor.putString("key.iphone.mainproduct.sendtofriend",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainProductSendToFriend());
		keyValuesEditor.putString("key.iphone.signup.submit",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupSubmit());
		keyValuesEditor.putString("key.iphone.checkout.cardnumber",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutCardNumber());
		keyValuesEditor.putString("key.iphone.postreview.rateit",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphonePostRreviewRateIt());
		keyValuesEditor.putString("key.iphone.info.update.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneInfoUpdateText());
		keyValuesEditor.putString("key.iphone.error.loading.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneErrorLoadingTitle());
		keyValuesEditor.putString("key.iphone.order.cancel.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderCancelTitle());
		keyValuesEditor.putString("key.iphone.checkout.expirydate",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutExpiryDate());
		keyValuesEditor.putString("key.iphone.checkout.pay",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutPay());
		keyValuesEditor.putString("key.iphone.checkout.total",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutTotal());
		keyValuesEditor.putString("key.iphone.signup.zip",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupZip());
		keyValuesEditor.putString("key.iphone.checkout.name",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutName());
		keyValuesEditor.putString("key.iphone.shoppingcart.edit",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingcartEdit());
		keyValuesEditor.putString("key.iphone.must.login",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMustLogin());
		keyValuesEditor.putString("key.iphone.mainproduct.selectoption",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainproductSelectOption());
		keyValuesEditor.putString("key.iphone.department.selectdepartment",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneDepartmentSelectDepartment());
		keyValuesEditor.putString("key.iphone.signup.state",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupState());
		keyValuesEditor.putString("key.iphone.tabbar.account",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTabBarAccount());
		keyValuesEditor.putString("key.iphone.nointernet.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNoInternetTitle());
		keyValuesEditor.putString("key.iphone.contactus.address",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneContactUsAddress());
		keyValuesEditor.putString("key.iphone.mainproduct.postreview",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainProductPostReview());
		keyValuesEditor.putString("key.iphone.wishlist.soldout",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneWishlistSoldOut());
		keyValuesEditor.putString("key.iphone.review.rating.posted.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReviewRatingPostedTitle());
		keyValuesEditor.putString("key.iphone.mainproduct.reviews",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainproductReviews());
		keyValuesEditor.putString("key.iphone.contactus.contactus",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneContactUsContactUs());
		keyValuesEditor.putString("key.iphone.order.cancel.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderCancelText());
		keyValuesEditor.putString("key.iphone.myaccount.myaccount",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMyAccountMyAccount());
		keyValuesEditor.putString("key.iphone.shoppingcart.promocode",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartPromoCode());
		keyValuesEditor.putString("key.iphone.checkout.qty",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutQty());
		keyValuesEditor.putString("key.iphone.signup.city",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupCity());
		keyValuesEditor.putString("key.iphone.more.contactus",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMoreContactUs());
		keyValuesEditor.putString("key.iphone.myaccount.wishlist",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMyAccountWishlist());
		keyValuesEditor.putString("key.iphone.productlist.sortby",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductListSortBy());
		keyValuesEditor.putString("key.iphone.department.store",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneDepartmentStore());
		keyValuesEditor.putString("key.iphone.shoppingcart.qty",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingcartQty());
		keyValuesEditor.putString("key.iphone.postreview.review",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphonePostreviewReview());
		keyValuesEditor.putString("key.iphone.password.notcorrect.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphonePasswordNotCorrectText());
		keyValuesEditor.putString("key.iphone.shoppingcart.yourcart",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartYourCart());
		keyValuesEditor.putString("key.iphone.more.tandc",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMoreTandC());
		keyValuesEditor.putString("key.iphone.shoppingcart.tax.shipping",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartTaxShipping());
		keyValuesEditor.putString("key.iphone.checkout.selectcard",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutSelectCard());
		keyValuesEditor.putString("key.iphone.news.twitter",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNewsTwitter());
		keyValuesEditor.putString("key.iphone.common.search",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCommonSearch());
		keyValuesEditor.putString("key.iphone.createaccount.edit",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCreateAccountEdit());
		keyValuesEditor.putString("key.iphone.shoppingcart.shipping",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartShipping());
		keyValuesEditor.putString("key.iphone.shoppingcart.done",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartDone());
		keyValuesEditor.putString("key.iphone.server.notresp.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneServerNotRespText());
		keyValuesEditor.putString("key.iphone.mainproduct.soldout",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainProductSoldOut());
		keyValuesEditor.putString("key.iphone.tabbar.store",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTabBarStore());
		keyValuesEditor.putString("key.iphone.news.news",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNewsNews());
		keyValuesEditor.putString("key.iphone.nocountry.avail.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNoCountryAvailText());
		keyValuesEditor.putString("key.iphone.mainproduct.addwishlist",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainProductAddWishlist());
		keyValuesEditor.putString("key.iphone.nointernet.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNoInternetText());
		keyValuesEditor.putString("key.iphone.email.already.exists.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneEmailAlreadyExistsText());
		keyValuesEditor.putString("key.iphone.shoppingcart.choosecountry",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartChooseCountry());
		keyValuesEditor.putString("key.iphone.signup.daddr",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupDaddr());
		keyValuesEditor.putString("key.iphone.productlist.price",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductListPrice());
		keyValuesEditor.putString("key.iphone.tapscreen.keyboard.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTapScreenKeyboardText());
		keyValuesEditor.putString("key.iphone.checkout.issuenumber",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutIssueNumber());
		keyValuesEditor.putString("key.iphone.more.privacy",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMorePrivacy());
		keyValuesEditor.putString("key.iphone.mainproduct.addtocart",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMainProductAddToCart());
		keyValuesEditor.putString("key.iphone.tapscreen.keyboard.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTapScreenKeyboardTitle());
		keyValuesEditor.putString("key.iphone.reviews.writereview",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReviewsWriteReview());
		keyValuesEditor.putString("key.iphone.checkout.or",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutOr());
		keyValuesEditor.putString("key.iphone.invalid.email.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneInvalidEmailText());
		keyValuesEditor.putString("key.iphone.review.rating.posted.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReviewRatingPostedText());
		keyValuesEditor.putString("key.iphone.create.account",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCreateAccount());
		keyValuesEditor.putString("key.iphone.checkout.options",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutOptions());
		keyValuesEditor.putString("key.iphone.shoppingcart.delivery.add",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingcartDeliveryAdd());
		keyValuesEditor.putString("key.iphone.shoppingcart.subtotal",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingcartSubtotal());
		keyValuesEditor.putString("key.iphone.wishlist.instock",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneWishlistInStock());
		keyValuesEditor.putString("key.iphone.tabbar.news",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTabbarNews());
		keyValuesEditor.putString("key.iphone.checkout.totalcost",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutTotalCost());
		keyValuesEditor.putString("key.iphone.shoppingcart.checkout",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartCheckout());
		keyValuesEditor.putString("key.iphone.checkout.nameoncard",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutNameOnCard());
		keyValuesEditor.putString("key.iphone.checkout.country",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutCountry());
		keyValuesEditor.putString("key.iphone.info.update.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneInfoUpdateTitle());
		keyValuesEditor.putString("key.iphone.confirm.pass.notmatch.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneConfirmPassNotMatchText());
		keyValuesEditor.putString("key.iphone.shoppingcart.select.category",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingcartSelectCategory());
		keyValuesEditor.putString("key.iphone.signup.country",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupCountry());
		keyValuesEditor.putString("key.iphone.selectopt.product.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSelectOptProductTitle());
		keyValuesEditor.putString("key.iphone.order.failed.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderFailedTitle());
		keyValuesEditor.putString("key.iphone.login.sucess.title",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneLoginSucessTitle());
		keyValuesEditor.putString("key.iphone.productlist.atoz",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductListAtoZ());
		keyValuesEditor.putString("key.iphone.shoppingcart.tax",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartTax());
		keyValuesEditor.putString("key.iphone.signup.street",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupStreet());
		keyValuesEditor.putString("key.iphone.checkout.sub-total",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutSubTotal());
		keyValuesEditor.putString("key.iphone.myaccount.orderhistory",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneMyAccountOrderHistory());
		keyValuesEditor.putString("key.iphone.tabbar.more",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneTabBarMore());
		keyValuesEditor.putString("key.iphone.checkout.startdate",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCheckoutStartDate());
		keyValuesEditor.putString("key.iphone.order.failed.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderFailedText());
		keyValuesEditor.putString("key.iphone.login.sucess.text",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneLoginSucessText());
		keyValuesEditor.putString("key.iphone.signup.name",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupName());
		keyValuesEditor.putString("key.iphone.shoppingcart.choose.state",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartChooseState());
		keyValuesEditor.putString("key.iphone.signup.signup",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupSignup());
		keyValuesEditor.putString("key.iphone.signup.confirm",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneSignupConfirm());
		keyValuesEditor.putString("key.iphone.read.reviews.no.review",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReadReviewsNoReview());
		keyValuesEditor.putString("key.iphone.home.back",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneHomeBack());
		keyValuesEditor.putString("key.iphone.details.view.login",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneDetailsViewLogin());
		keyValuesEditor.putString("key.iphone.product.detail.already.added",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailAlreadyAdded());
		keyValuesEditor.putString("key.iphone.global.search.result",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneGlobalSearchResult());
		keyValuesEditor.putString("key.iphone.shopping.cart.edit.cart",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartEditCart());
		keyValuesEditor.putString("key.iphone.order.history.order",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderHistoryOrder());
		keyValuesEditor.putString("key.iphone.order.history.status",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderHistoryStatus());
		keyValuesEditor.putString("key.iphone.product.detail.add.wishlist",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailAddWishlist());
		keyValuesEditor.putString("key.iphone.store.tab.department",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneStoreTabDepartment());
		keyValuesEditor.putString("key.iphone.product.detail.product.on",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailProductOn());
		keyValuesEditor.putString("key.iphone.order.history.date",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderHistoryDate());
		keyValuesEditor.putString("key.iphone.product.detail.see.great",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailSeeGreat());
		keyValuesEditor.putString("key.iphone.store.tab.page",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneStoreTabPage());
		keyValuesEditor.putString("key.iphone.product.detail.no.image",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailNoImage());
		keyValuesEditor.putString("key.iphone.home.departments",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneHomeDepartments());
		keyValuesEditor.putString("key.iphone.product.detail.thank.you",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailThankYou());
		keyValuesEditor.putString("key.iphone.product.detail.email.sent",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailEmailSent());
		keyValuesEditor.putString("key.iphone.product.detail.hello",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailHello());
		keyValuesEditor.putString("key.iphone.read.reviews.customer",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReadReviewsCustomer());
		keyValuesEditor.putString("key.iphone.shopping.cart.register",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartRegister());
		keyValuesEditor.putString("key.iphone.order.history.order.total",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderHistoryOrderTotal());
		keyValuesEditor.putString("key.iphone.shopping.cart.order.tocheckout",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneShoppingCartOrderTocheckout());
		keyValuesEditor.putString("key.iphone.wishlist.remove.item",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneWishlistRemoveItem());
		keyValuesEditor.putString("key.iphone.home.try.later",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneHomeTryLater());
		keyValuesEditor.putString("key.iphone.store.tab.all",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneStoreTabAll());
		keyValuesEditor.putString("key.iphone.product.detail.mcommerce",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailMcommerce());
		keyValuesEditor.putString("key.iphone.details.view.account.created",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneDetailsViewAccountCreated());
		keyValuesEditor.putString("key.iphone.store.tab.of",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneStoreTabOf());
		keyValuesEditor.putString("key.iphone.read.reviews.your.name",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReadReviewsYourName());
		keyValuesEditor.putString("key.iphone.read.reviews.by",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneReadReviewsBy());
		keyValuesEditor.putString("key.iphone.product.detail.cannot.added",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneProductDetailCannotAdded());
		keyValuesEditor.putString("key.iphone.news.show.by",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNewsShowBy());
		keyValuesEditor.putString("TimeStamp", MobicartCommonData.labelsVO
				.getTimeStamp());

		keyValuesEditor.putString("key.iphone.OrderHistoryDialog",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneOrderHistoryDialog());
		keyValuesEditor.putString("key.iphone.AccountDetailValidation",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneAccountDetailValidation());
		keyValuesEditor.putString("key.iphone.NetworkProblem",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNetworkProblem());
		keyValuesEditor.putString("key.iphone.LoaderText",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneLoaderText());
		keyValuesEditor.putString("key.iphone.NoProductMessage",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneNoProductMessage());
		keyValuesEditor.putString("key.iphone.CashOnDelivery",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneCashOnDelivery());
		keyValuesEditor.putString(
				"key.application.appearance.staticpages.page1",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneStaticpagesPage1());
		keyValuesEditor.putString(
				"key.application.appearance.staticpages.page2",
				MobicartCommonData.labelsVO.getLabelsMap()
						.getKeyIphoneStaticpagesPage2());
		keyValuesEditor.commit();
	}

	@Override
	protected void onPostExecute(String result) {
		if (result.equalsIgnoreCase("FALSE")) {
			if (isNetworkNotAvailable)
				showNetworkError();
			else
				showServerError();
		} else {
			activity.startActivity(new Intent(activity, TabHostAct.class));
		}
		super.onPostExecute(result);
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(this.activity)
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
						activity.startActivity(intent);
						activity.finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(this.activity)
				.create();
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
	protected void onProgressUpdate(String... values) {
		super.onProgressUpdate(values);
	}

	@Override
	protected void onPreExecute() {
		Toast.makeText(
				activity,
				MobicartCommonData.keyValues.getString(
						"key.iphone.NetworkProblem", "Connecting To Network"),
				Toast.LENGTH_LONG).show();
		super.onPreExecute();
	}
}
