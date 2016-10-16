package com.yihg.erp.controller.supplier;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javassist.expr.NewArray;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.functors.IfClosure;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.csource.upload.UploadFileUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceService;
import com.yihg.finance.api.FinanceVerifyService;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingDeliveryService;
import com.yihg.operation.api.BookingShopService;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.product.api.ProductInfoService;
import com.yihg.sales.api.GroupOrderGuestService;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.supplier.api.BizSupplierRelationService;
import com.yihg.supplier.api.ContractService;
import com.yihg.supplier.api.SupplierDriverService;
import com.yihg.supplier.api.SupplierGuideService;
import com.yihg.supplier.api.SupplierImgService;
import com.yihg.supplier.api.SupplierItemService;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.BizGuideRelation;
import com.yihg.supplier.po.BizSupplierRelation;
import com.yihg.supplier.po.SupplierBankaccount;
import com.yihg.supplier.po.SupplierBill;
import com.yihg.supplier.po.SupplierContactMan;
import com.yihg.supplier.po.SupplierContract;
import com.yihg.supplier.po.SupplierGuide;
import com.yihg.supplier.po.SupplierImg;
import com.yihg.supplier.po.SupplierImgType;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.supplier.po.SupplierItem;
import com.yihg.supplier.vo.SupplierVO;
import com.yihg.sys.api.SysBizInfoService;

@Controller
@RequestMapping(value = "/supplier")
public class SupplierController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(SupplierController.class);
	private Constants constants;
	@Autowired
	private BizSupplierRelationService bizSupplierRelationService;
	@Autowired
	private SupplierService supplierService;
	@Autowired
	private RegionService regionService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SupplierGuideService guideService;
	@Autowired
	private SysConfig config;
	@Autowired
	private SupplierDriverService driverService;
	@Autowired
	private SupplierImgService supplierImgService;
	@Autowired
	private ContractService contractService;

	@Autowired
	private SysBizInfoService bizInfoService;

	@Autowired
	private SupplierItemService supplierItemService;

	@Autowired
	private GroupOrderService groupOrderService;
	
	@Autowired
	private BookingSupplierService bookingSupplierService;
	
	@Autowired
	private BookingShopService bookingShopService;
	
	@Autowired
	private BookingDeliveryService bookingDeliveryService;
	
	@Autowired
	private FinanceVerifyService financeVerifyService;
	
	@Autowired
	private FinanceService financeService;
	
	@Autowired
	private ProductInfoService productService;
	
	@RequestMapping(value = "/deleteSupplierItem.htm")
	@ResponseBody
	public String deleteSupplierItem(Integer id) {
		supplierItemService.deleteByPrimaryKey(id);
		return successJson();
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
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("supplierType", supplierType);
		model.addAttribute("allProvince", allProvince);

		List<DicInfo> travelagencylevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAVELAGENCY);
		model.addAttribute("travelagencylevelList", travelagencylevelList);

		List<DicInfo> restaurantlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		model.addAttribute("restaurantlevelList", restaurantlevelList);

		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("levelList", levelList);

		List<DicInfo> fleetlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_FLEET);
		model.addAttribute("fleetlevelList", fleetlevelList);

		List<DicInfo> scenicspotlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		model.addAttribute("scenicspotlevelList", scenicspotlevelList);

		List<DicInfo> shoppinglevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SHOPPING);
		model.addAttribute("shoppinglevelList", shoppinglevelList);

		List<DicInfo> entertainmentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_ENTERTAINMENT);
		model.addAttribute("entertainmentlevelList", entertainmentlevelList);

		List<DicInfo> guidelevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_GUIDE);
		model.addAttribute("guidelevelList", guidelevelList);

		List<DicInfo> airticketagentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_AIRTICKETAGENT);
		model.addAttribute("airticketagentlevelList", airticketagentlevelList);

		List<DicInfo> trainticketagentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAINTICKETAGENT);
		model.addAttribute("trainticketagentlevelList",
				trainticketagentlevelList);

		List<DicInfo> golflevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_GOLF);
		model.addAttribute("golflevelList", golflevelList);

		List<DicInfo> insuranclevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_INSURANCE);
		model.addAttribute("insuranclevelList", insuranclevelList);

		List<DicInfo> otherlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_OTHER);
		model.addAttribute("otherlevelList", otherlevelList);

		List<DicInfo> localtravelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_LOCALTRAVEL);
		model.addAttribute("localtravelList", localtravelList);

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
		SupplierInfo supplierInfo = supplierService.selectBySupplierId(id);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		List<RegionInfo> cityList = regionService.getRegionById(supplierInfo
				.getProvinceId() + "");
		model.addAttribute("cityList", cityList);

		List<RegionInfo> areaList = regionService.getRegionById(supplierInfo
				.getCityId() + "");
		model.addAttribute("areaList", areaList);

		List<RegionInfo> townList = regionService.getRegionById(supplierInfo
				.getAreaId() + "");
		model.addAttribute("townList", townList);

		model.addAttribute("supplierInfo", supplierInfo);
		List<DicInfo> travelagencylevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAVELAGENCY);
		model.addAttribute("travelagencylevelList", travelagencylevelList);

		List<DicInfo> restaurantlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		model.addAttribute("restaurantlevelList", restaurantlevelList);

		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("levelList", levelList);

		List<DicInfo> fleetlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_FLEET);
		model.addAttribute("fleetlevelList", fleetlevelList);

		List<DicInfo> scenicspotlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		model.addAttribute("scenicspotlevelList", scenicspotlevelList);

		List<DicInfo> shoppinglevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SHOPPING);
		model.addAttribute("shoppinglevelList", shoppinglevelList);

		List<DicInfo> entertainmentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_ENTERTAINMENT);
		model.addAttribute("entertainmentlevelList", entertainmentlevelList);

		List<DicInfo> guidelevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_GUIDE);
		model.addAttribute("guidelevelList", guidelevelList);

		List<DicInfo> airticketagentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_AIRTICKETAGENT);
		model.addAttribute("airticketagentlevelList", airticketagentlevelList);

		List<DicInfo> trainticketagentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAINTICKETAGENT);
		model.addAttribute("trainticketagentlevelList",
				trainticketagentlevelList);

		List<DicInfo> golflevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_GOLF);
		model.addAttribute("golflevelList", golflevelList);

		List<DicInfo> insuranclevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_INSURANCE);
		model.addAttribute("insuranclevelList", insuranclevelList);

		List<DicInfo> otherlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_OTHER);
		model.addAttribute("otherlevelList", otherlevelList);

		List<DicInfo> localtravelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_LOCALTRAVEL);
		model.addAttribute("localtravelList", localtravelList);
		model.addAttribute("bizId", WebUtils.getCurBizId(request));

		List<SupplierItem> supplierItems = supplierItemService
				.findSupplierItemBySupplierId(id);
		model.addAttribute("supplierItems", supplierItems);
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
		int verifyNameFull = supplierService.verifyNameFull(supplierId,
				supplierType, nameFull);
		if (verifyNameFull > 0) {
			return "false";
		}
		return "true";
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
		Integer id;
		supplierInfo.setCreateTime(new Timestamp(System.currentTimeMillis()));
		if (supplierInfo.getProvinceId() != null) {
			supplierInfo.setProvinceName(regionService.getById(
					supplierInfo.getProvinceId() + "").getName());
		}
		if (supplierInfo.getCityId() != null) {
			supplierInfo.setCityName(regionService.getById(
					supplierInfo.getCityId() + "").getName());
		}
		if (supplierInfo.getAreaId() != null) {
			supplierInfo.setAreaName(regionService.getById(
					supplierInfo.getAreaId() + "").getName());
		}
		if (supplierInfo.getTownId() != null) {
			supplierInfo.setTownName(regionService.getById(
					supplierInfo.getTownId() + "").getName());
		}

		try {

			// 1、根据supplier_type获取文件夹对应字典类型编码

			// 2、根据文件夹字典类型编码获取字典
			Map<Integer, String> map = Constants.dictType3Map;

			List<DicInfo> dicList = new ArrayList<DicInfo>();
			for (Map.Entry<Integer, String> entry : map.entrySet()) {
				Integer key = entry.getKey();
				if (key == supplierInfo.getSupplierType()) {

					dicList = dicService.getListByTypeCode(entry.getValue());
				}
			}
			// 从字典获取业务类型下的文件夹类型
			List<DicInfo> busType = dicService
					.getListByTypeCode(Constants.SUPPLIER_IMG_TYPE_BUSSINESS);
			List<SupplierImgType> imgTypeList = new ArrayList<SupplierImgType>();

			if (dicList != null && dicList.size() > 0) {
				for (DicInfo dicInfo : dicList) {
					SupplierImgType imgType = new SupplierImgType();
					imgType.setTypeName(dicInfo.getValue());
					imgType.setTypeCode(dicInfo.getCode());
					imgType.setBussinessType(1);
					imgTypeList.add(imgType);
				}

			}

			if (busType != null && busType.size() > 0) {
				for (DicInfo dic : busType) {
					SupplierImgType imgType = new SupplierImgType();
					imgType.setBussinessType(0);
					imgType.setTypeCode(dic.getCode());
					imgType.setTypeName(dic.getValue());
					imgTypeList.add(imgType);
				}
			}

			id = supplierService.saveSupplier(supplierInfo,
					WebUtils.getCurBizId(request), imgTypeList);
		} catch (Exception e) {
			return errorJson("操作失败");
		}
		if (items != null && items != "") {
			supplierItemService.saveSupplierItem(items, id);
		}
		return successJson("id", String.valueOf(id));
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
		if (supplierInfo.getProvinceId() != null) {
			supplierInfo.setProvinceName(regionService.getById(
					supplierInfo.getProvinceId() + "").getName());
		}
		if (supplierInfo.getCityId() != null) {
			supplierInfo.setCityName(regionService.getById(
					supplierInfo.getCityId() + "").getName());
		}
		if (supplierInfo.getAreaId() != null) {
			supplierInfo.setAreaName(regionService.getById(
					supplierInfo.getAreaId() + "").getName());
		}
		if (supplierInfo.getTownId() != null) {
			supplierInfo.setTownName(regionService.getById(
					supplierInfo.getTownId() + "").getName());
		}

		try {
			supplierService.updateSupplier(supplierInfo);
		} catch (Exception e) {
			return errorJson("操作失败");
		}
		if (items != null && items != "") {
			// supplierItemService.deleteBySupplierId(supplierInfo.getId()) ;
			supplierItemService.saveSupplierItem(items, supplierInfo.getId());
		}
		return successJson();
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
		SupplierInfo supplierInfo = supplierService
				.selectBySupplierId(supplierId);
		supplierInfo.setState(state);
		supplierService.updateSupplier(supplierInfo);
		return successJson();
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
		List<SupplierContract> list = contractService.findContracts(
				WebUtils.getCurBizId(request), supplierId);
		if (list != null && list.size() > 0) {
			return errorJson("存在已签订的合同协议,暂时无法删除");
		}
		existOrderServer(supplierId);
		supplierService.delPrivateSupplier(supplierId,
				WebUtils.getCurBizId(request));

		return successJson();
	}

	/**
	 * 判断是否存在相应订单业务
	 * @param supplierId
	 * @return
	 */
	public String existOrderServer(int supplierId) {
		
		int exist = bookingSupplierService.getOrderCountBySupplierId(supplierId);
		if (exist >0) {
			return errorJson("存在已发生的计调订单业务,暂时无法删除");
		}else {
			int existGroupOrder = groupOrderService.existgroupOrder(supplierId);
			if (existGroupOrder >0) {
				return errorJson("存在已发生的组团社订单业务,暂时无法删除");
			}else {
				int exitBookingShop = bookingShopService.existBookingShop(supplierId);
				if (exitBookingShop >0) {
					return errorJson("存在已发生的购物订单业务,暂时无法删除");
				}
			}
		}
		return "";
	}
	
	

	@RequestMapping(value="fixSupplier.do", method = RequestMethod.GET)
	@ResponseBody
	public String fixSupplierName(Integer supplierId, Integer supplierType, String supplierName) throws UnsupportedEncodingException {
		//supplierName = new String(supplierName.getBytes("iso-8859-1"),"GB2312");
		supplierName = URLDecoder.decode(supplierName,"utf-8");
		
		System.out.println(supplierName);
		bookingSupplierService.fix_SupplierName_All(supplierId, supplierName);
		productService.fix_SupplierName(supplierId, supplierName);
		
		return successJson();
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
		List<SupplierBankaccount> supplierBankaccountList = supplierService
				.selectBankBySupplierId(supplierId);

		List<SupplierBill> supplierBillList = supplierService
				.selectBillBySupplierId(supplierId);

		SupplierInfo supplierInfo = supplierService
				.selectBySupplierId(supplierId);

		SupplierVO supplierVO = new SupplierVO();
		supplierVO.setSupplierBankaccountList(supplierBankaccountList);
		supplierVO.setSupplierBillList(supplierBillList);

		model.addAttribute("supplierVO", supplierVO);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("supplierType", supplierInfo.getSupplierType());

		List<DicInfo> bankList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_BANK);
		model.addAttribute("bankList", bankList);

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
		supplierBankaccount.setCreateTime(System.currentTimeMillis());

		DicInfo di = dicService.getById(supplierBankaccount.getBankId() + "");
		supplierBankaccount.setBankName(di.getValue());

		supplierService.saveBankaccount(supplierBankaccount);
		return successJson();
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
		SupplierBankaccount supplierBankaccount = supplierService
				.selectSupplierBankaccountById(id);

		Gson gson = new Gson();
		String string = gson.toJson(supplierBankaccount);

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
		DicInfo dicInfo = dicService.getById(supplierBankaccount.getBankId()
				+ "");
		supplierBankaccount.setBankName(dicInfo.getValue());
		supplierService.updateBankaccount(supplierBankaccount);
		return successJson();
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
		supplierService.delBankaccount(id);
		return successJson();
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
		supplierBill.setCreateTime(System.currentTimeMillis());
		supplierService.saveBill(supplierBill);
		return successJson();
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
		List<SupplierBill> selectBillBySupplierId = supplierService
				.selectBillBySupplierId(supplierId);
		for (SupplierBill supplierBill : selectBillBySupplierId) {
			if (supplierBill.getId() == billId) {
				supplierBill.setIsDefault(0);
			} else {
				supplierBill.setIsDefault(1);
			}
			supplierService.updateBill(supplierBill);
		}

		return successJson();
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
		SupplierBill supplierBill = supplierService.selectSupplierBillById(id);
		Gson gson = new Gson();
		String string = gson.toJson(supplierBill);
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
		supplierService.updateBill(supplierBill);
		return successJson();
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
		supplierService.delBill(id);
		return successJson();
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
		List<SupplierContactMan> list = supplierService
				.selectPrivateManBySupplierId(WebUtils.getCurBizId(request), id);

		model.addAttribute("manList", list);
		model.addAttribute("supplierId", id);

		SupplierInfo supplierInfo = supplierService.selectBySupplierId(id);
		model.addAttribute("supplierType", supplierInfo.getSupplierType());

		List<SupplierContactMan> allManList = supplierService
				.selectAllManBySupplierId(WebUtils.getCurBizId(request), id);
		model.addAttribute("allManList", allManList);
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
		List<SupplierContactMan> list = supplierService
				.selectPrivateManBySupplierId(WebUtils.getCurBizId(request), id);
		Gson gson = new Gson();
		String json = gson.toJson(list);
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
		supplierService.savePrivateMan(WebUtils.getCurBizId(request),
				supplierId, ids);
		return successJson();
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
		supplierService.saveSupplierContactMan(WebUtils.getCurBizId(request),
				supplierContactMan);
		return successJson();
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
		List<SupplierContactMan> list = supplierService.validateMobile(manId,
				mobile);

		if (list != null && list.size() > 0) {
			return "false";
		}
		return "true";

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
		supplierService.delRalationMan(supplierId,
				WebUtils.getCurBizId(request), manId);
		return successJson();
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
		SupplierContactMan man = supplierService
				.selectSupplierContactManById(manId);

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
		supplierService.updateContactMan(supplierContactMan);
		return successJson();
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
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(supplierInfo.getPageSize());
		pageBean.setParameter(supplierInfo);
		pageBean.setPage(supplierInfo.getPage());
		pageBean = supplierService.selectPrivateSupplierList(pageBean,
				WebUtils.getCurBizId(request));
		List result = pageBean.getResult();
		if (result!=null && result.size()>0) {
			//查询每个供应商的协议状态，有一个协议有效即为有效
			for (Object object : result) {
			 SupplierInfo	supplier=(SupplierInfo)object;
			 BizSupplierRelation bizSupplierRelation = bizSupplierRelationService.getByBizIdAndSupplierId(WebUtils.getCurBizId(request), Integer.valueOf(supplier.getId()));
				if (bizSupplierRelation != null) {
					Integer stateCount = supplierService.getSupplierContractState(bizSupplierRelation.getId(), new Date());
					if (supplierInfo.getSupplierType() != 4) {
						if (stateCount > 0) {
							supplier.setContractState("<font color='blue'>有效</font>");
						} else {
							supplier.setContractState("<font color='red'>无效</font>");
						}
					} else {
						//车队(SupplierType为 4)共用协议，不存在有效/无效，显示为"--"
						supplier.setContractState("<font color='blue'>--</font>");
					}
				}
			}
		}
		model.addAttribute("page", pageBean);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		List<RegionInfo> cityList = regionService.getRegionById(supplierInfo
				.getProvinceId() + "");
		model.addAttribute("cityList", cityList);

		List<RegionInfo> areaList = regionService.getRegionById(supplierInfo
				.getCityId() + "");
		model.addAttribute("areaList", areaList);
		List<DicInfo> travelagencylevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAVELAGENCY);
		model.addAttribute("travelagencylevelList", travelagencylevelList);

		List<DicInfo> restaurantlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		model.addAttribute("restaurantlevelList", restaurantlevelList);

		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("levelList", levelList);

		List<DicInfo> fleetlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_FLEET);
		model.addAttribute("fleetlevelList", fleetlevelList);

		List<DicInfo> scenicspotlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		model.addAttribute("scenicspotlevelList", scenicspotlevelList);

		List<DicInfo> shoppinglevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SHOPPING);
		model.addAttribute("shoppinglevelList", shoppinglevelList);

		List<DicInfo> entertainmentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_ENTERTAINMENT);
		model.addAttribute("entertainmentlevelList", entertainmentlevelList);

		List<DicInfo> guidelevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_GUIDE);
		model.addAttribute("guidelevelList", guidelevelList);

		List<DicInfo> airticketagentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_AIRTICKETAGENT);
		model.addAttribute("airticketagentlevelList", airticketagentlevelList);

		List<DicInfo> trainticketagentlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAINTICKETAGENT);
		model.addAttribute("trainticketagentlevelList",
				trainticketagentlevelList);

		List<DicInfo> golflevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_GOLF);
		model.addAttribute("golflevelList", golflevelList);

		List<DicInfo> insuranclevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_INSURANCE);
		model.addAttribute("insuranclevelList", insuranclevelList);

		List<DicInfo> otherlevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_OTHER);
		model.addAttribute("otherlevelList", otherlevelList);

		List<DicInfo> localtravelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_LOCALTRAVEL);
		model.addAttribute("localtravelList", localtravelList);
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
		PageBean pageBean = new PageBean();
		pageBean.setPageSize(supplierInfo.getPageSize());
		pageBean.setParameter(supplierInfo);
		pageBean.setPage(supplierInfo.getPage());
		pageBean = supplierService.selectAllSupplierListPage(pageBean,
				WebUtils.getCurBizId(request));
		model.addAttribute("page", pageBean);
		model.addAttribute("supplierInfo", supplierInfo);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		List<RegionInfo> cityList = regionService.getRegionById(supplierInfo
				.getProvinceId() + "");
		model.addAttribute("cityList", cityList);

		List<RegionInfo> areaList = regionService.getRegionById(supplierInfo
				.getCityId() + "");
		model.addAttribute("areaList", areaList);

		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("levelList", levelList);

		List<DicInfo> travelagencylevelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAVELAGENCY);
		model.addAttribute("travelagencylevelList", travelagencylevelList);
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
		supplierService.addPrivateSupplier(WebUtils.getCurBizId(request), ids);
		return successJson();
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

		PageBean pageBean = guideService.getGuideList(guide, page, pageSize,
				bizId);
		model.addAttribute("pageBean", pageBean);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
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
		PageBean pageBean = guideService.getGuideListByBizId(guide, bizId,
				page, pageSize);
		model.addAttribute("pageBean", pageBean);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		model.addAttribute("images_source", config.getImages200Url());

	}

	@RequestMapping(value = "addGuide.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String guideAdd(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<DicInfo> mzList = dicService
				.getListByTypeCode(BasicConstants.GYXX_MZ);
		List<DicInfo> djList = dicService
				.getListByTypeCode(BasicConstants.DYXX_DJ);
		List<DicInfo> xjpdList = dicService
				.getListByTypeCode(BasicConstants.DYXX_XJPD);
		List<DicInfo> shdtrsList = dicService
				.getListByTypeCode(BasicConstants.DYXX_SHDTRS);
		model.addAttribute("mzList", mzList);
		model.addAttribute("djList", djList);
		model.addAttribute("xjpdList", xjpdList);
		model.addAttribute("shdtrsList", shdtrsList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		return "supplier/guide/add-guide";
	}

	@RequestMapping(value = "editGuide.htm")
	@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String editGuide(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		List<DicInfo> mzList = dicService
				.getListByTypeCode(BasicConstants.GYXX_MZ);
		List<DicInfo> djList = dicService
				.getListByTypeCode(BasicConstants.DYXX_DJ);
		List<DicInfo> xjpdList = dicService
				.getListByTypeCode(BasicConstants.DYXX_XJPD);
		List<DicInfo> shdtrsList = dicService
				.getListByTypeCode(BasicConstants.DYXX_SHDTRS);
		model.addAttribute("mzList", mzList);
		model.addAttribute("djList", djList);
		model.addAttribute("xjpdList", xjpdList);
		model.addAttribute("shdtrsList", shdtrsList);

		model.addAttribute("images_source", config.getImages200Url());

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		SupplierGuide guide = null;
		guide = guideService.getGuideInfoById(id);
		model.addAttribute("guide", guide);
		if (guide.getProvinceId() != null) {
			List<RegionInfo> cityList = regionService.getRegionById(guide
					.getProvinceId() + "");
			model.addAttribute("cityList", cityList);
		}
		if (guide.getCityId() != null) {
			List<RegionInfo> areaList = regionService.getRegionById(guide
					.getCityId() + "");
			model.addAttribute("areaList", areaList);
		}
		if (guide.getAreaId() != null) {
			List<RegionInfo> townList = regionService.getRegionById(guide
					.getAreaId() + "");
			model.addAttribute("townList", townList);
		}

		return "supplier/guide/edit-guide";
	}
	
	@RequestMapping(value = "guideDetail.htm")
	//@RequiresPermissions(PermissionConstants.SUPPLIER_GUIDE)
	public String guideDetail(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, Integer id) {
		List<DicInfo> mzList = dicService
				.getListByTypeCode(BasicConstants.GYXX_MZ);
		List<DicInfo> djList = dicService
				.getListByTypeCode(BasicConstants.DYXX_DJ);
		List<DicInfo> xjpdList = dicService
				.getListByTypeCode(BasicConstants.DYXX_XJPD);
		List<DicInfo> shdtrsList = dicService
				.getListByTypeCode(BasicConstants.DYXX_SHDTRS);
		model.addAttribute("mzList", mzList);
		model.addAttribute("djList", djList);
		model.addAttribute("xjpdList", xjpdList);
		model.addAttribute("shdtrsList", shdtrsList);

		model.addAttribute("images_source", config.getImages200Url());

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		SupplierGuide guide = null;
		guide = guideService.getGuideInfoById(id);
		model.addAttribute("guide", guide);
		if (guide.getProvinceId() != null) {
			List<RegionInfo> cityList = regionService.getRegionById(guide
					.getProvinceId() + "");
			model.addAttribute("cityList", cityList);
		}
		if (guide.getCityId() != null) {
			List<RegionInfo> areaList = regionService.getRegionById(guide
					.getCityId() + "");
			model.addAttribute("areaList", areaList);
		}
		if (guide.getAreaId() != null) {
			List<RegionInfo> townList = regionService.getRegionById(guide
					.getAreaId() + "");
			model.addAttribute("townList", townList);
		}

		return "supplier/guide/guide-detail";
	}

	@RequestMapping(value = "delGuide.do")
	@ResponseBody
	public String delGuide(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		guideService.deleteBizGuideRelaion(WebUtils.getCurBizId(request), id);
		return successJson();
	}

	@RequestMapping(value = "delPublicGuide.do")
	@ResponseBody
	public String delPublicGuide(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {

		List<BizGuideRelation> list = guideService.getByGuideId(id);
		if (list != null && list.size() > 0) {
			return errorJson("商家导游存在关联关系,请先清除关联关系后再进行删除操作");
		}

		guideService.delById(id);
		return successJson();
	}

	@RequestMapping(value = "saveGuide.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveGuide(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide) {
		if (guide.getId() != null) {
			if (guide.getNationality() != -1) {
				DicInfo dicInfo = dicService.getById(guide.getNationality()
						+ "");
				guide.setNationalityName(dicInfo.getValue());
			}
			guideService.updateGuideInfo(guide);
		} else {
			int id = guideService.addGuideInfo(guide,
					WebUtils.getCurBizId(request));
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("guideId", id);
			return successJson(map);
		}
		return successJson();
	}

	@RequestMapping(value = "guideArchivesList.htm")
	@RequiresPermissions(value=PermissionConstants.SUPPLIER_GUIDE)
	public String guideArchivesList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, SupplierGuide guide,
			Integer page, Integer pageSize) {
		List<DicInfo> list = dicService
				.getListByTypeCode(BasicConstants.DYXX_DJ);
		model.addAttribute("djList", list);
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
		List<DicInfo> list = dicService
				.getListByTypeCode(BasicConstants.DYXX_DJ);
		model.addAttribute("djList", list);
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
		PageBean pageBean = guideService.getGuideListByBizId(guide, bizId, 1,
				100000);

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
			String[] guidArr = guideIds.split(",");

			guideService.addBizGuideRelation(bizId, guidArr);
			return successJson();
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
		List<SupplierImgType> imgTypeList = supplierService
				.getImgTypeListBySupplierId(id);
		List<SupplierImgType> bussList = new ArrayList<SupplierImgType>();
		List<SupplierImgType> huanList = new ArrayList<SupplierImgType>();
		for (SupplierImgType supplierImgType : imgTypeList) {
			if (supplierImgType.getBussinessType() == 0) {
				bussList.add(supplierImgType);
			} else {
				huanList.add(supplierImgType);
			}
		}

		model.addAttribute("bussList", bussList);
		model.addAttribute("huanList", huanList);
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
		List<SupplierImg> imgList = supplierImgService
				.getImgListBySupplierId(id);

		SupplierImgType supplierImgType = supplierService
				.selectBySupplierImgTypeId(id);
		model.addAttribute("supplierImgType", supplierImgType);
		model.addAttribute("imgList", imgList);
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

		List<SupplierImg> imgList = JSON.parseArray(imgs, SupplierImg.class);
		for (SupplierImg supplierImg : imgList) {
			supplierImg.setCreateTime(System.currentTimeMillis());
			supplierImg.setBussniessType(1);
			supplierImgService.insert(supplierImg);
		}
		return successJson();

	}

	@RequestMapping("delPicture.do")
	@ResponseBody
	public String delPicture(HttpServletRequest request,
			HttpServletResponse reponse, Integer id) {
		supplierImgService.deleteByPrimaryKey(id);
		return successJson();

	}
	
	@RequestMapping("searchSupplier.do")
	@ResponseBody
	public String searchSupplier(HttpServletRequest request, HttpServletResponse reponse, Integer supplierType, String keyword) {

		HashMap<String, String> parameter = new HashMap<String, String>();
		parameter.put("bizId", WebUtils.getCurBizId(request).toString());
		parameter.put("supplierType", supplierType.toString());
		parameter.put("supplierName", keyword);
		List<SupplierInfo> ret = supplierService.searchSupplierByKeyword(parameter);
		/*ArrayList<HashMap<String, String>> ret = new ArrayList<HashMap<String,String>>();
		HashMap<String, String> row1 = new HashMap<String, String>();
		row1.put("name", "刘蕴的测试供应商");
		row1.put("id", "109");
		ret.add(row1);
		HashMap<String, String> row2 = new HashMap<String, String>();
		row2.put("name", "王军的测试供应商");
		row2.put("id", "110");
		ret.add(row2);*/
		HashMap<String, Object> json = new HashMap<String, Object>();
		json.put("result", ret);
		json.put("success", "true");
		return JSON.toJSONString(json);
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
		pageBean= supplierService.selectCheckingSupplierListPage(pageBean, WebUtils.getCurBizId(request));
				//selectAllSupplierListPage(pageBean, WebUtils.getCurBizId(request));
		model.addAttribute("supplierInfo", supplierInfo);
		model.addAttribute("page", pageBean);
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
		List<SupplierInfo> supplierInfos = JSONArray.parseArray(checkedSupplierIds, SupplierInfo.class);
		try {
			for (SupplierInfo info : supplierInfos) {
				//SupplierInfo supplierInfo=new SupplierInfo();
				info.setState(1);
				//supplierInfo.setId(info.geti);
				supplierService.updateSupplier(info);
				return successJson();
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		return errorJson("供应商审核失败");
		
	}
}
