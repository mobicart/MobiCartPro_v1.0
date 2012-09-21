package com.mobicart.renamed_package.utils.adapters;

import java.util.ArrayList;
import java.util.HashMap;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.text.Html;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.RotateAnimation;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.CartItemVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.CartAct;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.TabHostAct;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.ImageLoader;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.ProductTax;

/**
 * 
 * @author mobicart
 * 
 */
public class CartListAdapter extends BaseAdapter {

	public static ArrayList<Double> subTotal = null;
	private Context activity;
	private Activity act;
	private ArrayList<CartItemVO> cartList;
	private ProductVO cartProduct;
	private LayoutInflater inflater;
	private DataBaseAccess database;
	public static int size;
	private double totalPrice;
	private Double[] finalPrice;
	private int quantity;
	private int maxQty;
	public ImageLoader imageLoader;
	private Double fPrice = 0.0,productPrice;
	public static HashMap<Integer, Integer> qtyMap;
	
	class RedButtonOnClickListener implements OnClickListener {
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

	/**
	 * @param currentactivity
	 * @param activity2
	 * @param cartListVO
	 */
	public CartListAdapter(Activity currentactivity, Activity activity2,
			ArrayList<CartItemVO> cartListVO) {
		this.activity = currentactivity;
		imageLoader = new ImageLoader(activity.getApplicationContext());
		this.act = activity2;
		size = CartItemCount.getCartCount(currentactivity);
		this.cartList = cartListVO;
		inflater = ((Activity) activity).getLayoutInflater();
		database = new DataBaseAccess(activity);
		subTotal = new ArrayList<Double>();
		finalPrice = new Double[size];
		qtyMap=new HashMap<Integer, Integer>();
	}

	class ViewHolder {
		MyCommonView titleTV, costTV, subTotal, qty, subTotalTitle;
		ImageView productIV;
		ImageView redIconIV;
		Button deleteButton;
		ImageView imageIV;
		EditText quantityET;
		TableLayout opTable;
		TextView quantityLabelTV;
		TextView quantityTV;
	}

	/**
	 * @return
	 */
	public ArrayList<Double> GetSubTotalArray() {
		return subTotal;
	}

	@Override
	public int getCount() {
		return MobicartCommonData.objCartList.size();
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		RelativeLayout imgRL;
		final ViewHolder holder;
		
		convertView = inflater.inflate(R.layout.yourcart_listlayout, null);
		holder = new ViewHolder();
		imgRL = (RelativeLayout) convertView
				.findViewById(R.id.cart_list_row_image);
		holder.subTotalTitle = (MyCommonView) convertView
				.findViewById(R.id.sub_totalTitle_tv1);
		holder.quantityLabelTV = (TextView) convertView
				.findViewById(R.id.cart_list_row_product_title_tv);
		holder.quantityTV = (TextView) convertView
				.findViewById(R.id.cart_list_row_product_no_TV);
		holder.subTotal = (MyCommonView) convertView
				.findViewById(R.id.sub_totalValue_tv);
		holder.titleTV = (MyCommonView) convertView
				.findViewById(R.id.cart_list_row_product_title_tv);
		holder.costTV = (MyCommonView) convertView
				.findViewById(R.id.cart_list_price_tv);
		holder.qty = (MyCommonView) convertView
				.findViewById(R.id.cart_list_product_qty_label__tv);
		holder.redIconIV = (ImageView) convertView
				.findViewById(R.id.cart_list_row_red_icon_iv);
		holder.deleteButton = (Button) convertView
				.findViewById(R.id.cart_list_row_delete_btn);
		holder.quantityET = (EditText) convertView
				.findViewById(R.id.cart_list_row_product_no_et);
		holder.opTable = (TableLayout) convertView
				.findViewById(R.id.option_table);
		holder.qty.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.shoppingcart.qty", ""));
		holder.subTotalTitle.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.checkout.sub-total", "Sub Total")
				+ ": ");

		if (MobicartCommonData.cartProductsList.size() != 0) {
			cartProduct = new ProductVO();
			cartProduct = MobicartCommonData.cartProductsList.get(position);
			holder.titleTV.setText(cartProduct.getsName());
			holder.titleTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			if (cartProduct.getProductImages() != null) {
				if (cartProduct.getProductImages().size() == 0) {
					imgRL.setPadding(0, 0, 0, 0);
					imgRL
							.setBackgroundResource(R.drawable.product_image_placeholder);
				}
				try {
					if (cartProduct.getProductImages().size() > 0) {
						holder.productIV = new ImageView(activity);

						holder.productIV.setLayoutParams(new LayoutParams(
								LayoutParams.WRAP_CONTENT,
								LayoutParams.WRAP_CONTENT));
						holder.productIV
								.setTag(MobicartUrlConstants.baseImageUrl
										.substring(
												0,
												MobicartUrlConstants.baseImageUrl
														.length() - 1)
										+ cartProduct.getProductImages().get(0)
												.getProductImageSmall());
						imageLoader.DisplayImage(
								MobicartUrlConstants.baseImageUrl.substring(0,
										MobicartUrlConstants.baseImageUrl
												.length() - 1)
										+ cartProduct.getProductImages().get(0)
												.getProductImageSmall(),
								(Activity) activity, holder.productIV);
						imgRL.addView(holder.productIV);
					}
				} catch (NullPointerException e) {
					showServerError();
				}
			}
			productPrice=ProductTax
			.calculateFinalPriceByUserLocation(cartProduct);
			finalPrice[position] = productPrice;
			holder.costTV.setTextColor(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getLabelColor()));
			holder.costTV.setVisibility(View.GONE);
			maxQty = MobicartCommonData.objCartList.get(position)
					.getAvailableQuantity();
			if (maxQty == -1) {
				maxQty = 100;
			}
			quantity = MobicartCommonData.objCartList.get(position)
					.getQuantity();
			holder.quantityTV.setText(String.valueOf(quantity));
			holder.quantityET.setText(String.valueOf(quantity));
			holder.quantityET.setTag(position);
			
			if (cartProduct.getbUseOptions() == true) {
				if (cartProduct.getProductOptions() != null) {
					TableRow row;
					TextView optionTitle;
					String st = cartList.get(position).getProductOptionId();
					String[] st1 = null;
					if (cartList.get(position).getProductOptionId() != null) {
						st1 = st.split(",");
						fPrice=0.0;
						for (int j = 0; j < cartProduct.getProductOptions()
								.size(); j++) {
							float id = cartProduct.getProductOptions().get(j)
									.getId();
							for (int i = 0; i < st1.length; i++) {
								if ((float) Double.parseDouble(st1[i]) == id) {
									
									fPrice = fPrice
											+ (double) cartProduct
													.getProductOptions().get(j)
													.getsPrice();
									int dip = (int) TypedValue.applyDimension(
											TypedValue.COMPLEX_UNIT_DIP,

											1, activity.getResources()
													.getDisplayMetrics());
									row = new TableRow(activity);
									optionTitle = new TextView(activity);
									String stTitle = cartProduct
											.getProductOptions().get(j)
											.getsTitle();
									if (stTitle.length() > 7) {
										stTitle = stTitle.substring(0, 6);
										stTitle = stTitle + "..: ";
									} else {
										stTitle = stTitle + ": ";
									}

									String st2 = cartProduct
											.getProductOptions().get(j)
											.getsName();
									if (st2.length() > 5) {
										st2 = st2.substring(0, 5);
										st2 = st2 + "..";
									}
									optionTitle.setText(Html.fromHtml(stTitle
											+ "<b>" + st2 + "</b>"));
									optionTitle.setTextColor(Color.BLACK);
									optionTitle.setTextSize(12f);
									optionTitle.setPadding(4 * dip, 0, 0, 0);
									row.addView(optionTitle);
									holder.opTable.addView(row,
											new TableLayout.LayoutParams(
													LayoutParams.WRAP_CONTENT,
													LayoutParams.WRAP_CONTENT));
									break;
								}
							}
						}
					}
				}
			}
			else
				fPrice=0.0;
			fPrice=fPrice+productPrice;
			totalPrice = (quantity * fPrice);
			holder.subTotal.setText(MobicartCommonData.currencySymbol
					+ String.format("%.2f", totalPrice));
			subTotal.add(totalPrice);
			if (CartAct.cartButtonMode == CartAct.CART_BUTTON_MODE_EDIT)
				holder.quantityET.setEnabled(false);
			else {
				holder.quantityTV.setVisibility(View.INVISIBLE);
				holder.quantityET.setVisibility(View.VISIBLE);
				holder.quantityET.setEnabled(true);
				holder.quantityET.setTag(position);
				holder.quantityET.setOnTouchListener(new OnTouchListener() {
					@SuppressWarnings({ "unchecked", "rawtypes" })
					@Override
					public boolean onTouch(View v, MotionEvent event) {
						if (event.getAction() == MotionEvent.ACTION_DOWN) {
							int pos=Integer.parseInt(v.getTag().toString());
							if(MobicartCommonData.cartProductsList.get(pos).getProductOptions()!=null&&MobicartCommonData.cartProductsList.get(pos).getProductOptions().size()>0){
								for (int j = 0; j < MobicartCommonData.cartProductsList.get(pos).getProductOptions()
										.size(); j++) {
									float id = MobicartCommonData.cartProductsList.get(pos).getProductOptions().get(j)
											.getId();
									String st = cartList.get(position).getProductOptionId();
									String[] st1 = null;
									if (cartList.get(position).getProductOptionId() != null) {
										st1 = st.split(",");
										for (int i = 0; i < st1.length; i++) {
											if ((float) Double.parseDouble(st1[i]) == id) {
												maxQty=MobicartCommonData.cartProductsList.get(pos).getProductOptions().get(i).getiAvailableQuantity();
											}
										}
									}
							}
							}
							else
								maxQty = MobicartCommonData.cartProductsList.get(pos).getiAggregateQuantity();
							if (maxQty == -1) {
								maxQty = 100;
							}
							AlertDialog.Builder builder = new AlertDialog.Builder(
									act);
							final AlertDialog dialog = builder.create();
							final String[] qtyAr = new String[maxQty];
							for (int count = 1; count <= maxQty; count++) {
								qtyAr[count - 1] = "" + count;
							}
							int height = 10;
							LinearLayout linlayout = new LinearLayout(act);
							linlayout.setOrientation(1);
							linlayout.setLayoutParams(new LayoutParams(
									LayoutParams.FILL_PARENT, height));
							ListView lv = new ListView(act);
							lv.setScrollingCacheEnabled(false);
							lv.setLayoutParams(new LayoutParams(
									LayoutParams.FILL_PARENT, 200));
							lv
									.setOnItemClickListener(new OnItemClickListener() {
										@Override
										public void onItemClick(
												AdapterView<?> arg0, View arg1,
												int arg2, long arg3) {
											holder.quantityET
													.setText(qtyAr[arg2]);
										}
									});
							lv
									.setAdapter(new ArrayAdapter(
											act,
											android.R.layout.simple_list_item_1,
											qtyAr));
							Button doneBtn = new Button(act);
							doneBtn.setText(MobicartCommonData.keyValues
									.getString("key.iphone.shoppingcart.done",
											""));
							doneBtn.setOnClickListener(new OnClickListener() {
								@Override
								public void onClick(View v) {
									updateCartDetails();
									dialog.cancel();
								}

								private void updateCartDetails() {
									long rowId = cartList.get(position).getId();
									int qty = Integer
											.parseInt(holder.quantityET
													.getText().toString());
									database.updateCartList(rowId, cartList
											.get(position).getProductId(),
											cartList.get(position)
													.getProductOptionId(), qty);

									totalPrice = (qty * finalPrice[position]);
									size = CartItemCount.getCartCount(activity);
									holder.subTotal
											.setText(MobicartCommonData.currencySymbol
													+ String.format("%.2f",
															totalPrice));
								}
							});
							linlayout.addView(lv);
							linlayout.addView(doneBtn);
							dialog.setView(linlayout);
							dialog.show();
						}
						return true;
					}
				});
			}
		}
		try {
			if (holder.quantityET.getText().toString().length() != 0)
				quantity = Integer.parseInt(holder.quantityET.getText()
						.toString());
		} catch (Exception e) {
		}
		holder.redIconIV
				.setVisibility(CartAct.cartButtonMode == CartAct.CART_BUTTON_MODE_EDIT ? View.GONE
						: View.VISIBLE);
		if (holder.redIconIV.getVisibility() == View.VISIBLE) {
			imgRL.setVisibility(View.INVISIBLE);
		}
		holder.redIconIV.setTag(holder.deleteButton);
		holder.redIconIV.setOnClickListener(new RedButtonOnClickListener());
		holder.deleteButton.setVisibility(View.GONE);
		holder.deleteButton.setTag(position);
		holder.deleteButton.setText("Delete");
		holder.deleteButton.setTextColor(Color.WHITE);
		holder.deleteButton.setOnClickListener(new OnClickListener() {

			public void onClick(View v) {
				int position = (Integer) v.getTag();
				database.deleteCartItem(cartList.get(position).getId());
				qtyMap.put(cartList.get(position).getProductId(),cartList.get(position).getQuantity());
				cartList.remove(position);
				MobicartCommonData.objCartList.remove(position);
				MobicartCommonData.cartProductsList.remove(position);
				notifyDataSetChanged();
				if (cartList.size() == 0) {
					CartAct.footerLayout.setVisibility(View.GONE);
				}
				Toast.makeText(
						activity,
						MobicartCommonData.keyValues.getString(
								"key.iphone.wishlist.remove.item",
								"Item Removed"), Toast.LENGTH_SHORT).show();
				TabHostAct.cartItemsCounter = cartList.size();
			}
		});
		return convertView;
	}

	/**
	 * This method shows server related errors.
	 */
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(this.act)
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

	/**
	 * @return
	 */
	public double getTotalPrice() {
		double sum = 0;
		for (int i = 0; i < subTotal.size(); i++) {
			sum = sum + subTotal.get(i);
		}
		return sum;
	}
}