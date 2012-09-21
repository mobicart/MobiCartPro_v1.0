package com.mobicart.renamed_package.utils.adapters;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.CategoryVO;
import com.mobicart.android.model.DepartmentVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.android.model.SubCategoryVO;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.StoreTabGroupAct;
import com.mobicart.renamed_package.SubCategoryTabAct;
import com.mobicart.renamed_package.utils.ImageLoader;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.ProductTax;

/**
 * @author mobicart
 * 
 */

public class DepartmentsListAdapter extends BaseAdapter {

	public static final String STATUS_COMING_SOON = "coming";
	public static final String STATUS_IN_STOCK = "active";
	public static final String STATUS_SOLD_OUT = "sold";
	private LayoutInflater layoutInflater;
	private Activity currentActivity;
	private int pOptAvailableQuantity = 0;
	private int type;
	private DepartmentVO[] searchedList;
	private CategoryVO[] searchedCategoryList;
	private SubCategoryVO[] searchedSubCategoryList;
	private ProductVO[] searchedProductList;
	public ImageLoader imageLoader;
	private ImageView imgView;
	public static RatingBar ratingBar;

	/**
	 * 
	 * @param activity
	 * @param type
	 */
	public DepartmentsListAdapter(Activity activity, int type) {
		currentActivity = activity;
		layoutInflater = activity.getLayoutInflater();
		this.type = type;
	}

	/**
	 * 
	 * @param activity
	 * @param type
	 * @param searchedList
	 */
	public DepartmentsListAdapter(Activity activity, int type,
			DepartmentVO[] searchedList) {
		currentActivity = activity;
		layoutInflater = activity.getLayoutInflater();
		this.type = type;
		this.searchedList = searchedList;
	}

	/**
	 * 
	 * @param activity
	 * @param type
	 * @param searchedList
	 */
	public DepartmentsListAdapter(Activity activity, int type,
			CategoryVO[] searchedList) {
		currentActivity = activity;
		layoutInflater = activity.getLayoutInflater();
		this.type = type;
		this.searchedCategoryList = searchedList;
	}

	/**
	 * 
	 * @param activity
	 * @param type
	 * @param searchedList
	 */
	public DepartmentsListAdapter(Activity activity, int type,
			ProductVO[] searchedList) {
		currentActivity = activity;
		layoutInflater = activity.getLayoutInflater();
		this.type = type;
		this.searchedProductList = searchedList;
		imageLoader = new ImageLoader(activity.getApplicationContext());
	}

	/**
	 * 
	 * @param activity
	 * @param type
	 * @param searchedList
	 */
	public DepartmentsListAdapter(SubCategoryTabAct activity, int type,
			SubCategoryVO[] searchedList) {
		currentActivity = activity;
		layoutInflater = activity.getLayoutInflater();
		this.type = type;
		this.searchedSubCategoryList = searchedList;
	}

	@Override
	public int getCount() {
		return getListCount(type);
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		RelativeLayout rowRL = null;
		if (type == StoreTabGroupAct.TYPE_DEPARTMENTS) {
			if (searchedList == null) {
				rowRL = (RelativeLayout) prepareDepartmentsView(position,
						MobicartCommonData.departmentsList
								.toArray(new DepartmentVO[] {}));
			} else {
				rowRL = (RelativeLayout) prepareDepartmentsView(position,
						searchedList);
			}
		} else if (type == StoreTabGroupAct.TYPE_CATEGORIES) {
			if (searchedCategoryList == null) {
				rowRL = (RelativeLayout) prepareCategoriesView(position,
						MobicartCommonData.categoriesList
								.toArray(new CategoryVO[] {}));
			} else {
				rowRL = (RelativeLayout) prepareCategoriesView(position,
						searchedCategoryList);
			}
		} else if (type == StoreTabGroupAct.TYPE_SUBCATEGORIES) {
			if (searchedSubCategoryList == null) {
				rowRL = (RelativeLayout) prepareSubCategoriesView(position,
						MobicartCommonData.subCategoriesList
								.toArray(new SubCategoryVO[] {}));
			} else {
				rowRL = (RelativeLayout) prepareSubCategoriesView(position,
						searchedSubCategoryList);
			}
		} else if (type == StoreTabGroupAct.TYPE_PRODUCTS) {
			if (searchedProductList.length == 0) {
				rowRL = (RelativeLayout) prepateProductsView(position,
						MobicartCommonData.productsList
								.toArray(new ProductVO[] {}));
			} else {
				rowRL = (RelativeLayout) prepateProductsView(position,
						searchedProductList);
			}
		}
		return rowRL;
	}

	private int getListCount(int listType) {
		try {
			if (type == StoreTabGroupAct.TYPE_DEPARTMENTS) {
				if (searchedList == null) {
					return MobicartCommonData.departmentsList.size();
				} else
					return searchedList.length;
			} else if (type == StoreTabGroupAct.TYPE_CATEGORIES) {
				if (searchedCategoryList == null) {
					return MobicartCommonData.categoriesList.size();
				} else
					return searchedCategoryList.length;
			} else if (type == StoreTabGroupAct.TYPE_SUBCATEGORIES) {
				if (searchedSubCategoryList == null) {
					return MobicartCommonData.subCategoriesList.size();
				} else
					return searchedSubCategoryList.length;
			} else {
				if (searchedProductList == null) {

					return MobicartCommonData.productsList.size();
				} else {
					if (searchedProductList.length == 0) {
					}
					return searchedProductList.length;
				}
			}
		} catch (NullPointerException e) {
			showServerError();
			return 0;
		}
	}

	private View prepareDepartmentsView(int position, DepartmentVO[] departments) {
		RelativeLayout rowRL = null;
		if (rowRL == null) {
			rowRL = (RelativeLayout) layoutInflater.inflate(
					R.layout.departments_list_row_layout, null);
		}
		TextView titleTV = (TextView) rowRL
				.findViewById(R.id.departments_row_title_tv);

		TextView countTV = (TextView) rowRL
				.findViewById(R.id.departments_count_dummy);

		titleTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		countTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		titleTV.setText(departments[position].getsName());
		if (departments[position].getiCategoryCount() > 0) {
			countTV.setText("" + departments[position].getiCategoryCount());
		} else {
			countTV.setText("" + departments[position].getiProductCount());
		}
		rowRL.setTag(departments[position].getiCategoryCount());
		rowRL.setTag(Math.round(departments[position].getId()));
		return rowRL;
	}

	private View prepareCategoriesView(int position, CategoryVO[] categories) {
		RelativeLayout rowRL = null;
		if (rowRL == null) {
			rowRL = (RelativeLayout) layoutInflater.inflate(
					R.layout.departments_list_row_layout, null);
			TextView titleTV = (TextView) rowRL
					.findViewById(R.id.departments_row_title_tv);
			TextView countTV = (TextView) rowRL
					.findViewById(R.id.departments_count_dummy);
			titleTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			countTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			titleTV.setText(categories[position].getsName());
			rowRL.setTag(categories[position].getDepartmentId());
			if (categories[position].getiCategoryCount() == 0) {
				countTV.setText("" + categories[position].getiProductCount());
			} else {
				countTV.setText("" + categories[position].getiCategoryCount());
			}
		}
		return rowRL;
	}

	private RelativeLayout prepareSubCategoriesView(int position,
			SubCategoryVO[] subCategories) {
		RelativeLayout rowRL = null;
		if (rowRL == null) {
			rowRL = (RelativeLayout) layoutInflater.inflate(
					R.layout.departments_list_row_layout, null);
			TextView titleTV = (TextView) rowRL
					.findViewById(R.id.departments_row_title_tv);
			TextView countTV = (TextView) rowRL
					.findViewById(R.id.departments_count_dummy);
			titleTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			countTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			titleTV.setText(subCategories[position].getsName());
			rowRL.setTag(subCategories[position].getDepartmentId());
			if (subCategories[position].getiCategoryCount() == 0) {
				countTV
						.setText(""
								+ subCategories[position].getiProductCount());

			} else {
				countTV.setText(""
						+ subCategories[position].getiCategoryCount());
			}
		}
		return rowRL;
	}

	private View prepateProductsView(final int position, ProductVO[] products) {
		RelativeLayout imgRL, rowRL = null;
		if (rowRL == null)
			rowRL = (RelativeLayout) layoutInflater.inflate(
					R.layout.product_list_row_layout, null);
		imgRL = (RelativeLayout) rowRL.findViewById(R.id.product_listimg_IV);
		MyCommonView productNameTV = (MyCommonView) rowRL
				.findViewById(R.id.product_listtitle_TV);
		MyCommonView priceTV = (MyCommonView) rowRL
				.findViewById(R.id.product_list_price_TV);
		MyCommonView actualPriceTV = (MyCommonView) rowRL
				.findViewById(R.id.product_list_actualPrice_TV);
		MyCommonView statusIV = (MyCommonView) rowRL
				.findViewById(R.id.product_listimgbtn_ImgBtn);
		ratingBar = (RatingBar) rowRL
				.findViewById(R.id.product_listrating_RatingBar);
		String currentStatus = (products[position].getsStatus());
		if (currentStatus.equalsIgnoreCase(STATUS_COMING_SOON)) {
			statusIV.setBackgroundResource(R.drawable.coming_soon_btn);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.comming.soon", "Comming Soon"));
		} else if (currentStatus.equalsIgnoreCase(STATUS_IN_STOCK)) {
			statusIV.setBackgroundResource(R.drawable.stock_btn);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.instock", "In Stock"));
		} else if (currentStatus.equalsIgnoreCase(STATUS_SOLD_OUT)) {
			statusIV.setBackgroundResource(R.drawable.sold_out);
			statusIV.setText(MobicartCommonData.keyValues.getString(
					"key.iphone.wishlist.soldout", "Sold Out"));
		}
		if (!products[position].getbUseOptions()) {
			pOptAvailableQuantity = products[position].getiAggregateQuantity();
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
						}
					}
				} else {
					if (currentStatus
							.equals(DepartmentsListAdapter.STATUS_COMING_SOON)) {

					} else {
						statusIV.setBackgroundResource(R.drawable.sold_out);
						statusIV.setText(MobicartCommonData.keyValues
								.getString("key.iphone.wishlist.soldout",
										"Sold Out"));
					}
				}
			}
		}
		if (!products[position].getbUseOptions()) {
			if (products[position].getiAggregateQuantity() < 0
					&& (!products[position].getsStatus().equals(
							DepartmentsListAdapter.STATUS_COMING_SOON))) {
				statusIV.setBackgroundResource(R.drawable.sold_out);
				statusIV.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.wishlist.soldout", "Sold Out"));
			}
		}
		if (products[position].getiAggregateQuantity() == -1) {
			if (currentStatus.equalsIgnoreCase(STATUS_COMING_SOON)) {
				statusIV.setBackgroundResource(R.drawable.coming_soon_btn);
				statusIV.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.wishlist.comming.soon", "Comming Soon"));
			} else {
				statusIV.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.wishlist.instock", "In Stock"));
				statusIV.setBackgroundResource(R.drawable.stock_btn);
			}
			if (currentStatus.equals(STATUS_SOLD_OUT)) {
				statusIV.setBackgroundResource(R.drawable.sold_out);
				statusIV.setText(MobicartCommonData.keyValues.getString(
						"key.iphone.wishlist.soldout", "Sold Out"));
			}
		}
		productNameTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		priceTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		actualPriceTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		ratingBar.setRating((float) MobicartCommonData.productsList.get(
				position).getfAverageRating());

		productNameTV.setText(products[position].getsName());
		priceTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", ProductTax
						.calculateFinalPriceByUserLocation(products[position])));
		if (!products[position].getsTaxType().equalsIgnoreCase("Default")&& MobicartCommonData.storeVO.isbIncludeTax())
			priceTV
					.setText(MobicartCommonData.currencySymbol
							+ String
									.format(
											"%.2f",
											ProductTax
													.calculateFinalPriceByUserLocation(products[position]))
							+ " (Inc. " + products[position].getsTaxType()
							+ ")");

		if (ProductTax
				.caluateTaxForProductWithoutIncByUserLocation(products[position]) > 0) {
			Double tax = ProductTax
					.caluateTaxForProductWithoutIncByUserLocation(products[position]);
			actualPriceTV.setText(MobicartCommonData.currencySymbol
							+ String.format("%.2f", tax));
		} else {
			actualPriceTV.setText(MobicartCommonData.currencySymbol
							+ String.format("%.2f", products[position]
									.getfPrice()));
		}
		if (!products[position].getsTaxType().equalsIgnoreCase("Default")) {
			if (actualPriceTV.getText().toString().equalsIgnoreCase(
					priceTV.getText().toString().replace(
							" (Inc. " + products[position].getsTaxType() + ")",
							""))) {
				actualPriceTV.setText(actualPriceTV.getText().toString()
						+ " (Inc. " + products[position].getsTaxType() + ")");
				priceTV.setVisibility(View.GONE);
			} else {
				actualPriceTV.setPaintFlags(actualPriceTV.getPaintFlags()
						| Paint.STRIKE_THRU_TEXT_FLAG);
			}
		} else {
			if (actualPriceTV.getText().toString().equalsIgnoreCase(
					priceTV.getText().toString())) {
				priceTV.setVisibility(View.GONE);
			} else {
				actualPriceTV.setPaintFlags(actualPriceTV.getPaintFlags()
						| Paint.STRIKE_THRU_TEXT_FLAG);
			}
		}
		try {
			String imageUrl = "";
			if (products[position].getProductImages() != null) {
				if (products[position].getProductImages().size() > 0) {
					imageUrl = products[position].getProductImages().get(0)
							.getProductImageSmall();
					imgView = new ImageView(currentActivity);
					imgView.setLayoutParams(new LayoutParams(
							LayoutParams.WRAP_CONTENT,
							LayoutParams.WRAP_CONTENT));
					imgView.setTag(MobicartUrlConstants.baseImageUrl.substring(
							0, MobicartUrlConstants.baseImageUrl.length() - 1)
							+ imageUrl);
					imageLoader.DisplayImage(MobicartUrlConstants.baseImageUrl
							.substring(0, MobicartUrlConstants.baseImageUrl
									.length() - 1)
							+ imageUrl, currentActivity, imgView);
					imgRL.addView(imgView);
				}
			}
		} catch (IndexOutOfBoundsException e) {
			showServerError();
		} catch (NullPointerException e) {
			showServerError();
		}
		rowRL.setTag(products[position].getId());
		return rowRL;
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(currentActivity)
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
}
