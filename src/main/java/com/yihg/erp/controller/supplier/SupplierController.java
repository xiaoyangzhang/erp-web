package com.yihg.erp.controller.supplier;

import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.contants.BasicConstants;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierBankaccountDTO;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierBillDTO;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierContactManDTO;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierGuideDTO;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierInfoDTO;
import com.yimayhd.erpcenter.facade.supplier.result.AddSupplierResult;
import com.yimayhd.erpcenter.facade.supplier.result.BusinessInfoResult;
import com.yimayhd.erpcenter.facade.supplier.result.ContactManListResult;
import com.yimayhd.erpcenter.facade.supplier.result.EditSupplierResult;
import com.yimayhd.erpcenter.facade.supplier.result.FolderListResult;
import com.yimayhd.erpcenter.facade.supplier.result.GuideAddResult;
import com.yimayhd.erpcenter.facade.supplier.result.GuideListResult;
import com.yimayhd.erpcenter.facade.supplier.result.PictureListResult;
import com.yimayhd.erpcenter.facade.supplier.result.SuplierListResult;
import com.yimayhd.erpcenter.facade.supplier.result.WebResult;
import com.yimayhd.erpcenter.facade.supplier.service.SupplierFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.po.SupplierBankaccount;
import com.yimayhd.erpresource.dal.po.SupplierBill;
import com.yimayhd.erpresource.dal.po.SupplierContactMan;
import com.yimayhd.erpresource.dal.po.SupplierGuide;
import com.yimayhd.erpresource.dal.po.SupplierInfo;

@Controller
@RequestMapping(value = "/supplier")
public class SupplierController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(SupplierController.class);
	private Constants constants;
	@Autowired
	private SupplierFacade supplierFacade;
	@Autowired
	private SysConfig config;
	@RequestMapping(value = "/deleteSupplierItem.htm")
	@ResponseBody
	public String deleteSupplierItem(Integer id) {
		WebResult<Boolean> webResult = supplierFacade.deleteSupplierItem(id);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

	/**
	 * 打开地图
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param address
	 * @param lon
	 * @param lat
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value = "baiduMap.htm", method = RequestMethod.GET)
	public String hotelMap(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String address,
			String lon, String lat) throws UnsupportedEncodingException {
		address = new String(address.getBytes("iso-8859-1"), "utf-8");
		model.addAttribute("address", address);
		model.addAttribute("lon", lon);
		model.addAttribute("lat", lat);
		return "/baiduMap/baiduMap";
	}

	/**
	 * 跳转到添加供应商页面
	 *
	 * @return
	 */
	@RequestMapping(value = "toAddSupplier.htm")
	public String toAddSupplier(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer supplierType) {
		AddSupplierResult webResult = supplierFacade.toAddSupplier();
		
		model.addAttribute("supplierType", supplierType);
		model.addAttribute("allProvince", webResult.getAllProvince());

		model.addAttribute("travelagencylevelList", webResult.getTravelagencylevelList());

		model.addAttribute("restaurantlevelList", webResult.getRestaurantlevelList());

		model.addAttribute("levelList", webResult.getLevelList());

		model.addAttribute("fleetlevelList", webResult.getFleetlevelList());

		model.addAttribute("scenicspotlevelList", webResult.getScenicspotlevelList());

		model.addAttribute("shoppinglevelList", webResult.getShoppinglevelList());

		model.addAttribute("entertainmentlevelList", webResult.getEntertainmentlevelList());

		model.addAttribute("guidelevelList", webResult.getGuidelevelList());

		model.addAttribute("airticketagentlevelList", webResult.getAirticketagentlevelList());

		model.addAttribute("trainticketagentlevelList",webResult.getTrainticketagentlevelList());

		model.addAttribute("golflevelList", webResult.getGolflevelList());

		model.addAttribute("insuranclevelList", webResult.getInsuranclevelList());

		model.addAttribute("otherlevelList", webResult.getOtherlevelList());

		model.addAttribute("localtravelList", webResult.getLocaltravelList());

		return "supplier/addInfo";
	}

	/**
	 * 跳转到供应商编辑页面
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "toEditSupplier.htm")
	public String toEditSupplier(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id,
			Integer operType) {
		// type=1编辑 type=0 查看
		model.addAttribute("operType", operType);
		EditSupplierResult webResult = supplierFacade.toEditSupplier(id, operType);
		
		model.addAttribute("allProvince", webResult.getAllProvince());

		model.addAttribute("cityList", webResult.getCityList());

		model.addAttribute("areaList", webResult.getAreaList());

		model.addAttribute("townList", webResult.getTownList());

		model.addAttribute("supplierInfo", webResult.getSupplierInfo());
		model.addAttribute("travelagencylevelList", webResult.getTrainticketagentlevelList());

		model.addAttribute("restaurantlevelList", webResult.getRestaurantlevelList());

		model.addAttribute("levelList", webResult.getLevelList());

		model.addAttribute("fleetlevelList", webResult.getFleetlevelList());

		model.addAttribute("scenicspotlevelList", webResult.getScenicspotlevelList());

		model.addAttribute("shoppinglevelList", webResult.getShoppinglevelList());

		model.addAttribute("entertainmentlevelList", webResult.getEntertainmentlevelList());

		model.addAttribute("guidelevelList", webResult.getGuidelevelList());

		model.addAttribute("airticketagentlevelList", webResult.getAirticketagentlevelList());

		model.addAttribute("trainticketagentlevelList",webResult.getTrainticketagentlevelList());

		model.addAttribute("golflevelList", webResult.getGolflevelList());

		model.addAttribute("insuranclevelList", webResult.getInsuranclevelList());

		model.addAttribute("otherlevelList", webResult.getOtherlevelList());

		model.addAttribute("localtravelList", webResult.getLocaltravelList());
		model.addAttribute("bizId", WebUtils.getCurBizId(request));

		model.addAttribute("supplierItems", webResult.getSupplierItems());
		return "supplier/editInfo";
	}

	/**
	 * 验证当前供应商类别下全称是否存在
	 *
	 * @param request
	 * @param reponse
	 * @param supplierId
	 * @param mobile
	 * @return
	 */
	@RequestMapping(value = "verifyNameFull.do", method = RequestMethod.POST)
	@ResponseBody
	public String verifyNameFull(HttpServletRequest request,
			HttpServletResponse reponse, Integer supplierId,
			Integer supplierType, String nameFull) {
		
		WebResult<String> webResult = supplierFacade.verifyNameFull(supplierId, supplierType, nameFull);
		if(webResult.isSuccess()){
			return webResult.getValue();
		}else{
			return "false";
		}
	}

	/**
	 * 添加供应商
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param supplierInfo
	 * @return
	 */
	@RequestMapping(value = "saveSupplier.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveRest(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo, String items) {
		SupplierInfoDTO supplierInfoDTO  = new SupplierInfoDTO();
		supplierInfoDTO.setSupplierInfo(supplierInfo);
		WebResult<String> webResult = supplierFacade.saveRest(supplierInfoDTO, items, WebUtils.getCurBizId(request));
		
		if(webResult.isSuccess()){
			return successJson("id", webResult.getValue());
		}else{
			log.error(webResult.getResultMsg());
			return errorJson("操作失败");
		}
	}

	/**
	 * 编辑供应商
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param supplierInfo
	 * @return
	 */
	@RequestMapping(value = "editSupplier.do", method = RequestMethod.POST)
	@ResponseBody
	public String editRest(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo, String items) {
		SupplierInfoDTO supplierInfoDTO  = new SupplierInfoDTO();
		supplierInfoDTO.setSupplierInfo(supplierInfo);
		WebResult<Boolean> webResult = supplierFacade.editRest(supplierInfoDTO, items);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson("操作失败");
		}
	}

	/**
	 * 启用停用
	 *
	 * @param request
	 * @param reponse
	 * @param supplierId
	 * @param state
	 * @return
	 */
	@RequestMapping(value = "changeState.do", method = RequestMethod.GET)
	@ResponseBody
	public String changeState(HttpServletRequest request,
			HttpServletResponse reponse, Integer supplierId, Integer state) {
		WebResult<Boolean> webResult = supplierFacade.changeState(supplierId, state);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson("操作失败");
		}
	}

	/**
	 * 删除供应商
	 *
	 * @param request
	 * @param reponse
	 * @param supplierId
	 * @return
	 */
	@RequestMapping(value = "delSupplier.do", method = RequestMethod.GET)
	@ResponseBody
	public String delSupplier(HttpServletRequest request,
			HttpServletResponse reponse, Integer supplierId) {
		WebResult<Boolean> webResult = supplierFacade.delSupplier(WebUtils.getCurBizId(request), supplierId);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 判断是否存在相应订单业务
	 * @param supplierId
	 * @return
	 */
//	public String existOrderServer(int supplierId) {
//		
//		return "";
//	}
	
	

	@RequestMapping(value="fixSupplier.do", method = RequestMethod.GET)
	@ResponseBody
	public String fixSupplierName(Integer supplierId, Integer supplierType, String supplierName) throws UnsupportedEncodingException {
		//supplierName = new String(supplierName.getBytes("iso-8859-1"),"GB2312");
		WebResult<Boolean> webResult = supplierFacade.fixSupplierName(supplierId, supplierType, supplierName);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}
	
	public String isUpdate(boolean flag) {
		if (!flag) {
			return errorJson("更新失败");
		}
		return "";
	}
	
	
	/**
	 * 跳转到银行、发票等其他信息页
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param supplierId
	 * @return
	 */
	@RequestMapping(value = "toBusinessInfo.htm")
	public String toBusinessInfo(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer supplierId,
			Integer operType) {
		model.addAttribute("operType", operType);
		BusinessInfoResult webResul = supplierFacade.toBusinessInfo(supplierId);
		
		model.addAttribute("supplierVO", webResul.getSupplierVO());
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("supplierType", webResul.getSupplierType());

		model.addAttribute("bankList", webResul.getBankList());

		return "supplier/businessInfo";
	}

	/**
	 * 添加银行帐号信息
	 *
	 * @param request
	 * @param reponse
	 * @param supplierBankaccount
	 */
	@RequestMapping(value = "addBankInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String addBankInfo(HttpServletRequest request,
			HttpServletResponse reponse, SupplierBankaccount supplierBankaccount) {
		SupplierBankaccountDTO supplierBankaccountDTO = new SupplierBankaccountDTO();
		supplierBankaccountDTO.setSupplierBankaccount(supplierBankaccount);
		WebResult<Boolean> webResult = supplierFacade.addBankInfo(supplierBankaccountDTO);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 查找所编辑的银行信息
	 *
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "getBankInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public String getBankInfo(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		WebResult<SupplierBankaccount> webResult = supplierFacade.getBankInfo(id);

		Gson gson = new Gson();
		String string = gson.toJson(webResult.getValue());

		return string;
	}

	/**
	 * 编辑银行账号信息
	 *
	 * @param request
	 * @param reponse
	 * @param supplierBankaccount
	 * @return
	 */
	@RequestMapping(value = "editBankInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String editBankInfo(HttpServletRequest request,
			HttpServletResponse reponse, SupplierBankaccount supplierBankaccount) {
		SupplierBankaccountDTO supplierBankaccountDTO = new SupplierBankaccountDTO();
		supplierBankaccountDTO.setSupplierBankaccount(supplierBankaccount);
		WebResult<Boolean> webResult = supplierFacade.editBankInfo(supplierBankaccountDTO);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 删除银行帐号信息
	 *
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delBankInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public String delBankInfo(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		WebResult<Boolean> webResult = supplierFacade.delBankInfo(id);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 添加发票信息
	 *
	 * @param request
	 * @param reponse
	 * @param supplierBill
	 */
	@RequestMapping(value = "addBillInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String addBillInfo(HttpServletRequest request,
			HttpServletResponse reponse, SupplierBill supplierBill) {
		
		SupplierBillDTO supplierBillDTO = new SupplierBillDTO();
		supplierBillDTO.setSupplierBill(supplierBill);
		WebResult<Boolean> webResult = supplierFacade.addBillInfo(supplierBillDTO);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 设置为默认发票
	 *
	 * @param request
	 * @param reponse
	 * @param billId
	 * @param supplierId
	 * @return
	 */
	@RequestMapping(value = "setDefault.do", method = RequestMethod.GET)
	@ResponseBody
	public String setDefault(HttpServletRequest request,
			HttpServletResponse reponse, Integer billId, Integer supplierId) {
		WebResult<Boolean> webResult = supplierFacade.setDefault(billId, supplierId);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 查找所编辑的发票信息
	 *
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "getBillInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public String getBillInfo(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		WebResult<SupplierBill> webResult = supplierFacade.getBillInfo(id);
		Gson gson = new Gson();
		String string = gson.toJson(webResult.getValue());
		return string;
	}

	/**
	 * 编辑发票信息
	 *
	 * @param request
	 * @param reponse
	 * @param supplierBill
	 * @return
	 */
	@RequestMapping(value = "editBillInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String editBillInfo(HttpServletRequest request,
			HttpServletResponse reponse, SupplierBill supplierBill) {
		SupplierBillDTO supplierBillDTO = new SupplierBillDTO();
		supplierBillDTO.setSupplierBill(supplierBill);
		WebResult<Boolean> webResult = supplierFacade.editBillInfo(supplierBillDTO);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 删除发票信息
	 *
	 * @param request
	 * @param reponse
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delBillInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public String delBillInfo(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		WebResult<Boolean> webResult = supplierFacade.delBillInfo(id);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 跳转到联系人列表
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "toContactManList.htm")
	public String toContactList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id,
			Integer operType) {
		model.addAttribute("operType", operType);
		ContactManListResult webResult = supplierFacade.toContactList(WebUtils.getCurBizId(request), id);

		model.addAttribute("manList", webResult.getManList());
		model.addAttribute("supplierId", id);

		model.addAttribute("supplierType", webResult.getSupplierType());

		model.addAttribute("allManList", webResult.getAllManList());
		return "supplier/contactManInfo";
	}

	/**
	 * 获取供应商下联系人信息，供列表查看用
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "getContactManList.do")
	@ResponseBody
	public String getContactManList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		WebResult<List<SupplierContactMan>> webResult = supplierFacade.getContactManList(WebUtils.getCurBizId(request), id);
		Gson gson = new Gson();
		String json = gson.toJson(webResult.getValue());
		return json;
	}

	/**
	 * 导入私有联系人
	 *
	 * @param request
	 * @param reponse
	 * @param ids
	 * @param supplierId
	 * @return
	 */
	@RequestMapping(value = "addPrivateMan.do")
	@ResponseBody
	public String addPrivateMan(HttpServletRequest request,
			HttpServletResponse reponse, String ids, Integer supplierId) {
		WebResult<Boolean> webResult = supplierFacade.addPrivateMan(WebUtils.getCurBizId(request), ids, supplierId);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 增加联系人
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "addContactMan.do", method = RequestMethod.POST)
	@ResponseBody
	public String addContactMan(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierContactMan supplierContactMan) {
		SupplierContactManDTO supplierContactManDTO = new SupplierContactManDTO();
		supplierContactManDTO.setSupplierContactMan(supplierContactMan);
		WebResult<Boolean> webResult = supplierFacade.addContactMan(WebUtils.getCurBizId(request), supplierContactManDTO);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 验证当前供应商联系人手机号码是否存在
	 *
	 * @param request
	 * @param reponse
	 * @param supplierId
	 * @param mobile
	 * @return
	 */
	@RequestMapping(value = "verifyMobile.do", method = RequestMethod.POST)
	@ResponseBody
	public String verifyMobile(HttpServletRequest request,
			HttpServletResponse reponse, Integer manId, String mobile) {

		WebResult<String> webResult = supplierFacade.verifyMobile(manId, mobile);
		if(webResult.isSuccess()){
			return webResult.getValue();
		}else{
			log.error(webResult.getResultMsg());
			return "false";
		}
		

	}

	/**
	 * 删除私有联系人信息
	 *
	 * @param request
	 * @param reponse
	 * @param supplierId
	 * @param manId
	 * @return
	 */
	@RequestMapping(value = "delContactMan.do")
	@ResponseBody
	public String delContactMan(HttpServletRequest request,
			HttpServletResponse reponse, Integer supplierId, Integer manId) {
		WebResult<Boolean> webResult = supplierFacade.delContactMan(WebUtils.getCurBizId(request), supplierId, manId);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 查找所编辑的联系人资料
	 *
	 * @param request
	 * @param reponse
	 * @param manId
	 * @return
	 */
	@RequestMapping(value = "getManInfo.do")
	@ResponseBody
	public String getManInfo(HttpServletRequest request,
			HttpServletResponse reponse, Integer manId) {
		WebResult<SupplierContactMan> webResult = supplierFacade.getManInfo(manId);
		SupplierContactMan man = webResult.getValue();
		Date birthDate = man.getBirthDate();
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
		String string = gson.toJson(man);
		return string;
	}

	/**
	 * 编辑联系人
	 *
	 * @param request
	 * @param reponse
	 * @param supplierContactMan
	 * @return
	 */
	@RequestMapping(value = "editContactMan.do")
	@ResponseBody
	public String editContactMan(HttpServletRequest request,
			HttpServletResponse reponse, SupplierContactMan supplierContactMan) {
		SupplierContactManDTO supplierContactManDTO = new SupplierContactManDTO();
		supplierContactManDTO.setSupplierContactMan(supplierContactMan);
		WebResult<Boolean> webResult = supplierFacade.editContactMan(supplierContactManDTO);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson(webResult.getResultMsg());
		}
	}

	/**
	 * 供应商
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toTravelagencyList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_AGENCY)
	public String toTravelagencyList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.TRAVELAGENCY);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 餐厅
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toRestaurantList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_RESTANRANT)
	public String toRestaurant(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.RESTAURANT);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 酒店
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toHotelList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_HOTEL)
	public String toHotelList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.HOTEL);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 车队
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toFleetList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_CAR)
	public String toFleetList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.FLEET);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 景区
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toScenicspotList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_SCENIC)
	public String toScenicspotList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.SCENICSPOT);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 购物
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toShoppingList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_SHOP)
	public String toShoppingList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.SHOPPING);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 娱乐
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toEntertainmentList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_ENTERAINMENT)
	public String toEntertainmentList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.ENTERTAINMENT);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 机票代理
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toAirticketagentList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_AIRTICKET)
	public String toAirticketagentList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.AIRTICKETAGENT);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 火车票代理
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toTrainticketagentList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_TRAIN)
	public String toTrainticketagentList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.TRAINTICKETAGENT);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 高尔夫
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toGolfList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_GOLF)
	public String toGolfList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.GOLF);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 其他
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toOtherList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_OTHER)
	public String toOtherList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.OTHER);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 保险
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toInsuranceList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_INSURANCE)
	public String toInsuranceList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.INSURANCE);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	/**
	 * 地接社
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toLocalTravelList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_LOCALTRAVEL)
	public String toLocalTravelList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		supplierInfo.setSupplierType(Constants.LOCALTRAVEL);
		return toSuplierList(request, reponse, model, supplierInfo);
	}

	@RequestMapping(value = "toSuplierList.htm")
	public String toSuplierList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		// 根据供应商类型查询当前登录商家所属的供应商
		model.addAttribute("supplierInfo", supplierInfo);
		/*
		 * if(null==supplierInfo.getStartTime()&&
		 * null==supplierInfo.getEndTime()){ Calendar c=Calendar.getInstance();
		 * int year=c.get(Calendar.YEAR); int month=c.get(Calendar.MONTH);
		 * SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd"); c.set(year,
		 * month, 1); supplierInfo.setStartTime(c.getTime()); c.set(year, month,
		 * c.getActualMaximum(Calendar.DAY_OF_MONTH));
		 * supplierInfo.setEndTime(c.getTime());
		 * 
		 * }
		 */
		SupplierInfoDTO supplierInfoDTO = new SupplierInfoDTO();
		supplierInfoDTO.setSupplierInfo(supplierInfo);
		SuplierListResult webResult = supplierFacade.toSuplierList(supplierInfoDTO, WebUtils.getCurBizId(request));
		model.addAttribute("page", webResult.getPageBean());
		model.addAttribute("allProvince", webResult.getAllProvince());

		model.addAttribute("cityList", webResult.getCityList());

		model.addAttribute("areaList", webResult.getAreaList());
		model.addAttribute("travelagencylevelList", webResult.getTravelagencylevelList());

		model.addAttribute("restaurantlevelList", webResult.getRestaurantlevelList());

		model.addAttribute("levelList", webResult.getLevelList());

		model.addAttribute("fleetlevelList", webResult.getFleetlevelList());

		model.addAttribute("scenicspotlevelList", webResult.getScenicspotlevelList());

		model.addAttribute("shoppinglevelList", webResult.getShoppinglevelList());

		model.addAttribute("entertainmentlevelList", webResult.getEntertainmentlevelList());

		model.addAttribute("guidelevelList", webResult.getGuidelevelList());

		model.addAttribute("airticketagentlevelList", webResult.getAirticketagentlevelList());

		model.addAttribute("trainticketagentlevelList",
				webResult.getTrainticketagentlevelList());

		model.addAttribute("golflevelList", webResult.getGolflevelList());

		model.addAttribute("insuranclevelList", webResult.getInsuranclevelList());

		model.addAttribute("otherlevelList", webResult.getOtherlevelList());

		model.addAttribute("localtravelList", webResult.getLocaltravelList());
		model.addAttribute("flag", 1);

		return "supplier/privateSupplierList";
	}

	/**
	 * 查找所有供应商
	 *
	 * @param request
	 * @param reponse
	 * @param model
	 * @param supplierInfo
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "toImpSupplierList.htm")
	public String toImpSupplierList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo) {
		SupplierInfoDTO supplierInfoDTO = new SupplierInfoDTO();
		supplierInfoDTO.setSupplierInfo(supplierInfo);
		SuplierListResult webResult = supplierFacade.toImpSupplierList(supplierInfoDTO, WebUtils.getCurBizId(request));
		
		model.addAttribute("page", webResult.getPageBean());
		model.addAttribute("supplierInfo", supplierInfo);
		model.addAttribute("allProvince", webResult.getAllProvince());
		model.addAttribute("cityList", webResult.getCityList());

		model.addAttribute("areaList", webResult.getAreaList());

		model.addAttribute("levelList", webResult.getLevelList());

		model.addAttribute("travelagencylevelList", webResult.getTravelagencylevelList());
		return "supplier/impSupplierList";
	}

	/**
	 * 导入供应商
	 *
	 * @param request
	 * @param reponse
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "impSupplier.do")
	@ResponseBody
	public String impSupplier(HttpServletRequest request,
			HttpServletResponse reponse, String ids) {
		WebResult<Boolean> webResult = supplierFacade.impSupplier(WebUtils.getCurBizId(request), ids);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

	@RequestMapping(value = "guideList.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String guideList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		loadGuideList(model, guide, page, pageSize, null);
		return "supplier/guide/guide-list";
	}

	@RequestMapping(value = "guideList.do", method = RequestMethod.POST)
	@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String guideListQuery(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		loadGuideList(model, guide, page, pageSize, null);
		return "supplier/guide/guide-list-table";
	}

	private void loadGuideList(ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize, Integer bizId) {
		if (page == null) {
			page = 1;
		}
		if (pageSize == null) {
			pageSize = Constants.PAGESIZE;
		}
		
		SupplierGuideDTO guideDTO = new SupplierGuideDTO();
		guideDTO.setSupplierGuide(guide);

		GuideListResult webResult = supplierFacade.loadGuideList(guideDTO, page, pageSize, bizId);
		model.addAttribute("pageBean", webResult.getPageBean());
		model.addAttribute("allProvince", webResult.getAllProvince());
		model.addAttribute("images_source", config.getImages200Url());
	}

	private void loadMyGuideList(HttpServletRequest request, ModelMap model,
			SupplierGuide guide, Integer page, Integer pageSize) {
		if (page == null) {
			page = 1;
		}
		if (pageSize == null) {
			pageSize = Constants.PAGESIZE;
		}

		Integer bizId = WebUtils.getCurBizId(request);
		
		SupplierGuideDTO guideDTO = new SupplierGuideDTO();
		guideDTO.setSupplierGuide(guide);

		GuideListResult webResult = supplierFacade.loadMyGuideList(guideDTO, page, pageSize, bizId);
		model.addAttribute("pageBean", webResult.getPageBean());
		model.addAttribute("allProvince", webResult.getAllProvince());
		model.addAttribute("images_source", config.getImages200Url());

	}

	@RequestMapping(value = "addGuide.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String guideAdd(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		GuideAddResult webResult = supplierFacade.guideAdd();
		model.addAttribute("mzList", webResult.getMzList());
		model.addAttribute("djList", webResult.getDjList());
		model.addAttribute("xjpdList", webResult.getXjpdList());
		model.addAttribute("shdtrsList", webResult.getShdtrsList());

		model.addAttribute("allProvince", webResult.getAllProvince());
		return "supplier/guide/add-guide";
	}

	@RequestMapping(value = "editGuide.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String editGuide(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		GuideAddResult webResult = supplierFacade.editGuide(id);
		model.addAttribute("mzList", webResult.getMzList());
		model.addAttribute("djList", webResult.getDjList());
		model.addAttribute("xjpdList", webResult.getXjpdList());
		model.addAttribute("shdtrsList", webResult.getShdtrsList());

		model.addAttribute("images_source", config.getImages200Url());

		model.addAttribute("allProvince", webResult.getAllProvince());
		SupplierGuide guide = null;
		guide = webResult.getSupplierGuide();
		model.addAttribute("guide", guide);
		if (guide.getProvinceId() != null) {
			model.addAttribute("cityList", webResult.getCityList());
		}
		if (guide.getCityId() != null) {
			model.addAttribute("areaList", webResult.getAreaList());
		}
		if (guide.getAreaId() != null) {
			model.addAttribute("townList", webResult.getTownList());
		}

		return "supplier/guide/edit-guide";
	}
	
	@RequestMapping(value = "guideDetail.htm")
	//@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String guideDetail(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		GuideAddResult webResult = supplierFacade.guideDetail(id);
		model.addAttribute("mzList", webResult.getMzList());
		model.addAttribute("djList", webResult.getDjList());
		model.addAttribute("xjpdList", webResult.getXjpdList());
		model.addAttribute("shdtrsList", webResult.getShdtrsList());

		model.addAttribute("images_source", config.getImages200Url());

		model.addAttribute("allProvince", webResult.getAllProvince());
		SupplierGuide guide = null;
		guide = webResult.getSupplierGuide();
		model.addAttribute("guide", guide);
		if (guide.getProvinceId() != null) {
			model.addAttribute("cityList", webResult.getCityList());
		}
		if (guide.getCityId() != null) {
			model.addAttribute("areaList", webResult.getAreaList());
		}
		if (guide.getAreaId() != null) {
			model.addAttribute("townList", webResult.getTownList());
		}
		return "supplier/guide/guide-detail";
	}

	@RequestMapping(value = "delGuide.do")
	@ResponseBody
	public String delGuide(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		WebResult<Boolean> webResult = supplierFacade.delGuide(WebUtils.getCurBizId(request), id);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
	}

	@RequestMapping(value = "delPublicGuide.do")
	@ResponseBody
	public String delPublicGuide(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {

		WebResult<Boolean> webResult = supplierFacade.delPublicGuide(id);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
	}

	@RequestMapping(value = "saveGuide.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveGuide(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide) {
		SupplierGuideDTO guideDTO  = new SupplierGuideDTO();
		guideDTO.setSupplierGuide(guide);
		WebResult<Map<String,Object>> webResult = supplierFacade.saveGuide(guideDTO,WebUtils.getCurBizId(request));
		if(webResult.isSuccess()){
			Map<String, Object> map = webResult.getValue();
			if(map.get("guideId")!=null){
				return successJson(map);
			}
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}

	@RequestMapping(value = "guideArchivesList.htm")
	@RequiresPermissions(value=PermissionConstants.SUPPLIER_GUIDE)
	public String guideArchivesList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		WebResult<List<DicInfo>> webResult = supplierFacade.getListByTypeCode(BasicConstants.DYXX_DJ);
		model.addAttribute("djList", webResult.getValue());
		loadMyGuideList(request, model, guide, page, pageSize);
		return "supplier/guide/guideArchivesList";
	}

	@RequestMapping(value = "guideArchivesList.do", method = RequestMethod.POST)
	public String queryGuideArchivesList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		loadMyGuideList(request, model, guide, page, pageSize);
		return "supplier/guide/guideArchivesList-table";
	}

	@RequestMapping(value = "impGuideArchivesList.htm")
	public String impGuideArchivesList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		Integer bizId = WebUtils.getCurBizId(request);
		loadGuideList(model, guide, page, pageSize, bizId);
		WebResult<List<DicInfo>> webResult = supplierFacade.getListByTypeCode(BasicConstants.DYXX_DJ);
		model.addAttribute("djList", webResult.getValue());
		return "supplier/guide/impGuideArchivesList";
	}

	@RequestMapping(value = "impGuideArchivesList.do", method = RequestMethod.POST)
	public String queryImpGuideArchivesList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		Integer bizId = WebUtils.getCurBizId(request);
		loadGuideList(model, guide, page, pageSize, bizId);
		return "supplier/guide/impGuideArchivesList-table";
	}

	@RequestMapping(value = "expGuide.do")
	public String expGuide(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, SupplierGuide guide)
			throws Exception {
		String excelHeader[] = { "等级", "星级", "姓名", "性别", "身份证号", "导游证号", "手机",
				"语种", "民族", "籍贯" };
		int excelHeaderWidth[] = { 100, 100, 100, 100, 200, 200, 100, 100, 100,
				150 };

		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Sheet1");
		// 设置列宽度（像素）
		for (int i = 0; i < excelHeaderWidth.length; i++) {
			sheet.setColumnWidth(i, 32 * excelHeaderWidth[i]);
		}
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, excelHeader.length-1));
		HSSFRow row = sheet.createRow((int) 0);
		HSSFCell titleCell = row.createCell(0);
		// 设置标题样式
		HSSFCellStyle titleStyle = wb.createCellStyle();
		titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平居中
		titleStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER); // 垂直居中
		titleStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		titleStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		titleStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		titleStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		HSSFFont font = wb.createFont();
		font.setFontName("黑体");
		font.setFontHeightInPoints((short) 16);// 设置字体大小
		titleStyle.setFont(font);

		titleCell.setCellValue("导游档案表");
		titleCell.setCellStyle(titleStyle);

		// 设置标题头样式
		HSSFCellStyle headerStyle = wb.createCellStyle();
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平居中
		headerStyle.setFillBackgroundColor(HSSFColor.GREY_25_PERCENT.index);// 设置背景色
		headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);// 设置前景色
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		font = wb.createFont();
		font.setFontName("黑体");
		font.setFontHeightInPoints((short) 13);// 设置字体大小
		headerStyle.setFont(font);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER); // 垂直居中
		HSSFRow headerRow = sheet.createRow((int) 1);
		for (int i = 0; i < excelHeader.length; i++) {
			HSSFCell cell = headerRow.createCell(i);
			cell.setCellStyle(headerStyle);
			cell.setCellValue(excelHeader[i]);
		}
		Integer bizId = WebUtils.getCurBizId(request);
//		PageBean pageBean = guideService.getGuideListByBizId(guide, bizId, 1,
//				100000);
		SupplierGuideDTO guideDTO = new SupplierGuideDTO();
		guideDTO.setSupplierGuide(guide);
		WebResult<PageBean> webResult = supplierFacade.expGuide(guideDTO, bizId, 1, 100000);
		PageBean pageBean = webResult.getValue();
		// 设置水平居中样式
		HSSFCellStyle centerStyle = wb.createCellStyle();
		centerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 水平居中
		centerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER); // 垂直居中
		centerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框
		centerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框
		centerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框
		centerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框
		List<SupplierGuide> result = pageBean.getResult();
		if (result != null && result.size() > 0) {
			HSSFRow createRow = null;
			HSSFCell cell = null;
			for (int i = 0; i < result.size(); i++) {
				createRow = sheet.createRow(i + 2);
				cell = createRow.createCell(0);
				cell.setCellValue("请选择".equals(result.get(i).getLevelName())?"":result.get(i).getLevelName());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(1);
				cell.setCellValue(result.get(i).getStarLevelName());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(2);
				cell.setCellValue(result.get(i).getName());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(3);
				cell.setCellValue(result.get(i).getGender() == 0 ? "男" : "女");
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(4);
				cell.setCellValue(result.get(i).getIdCardNo());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(5);
				cell.setCellValue(result.get(i).getLicenseNo());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(6);
				cell.setCellValue(result.get(i).getMobile());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(7);
				cell.setCellValue(result.get(i).getLanguage());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(8);
				cell.setCellValue(result.get(i).getNationalityName());
				cell.setCellStyle(centerStyle);

				cell = createRow.createCell(9);
				cell.setCellValue(result.get(i).getNativePlace());
				cell.setCellStyle(centerStyle);
			}
		}
		String fileName = new String("导游档案表.xls".getBytes("UTF-8"),
				"iso-8859-1");
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-disposition", "attachment;filename="
				+ fileName);
		OutputStream ouputStream = response.getOutputStream();
		wb.write(ouputStream);
		ouputStream.flush();
		ouputStream.close();

		return null;
	}

	@RequestMapping(value = "myGuideList.htm")
	public String bizGuideList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		loadMyGuideList(request, model, guide, page, pageSize);
		return "supplier/guide/supplier-guide-list";
	}

	@RequestMapping(value = "myGuideList.do", method = RequestMethod.POST)
	public String queryBizGuideList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		loadMyGuideList(request, model, guide, page, pageSize);
		return "supplier/guide/supplier-guide-list-table";
	}

	@RequestMapping(value = "impGuideList.htm")
	public String impGuideList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		Integer bizId = WebUtils.getCurBizId(request);
		loadGuideList(model, guide, page, pageSize, bizId);
		return "supplier/guide/imp-guide-list";
	}

	@RequestMapping(value = "impGuideList.do", method = RequestMethod.POST)
	public String queryImpGuideList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		Integer bizId = WebUtils.getCurBizId(request);
		loadGuideList(model, guide, page, pageSize, bizId);
		return "supplier/guide/imp-guide-list-table";
	}

	@RequestMapping(value = "impGuides.do", method = RequestMethod.POST)
	@ResponseBody
	public String impGuideList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String guideIds) {

		if (StringUtils.isNotBlank(guideIds)) {
			Integer bizId = WebUtils.getCurBizId(request);
			WebResult<Boolean> webResult = supplierFacade.impGuideList(bizId, guideIds);
			if(webResult.isSuccess()){
				return successJson();
			}else{
				return errorJson(webResult.getResultMsg());
			}
		} else {
			return errorJson("没有选择导游");
		}
	}

	/**
	 * 跳转到图片页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @param supplierType
	 * @return
	 */
	@RequestMapping("toFolderList.htm")
	public String toFolderList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id,
			Integer supplierType, Integer operType) {
		model.addAttribute("operType", operType);
		FolderListResult webResult = supplierFacade.toFolderList(id, supplierType, operType);

		model.addAttribute("bussList", webResult.getBussList());
		model.addAttribute("huanList", webResult.getHuanList());
		model.addAttribute("supplierType", supplierType);
		model.addAttribute("id", id);
		// model.addAttribute("imgCount", imgCount);

		return "supplier/FolderShow";

	}

	/**
	 * 跳转到图片展示页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param id
	 * @param supplierId
	 * @param supplierType
	 * @return
	 */

	@RequestMapping("toPictureList.htm")
	public String toPictureList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id,
			Integer supplierId, Integer supplierType, Integer operType) {
		PictureListResult webResult = supplierFacade.toPictureList(id, supplierId, supplierType, operType);
		model.addAttribute("supplierImgType", webResult.getSupplierImgType());
		model.addAttribute("imgList", webResult.getImgList());
		model.addAttribute("supplierType", supplierType);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("imgTypeId", id);
		model.addAttribute("config", config);
		model.addAttribute("operType", operType);
		// model.addAttribute("id", id);
		return "supplier/PictureShow";

	}

	/**
	 * 保存图片
	 * 
	 * @param request
	 * @param reponse
	 * @param imgs
	 * @return
	 */
	@RequestMapping(value = "saveImg.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveSupplierImg(HttpServletRequest request,
			HttpServletResponse reponse, String imgs) {

		WebResult<Boolean> webResult = supplierFacade.saveSupplierImg(imgs);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}

	}

	@RequestMapping("delPicture.do")
	@ResponseBody
	public String delPicture(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		WebResult<Boolean> webResult = supplierFacade.delPicture(id);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			return errorJson(webResult.getResultMsg());
		}

	}
	
	@RequestMapping("searchSupplier.do")
	@ResponseBody
	public String searchSupplier(HttpServletRequest request, HttpServletResponse reponse, Integer supplierType, String keyword) {

		WebResult<String> webResult = supplierFacade.searchSupplier(WebUtils.getCurBizId(request), supplierType, keyword);
		if(webResult.isSuccess()){
			return webResult.getValue();
		}else{
			return errorJson(webResult.getResultMsg());
		}
		
	}
	/**
	 * 获取待审核的供应商列表
	 * @param request
	 * @param response
	 * @param model
	 * @param supplierInfo
	 * @return
	 */
	@RequestMapping("supplierCheckList.htm")
	public String supplierCheckList(HttpServletRequest request,HttpServletResponse response,ModelMap model,SupplierInfo supplierInfo){
		PageBean pageBean=new PageBean();
		if (supplierInfo.getPage()==null) {
			pageBean.setPage(1);
		}
		else {
			pageBean.setPage(supplierInfo.getPage());
		}
		if (supplierInfo.getPageSize()==null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		}
		else {
			pageBean.setPageSize(supplierInfo.getPageSize());
		}
		//设置审核状态为待审核
		supplierInfo.setState(2);
		pageBean.setParameter(supplierInfo);
		
		WebResult<PageBean> webResult = supplierFacade.supplierCheckList(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("supplierInfo", supplierInfo);
		model.addAttribute("page", webResult.getValue());
		return "supplier/supplierCheck/supplierCheckList";
		
	}
	/**
	 * 审核供应商
	 * @param request
	 * @param response
	 * @param model
	 * @param checkedSupplierIds
	 * @return
	 */
	
	@RequestMapping("checkSupplier.do")
	@ResponseBody
	public String checkSupplier(HttpServletRequest request,HttpServletResponse response,ModelMap model,String checkedSupplierIds){
		//String[] checkedSuppliers = checkedSupplierIds.split(",");
		
		WebResult<Boolean> webResult = supplierFacade.checkSupplier(checkedSupplierIds);
		if(webResult.isSuccess()){
			return successJson();
		}else{
			log.error(webResult.getResultMsg());
			return errorJson("供应商审核失败");
		}
		
		
		
	}
}
