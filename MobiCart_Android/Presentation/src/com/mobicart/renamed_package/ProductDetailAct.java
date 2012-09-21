package com.mobicart.renamed_package;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.json.JSONException;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.drawable.GradientDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.AdapterView.OnItemSelectedListener;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.core.Product;
import com.mobicart.android.model.CartItemVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductOptionVO;
import com.mobicart.android.model.ProductVO;
import com.mobicart.android.model.WishListVO;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.database.MobicartDbConstants;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.ImageLoader;
import com.mobicart.renamed_package.utils.LoaderImageView;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.ProductTax;
import com.mobicart.renamed_package.utils.SoundManager;
import com.mobicart.renamed_package.utils.adapters.CartListAdapter;
import com.mobicart.renamed_package.utils.adapters.DepartmentsListAdapter;
import com.mobicart.renamed_package.utils.coverflow.CoverFlowExample;

/**
 * This activity class is used for displaying Details of selected product.
 * 
 * @author mobicart
 * 
 */
@SuppressWarnings("unchecked")
public class ProductDetailAct extends Activity implements OnClickListener {

	@SuppressWarnings("unused")
	private String productName, pOptID, optionIdStr = "";
	private String option = "", status = null;
	private String pOptName = null;
	private String pOptTitle = null;
	private String WishlistOptionId = null;
	private int MaxAvlQty = -1, remainingQty = 0;
	private int productOption = 0;
	@SuppressWarnings("unused")
	private Double optionPrice = 0.0;
	private int qtyInCart = 0;
	private Double productPrice;
	private Double actualPrice;
	private ArrayList<ProductOptionVO> productOptions = null;
	private int currentProductPosition;
	private int WishlistId = 0;
	private int reviewSize, pOptAvailableQuantity = 0, selectedPosition;
	private int count, optionSize;
	private boolean AddWishlist = false;
	private static boolean fromFeature = false;
	private boolean backText = false;
	private static boolean fromWishlist = false;
	private boolean select = true, optionSelected = true, itemAdded = false;
	private MyCommonView backButton, postReviewBtn, addToCartBtn,
			productTextTV, productTitleTV, productPriceTV, cartBtn,
			actualPriceTV, actualPriceTaxTV, priceTaxTV;
	private MyCommonView sendToFriendBtn, addToWishListBtn, watchVideoBtn;
	private MyCommonView statusIV, cartEditBtn;
	private LoaderImageView productIV, productIVDummy;
	private Button zoomBtn;
	private SoundManager mSoundManager;
	private Spinner[] optionSpinner1;
	private ArrayList<ProductOptionVO> spinnerArray;
	private ArrayList<CartItemVO> cartListVO;
	private DataBaseAccess database;
	private ArrayAdapter<String> adapter;
	private WishListVO wishlistVO = new WishListVO();
	private CartItemVO cartlistItemVO;
	private GradientDrawable drawable;
	public static int finalPosition, finalOrder, currentProductId;
	public static float fAvRating;
	public static long iRating;
	private static String productOptionId;
	private static int productId = 0, GetProductId;
	private static ProductVO currentProduct;
	private Product objProduct;
	private static RatingBar ratingView;
	private static MyCommonView productReviewTV;
	private RelativeLayout imgRl = null;
	private ImageLoader imageLoader;
	private String currentStatus = null;
	private int optionsCount = 0;
	private int optionsInisializCount = 0;
	private boolean isAnyOneOptionsZero = false;
	private int productList_Id;
	private Double optionProductPrice = 0.0, optionActualPrice = 0.0;
	@SuppressWarnings("rawtypes")
	private HashMap productOptionsPrice = new HashMap();
	@SuppressWarnings("rawtypes")
	private HashMap<Integer, Integer> productOptionsQty = new HashMap();
	@SuppressWarnings({ "unused", "rawtypes" })
	private HashMap productOptionsId = new HashMap();
	private ProductOptionVO innerOptionVO = new ProductOptionVO();

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.product_detail_layout);
		cartEditBtn = TabHostAct.prepareCartEditButton(this);
		cartEditBtn.setVisibility(View.GONE);
		imageLoader = new ImageLoader(this.getApplicationContext());
		database = new DataBaseAccess(this);
		currentProductId = (int) getIntent().getLongExtra("productId", -1);
		currentProductPosition = getIntent().getIntExtra(
				"currentProductPosition", -1);
		Bundle extra = getIntent().getExtras();
		WishlistId = extra.getInt("ProductWishlistId");
		backText = extra.getBoolean("isFromWishlist");
		prepareViewControls();
		if (HomeTabAct.currentOrder == HomeTabAct.ORDER_PRODUCT_DETAIL) {
			int seclectedFeturedProductPosition = getIntent().getIntExtra(
					"seclectedFeturedProductPosition", -1);
			if (seclectedFeturedProductPosition != -1) {
				currentProduct = MobicartCommonData.featuredPrducts
						.get(seclectedFeturedProductPosition);
				productId = currentProduct.getId();
				objProduct = new Product();
				try {
					currentProduct = objProduct
							.getProductDetailsByCountryStateStore(
									ProductDetailAct.this, productId,
									MobicartCommonData.territoryId,
									MobicartCommonData.stateId);
				} catch (NullPointerException e) {
					showServerError();
				} catch (JSONException e) {
					showServerError();
				} catch (CustomException e) {
					showNetworkError();
				}
				HomeTabAct.currentOrder = 0;
				fromFeature = true;
				finalPosition = seclectedFeturedProductPosition;
				finalOrder = 1;
				fromWishlist = false;
			}
		} else {
			if (currentProductPosition != -1) {
				productList_Id = extra.getInt("productId");
				objProduct = new Product();
				try {
					currentProduct = objProduct
							.getProductDetailsByCountryStateStore(
									ProductDetailAct.this, productList_Id,
									MobicartCommonData.territoryId,
									MobicartCommonData.stateId);
				} catch (NullPointerException e) {
					showServerError();
				} catch (JSONException e) {
					showServerError();
				} catch (CustomException e) {
					showServerError();
				}
				productId = currentProduct.getId();
				HomeTabAct.currentOrder = 0;
				finalPosition = currentProductPosition;
				finalOrder = 0;
				fromFeature = false;
				fromWishlist = false;
			} else {
				fromWishlist = true;
				WishlistOptionId = extra.getString("wishlistOptionId");
				finalPosition = extra.getInt("wishlistCurrentPosition");
				objProduct = new Product();
				try {
					currentProduct = objProduct
							.getProductDetailsByCountryStateStore(
									ProductDetailAct.this, WishlistId,
									MobicartCommonData.territoryId,
									MobicartCommonData.stateId);
					MobicartCommonData.currentProductCover = currentProduct;
					productId = currentProduct.getId();
					finalOrder = 2;
				} catch (NullPointerException e1) {
					showServerError();
				} catch (JSONException e1) {
					showServerError();
				} catch (CustomException e) {
					showNetworkError();
				}
				addToWishListBtn.setVisibility(View.GONE);
				fromFeature = false;
			}
		}

		currentStatus = currentProduct.getsStatus();
		if (currentStatus.equals(DepartmentsListAdapter.STATUS_COMING_SOON)) {
			statusIV.setBackgroundResource(R.drawable.coming_soon_btn);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.comming.soon", "Comming Soon"));
			addToCartBtn.setVisibility(View.INVISIBLE);
			status = "coming";
		} else if (currentStatus.equals(DepartmentsListAdapter.STATUS_IN_STOCK)) {
			statusIV.setBackgroundResource(R.drawable.stock_btn);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.instock", "In Stock"));
			status = "instock";
		} else if (currentStatus.equals(DepartmentsListAdapter.STATUS_SOLD_OUT)) {
			statusIV.setBackgroundResource(R.drawable.sold_out);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.soldout", "Sold Out"));
			addToCartBtn.setVisibility(View.INVISIBLE);
			status = "sold";
		}

		if (!currentProduct.getbUseOptions()) {
			pOptAvailableQuantity = currentProduct.getiAggregateQuantity();
			if (pOptAvailableQuantity > 0) {
			} else {
				if (pOptAvailableQuantity == -1) {
					if (pOptAvailableQuantity > 0) {
						if (currentStatus
								.equals(DepartmentsListAdapter.STATUS_SOLD_OUT)) {
							statusIV.setBackgroundResource(R.drawable.sold_out);
							statusIV.setText(MobicartCommonData.keyValues
									.getString("key.iphone.wishlist.soldout",
											"Sold Out"));
							addToCartBtn.setVisibility(View.INVISIBLE);
							status = "sold";
						}
					}
				} else {
					if (currentProduct.getsStatus().equals(
							DepartmentsListAdapter.STATUS_COMING_SOON)) {
					} else {
						statusIV.setBackgroundResource(R.drawable.sold_out);
						statusIV.setText(MobicartCommonData.keyValues
								.getString("key.iphone.wishlist.soldout",
										"Sold Out"));
						addToCartBtn.setVisibility(View.INVISIBLE);
						status = "sold";
					}
				}
			}

		} else if (currentProduct.getProductOptions() == null) {
			if (currentProduct.getsStatus().equals(
					DepartmentsListAdapter.STATUS_COMING_SOON)) {
			} else {
				statusIV.setBackgroundResource(R.drawable.sold_out);
				statusIV.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.wishlist.soldout", "Sold Out"));
				addToCartBtn.setVisibility(View.INVISIBLE);
				status = "sold";
			}
		}

		getRatingReview();
		if (productId != 0)
			updateViewCount(productId);

		for (int i = 0; i < currentProduct.getProductImages().size(); i++) {
			ImageView productIV = null;
			productIV = new ImageView(this);
			productIV.setLayoutParams(new LayoutParams(
					LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
			productIV.setTag(MobicartUrlConstants.baseImageUrl.substring(0,
					MobicartUrlConstants.baseImageUrl.length() - 1)
					+ currentProduct.getProductImages().get(0)
							.getProductImageMedium());
			imageLoader.DisplayImage(
					MobicartUrlConstants.baseImageUrl.substring(0,
							MobicartUrlConstants.baseImageUrl.length() - 1)
							+ currentProduct.getProductImages().get(0)
									.getProductImageMedium(), this, productIV);
			imgRl.addView(productIV);
		}

		if (currentProduct.getsVideoUrl() == "null"
				|| currentProduct.getsVideoUrl() == ""
				|| currentProduct.getsVideoUrl().length() == 0) {
			watchVideoBtn.setVisibility(View.INVISIBLE);
		}
		mSoundManager.initSounds(getBaseContext());
		mSoundManager.addSound(1, R.raw.pickup_coin);
		productIV.setOnClickListener(this);
		productIVDummy.setOnClickListener(this);
		zoomBtn.setOnClickListener(this);
		postReviewBtn.setOnClickListener(this);
		sendToFriendBtn.setOnClickListener(this);
		addToWishListBtn.setOnClickListener(this);
		addToCartBtn.setOnClickListener(this);
		watchVideoBtn.setOnClickListener(this);
		productTextTV.setText(currentProduct.getsDescription());

		productPrice = ProductTax
				.calculateFinalPriceByUserLocation(currentProduct);
		productPriceTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", productPrice));
		if (!currentProduct.getsTaxType().equalsIgnoreCase("Default")
				&& MobicartCommonData.storeVO.isbIncludeTax())
			priceTaxTV.setText("(Inc. " + currentProduct.getsTaxType() + ")");
		if (ProductTax
				.caluateTaxForProductWithoutIncByUserLocation(currentProduct) > 0) {
			Double tax = ProductTax
					.caluateTaxForProductWithoutIncByUserLocation(currentProduct);
			actualPrice = tax;
			actualPriceTV.setText(String
					.valueOf(MobicartCommonData.currencySymbol
							+ String.format("%.2f", tax)));
			if (!currentProduct.getsTaxType().equalsIgnoreCase("Default")
					&& MobicartCommonData.storeVO.isbIncludeTax())
				actualPriceTaxTV.setText("(Inc. "
						+ currentProduct.getsTaxType() + ")");
		} else {
			actualPriceTV
					.setText(String.valueOf(MobicartCommonData.currencySymbol
							+ String.format("%.2f", currentProduct.getfPrice())));
			if (!currentProduct.getsTaxType().equalsIgnoreCase("Default")
					&& MobicartCommonData.storeVO.isbIncludeTax())
				actualPriceTaxTV.setText("(Inc. "
						+ currentProduct.getsTaxType() + ")");
		}
		productTitleTV.setText(currentProduct.getsName());
		if (actualPriceTV.getText().toString()
				.equalsIgnoreCase(productPriceTV.getText().toString())) {
			productPriceTV.setVisibility(View.GONE);
			priceTaxTV.setVisibility(View.GONE);
		} else {
			actualPriceTV.setPaintFlags(actualPriceTV.getPaintFlags()
					| Paint.STRIKE_THRU_TEXT_FLAG);
		}
		if (fromWishlist) {

			if (currentProduct.getProductOptions() != null) {
				database.GetRow("SELECT * from "
						+ MobicartDbConstants.TBL_WISHLIST + " where "
						+ MobicartDbConstants.KEY_PRODUCT_OPTION_ID + "='"
						+ WishlistOptionId + "'", wishlistVO);
				String st = wishlistVO.getsProductOptionId();
				String[] st1 = null;

				if (st != null)
					st1 = st.split(",");
				ArrayList<Integer> selectedOptionsQuantity = new ArrayList<Integer>();
				optionProductPrice = productPrice;
				optionActualPrice = actualPrice;
				for (int i = 0; i < currentProduct.getProductOptions().size(); i++) {

					if (st1 != null) {
						for (int j = 0; j < st1.length; j++) {
							if (st1[j].equalsIgnoreCase(String
									.valueOf(currentProduct.getProductOptions()
											.get(i).getId()))) {
								optionProductPrice = optionProductPrice
										+ (double) currentProduct
												.getProductOptions().get(i)
												.getsPrice();
								optionActualPrice = optionActualPrice
										+ (double) currentProduct
												.getProductOptions().get(i)
												.getsPrice();
								selectedOptionsQuantity.add(currentProduct
										.getProductOptions().get(i)
										.getiAvailableQuantity());
							}
						}
					}
				}
				if (selectedOptionsQuantity != null) {
					Collections.sort(selectedOptionsQuantity);
					if (selectedOptionsQuantity.size() > 0) {
						if (selectedOptionsQuantity.get(0) != 0) {
							statusIV.setBackgroundResource(R.drawable.stock_btn);
							statusIV.setText(MobicartCommonData.keyValues
									.getString("key.iphone.wishlist.instock",
											""));
						} else {
							statusIV.setBackgroundResource(R.drawable.sold_out);
							statusIV.setText(MobicartCommonData.keyValues
									.getString("key.iphone.wishlist.soldout",
											""));
							addToCartBtn.setVisibility(View.INVISIBLE);
						}
					}
				}
				productPriceTV.setText(MobicartCommonData.currencySymbol
						+ String.format("%.2f", optionProductPrice));
				actualPriceTV.setText(MobicartCommonData.currencySymbol
						+ String.format("%.2f", optionActualPrice));
				if (!currentProduct.getsTaxType().equalsIgnoreCase("Default")
						&& MobicartCommonData.storeVO.isbIncludeTax())
					actualPriceTaxTV.setText("(Inc. "
							+ currentProduct.getsTaxType() + ")");
				if (actualPriceTV.getText().toString()
						.equalsIgnoreCase(productPriceTV.getText().toString())) {
					productPriceTV.setVisibility(View.GONE);
					priceTaxTV.setVisibility(View.GONE);
				} else {
					actualPriceTV.setPaintFlags(actualPriceTV.getPaintFlags()
							| Paint.STRIKE_THRU_TEXT_FLAG);
				}
			}
		}
		if (fromWishlist == false || finalOrder == 0 || finalOrder == 1) {
			if (currentProduct.getbUseOptions() == true) {
				if (currentProduct.getProductOptions() != null) {
					prepareOptionSpinner();
				}
			}
		}
		if (currentProduct.getProductImages().size() == 0) {
			productIV.setPadding(0, 0, 2, 0);
			productIVDummy.setPadding(0, 0, 2, 0);
			productIVDummy
					.setBackgroundDrawable(R.drawable.product_placeholder_standard);
			zoomBtn.setVisibility(View.GONE);
		}

	}

	/**
	 * This Method shows Network related errors.
	 */
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(
				ProductDetailAct.this.getParent()).create();
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
						ProductDetailAct.this.startActivity(intent);
						ProductDetailAct.this.finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * This method shows Server errors.
	 */
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				ProductDetailAct.this.getParent()).create();
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
	 * This Method is used for updating review count.
	 * 
	 * @param productId2
	 */
	private void updateViewCount(int productId2) {
		Product pr = new Product();
		try {
			pr.updateProductView(ProductDetailAct.this, productId2);
		} catch (CustomException e) {
			showNetworkError();
		}
	}

	/**
	 * This method is used for getting rating from server to show.
	 */
	static void getRatingReview() {
		GetProductId = productId;
		Product GetProduct = new Product();
		try {
			MobicartCommonData.productObj = GetProduct
					.getProductDetailsByCountryStateStore(GetProductId,
							MobicartCommonData.territoryId,
							MobicartCommonData.stateId);
		} catch (NullPointerException e) {
		} catch (JSONException e) {
		} catch (CustomException e) {
		}
		if (MobicartCommonData.productObj.getProductReviews() != null) {
			fAvRating = (float) MobicartCommonData.productObj
					.getfAverageRating();
			iRating = MobicartCommonData.productObj.getProductReviews().size();
			productReviewTV.setText(iRating
					+ " "
					+ MobicartCommonData.keyValues.getString(
							"key.iphone.mainproduct.reviews", "Review(s)"));
			ratingView.setRating(fAvRating);
			if (fromFeature || fromWishlist) {
			} else
				DepartmentsListAdapter.ratingBar.setRating(fAvRating);
		} else {
			iRating = 0;
			productReviewTV.setText(iRating
					+ " "
					+ MobicartCommonData.keyValues.getString(
							"key.iphone.mainproduct.reviews", "Review(s)"));
			productReviewTV.setOnClickListener(null);
		}
	}

	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		drawable = (GradientDrawable) this.getResources().getDrawable(
				R.drawable.rounded_button);
		drawable.setColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getThemeColor()));
		ratingView = (RatingBar) findViewById(R.id.productDetail_ratingbar);
		productReviewTV = (MyCommonView) findViewById(R.id.productDetail_review_TV);
		imgRl = (RelativeLayout) findViewById(R.id.productDetail_productimg_RL);
		zoomBtn = (Button) findViewById(R.id.productDetail_searchicon_Btn);
		productTextTV = (MyCommonView) findViewById(R.id.productDetail_text_TV);
		productTitleTV = (MyCommonView) findViewById(R.id.productDetail_title_TV);
		productPriceTV = (MyCommonView) findViewById(R.id.productDetail_price_TV);
		actualPriceTV = (MyCommonView) findViewById(R.id.productDetail_actualPrice_TV);
		postReviewBtn = (MyCommonView) findViewById(R.id.productDetail_postReview_Btn);// productDetail_postReview_Btn
		addToCartBtn = (MyCommonView) findViewById(R.id.productDetail_AddToCart_Btn);
		sendToFriendBtn = (MyCommonView) findViewById(R.id.productDetail_sendtofrend_Btn);
		addToWishListBtn = (MyCommonView) findViewById(R.id.productDetail_addtoWishlist_Btn);
		productIV = (LoaderImageView) findViewById(R.id.productDetail_productimg_IV);
		productIVDummy = (LoaderImageView) findViewById(R.id.productDetail_productimg_IV1);
		watchVideoBtn = (MyCommonView) findViewById(R.id.productDetail_watchVideo_Btn);
		statusIV = (MyCommonView) findViewById(R.id.productDetail_soldOut_Btn);
		backButton = (MyCommonView) ((TabHostAct) getParent().getParent())
				.getBackButton();
		actualPriceTaxTV = (MyCommonView) findViewById(R.id.productDetail_actualPriceTax_TV);
		priceTaxTV = (MyCommonView) findViewById(R.id.productDetail_priceTax_TV);
		productReviewTV.setOnClickListener(this);
		backButton.setOnClickListener(this);
		mSoundManager = new SoundManager();
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
		productTitleTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		productPriceTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		actualPriceTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		actualPriceTaxTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		priceTaxTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		addToCartBtn.setBackgroundDrawable(drawable);
		productTextTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		postReviewBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.mainproduct.postreview", "Post Review"));
		addToCartBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.mainproduct.addtocart", "Add To Cart"));
		sendToFriendBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.mainproduct.sendtofriend", "Send to friend"));
		addToWishListBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.mainproduct.addwishlist", "Add To Wishlist"));
		watchVideoBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.mainproduct.watchvideo", "Watch Video"));
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.navigation_bar_cart_btn:
			if (backText == false) {
				StoreTabGroupAct parentActivity1 = (StoreTabGroupAct) getParent();
				Intent cartAct = new Intent(this, CartAct.class);
				String backBtn = MobicartCommonData.keyValues.getString(
						"key.iphone.home.back", "Back");
				cartAct.putExtra("IsFrom", backBtn);
				cartAct.putExtra("ParentAct", "2");
				cartAct.putExtra("parent", "");
				parentActivity1.startChildActivity("CartAct", cartAct);
			} else if (backText == true) {
				AccountTabGroupAct parentActivity1 = (AccountTabGroupAct) getParent();
				Intent cartAct = new Intent(this, CartAct.class);
				String backBtn = MobicartCommonData.keyValues.getString(
						"key.iphone.home.back", "Back");
				cartAct.putExtra("IsFrom", backBtn);
				cartAct.putExtra("ParentAct", "4");
				parentActivity1.startChildActivity("CartAct", cartAct);
			}
			break;
		case R.id.productDetail_productimg_IV:
			if (currentProduct.getProductImages().size() == 0) {
			} else {
				ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
				Intent intent = new Intent(
						parentActivity.getApplicationContext(),
						CoverFlowExample.class);
				intent.putExtra("currentProductPosition", finalPosition);
				intent.putExtra("currentOrder", finalOrder);
				parentActivity.startChildActivity("CoverFlowExample", intent);
			}
			break;
		case R.id.productDetail_productimg_IV1:
			if (currentProduct.getProductImages().size() == 0) {
			} else {
				ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
				Intent intent = new Intent(
						parentActivity.getApplicationContext(),
						CoverFlowExample.class);
				intent.putExtra("currentProductPosition", finalPosition);
				intent.putExtra("currentOrder", finalOrder);
				parentActivity.startChildActivity("CoverFlowExample", intent);
			}
			break;
		case R.id.productDetail_watchVideo_Btn:
			String urlVideo = currentProduct.getsVideoUrl();
			String vid = Uri.parse(urlVideo).getQueryParameter("v");
			Intent intent = new Intent(Intent.ACTION_VIEW,
					Uri.parse("vnd.youtube:" + vid));
			startActivity(intent);
			break;
		case R.id.productDetail_review_TV:
			ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
			Intent intent2 = new Intent(parentActivity.getApplicationContext(),
					ReviewListAct.class);
			currentProductId = currentProduct.getId();
			productName = currentProduct.getsName();
			intent2.putExtra("Wishlist", backText);
			intent2.putExtra("ARating", fAvRating);
			intent2.putExtra("Id", productId);
			intent2.putExtra("Size", reviewSize);
			intent2.putExtra("ProductName", productName);
			parentActivity.startChildActivity("ReviewListAct", intent2);
			break;
		case R.id.productDetail_AddToCart_Btn:
			if (!fromWishlist) {
				try {
					if (!currentProduct.getbUseOptions()) {
						if (pOptAvailableQuantity > 0) {
							if (!checkDB()) {
								doCartTask();
								select = true;
							} else {
								select = false;
							}
						} else {
							if (pOptAvailableQuantity == -1) {
								if (!checkDB()) {
									pOptAvailableQuantity = 100;
									doCartTask();
									select = true;
								} else {
									select = false;
								}
							}
						}
					} else {
						if (!getProductOptions()) {
							AlertDialog.Builder builder = new AlertDialog.Builder(
									getParent());
							builder.setMessage(MobicartCommonData.keyValues
									.getString(
											"key.iphone.selectopt.product.text",
											"Product Details"));
							builder.setCancelable(false)
									.setPositiveButton(
											MobicartCommonData.keyValues
													.getString(
															"key.iphone.nointernet.cancelbutton",
															"Ok"),
											new DialogInterface.OnClickListener() {
												@Override
												public void onClick(
														DialogInterface dialog,
														int which) {
													dialog.cancel();
												}
											});
							builder.show();
							optionSelected = false;
						} else {
							productOptionId = getProductOptionId();
							if (currentProduct.getProductOptions()
									.get(selectedPosition)
									.getiAvailableQuantity() > 0) {
								doCartTask();
							}
							if (currentProduct.getProductOptions()
									.get(selectedPosition)
									.getiAvailableQuantity() == -1) {
								doCartTask();
							}
						}
					}
				} catch (NullPointerException e) {
					productOptionId = getProductOptionId();
					select = true;
					if (currentProduct.getProductOptions()
							.get(selectedPosition).getiAvailableQuantity() == -1) {
						if (!checkDB()) {
							doCartTask();
						}
					}
				}
			} else {
				database.GetRow("SELECT * from "
						+ MobicartDbConstants.TBL_WISHLIST + " where "
						+ MobicartDbConstants.KEY_PRODUCT_OPTION_ID + "='"
						+ WishlistOptionId + "'", wishlistVO);
				if (currentProduct.getbUseOptions()) {
					boolean productOptionIdExists = database
							.checkIfItemExists("Select * from "
									+ MobicartDbConstants.TBL_CART + " where "
									+ MobicartDbConstants.KEY_PRODUCT_ID + "="
									+ currentProduct.getId() + " and "
									+ MobicartDbConstants.KEY_PRODUCT_OPTION_ID
									+ "='" + WishlistOptionId + "'");

					if (productOptionIdExists) {
						cartListVO = database.GetRows("SELECT * from "
								+ CartItemVO.CART_TABLE_NAME + " where "
								+ MobicartDbConstants.KEY_PRODUCT_OPTION_ID
								+ "='" + WishlistOptionId + "'",
								new CartItemVO());
						select = false;
					} else {
						if (checkDB()) {
							cartlistItemVO = new CartItemVO();
							database.GetRow("SELECT * from "
									+ MobicartDbConstants.TBL_CART + " where "
									+ MobicartDbConstants.KEY_PRODUCT_ID + "="
									+ wishlistVO.getProductId(), cartlistItemVO);
							qtyInCart = cartlistItemVO.getQuantity();
						}
						if (wishlistVO.getAvailQty() > 0
								|| wishlistVO.getAvailQty() == -1) {
							if (wishlistVO.getAvailQty() == -1) {
								wishlistVO.setAvailQty(100);
							}
							remainingQty = wishlistVO.getAvailQty() - qtyInCart;
							if (remainingQty > 0) {
								statusIV.setBackgroundResource(R.drawable.stock_btn);
								statusIV.setText(MobicartCommonData.keyValues
										.getString(
												"key.iphone.wishlist.instock",
												""));
								status = "instock";
								addToCartBtn.setVisibility(View.VISIBLE);
							} else {
								select = false;
								statusIV.setBackgroundResource(R.drawable.sold_out);
								statusIV.setText(MobicartCommonData.keyValues
										.getString(
												"key.iphone.wishlist.soldout",
												""));
								status = "sold";
								addToCartBtn.setVisibility(View.INVISIBLE);
							}
						}
						if (status.equalsIgnoreCase("instock")) {
							database.insertCartList(currentProduct.getId(),
									WishlistOptionId, 1,
									wishlistVO.getAvailQty());
							select = true;
						}
					}
				} else {
					if (!checkDB()) {
						database.insertCartList(currentProduct.getId(),
								productOptionId, 1, wishlistVO.getAvailQty());
						select = true;
					} else
						select = false;
				}
			}
			if (select) {
				if (optionSelected) {
					mSoundManager.playSound(1);
					getAnimSet(productIVDummy, ProductDetailAct.this);
					TabHostAct.cartItemsCounter++;
					MyCommonView cartButton = (MyCommonView) ((TabHostAct) getParent()
							.getParent()).getCartButton();
					cartButton.setText("" + CartItemCount.getCartCount(this));
				}
			} else {
				if (!select) {
					if (status.equalsIgnoreCase("sold")) {
					} else {
						if (optionSelected) {
							AlertDialog.Builder builder = new AlertDialog.Builder(
									getParent());
							builder.setMessage(MobicartCommonData.keyValues
									.getString(
											"key.iphone.product.alreadyadded.text",
											"Product already added to cart. \n Please edit cart to change Qty."));
							builder.setCancelable(false)
									.setPositiveButton(
											MobicartCommonData.keyValues
													.getString(
															"key.iphone.nointernet.cancelbutton",
															"Ok"),
											new DialogInterface.OnClickListener() {
												@Override
												public void onClick(
														DialogInterface dialog,
														int which) {
													dialog.cancel();
												}
											});
							builder.show();
						}
					}
				}
			}
			break;
		case R.id.productDetail_postReview_Btn:
			ParentActivityGroup parentActivity1 = (ParentActivityGroup) getParent();
			Intent intent1 = new Intent(
					parentActivity1.getApplicationContext(),
					PostReviewAct.class);
			intent1.putExtra("Id", productId);
			intent1.putExtra("Wishlist", backText);
			parentActivity1.startChildActivity("PostReviewAct", intent1);

			break;
		case R.id.productDetail_searchicon_Btn:
			break;
		case R.id.productDetail_sendtofrend_Btn:
			Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
			emailIntent.setType("text/html");
			emailIntent
					.putExtra(android.content.Intent.EXTRA_TITLE, "My Title");
			emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT,
					"Subject: " + "" + currentProduct.getsName() + " - " + ""
							+ MobicartCommonData.storeVO.getsSName());
			emailIntent
					.putExtra(
							android.content.Intent.EXTRA_TEXT,
							MobicartCommonData.keyValues
									.getString(
											"key.iphone.product.detail.email.content",
											"Hello, \r\n\r\nI have just seen this great Product on the M-Commerce store. You can buy it from your Phone. \r\n\r\nThank You"));
			startActivity(Intent.createChooser(emailIntent,
					"Complete Action Using"));

			break;
		case R.id.productDetail_addtoWishlist_Btn:
			AddWishlist = true;
			LayoutInflater lf = LayoutInflater.from(this);
			View text = lf.inflate(R.layout.addtowishlist_dialog_layout, null);
			final AlertDialog.Builder builder = new AlertDialog.Builder(
					getParent());
			TextView titleTV = (TextView) text
					.findViewById(R.id.dialog_title_TV);
			titleTV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.selectopt.product.title", "Product Details"));
			TextView descTV = (TextView) text.findViewById(R.id.dialog_desc_TV);
			if (currentProduct.getbUseOptions()) {
				if (!getProductOptions()) {
					AlertDialog.Builder builder1 = new AlertDialog.Builder(
							getParent());
					builder1.setMessage(MobicartCommonData.keyValues.getString(
							"key.iphone.selectopt.product.text",
							"Product Details"));
					builder1.setCancelable(false)
							.setPositiveButton(
									MobicartCommonData.keyValues.getString(
											"key.iphone.nointernet.cancelbutton",
											"Ok"),
									new DialogInterface.OnClickListener() {
										@Override
										public void onClick(
												DialogInterface dialog,
												int which) {
											dialog.cancel();
										}
									});
					builder1.show();
					AddWishlist = false;
				}
			}
			if (AddWishlist == true) {
				if (!currentProduct.getbUseOptions()) {
					pOptAvailableQuantity = currentProduct
							.getiAggregateQuantity();
					if (database.checkIfItemExists("Select * from "
							+ MobicartDbConstants.TBL_WISHLIST + " where "
							+ MobicartDbConstants.KEY_PRODUCT_ID + "="
							+ currentProduct.getId())) {
						itemAdded = false;
					} else {
						insertIntoWishlist();
					}
				} else {
					if (currentProduct.getProductOptions() != null) {
						productOptionId = getProductOptionId();
						if (currentProduct.getProductOptions()
								.get(selectedPosition).getiAvailableQuantity() >= 0) {
							doWishlistTask();
						}
						if (currentProduct.getProductOptions()
								.get(selectedPosition).getiAvailableQuantity() == -1) {
							doWishlistTask();
						}
					} else {
						productOptionId = null;
						doWishlistTask();
					}
				}
				if (itemAdded) {
					descTV.setText(MobicartCommonData.keyValues.getString(
							"key.iphone.product.detail.add.wishlist",
							"Product has been added to your Wishlist"));
					itemAdded = false;

				} else {
					descTV.setText(MobicartCommonData.keyValues.getString(
							"key.iphone.product.detail.already.added",
							"Product already added to Wishlist"));
				}
				builder.setView(text);
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
				builder.setView(text);
				builder.show();
			}
			break;
		case R.id.universal_back_btn:
			finish();
		default:
			break;
		}
	}

	/**
	 * This method checks Database foe availability of product in wishlist if it
	 * is not added in wishlist it insert that product in wishlist.
	 */
	private void doWishlistTask() {
		if (!checkWishlistDB()) {
			insertIntoWishlist();
		}
	}

	@SuppressLint("ParserError")
	private void insertIntoWishlist() {
		database.insertWishList(
				currentProduct.getId(),
				currentProduct.getsName(),
				actualPriceTV.getText().toString().equalsIgnoreCase("")?0.0:Double
						.parseDouble(actualPriceTV
								.getText()
								.toString()
								.substring(
										MobicartCommonData.currencySymbol.toString().length(),
										actualPriceTV.getText().toString()
												.length())),
				productPriceTV.getText().toString().equalsIgnoreCase("")?0.0:Double
						.parseDouble(productPriceTV
								.getText()
								.toString()
								.substring(
										MobicartCommonData.currencySymbol.toString().length(),
										productPriceTV.getText().toString()
												.length())),
				currentProduct.getProductImages().size() > 0 ? currentProduct
						.getProductImages().get(0).getProductImageMedium() : "",
				status, currentProduct.getfAverageRating(),
				pOptAvailableQuantity, fromWishlist ? null : productOptionId);
		itemAdded = true;
	}

	private boolean checkWishlistDB() {
		boolean exists = database.checkIfItemExists("Select * from "
				+ MobicartDbConstants.TBL_WISHLIST + " where "
				+ MobicartDbConstants.KEY_PRODUCT_ID + "="
				+ currentProduct.getId() + " and "
				+ MobicartDbConstants.KEY_PRODUCT_OPTION_ID + "='"
				+ productOptionId + "'");
		return exists;
	}

	/**
	 * This method checks Database foe availability of product in Cart if it is
	 * not added in Cart it insert that product in Cart.
	 */
	private void doCartTask() {
		if (!checkDB()) {
			productOptionId=currentProduct.getbUseOptions()?productOptionId:"0";
			database.insertCartList(currentProduct.getId(), productOptionId, 1,
					MaxAvlQty);
			select = true;
			optionSelected = true;
			if (currentProduct.getbUseOptions()) {
				if (currentProduct.getProductOptions() != null) {
					Set set = productOptionsPrice.entrySet();
					Iterator iterator = set.iterator();
					optionIdStr = "";
					while (iterator.hasNext()) {
						final Map.Entry me = (Map.Entry) iterator.next();
						innerOptionVO = (ProductOptionVO) me.getValue();
						for (int loop = 0; loop < currentProduct
								.getProductOptions().size(); loop++) {
							if (currentProduct.getProductOptions().get(loop)
									.getId() == innerOptionVO.getId()) {
								currentProduct
										.getProductOptions()
										.get(loop)
										.setiAvailableQuantity(
												currentProduct
														.getProductOptions()
														.get(loop)
														.getiAvailableQuantity() - 1);
								innerOptionVO
										.setiAvailableQuantity(currentProduct
												.getProductOptions().get(loop)
												.getiAvailableQuantity());
								productOptionsQty.put(Integer.parseInt(me
										.getKey().toString()), innerOptionVO
										.getiAvailableQuantity());
								MaxAvlQty = Collections.min(productOptionsQty
										.values());
							}
						}
					}
				}
			}
		} else {
			boolean exist = false;
			cartListVO = database.GetRows(
					"SELECT * from " + CartItemVO.CART_TABLE_NAME + " where "
							+ MobicartDbConstants.KEY_PRODUCT_ID + "="
							+ currentProduct.getId(), new CartItemVO());
			String[] OptionID = new String[cartListVO.size()];

			for (int iIndex = 0; iIndex < cartListVO.size(); iIndex++) {
				OptionID[iIndex] = cartListVO.get(iIndex).getProductOptionId();
				qtyInCart = cartListVO.get(iIndex).getQuantity();
			}
			for (int i = 0; i < cartListVO.size(); i++) {
				if (OptionID[i] != null && OptionID[i].equals(productOptionId)) {
					select = false;
					optionSelected = true;
					exist = true;
				}
			}
			if (!exist) {
				select = true;
				optionSelected = true;
				database.insertCartList(currentProduct.getId(),
						productOptionId, 1, MaxAvlQty);
				if (currentProduct.getbUseOptions()) {
					if (currentProduct.getProductOptions() != null) {
						Set set = productOptionsPrice.entrySet();
						Iterator iterator = set.iterator();
						optionIdStr = "";
						while (iterator.hasNext()) {
							final Map.Entry me = (Map.Entry) iterator.next();
							innerOptionVO = (ProductOptionVO) me.getValue();
							for (int loop = 0; loop < currentProduct
									.getProductOptions().size(); loop++) {
								if (currentProduct.getProductOptions()
										.get(loop).getId() == innerOptionVO
										.getId()) {
									currentProduct
											.getProductOptions()
											.get(loop)
											.setiAvailableQuantity(
													currentProduct
															.getProductOptions()
															.get(loop)
															.getiAvailableQuantity() - 1);
									innerOptionVO
											.setiAvailableQuantity(currentProduct
													.getProductOptions()
													.get(loop)
													.getiAvailableQuantity());
									productOptionsQty.put(Integer.parseInt(me
											.getKey().toString()),
											innerOptionVO
													.getiAvailableQuantity());
									MaxAvlQty = Collections
											.min(productOptionsQty.values());
								}
							}
						}
					}
				}
			}
		}
	}

	private boolean checkDB() {
		boolean exists = database.checkIfItemExists("Select * from "
				+ MobicartDbConstants.TBL_CART + " where "
				+ MobicartDbConstants.KEY_PRODUCT_ID + "="
				+ currentProduct.getId());
		return exists;
	}

	private boolean checkDBWithOption() {
		boolean exists = database.checkIfItemExists("Select * from "
				+ MobicartDbConstants.TBL_CART + " where "
				+ MobicartDbConstants.KEY_PRODUCT_ID + "="
				+ currentProduct.getId() + " and "
				+ MobicartDbConstants.KEY_PRODUCT_OPTION_ID + "='"
				+ optionIdStr + "'");
		return exists;
	}

	private String getProductOptionId() {
		String optionArr[] = new String[productOption];
		String tempId = null;
		int pOptid = 0;
		int pId = 0;
		String pOiD = null;

		for (int spinnerSize = 0; spinnerSize < productOption; spinnerSize++) {
			if (optionSpinner1[spinnerSize].getSelectedItemPosition() == 0) {
			} else {
				for (int loop = 0; loop < currentProduct.getProductOptions()
						.size(); loop++) {
					if (optionSpinner1[spinnerSize].getSelectedItem() == currentProduct
							.getProductOptions().get(loop).getsName()) {

						pId = (int) currentProduct.getProductOptions()
								.get(loop).getProductId();
						pOptName = currentProduct.getProductOptions().get(loop)
								.getsName();
						pOptTitle = currentProduct.getProductOptions()
								.get(loop).getsTitle();
						pOptAvailableQuantity = currentProduct
								.getProductOptions().get(loop)
								.getiAvailableQuantity();
						pOptid = (int) currentProduct.getProductOptions()
								.get(loop).getId();
						pOiD = String.valueOf(currentProduct
								.getProductOptions().get(loop).getId());
						optionArr[spinnerSize] = pOiD;
						tempId = tempId + pOptid + ",";
						selectedPosition = loop;
					}
				}
			}
		}

		productOptionId = tempId.substring(4, tempId.length() - 1);
		if (!AddWishlist) {
			if (!checkDbWithOptionId()) {
				database.insertProductOptions(pOptName, productOptionId,
						pOptTitle, 0, pId, 0, MaxAvlQty);
				select = true;
			} else
				select = false;
		} else {
			if (!checkWishlistDbWithOptionId(productOptionId)) {

				database.insertWishlistOptions(pOptName, productOptionId,
						pOptTitle, 0, pId, 0, MaxAvlQty);

			}
		}
		return productOptionId;
	}

	private boolean checkWishlistDbWithOptionId(String SelectedOptions) {
		boolean productOptionIdExists = database
				.checkIfItemIdExists("Select * from "
						+ MobicartDbConstants.TBL_WISHLIST_PRODUCT_OPTIONS
						+ " where " + MobicartDbConstants.KEY_OPTION_ID + "= '"
						+ SelectedOptions + "'");
		return productOptionIdExists;
	}

	private boolean checkDbWithOptionId() {
		boolean productOptionIdExists = database
				.checkIfItemIdExists("Select * from "
						+ MobicartDbConstants.TBL_PRODUCT_OPTIONS + " where "
						+ MobicartDbConstants.KEY_PRODUCT_ID + "="
						+ currentProduct.getId());
		return productOptionIdExists;
	}

	private boolean getProductOptions() {
		boolean selected = true;
		for (int spinnerSize = 0; spinnerSize < productOption; spinnerSize++) {
			if (optionSpinner1[spinnerSize].getSelectedItemPosition() == 0) {
				selected = false;
				break;
			}
		}
		return selected;
	}

	/**
	 * This Method is used for animation done on Add to cart button.
	 * 
	 * @param animview
	 * @param mycontext
	 */
	public static void getAnimSet(
			com.mobicart.renamed_package.utils.LoaderImageView animview,
			Context mycontext) {
		AnimationSet animset = new AnimationSet(true);
		animset.getFillBefore();
		animset.setFillEnabled(true);
		Animation anim, anim2;
		ScaleAnimation anim3;
		anim = new RotateAnimation(0, 360, 60, 60);
		anim.setRepeatCount(0);
		anim.setInterpolator(new LinearInterpolator());
		anim.setRepeatMode(Animation.REVERSE);
		anim.setDuration(300l);
		animset.addAnimation(anim);
		anim2 = new TranslateAnimation(0, 450, 10, -230);
		anim2.setRepeatCount(0);
		anim2.setRepeatMode(Animation.REVERSE);
		anim2.setDuration(300l);
		anim2.setInterpolator(new LinearInterpolator());
		animset.addAnimation(anim2);
		anim3 = new ScaleAnimation(1, 0.4f, 1, 0.4f, 60, 60);
		anim3.setDuration(100l);
		animset.addAnimation(anim3);
		animview.startAnimation(animset);
	}

	private void prepareOptionSpinner() {
		LinearLayout optionLayout;
		String[] optionValueAr;
		HashMap productOptionsList = null;

		if (currentProduct.getProductOptions().size() != 0) {
			productOptions = currentProduct.getProductOptions();
			productOptionsList = new HashMap();

			optionSize = productOptions.size();
			optionSpinner1 = new Spinner[optionSize];
			Collections.sort(productOptions, new Comparator<ProductOptionVO>() {
				@Override
				public int compare(ProductOptionVO object1,
						ProductOptionVO object2) {

					return object1.getsTitle().compareToIgnoreCase(
							object2.getsTitle());

				}
			});
		}
		if (productOptions.size() > 0) {
			productOptionsList = new HashMap();
			ArrayList<ProductOptionVO> productOptionValues = null;
			for (ProductOptionVO productOption : productOptions) {
				if (!option.equalsIgnoreCase(productOption.getsTitle()
						.toLowerCase())) {
					option = productOption.getsTitle().toLowerCase();
					productOptionValues = new ArrayList<ProductOptionVO>();
					productOptionsList.put(option, productOptionValues);
				}
				productOptionValues.add(productOption);
			}
			Set set = productOptionsList.entrySet();
			Iterator iterator = set.iterator();
			count = 0;
			optionLayout = (LinearLayout) findViewById(R.id.productDetail_options_LL);
			while (iterator.hasNext()) {
				final Map.Entry me = (Map.Entry) iterator.next();
				// Create Lable from key of me
				final String value = (String) me.getKey();
				spinnerArray = (ArrayList<ProductOptionVO>) me.getValue();
				int size = spinnerArray.size();
				size++;
				optionValueAr = new String[size];
				optionValueAr[0] = value;
				for (int j = 0; j < spinnerArray.size(); j++) {
					optionValueAr[j + 1] = spinnerArray.get(j).getsName();
				}
				adapter = new ArrayAdapter(ProductDetailAct.this,
						android.R.layout.simple_spinner_item, optionValueAr);
				optionsCount = productOptionsList.size();
				optionsInisializCount = 0;
				optionSpinner1[count] = new Spinner(getParent());
				optionSpinner1[count].setBackgroundResource(R.drawable.spinner);
				optionSpinner1[count].setAdapter(adapter);
				optionSpinner1[count].setId(count);
				optionSpinner1[count]
						.setOnItemSelectedListener(new OnItemSelectedListener() {

							@Override
							public void onItemSelected(AdapterView<?> arg0,
									View arg1, int arg2, long arg3) {

								if (optionsInisializCount < optionsCount) {
									optionsInisializCount++;
								} else {
									int qty = -1;
									boolean isSelected = false;
									String selectedItem = (String) arg0
											.getItemAtPosition(arg2);
									if (selectedItem.equalsIgnoreCase(value)) {
										isSelected = false;
										changeStatusImage(isSelected);
									} else {
										for (int selValue = 0; selValue < optionSize; selValue++) {
											if (selectedItem == currentProduct
													.getProductOptions()
													.get(selValue).getsName()) {
												if (CartListAdapter.qtyMap != null) {
													if (CartListAdapter.qtyMap
															.size() != 0) {
														Set set = CartListAdapter.qtyMap
																.entrySet();
														Iterator iterator = set
																.iterator();
														while (iterator
																.hasNext()) {
															final Map.Entry me = (Map.Entry) iterator
																	.next();
															int key = (Integer) me
																	.getKey();
															int value = (Integer) me
																	.getValue();
															if (currentProduct
																	.getId() == key) {
																currentProduct
																		.getProductOptions()
																		.get(selValue)
																		.setiAvailableQuantity(
																				currentProduct
																						.getProductOptions()
																						.get(selValue)
																						.getiAvailableQuantity()
																						+ value);
															}
														}
														CartListAdapter.qtyMap = new HashMap<Integer, Integer>();
													}
												}
												qty = currentProduct
														.getProductOptions()
														.get(selValue)
														.getiAvailableQuantity();
												ProductOptionVO objProductOptionVO = new ProductOptionVO();

												objProductOptionVO
														.setiAvailableQuantity(qty);
												objProductOptionVO
														.setsPrice(currentProduct
																.getProductOptions()
																.get(selValue)
																.getsPrice());
												objProductOptionVO
														.setId(currentProduct
																.getProductOptions()
																.get(selValue)
																.getId());
												optionPrice = currentProduct
														.getProductOptions()
														.get(selValue)
														.getsPrice();
												pOptID = addOptionToHashMap(
														objProductOptionVO,
														arg0.getId());
												MaxAvlQty = addQtyToHashMap(
														objProductOptionVO
																.getiAvailableQuantity(),
														arg0.getId());
												isSelected = true;
											}

										}

										if (MaxAvlQty > 0
												&& (!isAnyOneOptionsZero)) {
											if (checkDBWithOption()) {
												cartListVO = database
														.GetRows(
																"SELECT * from "
																		+ CartItemVO.CART_TABLE_NAME
																		+ " where "
																		+ MobicartDbConstants.KEY_PRODUCT_ID
																		+ "="
																		+ currentProduct
																				.getId(),
																new CartItemVO());
												for (int iIndex = 0; iIndex < cartListVO
														.size(); iIndex++) {
													qtyInCart = cartListVO.get(
															iIndex)
															.getQuantity();
												}
											} else
												qtyInCart = 0;
											remainingQty = MaxAvlQty
													- qtyInCart;
											if (!isSelected) {
												remainingQty = 1;
											}
											if (remainingQty > 0) {
												if (!isSelected) {
													currentStatus = currentProduct
															.getsStatus();
												}
												if (currentStatus
														.equals(DepartmentsListAdapter.STATUS_COMING_SOON)) {
													statusIV.setBackgroundResource(R.drawable.coming_soon_btn);
													statusIV.setText(MobicartCommonData.keyValues
															.getString(
																	"key.iphone.wishlist.comming.soon",
																	"Comming Soon"));
													addToCartBtn
															.setVisibility(View.INVISIBLE);
													status = "coming";
												} else if (currentStatus
														.equals(DepartmentsListAdapter.STATUS_SOLD_OUT)) {
													statusIV.setBackgroundResource(R.drawable.sold_out);
													statusIV.setText(MobicartCommonData.keyValues
															.getString(
																	"key.iphone.wishlist.soldout",
																	"Sold Out"));
													addToCartBtn
															.setVisibility(View.INVISIBLE);
													status = "sold";
												} else {
													statusIV.setBackgroundResource(R.drawable.stock_btn);
													statusIV.setText(MobicartCommonData.keyValues
															.getString(
																	"key.iphone.wishlist.instock",
																	""));
													status = "instock";
													addToCartBtn
															.setVisibility(View.VISIBLE);
												}

											} else if (qtyInCart > 0
													&& remainingQty <= 0) {
												if (currentStatus
														.equals(DepartmentsListAdapter.STATUS_COMING_SOON)) {
													statusIV.setBackgroundResource(R.drawable.coming_soon_btn);
													statusIV.setText(MobicartCommonData.keyValues
															.getString(
																	"key.iphone.wishlist.comming.soon",
																	"Comming Soon"));
													addToCartBtn
															.setVisibility(View.INVISIBLE);
													status = "coming";
												} else if (currentStatus
														.equals(DepartmentsListAdapter.STATUS_SOLD_OUT)) {
													statusIV.setBackgroundResource(R.drawable.sold_out);
													statusIV.setText(MobicartCommonData.keyValues
															.getString(
																	"key.iphone.wishlist.soldout",
																	"Sold Out"));
													addToCartBtn
															.setVisibility(View.INVISIBLE);
													status = "sold";
												} else {
													statusIV.setBackgroundResource(R.drawable.stock_btn);
													statusIV.setText(MobicartCommonData.keyValues
															.getString(
																	"key.iphone.wishlist.instock",
																	""));
													status = "instock";
													addToCartBtn
															.setVisibility(View.VISIBLE);
												}
											} else {
												statusIV.setBackgroundResource(R.drawable.sold_out);
												statusIV.setText(MobicartCommonData.keyValues
														.getString(
																"key.iphone.wishlist.soldout",
																""));
												status = "sold";
												addToCartBtn
														.setVisibility(View.INVISIBLE);
											}

										} else {
											// isAnyOneOptionsZero = true;
											statusIV.setBackgroundResource(R.drawable.sold_out);
											statusIV.setText(MobicartCommonData.keyValues
													.getString(
															"key.iphone.wishlist.soldout",
															""));
											status = "sold";
											addToCartBtn
													.setVisibility(View.INVISIBLE);
										}
									}
								}
							}

							private String addOptionToHashMap(
									ProductOptionVO objProductOptionVO, int id) {
								optionProductPrice = 0.0;
								optionActualPrice = 0.0;
								productOptionsPrice.put(id, objProductOptionVO);
								Set set = productOptionsPrice.entrySet();
								Iterator iterator = set.iterator();
								optionIdStr = "";

								while (iterator.hasNext()) {
									final Map.Entry me = (Map.Entry) iterator
											.next();
									innerOptionVO = (ProductOptionVO) me
											.getValue();
									optionIdStr = optionIdStr + ","
											+ innerOptionVO.getId();
									optionProductPrice = optionProductPrice
											+ innerOptionVO.getsPrice();
									optionActualPrice = optionActualPrice
											+ innerOptionVO.getsPrice();
								}
								optionIdStr = optionIdStr.substring(1,
										optionIdStr.length());
								optionProductPrice = productPrice
										+ optionProductPrice;
								optionActualPrice = optionActualPrice
										+ actualPrice;
								productPriceTV
										.setText(MobicartCommonData.currencySymbol
												+ String.format("%.2f",
														optionProductPrice));
								actualPriceTV
										.setText(MobicartCommonData.currencySymbol
												+ String.format("%.2f",
														optionActualPrice));
								if (!currentProduct.getsTaxType()
										.equalsIgnoreCase("Default")
										&& MobicartCommonData.storeVO
												.isbIncludeTax())
									actualPriceTaxTV.setText("(Inc. "
											+ currentProduct.getsTaxType()
											+ ")");
								if (actualPriceTV
										.getText()
										.toString()
										.equalsIgnoreCase(
												productPriceTV.getText()
														.toString())) {
									productPriceTV.setVisibility(View.GONE);
									priceTaxTV.setVisibility(View.GONE);
								} else {
									actualPriceTV.setPaintFlags(actualPriceTV
											.getPaintFlags()
											| Paint.STRIKE_THRU_TEXT_FLAG);
								}
								return optionIdStr;

							}

							private int addQtyToHashMap(int qty, int id) {
								productOptionsQty.put(id, qty);
								int min = Collections.min(productOptionsQty
										.values());
								return min;
							}

							@Override
							public void onNothingSelected(AdapterView<?> arg0) {
							}
						});
				optionLayout.addView(optionSpinner1[count]);
				count++;
			}
			productOption = optionLayout.getChildCount();
		}
		for (ProductOptionVO productOption : productOptions) {
			if (option.equalsIgnoreCase(productOption.getsTitle())) {
				option = productOption.getsTitle();
			}
		}
	}

	protected void changeStatusImage(boolean isSelected) {
		if (!isSelected) {
			currentStatus = currentProduct.getsStatus();
		}
		if (currentStatus.equals(DepartmentsListAdapter.STATUS_COMING_SOON)) {
			statusIV.setBackgroundResource(R.drawable.coming_soon_btn);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.comming.soon", "Comming Soon"));
			addToCartBtn.setVisibility(View.INVISIBLE);
			status = "coming";
		} else if (currentStatus.equals(DepartmentsListAdapter.STATUS_SOLD_OUT)) {
			statusIV.setBackgroundResource(R.drawable.sold_out);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.soldout", "Sold Out"));
			addToCartBtn.setVisibility(View.GONE);
			status = "sold";
		} else {
			statusIV.setBackgroundResource(R.drawable.stock_btn);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.instock", ""));
			status = "instock";
			addToCartBtn.setVisibility(View.VISIBLE);
		}

	}

	@Override
	protected void onResume() {
		StoreTabGroupAct.FLAG_BACK_KEY = false;
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		cartEditBtn.setVisibility(View.GONE);
		cartBtn.setVisibility(View.VISIBLE);
		if (backText == true) {
			backButton.setVisibility(View.VISIBLE);
			backButton.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.wishlist", "Wishlist"));
		} else {
			backButton.setVisibility(View.VISIBLE);
			backButton.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.department.store", "Store"));
		}
		backButton.setOnClickListener(this);

		if (!fromWishlist) {
			checkDB();
			cartListVO = database.GetRows(
					"SELECT * from " + CartItemVO.CART_TABLE_NAME + " where "
							+ MobicartDbConstants.KEY_PRODUCT_ID + "="
							+ currentProduct.getId(), new CartItemVO());
			String[] optionIdArr = null;
			String[] optionIdStr = new String[cartListVO.size()];
			for (int iIndex = 0; iIndex < cartListVO.size(); iIndex++) {
				optionIdStr[iIndex] = cartListVO.get(iIndex)
						.getProductOptionId();
				if (optionIdStr[iIndex] != null) {
					optionIdArr = optionIdStr[iIndex].split(",");
					for (int iloop = 0; iloop < optionIdArr.length; iloop++) {
						for (int loop = 0; loop < optionSize; loop++) {
							if (String.valueOf(
									currentProduct.getProductOptions()
											.get(loop).getId())
									.equalsIgnoreCase(optionIdArr[iloop])) {
								if (currentProduct.getProductOptions()
										.get(loop).getiAvailableQuantity() != 0)
									currentProduct
											.getProductOptions()
											.get(loop)
											.setiAvailableQuantity(
													currentProduct
															.getProductOptions()
															.get(loop)
															.getiAvailableQuantity()
															- cartListVO
																	.get(iIndex)
																	.getQuantity());
							}
						}
					}
				}
			}
		}
		super.onResume();
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		cartEditBtn.setVisibility(View.GONE);
		backButton.setVisibility(View.VISIBLE);
		backButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.department.store", "Store"));
		cartBtn.setOnClickListener(this);
		productReviewTV.setOnClickListener(this);
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		if (backText == true) {
			cartBtn.setVisibility(View.GONE);
			cartEditBtn.setVisibility(View.VISIBLE);
			cartEditBtn.setGravity(Gravity.CENTER);
			cartEditBtn.setPadding(0, 0, 0, 0);
			cartEditBtn.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.shoppingcart.edit", "Edit"));
			cartEditBtn.setBackgroundResource(R.drawable.button_without_color);
			backButton.setVisibility(View.VISIBLE);
			backButton.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.tabbar.account", "Account"));
		} else {
			if (fromFeature) {
				StoreTabGroupAct.FLAG_BACK_KEY = true;
				backButton.setVisibility(View.GONE);
			} else {
				StoreTabGroupAct.FLAG_BACK_KEY = false;
				backButton.setVisibility(View.VISIBLE);

				backButton.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.department.store", "Store"));
			}
		}
		super.onDestroy();
	}
}
