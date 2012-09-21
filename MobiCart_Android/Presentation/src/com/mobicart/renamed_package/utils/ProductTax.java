package com.mobicart.renamed_package.utils;

import java.util.ArrayList;

import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;

/**
 * This Class is used for calculating product cost,tax and tax shipping for a
 * product.
 * 
 * @author mobicart
 * 
 */
public class ProductTax {

	/**
	 * @param product
	 * @return
	 */
	public static double caluateTaxForProductInShoppingCart(ProductVO product) {
		double productCost = 0;
		double discountedPrice = product.getfDiscountedPrice();
		if (product.getbTaxable() && MobicartCommonData.storeVO.isbIncludeTax()) {
			if (product.getfPrice() > discountedPrice) {
				productCost = (float) product.getfTax();
			} else {
				productCost = (float) (product.getfPrice() + product.getfTax());
			}
		} else {
			if (product.getfPrice() > discountedPrice) {
				productCost = discountedPrice;

			} else {
				productCost = (float) product.getfPrice();
			}
		}
		return productCost;
	}

	/**
	 * @param product
	 * @return
	 */
	public static double calculateActualPriceWithoutTax(ProductVO product) {
		double productCost = 0;
		float discount = product.getfDiscount();
		if (discount != 0) {
			if (product.getfPrice() >= discount) {
				productCost = product.getfDiscountedPrice();
			}
		} else {
			productCost = product.getfPrice();
		}
		return productCost;
	}

	/**
	 * @param product
	 * @return
	 */
	public static Double calculateFinalPrice(ProductVO product) {
		double productCost = 0;
		float discount = product.getfDiscount();
		if (discount != 0) {
			if (product.getfPrice() >= discount) {
				productCost = product.getfDiscountedPrice();
			} else {
				productCost = product.getfPrice();
			}
		} else {
			productCost = product.getfPrice();
		}
		if (product.getbTaxable() && MobicartCommonData.storeVO.isbIncludeTax()) {

			try {
				if (!product.getsTaxType().equalsIgnoreCase("default")) {
					productCost = productCost
							+ (productCost * product.getfTax()) / 100;
				} else {
					productCost = product.getfDiscountedPrice();
				}
			} catch (NullPointerException e) {
			}

		} else {
			productCost = product.getfDiscountedPrice();
		}
		return productCost;
	}

	/**
	 * 
	 * @param product
	 * @return
	 */
	public static String calculateTaxByUserLocation(ProductVO product) {
		String tax = "";
		double productCost = 0;

		float discount = product.getfDiscount();

		if (discount != 0) {
			if (product.getfPrice() >= discount) {
				productCost = product.getfDiscountedPrice();
			}
		} else {
			productCost = product.getfPrice();
		}
		if (product.getbTaxable() && MobicartCommonData.storeVO.isbIncludeTax()) {
			productCost = productCost
					+ (productCost * MobicartCommonData.tax.getfTax()) / 100;
			try {
				if (!product.getsTaxType().equalsIgnoreCase("default")) {
					tax = "" + "Inc. " + product.getsTaxType().trim();
				}
			} catch (NullPointerException e) {
			}
		}
		return tax;

	}

	/**
	 * @param product
	 * @return
	 */
	public static String caluateTaxForProduct(ProductVO product) {

		double productCost = 0;
		String strFinalPrice = "";
		float discount = product.getfDiscount();
		if (discount != 0) {
			if (product.getfPrice() >= discount) {
				productCost = product.getfDiscountedPrice();
			}
		} else {
			productCost = product.getfPrice();
		}
		if (product.getbTaxable() && MobicartCommonData.storeVO.isbIncludeTax()) {
			productCost = productCost + product.getfTax();
			try {
				if (!product.getsTaxType().equalsIgnoreCase("default")) {
					strFinalPrice = "" + "Inc. " + product.getsTaxType().trim();
				}
			} catch (NullPointerException e) {
			}
		}
		return strFinalPrice.trim();
	}

	/**
	 * @param product
	 * @return
	 */
	public static Double caluateTaxForProductWithoutIncByUserLocation(
			ProductVO product) {
		double productCost = 0;

		productCost = product.getfPrice();
		if (product.getbTaxable() && MobicartCommonData.storeVO.isbIncludeTax()) {
			productCost = productCost
					+ (productCost * MobicartCommonData.tax.getfTax()) / 100;
		}
		return productCost;
	}

	/**
	 * @param product
	 * @return
	 */
	public static Double caluateTaxForProductWithoutInc(ProductVO product) {
		double productCost = 0;
		productCost = product.getfPrice();
		if (product.getbTaxable() && MobicartCommonData.storeVO.isbIncludeTax()) {
			productCost = productCost + product.getfTax();
		}
		return productCost;
	}

	/**
	 * @param product
	 * @param productsInCart
	 * @return
	 */
	public float calculateShippingChargesForProduct(ProductVO product,
			ArrayList<ProductVO> productsInCart) {
		@SuppressWarnings("unused")
		float shippingCharges = 0.0f;
		if (productsInCart.size() > 1) {
			// shippingCharges=new ShippingVO().getfOther()product;
		}
		return 0;
	}

	/**
	 * @param product
	 * @return
	 */
	public static Double calculateFinalPriceByUserLocation(ProductVO product) {
		double productCost = 0;

		float discount = product.getfDiscount();
		if (discount != 0) {

		} else {
			productCost = product.getfPrice();
		}
		if (MobicartCommonData.storeVO.isbIncludeTax()) {
			if (product.getbTaxable()) {
				if (product.getfPrice() >= discount) {
					productCost = product.getfDiscountedPrice();
					try {
						if (!product.getsTaxType().equalsIgnoreCase("default")) {
							productCost = productCost
									+ (productCost * MobicartCommonData.tax
											.getfTax()) / 100;
						} else {
						}
					} catch (NullPointerException e) {
					}
				} else {
					productCost = product.getfPrice();
					productCost = product.getfDiscountedPrice()
							+ product.getfTax();
				}
			}
		} else {
			productCost = product.getfDiscountedPrice();
		}
		float p = (float) Math.pow(10, 2);
		productCost = productCost * p;
		float tmp = Math.round(productCost);
		productCost = tmp / p;
		return productCost;
	}
}
