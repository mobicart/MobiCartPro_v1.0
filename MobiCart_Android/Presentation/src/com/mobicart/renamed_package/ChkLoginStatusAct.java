package com.mobicart.renamed_package;

import java.util.ArrayList;

import android.app.Activity;

import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.TaxVO;
import com.mobicart.renamed_package.database.DataBaseAccess;

/**
 * This Class is used to check Account is created by user or not and fetch
 * country and state Id of user..
 * 
 * @author mobicart
 * 
 */
public class ChkLoginStatusAct {
	private Activity mainContext;
	private DataBaseAccess objDataBaseAccess;
	private GetCountryNStateAct getCountryNState;
	private ArrayList<TaxVO> taxListVO;
	private int stateIDs = 0;

	public ChkLoginStatusAct(Activity context) {
		mainContext = context;
		objDataBaseAccess = new DataBaseAccess(mainContext);
		getCountryNState = new GetCountryNStateAct(mainContext);
	}

	/**
	 * This method need access to database to check account is created or not
	 * and fetch country or state Id.
	 */
	public void chkUserExistOrNot() {
		objDataBaseAccess.GetRow("Select * from tblAccountDetails where _id=1",
				MobicartCommonData.objAccountVO);
		if (MobicartCommonData.objAccountVO.get_id() > 0) {
			MobicartCommonData.territoryId = getCountryNState
					.checkId(MobicartCommonData.objAccountVO
							.getsDeliveryCountry());
			MobicartCommonData.stateId = getCountryNState
					.checkstateId(MobicartCommonData.objAccountVO
							.getsDeliveryState());
		} else {
			MobicartCommonData.territoryId = MobicartCommonData.storeVO
					.getTerritoryId();
			taxListVO = new ArrayList<TaxVO>(MobicartCommonData.storeVO
					.getTaxList().size());
			taxListVO = MobicartCommonData.storeVO.getTaxList();

			for (int j = 0; j < taxListVO.size(); j++) {
				if (taxListVO.get(j).getTerritoryId() == MobicartCommonData.territoryId
						&& taxListVO.get(j).getsState().equalsIgnoreCase(
								"Other")) {
					stateIDs = taxListVO.get(j).getStateId();
				}
			}
			MobicartCommonData.stateId = stateIDs;
		}
	}
}
