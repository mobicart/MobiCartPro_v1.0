package com.mobicart.renamed_package.utils.AsyncTasks;

import java.util.ArrayList;
import org.json.JSONException;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.widget.ListView;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.Product;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.database.MobicartDbConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.android.model.WishListVO;
import com.mobicart.renamed_package.utils.adapters.WishListAdapter;

/**
 * @author mobicart
 *
 */
public class GetWishListProductTask extends AsyncTask<String, String, String>{
	@SuppressWarnings("unused")
	private final String TAG="--->>>GetProductOrderTask<<<---";
	private Activity currentactivity;
	private ListView wishProductLV;
	private ProgressDialog progressDialog;
	private int wishListProuctId;
	private ArrayList<WishListVO> wishList;
	private ArrayList<ProductVO> getWishListVO;
	private ProductVO wishListPVO;
	private DataBaseAccess database;
	private boolean isNetworkNotAvailable = false;
	/**
	 * @param activity
	 * @param orderListView
	 * @param email2
	 */
	public GetWishListProductTask(Activity activity, ListView wishListView){
		this.wishProductLV=wishListView;
		this.currentactivity= activity;
		progressDialog = new ProgressDialog(activity.getParent());
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage(MobicartCommonData.keyValues.getString("key.iphone.LoaderText", ""));
		progressDialog.setCancelable(false);
		database=new DataBaseAccess(this.currentactivity);
		wishList = database.GetRows("SELECT * from "
				+ MobicartDbConstants.TBL_WISHLIST, new WishListVO());
		getWishListVO=new ArrayList<ProductVO>();
	}
	@Override
	protected void onPreExecute() {
		progressDialog.show();
		
		
		super.onPreExecute();
	}
	@Override
	protected String doInBackground(String... params) {
		
			if(!getWishListProduct()){return "FALSE";}
			else
			{return "TRUE";}
					
		
	}
	private boolean getWishListProduct() {
			
		Product product=new Product();
		
		wishListPVO=new ProductVO();
		getWishListVO.clear();
		for(int i=0;i<wishList.size();i++)
		{
			wishListProuctId=wishList.get(i).getProductId();
			
				try {
					wishListPVO=product.getProductDetailsByCountryStateStore(currentactivity,wishListProuctId,MobicartCommonData.territoryId,
							MobicartCommonData.stateId);
					if(wishListPVO.getsStatus().equals("hidden"))
					{
						// code to delete from wishlist
						continue;
					}
				}catch (NullPointerException e) {
					e.printStackTrace();
			       return false;
				} catch (JSONException e) {
					
					// IF product is not found on server => its deteted from server then skip product from wishlist & delete it
					DataBaseAccess database=new DataBaseAccess(this.currentactivity);
					database.deleteWishListItemFromOptionTableWithProductId(wishListProuctId);
					e.printStackTrace();
					continue;
					/*e.printStackTrace();
					return false;	*/		
				} catch (CustomException e) {
					e.printStackTrace();
					isNetworkNotAvailable=true;
					return false;
				}
				getWishListVO.add(wishListPVO);
			}
			
		return true;
	}
	@Override
	protected void onPostExecute(String result) {
		if(result.equalsIgnoreCase("FALSE")){
			if(isNetworkNotAvailable)
				showNetworkError();
			else
			showServerError();
		}else
		{
		wishProductLV.setAdapter(new WishListAdapter(currentactivity,getWishListVO));
		}
		try{
			  progressDialog.dismiss();
			  progressDialog=null;
			         }
			         catch(Exception e){
			          
			          
			         }
		super.onPostExecute(result);
	}
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(currentactivity).create();
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
						currentactivity.startActivity(intent);
						currentactivity.finish();
					}
				});
		alertDialog.show();		
	}
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(this.currentactivity)
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
