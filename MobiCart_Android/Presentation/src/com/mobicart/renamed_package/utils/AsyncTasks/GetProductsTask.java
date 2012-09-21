package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.widget.ListView;
import android.widget.Toast;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.Category;
import com.mobicart.android.core.Department;
import com.mobicart.android.core.Product;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.CategoryTabAct;
import com.mobicart.renamed_package.HomeTabAct;
import com.mobicart.renamed_package.StoreTabGroupAct;
import com.mobicart.renamed_package.utils.adapters.DepartmentsListAdapter;

/**
 * @author mobicart
 * 
 */
public class GetProductsTask extends AsyncTask<String, String, String> {

	private Activity activity;
	private ListView departmentsLV;
	private ProgressDialog progressDialog;
	private int type, isFrom;
	private int departmentId;
	private long categoryId;
	private ArrayList<ProductVO> listToSort = new ArrayList<ProductVO>();
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	public GetProductsTask(Activity activity, ListView departmentsLV, int type) {
		this.activity = activity;
		this.departmentsLV = departmentsLV;
		this.type = type;
		progressDialog = new ProgressDialog(activity.getParent());
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", ""));
		progressDialog.setCancelable(false);
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
	}

	public GetProductsTask(Activity activity, ListView departmentsLV, int type,
			int DepartmentId, long CategoryId) {
		this.activity = activity;
		this.departmentsLV = departmentsLV;
		this.type = type;
		this.departmentId = DepartmentId;
		this.categoryId = CategoryId;
		progressDialog = new ProgressDialog(activity.getParent());
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", ""));
		progressDialog.setCancelable(false);

	}

	public GetProductsTask(Activity activity, ListView departmentsLV, int type,
			int DepartmentId, long CategoryId, int isFrom) {
		this.activity = activity;
		this.departmentsLV = departmentsLV;
		this.type = type;
		this.isFrom = isFrom;
		this.departmentId = DepartmentId;
		this.categoryId = CategoryId;
		progressDialog = new ProgressDialog(activity.getParent());
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
	protected String doInBackground(String... urls) {
		if (type == StoreTabGroupAct.TYPE_DEPARTMENTS) {// departments
			if (!getDepartments(getCurrentStoreId())) {
				return "FALSE";
			} else {
				return "TRUE";
			}
		} else if (type == StoreTabGroupAct.TYPE_CATEGORIES) {
			if (!getCategories(getCurrentStoreId(),
					(int) CategoryTabAct.currentDepartmentId)) {
				return "FALSE";
			} else {
				return "TRUE";
			}

		} else if (type == StoreTabGroupAct.TYPE_SUBCATEGORIES) {
			if (!getSubCategories(departmentId, categoryId)) {
				return "FALSE";
			} else {
				return "TRUE";
			}
		} else if (type == StoreTabGroupAct.TYPE_PRODUCTS) {
			if (HomeTabAct.currentOrder == HomeTabAct.ORDER_PRODUCT_SEARCH) {
				globalSearch(HomeTabAct.searchQuery);
				return "TRUE";
			} else {
				if (isFrom != 1) {
					if (!getProducts(getCurrentStoreId(), departmentId,
							(int) categoryId)) {
						return "FALSE";
					} else {
						return "TRUE";
					}
				} else {
					if (!getProductsFromDepartment(getCurrentStoreId(),
							departmentId)) {
						return "FALSE";
					} else {
						return "TRUE";
					}
				}
			}
		}
		return "FALSE";
	}

	private boolean getSubCategories(int departmentId2, long categoryId2) {
		Category category = new Category();
		try {
			MobicartCommonData.subCategoriesList = category.getSubCategory(
					activity, getCurrentStoreId(), (int) categoryId2);
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

	@Override
	protected void onPostExecute(String result) {
		if (result.equalsIgnoreCase("FALSE")) {
			if (isNetworkNotAvailable)
				showNetworkError();
			else
				showServerError();
		} else {
			if (type == StoreTabGroupAct.TYPE_CATEGORIES
					|| type == StoreTabGroupAct.TYPE_DEPARTMENTS) {
				departmentsLV.setAdapter(new DepartmentsListAdapter(activity,
						type));
			}
			if (type == StoreTabGroupAct.TYPE_SUBCATEGORIES) {
				departmentsLV.setAdapter(new DepartmentsListAdapter(activity,
						type));
			}
			if (type == StoreTabGroupAct.TYPE_PRODUCTS) {
				sortingByPrice();
				departmentsLV.setAdapter(new DepartmentsListAdapter(activity,
						StoreTabGroupAct.TYPE_PRODUCTS, listToSort
								.toArray(new ProductVO[] {})));
			}
		}
		try {
			progressDialog.dismiss();
			progressDialog = null;
		} catch (Exception e) {
		}
		super.onPostExecute(result);
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(this.activity
				.getParent()).create();
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
						activity.getParent().startActivity(intent);
						activity.getParent().finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(this.activity
				.getParent()).create();
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

	private Boolean getDepartments(int storeId) {
		Department department = new Department();
		try {
			MobicartCommonData.departmentsList = department
					.getStoreDepartments(activity,
							MobicartCommonData.appIdentifierObj.getStoreId());
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

	private boolean getCategories(int storeId, int departmentId) {

		Category category = new Category();
		try {
			MobicartCommonData.categoriesList = category
					.getStoreSubDepartments(activity, storeId, departmentId);
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

	private boolean getProducts(int storeId, int departmentId, int categoryId) {
		Product product = new Product();
		try {
			MobicartCommonData.productsList = product
					.getCategoryProductsByCountryStateStore(activity, storeId,
							departmentId, categoryId,
							MobicartCommonData.territoryId,
							MobicartCommonData.stateId);
			return true;
		} catch (JSONException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			return false;
		} catch (NullPointerException e) {
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

	private boolean getProductsFromDepartment(int storeId, int departmentId) {
		Product product = new Product();
		try {
			MobicartCommonData.productsList = product
					.getCategoryProductsFromDepartmentByCountryStateStore(
							activity, storeId, departmentId,
							MobicartCommonData.territoryId,
							MobicartCommonData.stateId);
			return true;
		} catch (JSONException e) {
			return false;
		} catch (NullPointerException e) {
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

	private int getCurrentStoreId() {
		return MobicartCommonData.appIdentifierObj.getStoreId();
	}

	private void globalSearch(String query) {
		Product product = new Product();
		try {
			MobicartCommonData.productsList = product
					.getproductsBySearchWithCountryAndState(activity,
							MobicartCommonData.appIdentifierObj.getAppId(),
							query, departmentId,
							MobicartCommonData.territoryId,
							MobicartCommonData.stateId);
		} catch (JSONException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			Toast.makeText(
					this.activity,
					MobicartCommonData.keyValues.getString(
							"key.iphone.server.notresp.text",
							"Server not Responding"), Toast.LENGTH_LONG).show();
		} catch (NullPointerException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
		} catch (CustomException e) {
			isNetworkNotAvailable = true;
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
		}
	}

	private void sortingByPrice() {
		listToSort = MobicartCommonData.productsList;
		Collections.sort(listToSort, new Comparator<ProductVO>() {
			@Override
			public int compare(ProductVO object1, ProductVO object2) {
				float price1 = (float) object1.getfPrice();
				float price2 = (float) object2.getfPrice();
				if (price1 > price2) {
					return 1;
				} else if (price1 < price2) {
					return -1;
				} else {
					return 0;
				}
			}
		});
	}
}
