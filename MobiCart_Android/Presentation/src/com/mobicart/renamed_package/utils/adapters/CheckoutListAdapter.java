package com.mobicart.renamed_package.utils.adapters;

import java.util.ArrayList;
import org.json.JSONException;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.DataSetObserver;
import android.graphics.Color;
import android.text.Html;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.ListAdapter;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.Product;
import com.mobicart.android.model.CartItemVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.CheckoutAct;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.ProductTax;

/**
 * @author mobicart
 *  * 
 */
public class CheckoutListAdapter implements ListAdapter {

	private Activity context;
	public static ArrayList<Double> price = null;
	public static ArrayList<CartItemVO> checkOutList;
	public static Double finalPrice = 0.0;
	private Double optionPrice = 0.0, productPrice;



	/**
	 * @param checkout
	 * @param checkOutList2
	 * @param cartProduct
	 */
	public CheckoutListAdapter(Activity checkout,
			ArrayList<CartItemVO> checkOutList2, ProductVO cartProduct) {
		this.context = checkout;
		this.checkOutList = checkOutList2;
		CheckoutAct.optionDetail=new String[checkOutList2.size()];
		
	}

	@Override
	public boolean areAllItemsEnabled() {
		return false;
	}

	@Override
	public boolean isEnabled(int arg0) {
		return false;
	};

	@Override
	public int getCount() {
		return checkOutList.size();
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
		MyCommonView priceItemTV, quantyTV, totalCostTV, titleItemTV,
				cartSizeTV;
		TableLayout opTable;
	}

	@Override
	public int getItemViewType(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (context).getLayoutInflater();
		ViewHolder holder;
		convertView = inflater.inflate(R.layout.checkout_listlayout, null);
		holder = new ViewHolder();
		holder.titleItemTV = (MyCommonView) convertView
				.findViewById(R.id.cart_Name_TV);

		holder.quantyTV = (MyCommonView) convertView
				.findViewById(R.id.cart_Qty_TV);
		holder.totalCostTV = (MyCommonView) convertView
				.findViewById(R.id.cart_totalCost_TV);
		holder.opTable = (TableLayout) convertView
				.findViewById(R.id.option_table);
		convertView.setTag(holder);
		holder = (ViewHolder) convertView.getTag();
		int GetProductId = checkOutList.get(position).getProductId();
		Product product = new Product();
		optionPrice=0.0;
		ProductVO checkoutProduct = new ProductVO();
	    CheckoutAct.optionDetail[position]="";
		try {
			checkoutProduct = product.getProductDetailsByCountryStateStore(context, GetProductId,MobicartCommonData.territoryId,
					MobicartCommonData.stateId);
			checkOutList.get(position).setProductName(checkoutProduct.getsName());
			} catch (NullPointerException e1) {
			showServerError();
		} catch (JSONException e1) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
		if (checkoutProduct.getbUseOptions() == true) {
			if (checkoutProduct.getProductOptions() != null) {
				TableRow row;
				TextView optionTitle;
				String st = checkOutList.get(position).getProductOptionId();

				String[] st1 = null;
				if(st!=null)
					st1 = st.split(",");
				if(checkoutProduct.getProductOptions()!=null){
				for (int j = 0; j < checkoutProduct.getProductOptions().size(); j++) {
					float id = checkoutProduct.getProductOptions().get(j)
							.getId();
					if(st1!=null)
						{
						for (int i = 0; i < st1.length; i++) {
						if ((float) Double.parseDouble(st1[i].toString()) == id) {
									
							optionPrice = optionPrice
							+ (double) checkoutProduct
									.getProductOptions().get(j)
									.getsPrice();
							CheckoutAct.optionDetail[position]=CheckoutAct.optionDetail[position]+checkoutProduct.getProductOptions().get(j).getsTitle()+":"+checkoutProduct.getProductOptions().get(j).getsName()+",";
							checkOutList.get(position).setProductOptionId(checkoutProduct.getProductOptions().get(j).getsName()+",");
							int dip = (int) TypedValue.applyDimension(
									TypedValue.COMPLEX_UNIT_DIP,

									1, context.getResources()
											.getDisplayMetrics());
							row = new TableRow(context);
							optionTitle = new TextView(context);
							String stTitle = checkoutProduct
									.getProductOptions().get(j).getsTitle();
							if (stTitle.length() > 5) {
								stTitle = stTitle.substring(0, 5);
								stTitle = stTitle + "..: ";
							} else {
								stTitle = stTitle + ": ";
							}
							String st2 = checkoutProduct.getProductOptions()
									.get(j).getsName();
							if (st2.length() > 5) {
								st2 = st2.substring(0, 5);
								st2 = st2 + "..";
							}
							optionTitle.setText(Html.fromHtml(stTitle + "<b>"
									+ st2 + "</b>"));
							optionTitle.setTextColor(Color.BLACK);
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
		}
		else
			optionPrice=0.0;
		holder.titleItemTV.setText(checkoutProduct.getsName());
		productPrice=ProductTax
		.calculateFinalPriceByUserLocation(checkoutProduct);
		
		finalPrice = productPrice+optionPrice;
		holder.totalCostTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", finalPrice));
		
		checkOutList.get(position).setProductPrice(finalPrice.floatValue());
		if(!CheckoutAct.optionDetail[position].equalsIgnoreCase(""))
		CheckoutAct.optionDetail[position]=CheckoutAct.optionDetail[position].toString().substring(0,CheckoutAct.optionDetail[position].length()-1);
		else 
		CheckoutAct.optionDetail[position]="Null";
		holder.quantyTV.setText("" + checkOutList.get(position).getQuantity());
		return convertView;
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(context).create();
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
						context.startActivity(intent);
						context.finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(this.context)
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
	public int getViewTypeCount() {
		return 1;
	}

	@Override
	public boolean hasStableIds() {
		return false;
	}

	@Override
	public boolean isEmpty() {
		return false;
	}

	@Override
	public void registerDataSetObserver(DataSetObserver observer) {
	}

	@Override
	public void unregisterDataSetObserver(DataSetObserver observer) {
	}
}