package com.mobicart.renamed_package.utils.adapters;

import java.util.ArrayList;
import java.util.Arrays;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.RotateAnimation;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.android.model.WishListVO;
import com.mobicart.renamed_package.ParentActivityGroup;
import com.mobicart.renamed_package.ProductDetailAct;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.WishlistAct;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.database.MobicartDbConstants;
import com.mobicart.renamed_package.utils.ImageLoader;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.ProductTax;

/**
 * @author mobicart
 * 
 */

public class WishListAdapter extends BaseAdapter {

	private Activity context;
	private LayoutInflater inflater;
	private DataBaseAccess database;
	private ArrayList<ProductVO> wishListVO;
	private ProductVO wishListPVO;
	public ImageLoader imageLoader;
	private ImageView imgView;
	private String imageURL;
	private Double optionProductPrice = 0.0, optionActualPrice = 0.0;
	private Double actualPrice = 0.0, productPrice = 0.0;

	public WishListAdapter(Activity wishlistAct,
			ArrayList<ProductVO> getWishListVO) {
		this.context = wishlistAct;
		this.wishListVO = getWishListVO;
		inflater = context.getLayoutInflater();
		database = new DataBaseAccess(context);
		imageLoader = new ImageLoader(context.getApplicationContext());
		MobicartCommonData.wishList = database.GetRows("SELECT * from "
				+ MobicartDbConstants.TBL_WISHLIST, new WishListVO());
	}

	@Override
	public int getCount() {
		return wishListVO.size();
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	static class ViewHolder {
		TextView productTitle_TV, productPrice_TV, actualPriceTV, priceTaxTV;
		ImageView productImg_IV;
		MyCommonView productStatus_IB;
		RatingBar ratingBar;
		ImageView redIconIV;
		Button deleteButton;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		final ViewHolder holder = new ViewHolder();
		RelativeLayout imgRL;
		wishListPVO = new ProductVO();
		wishListPVO = wishListVO.get(position);
		convertView = inflater.inflate(R.layout.wishlist_listlayout, null);
		holder.productTitle_TV = (TextView) convertView
				.findViewById(R.id.wishlist_listtitle_TV);
		holder.productPrice_TV = (TextView) convertView
				.findViewById(R.id.wishlist_list_price_TV);
		holder.priceTaxTV = (TextView) convertView
				.findViewById(R.id.wishlist_list_priceTax_TV);
		imgRL = (RelativeLayout) convertView
				.findViewById(R.id.wishlist_listimg_IV);
		holder.redIconIV = (ImageView) convertView
				.findViewById(R.id.wishlist_list_row_red_icon_iv);
		holder.productStatus_IB = (MyCommonView) convertView
				.findViewById(R.id.wishlist_listimgbtn_ImgBtn);
		holder.ratingBar = (RatingBar) convertView
				.findViewById(R.id.wishlist_listrating_RatingBar);
		holder.deleteButton = (Button) convertView
				.findViewById(R.id.wishlist_list_row_delete_btn);
		holder.actualPriceTV = (TextView) convertView
				.findViewById(R.id.wishlist_list_actualPrice_TV);
		holder.productTitle_TV.setText(wishListPVO.getsName());
		productPrice = ProductTax
				.calculateFinalPriceByUserLocation(wishListPVO);
		if (!wishListPVO.getsTaxType().equalsIgnoreCase("Default"))
			holder.productPrice_TV.setText(MobicartCommonData.currencySymbol
					+ String.format("%.2f", productPrice) + " (Inc "
					+ wishListPVO.getsTaxType() + ")");
		else
			holder.productPrice_TV.setText(MobicartCommonData.currencySymbol
					+ String.format("%.2f", productPrice));
		if (ProductTax
				.caluateTaxForProductWithoutIncByUserLocation(wishListPVO) > 0) {
			Double tax = ProductTax
					.caluateTaxForProductWithoutIncByUserLocation(wishListPVO);
			actualPrice = tax;
			holder.actualPriceTV.setText(String
					.valueOf(MobicartCommonData.currencySymbol
							+ String.format("%.2f", tax)));
		} else {
			holder.actualPriceTV.setText(String
					.valueOf(MobicartCommonData.currencySymbol
							+ String.format("%.2f", wishListPVO.getfPrice())));
		}

		if (!wishListPVO.getsTaxType().equalsIgnoreCase("Default")) {
			if (holder.actualPriceTV.getText().toString().equalsIgnoreCase(
					holder.productPrice_TV.getText().toString().replace(
							" (Inc " + wishListPVO.getsTaxType() + ")", ""))) {

				holder.actualPriceTV.setText(holder.actualPriceTV.getText()
						.toString()
						+ " (Inc " + wishListPVO.getsTaxType() + ")");
				holder.productPrice_TV.setVisibility(View.GONE);
			} else {
				holder.actualPriceTV.setPaintFlags(holder.actualPriceTV
						.getPaintFlags()
						| Paint.STRIKE_THRU_TEXT_FLAG);
			}
		} else {
			if (holder.actualPriceTV.getText().toString().equalsIgnoreCase(
					holder.productPrice_TV.getText().toString())) {
				holder.productPrice_TV.setVisibility(View.GONE);
			} else {
				holder.actualPriceTV.setPaintFlags(holder.actualPriceTV
						.getPaintFlags()
						| Paint.STRIKE_THRU_TEXT_FLAG);
			}
		}

		holder.productTitle_TV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
		holder.productPrice_TV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		holder.priceTaxTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		holder.actualPriceTV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		if (wishListPVO.getProductImages() != null) {
			if (wishListPVO.getProductImages().size() == 0) {
			} else {
				for (int i = 0; i < wishListPVO.getProductImages().size(); i++) {
					imageURL = MobicartUrlConstants.baseUrl.substring(0,
							MobicartUrlConstants.baseUrl.length() - 1)
							+ wishListPVO.getProductImages().get(0)
									.getProductImageMedium();
				}
				imgView = new ImageView(context);
				imgView.setLayoutParams(new LayoutParams(
						LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
				imgView.setTag(imageURL);
				imageLoader.DisplayImage(imageURL, context, imgView);
				imgRL.addView(imgView);
			}
		}
		String currentStatus = wishListPVO.getsStatus();
		if (wishListPVO.getbUseOptions() == false) { 
			if (currentStatus.equals("coming")) {
				holder.productStatus_IB
						.setBackgroundResource(R.drawable.coming_soon_btn);
				holder.productStatus_IB.setText(MobicartCommonData.keyValues
						.getString("key.iphone.wishlist.comming.soon", ""));
			} else if (currentStatus.equals("active")
					&& (wishListPVO.getiAggregateQuantity() != 0)) {
				holder.productStatus_IB
						.setBackgroundResource(R.drawable.stock_btn);
				holder.productStatus_IB.setText(MobicartCommonData.keyValues
						.getString("key.iphone.wishlist.instock", ""));
			} else if (currentStatus.equals("sold")
					|| (wishListPVO.getiAggregateQuantity() == 0)) {
				holder.productStatus_IB
						.setBackgroundResource(R.drawable.sold_out);
				holder.productStatus_IB.setText(MobicartCommonData.keyValues
						.getString("key.iphone.wishlist.soldout", ""));
			}
		} else if (wishListPVO.getbUseOptions() == true) { 
			if (wishListPVO.getProductOptions() != null) { 
				String[] optionIDList;
				if (MobicartCommonData.wishList.get(position)
						.getsProductOptionId() != null) {
					optionIDList = MobicartCommonData.wishList.get(position)
							.getsProductOptionId().split(",");
					int size = optionIDList.length;

					Integer selectedOptionsQuantity[] = new Integer[size];
					int count = 0;
					optionActualPrice = actualPrice;
					optionProductPrice = productPrice;
					for (int i = 0; i < wishListPVO.getProductOptions().size(); i++) 					
					{
						for (int j = 0; j < optionIDList.length; j++) {
							if (wishListPVO.getProductOptions().get(i).getId() == Integer
									.parseInt(optionIDList[j])) {
								selectedOptionsQuantity[count++] = wishListPVO
										.getProductOptions().get(i)
										.getiAvailableQuantity();
								optionProductPrice = optionProductPrice
										+ (double) wishListPVO
												.getProductOptions().get(i)
												.getsPrice();
								optionActualPrice = optionActualPrice
										+ (double) wishListPVO
												.getProductOptions().get(i)
												.getsPrice();
							}
						}
					}
					holder.actualPriceTV
							.setText(MobicartCommonData.currencySymbol
									+ String.format("%.2f", optionActualPrice));
					holder.productPrice_TV
							.setText(MobicartCommonData.currencySymbol
									+ String.format("%.2f", optionProductPrice));
					if (!wishListPVO.getsTaxType().equalsIgnoreCase("Default")) {
						if (holder.actualPriceTV
								.getText()
								.toString()
								.equalsIgnoreCase(
										holder.productPrice_TV
												.getText()
												.toString()
												.replace(
														" (Inc "
																+ wishListPVO
																		.getsTaxType()
																+ ")", ""))) {

							holder.actualPriceTV.setText(holder.actualPriceTV
									.getText().toString()
									+ " (Inc "
									+ wishListPVO.getsTaxType()
									+ ")");
							holder.productPrice_TV.setVisibility(View.GONE);
						} else {
							holder.actualPriceTV
									.setPaintFlags(holder.actualPriceTV
											.getPaintFlags()
											| Paint.STRIKE_THRU_TEXT_FLAG);
						}
					} else {
						if (holder.actualPriceTV.getText().toString()
								.equalsIgnoreCase(
										holder.productPrice_TV.getText()
												.toString())) {
							holder.productPrice_TV.setVisibility(View.GONE);
						} else {
							holder.actualPriceTV
									.setPaintFlags(holder.actualPriceTV
											.getPaintFlags()
											| Paint.STRIKE_THRU_TEXT_FLAG);
						}
					}
					Arrays.sort(selectedOptionsQuantity);
					if (selectedOptionsQuantity[0] != 0) {
						holder.productStatus_IB
								.setBackgroundResource(R.drawable.stock_btn);
						holder.productStatus_IB
								.setText(MobicartCommonData.keyValues
										.getString(
												"key.iphone.wishlist.instock",
												""));
					} else {
						holder.productStatus_IB
								.setBackgroundResource(R.drawable.sold_out);
						holder.productStatus_IB
								.setText(MobicartCommonData.keyValues
										.getString(
												"key.iphone.wishlist.soldout",
												""));
					}

				} else {
					holder.productStatus_IB
							.setBackgroundResource(R.drawable.sold_out);
					holder.productStatus_IB
							.setText(MobicartCommonData.keyValues.getString(
									"key.iphone.wishlist.soldout", ""));
				}
			}
		}
		holder.ratingBar.setRating((float) wishListPVO.getfAverageRating());
		holder.redIconIV
				.setVisibility(WishlistAct.WishListButtonMode == WishlistAct.WISHLIST_BUTTON_MODE_EDIT ? View.GONE
						: View.VISIBLE);
		if (holder.redIconIV.getVisibility() == View.VISIBLE) {
			imgRL.setVisibility(View.INVISIBLE);
			if (wishListPVO.getProductImages().size() != 0)
				imgView.setVisibility(View.INVISIBLE);
		}
		holder.redIconIV.setTag(holder.deleteButton);
		holder.redIconIV.setOnClickListener(new RedButtonOnClickListener1());
		holder.deleteButton.setVisibility(View.GONE);
		holder.deleteButton.setTag(position);
		holder.deleteButton.setText("Delete");
		holder.deleteButton.setTextColor(Color.WHITE);
		holder.deleteButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				int position = (Integer) v.getTag();
				database.deleteWishListItem(MobicartCommonData.wishList.get(
						position).get_id());
				@SuppressWarnings("unused")
				boolean data = database
						.deleteWishListItemFromOptionTable(MobicartCommonData.wishList
								.get(position).get_id());
				MobicartCommonData.wishList.remove(position);
				wishListVO.remove(position);
				notifyDataSetChanged();
			}
		});
		convertView.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (WishlistAct.WishListButtonMode == WishlistAct.WISHLIST_BUTTON_MODE_DONE) {
				} else {
					Intent intent = new Intent(context.getParent()
							.getApplicationContext(), ProductDetailAct.class);
					intent.putExtra("isFromWishlist", true);
					intent.putExtra("ProductWishlistId",
							MobicartCommonData.wishList.get(position)
									.getProductId());
					intent.putExtra("rating", holder.ratingBar.getRating());
					intent.putExtra("wishlistOptionId",
							MobicartCommonData.wishList.get(position)
									.getsProductOptionId());
					intent.putExtra("wishlistCurrentPosition", position);
					((ParentActivityGroup) context).startChildActivity(
							"ProductDetailAct", intent);
				}
			}
		});
		return convertView;
	}

	@Override
	public int getViewTypeCount() {
		return 1;
	}
}

class RedButtonOnClickListener1 implements OnClickListener {
	@Override
	public void onClick(View redIcon) {
		View button = (View) redIcon.getTag();
		if (button.getVisibility() == View.VISIBLE) {
			redIcon.startAnimation(horizontalToVertical());
			button.setVisibility(View.GONE);
		} else {
			redIcon.startAnimation(verticalToHorizontal());
			button.setVisibility(View.VISIBLE);
		}
	}

	private RotateAnimation horizontalToVertical() {
		RotateAnimation animation = new RotateAnimation(90, 0, 15, 15);
		animation.setDuration(400);
		animation.setFillAfter(true);
		return animation;
	}

	private RotateAnimation verticalToHorizontal() {
		RotateAnimation animation = new RotateAnimation(0, 90, 15, 15);
		animation.setDuration(300);
		animation.setFillAfter(true);
		return animation;
	}
}
