package com.yihg.erp.controller.queries;

import java.beans.DefaultPersistenceDelegate;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javassist.expr.NewArray;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.SheetUtil;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.EnableLoadTimeWeaving;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.util.TypeUtils;
import com.yihg.basic.api.CommonService;
import com.yihg.basic.api.DicService;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.basic.po.RegionInfo;
import com.yihg.basic.util.NumberUtil;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.BizConfigConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.controller.sys.sysConfig.sysConfigController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.finance.api.FinanceService;
import com.yihg.finance.po.FinancePay;
import com.yihg.finance.po.InfoBean;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.api.BookingGuideService;
import com.yihg.operation.api.BookingShopDetailDeployService;
import com.yihg.operation.api.BookingShopDetailService;
import com.yihg.operation.api.BookingShopService;
import com.yihg.operation.api.BookingSupplierDetailService;
import com.yihg.operation.api.BookingSupplierService;
import com.yihg.operation.po.BookingAirTicket;
import com.yihg.operation.po.BookingGuide;
import com.yihg.operation.po.BookingShopDetail;
import com.yihg.operation.po.BookingShopSelect;
import com.yihg.operation.po.BookingSupplierDetail;
import com.yihg.operation.vo.BookingGroup;
import com.yihg.operation.vo.GroupBookingInfo;
import com.yihg.operation.vo.PaymentExportVO;
import com.yihg.operation.vo.QueryGuideShop;
import com.yihg.operation.vo.QueryShopInfo;
import com.yihg.product.api.ProductGroupPriceService;
import com.yihg.query.api.QueryService;
import com.yihg.query.vo.DeparentmentOrderCondition;
import com.yihg.query.vo.DepartmentOrderResult;
import com.yihg.query.vo.DepartmentOrderVO;
import com.yihg.query.vo.ProductGuestCondition;
import com.yihg.query.vo.ProductGuestShoppingCondition;
import com.yihg.query.vo.ProductGuestStaticsVo;
import com.yihg.sales.api.GroupOrderService;
import com.yihg.sales.api.TourGroupService;
import com.yihg.sales.po.GroupOrder;
import com.yihg.sales.po.GroupOrderGuest;
import com.yihg.sales.po.PaymentCondition;
import com.yihg.sales.po.TourGroup;
import com.yihg.sales.vo.OperatorGroupStatic;
import com.yihg.sales.vo.SaleOperatorOrderStatic;
import com.yihg.sales.vo.SaleOperatorVo;
import com.yihg.sales.vo.TourGroupVO;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.constants.SupplierConstant;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.api.SysBizBankAccountService;
import com.yihg.sys.po.PlatformEmployeePo;
import com.yihg.sys.po.PlatformOrgPo;
import com.yihg.sys.po.SysBizBankAccount;

@Controller
@RequestMapping("/query")
public class QueryController extends BaseController {
	@Autowired
	private ApplicationContext appContext;
	@Autowired
	private BookingSupplierDetailService detailService;
	@Autowired
	private BookingSupplierService bookingSupplierService;
	@Autowired
	private DicService dicService;
	@Autowired
	private TourGroupService tourGroupService;
	@Autowired
	private GroupOrderService groupOrderService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private RegionService regionService;

	@Autowired
	private SupplierService supplierSerivce;
	@Autowired
	private BookingShopService bookingShopService;
	@Autowired
	private BookingShopDetailService bookingShopDetailService;
	@Autowired
	private SysBizBankAccountService bizBankAccountService;
	@Autowired
	private BookingGuideService bGuideService;
	@Autowired
	private QueryService queryService;
	@Autowired
	private BizSettingCommon bizSettingCommon;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private BookingShopDetailDeployService detailDeployService;
	@Autowired
	private FinanceService financeService;
	@Autowired
	private ProductGroupPriceService groupPriceService;
	@Autowired
	private BookingGuideService bookingGuideService;

	@ModelAttribute
	public void getOrgAndUserTreeJsonStr(ModelMap model,
			HttpServletRequest request) {

		model.addAttribute("orgJsonStr", orgService
				.getComponentOrgTreeJsonStr(WebUtils.getCurBizId(request)));
		model.addAttribute("orgUserJsonStr", platformEmployeeService
				.getComponentOrgUserTreeJsonStr(WebUtils.getCurBizId(request)));
	}

	@RequestMapping(value = "/toSaleOperatorPreview.htm")
	public String toSaleOperatorPreview(HttpServletRequest request,
			Model model, SaleOperatorVo order) {
		// 酒店星级
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		PageBean<SaleOperatorVo> pageBean = new PageBean<SaleOperatorVo>();
		pageBean.setPage(1);
		pageBean.setPageSize(10000);
		pageBean.setParameter(order);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(order.getSaleOperatorIds())
				&& StringUtils.isNotBlank(order.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = order.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				order.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean = queryService.selectSaleOperatorByConListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		List<SaleOperatorVo> orders = pageBean.getResult();
		for (int i = 0; i < orders.size(); i++) {
			SaleOperatorVo vo = orders.get(i);
			List<GroupOrderGuest> guests = new ArrayList<GroupOrderGuest>();
			if (vo.getGuestNames() != null) {
				GroupOrderGuest guest = null;
				String[] guestsString = vo.getGuestNames().split(",");
				for (String s : guestsString) {
					String[] ss = s.split("@");
					if (ss.length == 2) {
						guest = new GroupOrderGuest();
						guest.setName(ss[0]);
						guest.setCertificateNum(ss[1]);
					} else if (ss.length == 3) {
						guest = new GroupOrderGuest();
						guest.setName(ss[0]);
						guest.setCertificateNum(ss[1]);
						guest.setMobile(ss[2]);
					}
					guests.add(guest);
				}
			}
			vo.setGuests(guests);
		}
		// model.addAttribute("guests", guests);
		model.addAttribute("page", pageBean);
		model.addAttribute("orders", pageBean.getResult());
		model.addAttribute("startTime", order.getStartTime());
		model.addAttribute("endTime", order.getEndTime());
		model.addAttribute("supplierName", order.getSupplierName());
		model.addAttribute("groupCode", order.getGroupCode());
		model.addAttribute("guestName", order.getGuestName());
		model.addAttribute("mobile", order.getMobile());
		model.addAttribute("saleOperatorIds", order.getSaleOperatorIds());
		model.addAttribute("productName", order.getProductName());
		model.addAttribute("select", order.getSelect());
		model.addAttribute("mergeGroupState", order.getMergeGroupState());
		return "queries/saleOperator/saleOperatorPreview";
	}

	/**
	 * 销售计调单列表
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toSaleOperatorList.htm")
	public String toSaleOperatorList(HttpServletRequest request, ModelMap model) {
		List<RegionInfo> allProvince = regionService.getAllProvince();
		// 酒店星级
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("jdxjList", jdxjList);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/saleOperator/saleOperatorList";
	}

	/**
	 * 销售计调单分页查询
	 * 
	 * @param request
	 * @param model
	 * @param order
	 * @return
	 */
	@RequestMapping(value = "/toSaleOperatorTable.htm")
	public String toSaleOperatorTable(HttpServletRequest request, Model model,
			SaleOperatorVo order) {
		PageBean<SaleOperatorVo> pageBean = new PageBean<SaleOperatorVo>();
		pageBean.setPage(order.getPage());
		pageBean.setPageSize(order.getPageSize() == null ? Constants.PAGESIZE
				: order.getPageSize());
		pageBean.setParameter(order);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(order.getSaleOperatorIds())
				&& StringUtils.isNotBlank(order.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = order.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				order.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean = queryService.selectSaleOperatorByConListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		Map<String, Object> sumPerson = queryService
				.selectSaleOperatorTotalPerson(pageBean,
						WebUtils.getCurBizId(request),
						WebUtils.getDataUserIdSet(request));
		List<SaleOperatorVo> orders = pageBean.getResult();
		for (SaleOperatorVo vo : orders) {
			List<GroupOrderGuest> guests = new ArrayList<GroupOrderGuest>();
			if (vo.getGuestNames() != null) {
				String[] guestsString = vo.getGuestNames().split(",");
				for (String s : guestsString) {
					GroupOrderGuest guest = null;
					String[] ss = s.split("@");
					if (ss.length == 2) {
						guest = new GroupOrderGuest();
						guest.setName(ss[0]);
						guest.setCertificateNum(ss[1]);
					} else if (ss.length == 3) {
						guest = new GroupOrderGuest();
						guest.setName(ss[0]);
						guest.setCertificateNum(ss[1]);
						guest.setMobile(ss[2]);
					}
					guests.add(guest);
				}
			}
			vo.setGuests(guests);
		}
		model.addAttribute("page", pageBean);
		model.addAttribute("sumPerson", sumPerson);
		model.addAttribute("orders", pageBean.getResult());
		return "queries/saleOperator/saleOperatorTable";
	}

	public String getLevelName(String levelCode) {
		if (null == levelCode) {
			return "";
		}
		String levelName = "";
		// 酒店星级
		List<DicInfo> jdxjList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		for (DicInfo dicInfo : jdxjList) {
			if (dicInfo.getId() == Integer.parseInt(levelCode)) {
				levelName = dicInfo.getValue();
				break;
			}
		}
		return levelName;
	}

	@RequestMapping(value = "/saleOperatorExcel.htm")
	public void saleOperatorExcel(HttpServletRequest request, Model model,
			SaleOperatorVo order, HttpServletResponse response) {
		PageBean<SaleOperatorVo> pageBean = new PageBean<SaleOperatorVo>();
		pageBean.setPage(1);
		pageBean.setPageSize(10000);
		pageBean.setParameter(order);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(order.getSaleOperatorIds())
				&& StringUtils.isNotBlank(order.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = order.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				order.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean = queryService.selectSaleOperatorByConListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		String path = "";

		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/saleOperator.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			cellStyle.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			cellStyle.setWrapText(true);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
			styleLeft.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleLeft.setWrapText(true);

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			styleRight.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);// 垂直
			styleRight.setWrapText(true);

			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			Iterator<SaleOperatorVo> it = pageBean.getResult().iterator();
			int num = 1;
			int index = 0;
			// 合并行填充数据列
			int createRow = 2;
			while (it.hasNext()) {
				SaleOperatorVo sov = it.next();
				List<GroupOrderGuest> guestList = new ArrayList<GroupOrderGuest>();
				GroupOrderGuest orderGuest = null;
				if (null != sov.getGuestNames()) {
					String[] guests = sov.getGuestNames().split(",");
					for (String guestString : guests) {
						String[] guestInfo = guestString.split("@");
						orderGuest = new GroupOrderGuest();
						orderGuest.setName(guestInfo[0]);
						orderGuest.setCertificateNum(guestInfo[1]);
						if (guestInfo.length == 3) {
							orderGuest.setMobile(guestInfo[2]);
						}

						guestList.add(orderGuest);
					}
				}

				if (guestList.size() == 0) {
					row = sheet.createRow(index + 2);
					cc = row.createCell(0);
					cc.setCellValue(num);
					cc.setCellStyle(cellStyle);
					cc = row.createCell(1);
					cc.setCellValue(sov.getGroupCode());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(2);
					cc.setCellValue("【" + sov.getProductBrandName() + "】"
							+ sov.getProductName());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(3);
					cc.setCellValue(sov.getSupplierName());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(4);
					cc.setCellValue(sov.getContactName());
					cc.setCellStyle(cellStyle);
					cc = row.createCell(5);
					cc.setCellValue((sov.getNumAdult() == null ? 0 : sov
							.getNumAdult())
							+ "+"
							+ (sov.getNumChild() == null ? 0 : sov
									.getNumChild())
							+ "+"
							+ (sov.getNumGuide() == null ? 0 : sov
									.getNumGuide()));
					cc.setCellStyle(cellStyle);
					cc.setCellStyle(cellStyle);
					cc = row.createCell(6);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(7);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(8);
					cc.setCellValue("");
					cc.setCellStyle(cellStyle);
					cc = row.createCell(9);
					cc.setCellValue(getLevelName(sov.getHotelLevels()));
					cc.setCellStyle(cellStyle);
					cc = row.createCell(10);
					cc.setCellValue(sov.getHotelNums());
					cc.setCellStyle(styleLeft);
					cc = row.createCell(11);
					cc.setCellValue(sov.getUpAir() == null ? "" : sov
							.getUpAir().replace(",", "\n")); // 团款
					cc.setCellStyle(styleLeft);
					cc = row.createCell(12);
					cc.setCellValue(sov.getOffAir() == null ? "" : sov
							.getOffAir().replace(",", "\n"));
					cc.setCellStyle(styleLeft);
					cc = row.createCell(13);
					cc.setCellValue(sov.getTrans() == null ? "" : sov
							.getTrans().replace(",", "\n"));
					cc.setCellStyle(styleLeft);
					cc = row.createCell(14);
					cc.setCellValue(sov.getSaleOperatorName());
					cc.setCellStyle(cellStyle);
					cc = row.createCell(15);
					cc.setCellValue(sov.getOperatorName());
					cc.setCellStyle(cellStyle);
					cc = row.createCell(16);
					cc.setCellValue(sov.getRemark());
					cc.setCellStyle(cellStyle);
					index++;
				} else {
					for (GroupOrderGuest guest : guestList) {
						row = sheet.createRow(index + 2);
						cc = row.createCell(0);
						cc.setCellValue(num);
						cc.setCellStyle(cellStyle);
						cc = row.createCell(1);
						cc.setCellValue(sov.getGroupCode());
						cc.setCellStyle(styleLeft);
						cc = row.createCell(2);
						cc.setCellValue("【" + sov.getProductBrandName() + "】"
								+ sov.getProductName());
						cc.setCellStyle(styleLeft);
						cc = row.createCell(3);
						cc.setCellValue(sov.getSupplierName());
						cc.setCellStyle(styleLeft);
						cc = row.createCell(4);
						cc.setCellValue(sov.getContactName());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(5);
						cc.setCellValue((sov.getNumAdult() == null ? 0 : sov
								.getNumAdult())
								+ "+"
								+ (sov.getNumChild() == null ? 0 : sov
										.getNumChild())
								+ "+"
								+ (sov.getNumGuide() == null ? 0 : sov
										.getNumGuide()));
						cc.setCellStyle(cellStyle);

						cc.setCellStyle(cellStyle);
						cc = row.createCell(6);
						cc.setCellValue(guest.getName());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(7);
						cc.setCellValue(guest.getCertificateNum());
						cc.setCellStyle(styleLeft);
						cc = row.createCell(8);
						cc.setCellValue(guest.getMobile());
						cc.setCellStyle(styleLeft);

						cc = row.createCell(9);
						cc.setCellValue(getLevelName(sov.getHotelLevels()));
						cc.setCellStyle(cellStyle);
						cc = row.createCell(10);
						cc.setCellValue(sov.getHotelNums());
						cc.setCellStyle(styleLeft);
						cc = row.createCell(11);
						cc.setCellValue(sov.getUpAir() == null ? "" : sov
								.getUpAir().replace(",", "\n")); // 团款
						cc.setCellStyle(styleLeft);
						cc = row.createCell(12);
						cc.setCellValue(sov.getOffAir() == null ? "" : sov
								.getOffAir().replace(",", "\n"));
						cc.setCellStyle(styleLeft);
						cc = row.createCell(13);
						cc.setCellValue(sov.getTrans() == null ? "" : sov
								.getTrans().replace(",", "\n"));
						cc.setCellStyle(styleLeft);
						cc = row.createCell(14);
						cc.setCellValue(sov.getSaleOperatorName());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(15);
						cc.setCellValue(sov.getOperatorName());
						cc.setCellStyle(cellStyle);
						cc = row.createCell(16);
						cc.setCellValue(sov.getRemark());
						cc.setCellStyle(cellStyle);
						index++;
					}
					for (int i = 0; i < 17; i++) {
						if (i != 6 && i != 7 && i != 8) {
							CellRangeAddress region = new CellRangeAddress(
									createRow,
									createRow + guestList.size() - 1, i, i);
							sheet.addMergedRegion(region);
							cc = SheetUtil.getCellWithMerges(sheet, createRow,
									i);
							if (1 == i) {
								cc.setCellStyle(styleLeft);
							} else if (2 == i) {
								cc.setCellStyle(styleLeft);
							} else if (3 == i) {
								cc.setCellStyle(styleLeft);
							} else if (9 == i) {
								cc.setCellStyle(styleLeft);
							} else if (10 == i) {
								cc.setCellStyle(styleLeft);
							} else if (11 == i) {
								cc.setCellStyle(styleLeft);
							} else if (12 == i) {
								cc.setCellStyle(styleLeft);
							} else if (13 == i) {
								cc.setCellStyle(styleLeft);
							} else if (16 == i) {
								cc.setCellStyle(styleLeft);
							} else {
								cc.setCellStyle(cellStyle);
							}

						}
					}
				}
				createRow = createRow + guestList.size();
				num++;
			}

			/*
			 * CellRangeAddress region = new
			 * CellRangeAddress(pageBean.getResult() .size() + 2,
			 * pageBean.getResult().size() + 3, 0, 14);
			 * sheet.addMergedRegion(region); row =
			 * sheet.createRow(pageBean.getResult().size() + 2); cc =
			 * row.createCell(0); cc.setCellValue("打印人：" +
			 * WebUtils.getCurUser(request).getName() + " 打印时间：" +
			 * DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			 */
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("销售计调单.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);
	}

	/**
	 * 销售计调业绩统计
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toSaleOperatorOrderStatic.htm")
	public String toSaleOperatorOrderStatic(HttpServletRequest request,
			ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "operation/saleOperatorOrderStatic";
	}

	@RequestMapping(value = "/toSaleOperatorOrderStaticTable.htm")
	public String toSaleOperatorOrderStaticTable(HttpServletRequest request,
			SaleOperatorOrderStatic soos, Integer page, Integer pageSize,
			ModelMap model) {
		PageBean<SaleOperatorOrderStatic> pageBean = new PageBean<SaleOperatorOrderStatic>();

		pageBean.setPage(page);
		pageBean.setPageSize(pageSize == null ? 15 : pageSize);
		pageBean.setParameter(soos);
		if (StringUtils.isBlank(soos.getSaleOperatorIds())
				&& StringUtils.isNotBlank(soos.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = soos.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				soos.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		Integer bizId = WebUtils.getCurBizId(request);
		pageBean = groupOrderService.selectSaleOperatorOrderStaticListPage(
				pageBean, bizId, WebUtils.getDataUserIdSet(request));
		SaleOperatorOrderStatic sum = groupOrderService
				.selectSaleOperatorOrderStaticCon(pageBean, bizId,
						WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		model.addAttribute("sum", sum);
		return "operation/saleOperatorOrderStaticTable";
	}

	/**
	 * 计调业绩统计
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toOperatorGroupStatic.htm")
	public String toOperatorGroupStatic(HttpServletRequest request,
			ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "operation/operatorGroupStatic";
	}

	@RequestMapping(value = "/toOperatorGroupStaticTable.htm")
	public String toOperatorGroupStaticTable(HttpServletRequest request,
			OperatorGroupStatic ogs, Integer page, Integer pageSize,
			ModelMap model) {
		PageBean<OperatorGroupStatic> pageBean = new PageBean<OperatorGroupStatic>();

		pageBean.setPage(page);
		pageBean.setPageSize(pageSize == null ? 15 : pageSize);
		pageBean.setParameter(ogs);
		if (StringUtils.isBlank(ogs.getOperatorIds())
				&& StringUtils.isNotBlank(ogs.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = ogs.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				ogs.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		Integer bizId = WebUtils.getCurBizId(request);
		pageBean = tourGroupService.selectOperatorGroupStaticListPage(pageBean,
				bizId, WebUtils.getDataUserIdSet(request));
		OperatorGroupStatic sum = tourGroupService
				.selectOperatorGroupStaticCon(pageBean, bizId,
						WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		model.addAttribute("sum", sum);
		return "operation/operatorGroupStaticTable";
	}

	/**
	 * 客人明细
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/shopInfoDetailList.htm")
	public String toShopInfoDetail(HttpServletRequest request, ModelMap model) {
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		return "queries/shop/shopInfoDetail-list";
	}

	@RequestMapping(value = "/toOrdersPreview.do")
	public String toOrdersPreview(HttpServletRequest request,
			HttpServletResponse response, PaymentExportVO vo, ModelMap model) {
		PageBean<PaymentExportVO> pageBean = new PageBean<PaymentExportVO>();
		Map parameters = WebUtils.getQueryParamters(request);
		if (StringUtils.isBlank(vo.getOperatorIds())
				&& StringUtils.isNotBlank(vo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = vo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				vo.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
				parameters.put("saleOperatorIds", salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(vo);
		List<GroupOrder> orders = groupOrderService.selectPaymentDetailList(
				pageBean, WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("orders", orders);
		// model.addAttribute("startTime", vo.getStartTime());
		// model.addAttribute("endTime", vo.getEndTime());
		// model.addAttribute("supplierId", vo.getSupplierId());
		// model.addAttribute("supplierName", vo.getSupplierName());
		// model.addAttribute("provinceId", vo.getProvinceId());
		// model.addAttribute("cityId", vo.getCityId());
		// model.addAttribute("groupCode", vo.getGroupCode());
		// model.addAttribute("paymentState", vo.getPaymentState());
		// model.addAttribute("productName", vo.getProductName());
		// model.addAttribute("operatorIds", vo.getOperatorIds());
		// model.addAttribute("groupMode", vo.getGroupMode());
		// model.addAttribute("type", vo.getType());
		model.addAttribute("parameter", parameters);
		return "queries/paymentDetailPreview";
	}

	/**
	 * 对账明细预览页面（应收款明细表页面）
	 * 
	 * @param request
	 * @param response
	 * @param vo
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/toPaymentPreview.do")
	public String toPaymentPreview(HttpServletRequest request,
			HttpServletResponse response, PaymentExportVO vo, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		PageBean<PaymentExportVO> pageBean = new PageBean<PaymentExportVO>();
		Map parameters = WebUtils.getQueryParamters(request);
		if (StringUtils.isBlank(vo.getOperatorIds())
				&& StringUtils.isNotBlank(vo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = vo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(bizId, set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				vo.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
				parameters.put("saleOperatorIds", salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(vo);
		List<GroupOrder> orders = groupOrderService.selectPaymentDetailList(
				pageBean, bizId, WebUtils.getDataUserIdSet(request));
		model.addAttribute("orders", orders);
		// model.addAttribute("startTime", vo.getStartTime());
		// model.addAttribute("endTime", vo.getEndTime());
		// model.addAttribute("supplierId", vo.getSupplierId());
		// model.addAttribute("supplierName", vo.getSupplierName());
		// model.addAttribute("provinceId", vo.getProvinceId());
		// model.addAttribute("cityId", vo.getCityId());
		// model.addAttribute("groupCode", vo.getGroupCode());
		// model.addAttribute("paymentState", vo.getPaymentState());
		// model.addAttribute("productName", vo.getProductName());
		// model.addAttribute("operatorIds", vo.getOperatorIds());
		// model.addAttribute("groupMode", vo.getGroupMode());
		// model.addAttribute("type", vo.getType());
		model.addAttribute("parameter", parameters);
		/**
		 * 查询当前用户的收款明细
		 */
		List<FinancePay> payDetailList = financeService
				.getFinancePayBySupplierId(vo.getSupplierId(), bizId);
		model.addAttribute("payDetailList", payDetailList);

		List<SysBizBankAccount> sysBizBankAccountList = bizBankAccountService
				.getListByBizId(WebUtils.getCurBizId(request));
		StringBuilder sb = new StringBuilder();
		StringBuilder sb1 = new StringBuilder();
		StringBuilder sb2 = new StringBuilder();
		for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
			sb.append("类别:"
					+ (sysBizBankAccount.getAccountType() == 1 ? "个人账户"
							: "对公账户") + " 银行名称："
					+ sysBizBankAccount.getBankName()
					+ sysBizBankAccount.getBankAccount() + " 开户全称："
					+ sysBizBankAccount.getAccountName() + " 公司账号："
					+ sysBizBankAccount.getAccountNo() + "\n");
		}
		sb1.append("组团社盖章：" + "\n" + "签字：_________" + "\n" + "日期：_________"
				+ "\n");
		sb2.append("组团社盖章：" + "\n" + "签字：_________" + "\n" + "日期：_________"
				+ "\n");
		// 本期发生的应收已收
		GroupOrder orderMiddle = groupOrderService.selectTotalStatic(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		vo.setEndTime(null);
		pageBean.setParameter(vo);
		// 期初余额
		GroupOrder orderPre = groupOrderService.selectTotalStatic(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("orderMiddle", orderMiddle);
		model.addAttribute("orderPre", orderPre);
		model.addAttribute("sb1", sb1.toString());
		model.addAttribute("sb2", sb2.toString());
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("printTime",
				com.yihg.erp.utils.DateUtils.format(new Date()));
		return "queries/paymentPreview";
	}

	/**
	 * excel导出部分
	 * 
	 * @param request
	 * @param response
	 * @param vo
	 * @param page
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value = "/getOrders.do")
	@ResponseBody
	public void getOrders(HttpServletRequest request,
			HttpServletResponse response, PaymentExportVO vo, Integer page,
			Integer pageSize) {
		PageBean<PaymentExportVO> pageBean = new PageBean<PaymentExportVO>();
		pageBean.setParameter(vo);
		List<GroupOrder> orders = groupOrderService.selectPaymentDetailList(
				pageBean, WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		String path = "";

		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/paymentDetail.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			XSSFFont createFont = wb.createFont();
			createFont.setFontName("微软雅黑");
			createFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);// 粗体显示
			createFont.setFontHeightInPoints((short) 12);

			XSSFFont tableIndex = wb.createFont();
			tableIndex.setFontName("宋体");
			tableIndex.setFontHeightInPoints((short) 11);

			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleFontCenter = wb.createCellStyle();
			styleFontCenter.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontCenter.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontCenter.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontCenter.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontCenter.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontCenter.setFont(createFont);

			CellStyle styleFontTable = wb.createCellStyle();
			styleFontTable.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontTable.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontTable.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontTable.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontTable.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontTable.setFillForegroundColor(IndexedColors.GREY_25_PERCENT
					.getIndex());
			styleFontTable.setFillPattern(CellStyle.SOLID_FOREGROUND);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			Iterator<GroupOrder> it = orders.iterator();
			int index = 0;
			while (it.hasNext()) {
				GroupOrder order = it.next();
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(order.getGroupCode());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(order.getDepartureDate());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue("【" + order.getProductBrandName() + "】"
						+ order.getProductName());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(4);
				cc.setCellValue(order.getSupplierName() + "\n"
						+ order.getSupplierCode() + "\n"
						+ order.getContactName());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(5);
				cc.setCellValue(order.getContactName());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(order.getReceiveMode());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(7);
				cc.setCellValue((order.getProvinceName() == null ? "" : order
						.getProvinceName())
						+ (order.getCityName() == null ? "" : order
								.getCityName()));
				cc.setCellStyle(cellStyle);
				cc = row.createCell(8);
				cc.setCellValue((order.getNumAdult() == null ? 0 : order
						.getNumAdult())
						+ "+"
						+ (order.getNumChild() == null ? 0 : order
								.getNumChild())
						+ "+"
						+ (order.getNumGuide() == null ? 0 : order
								.getNumGuide()));
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				cc.setCellValue(order.getSaleOperatorName());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(10);
				cc.setCellValue(order.getOperatorName());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(11);
				cc.setCellValue(order.getPrices().replace(",", "\n"));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(12);
				cc.setCellValue(order.getTotal() == null ? 0 : order.getTotal()
						.doubleValue()); // 团款
				cc.setCellStyle(cellStyle);
				cc = row.createCell(13);
				cc.setCellValue(order.getTotalCash().doubleValue());// 已收
				cc.setCellStyle(cellStyle);
				cc = row.createCell(14);
				cc.setCellValue((order.getTotal() == null ? 0 : order
						.getTotal().doubleValue())
						- (order.getTotalCash() == null ? 0 : order
								.getTotalCash().doubleValue()));// 未收
				cc.setCellStyle(cellStyle);
				index++;

			}
			List<String> list = getTotal(orders);
			row = sheet.createRow(orders.size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellValue(list.get(0) + "+" + list.get(1) + "+" + list.get(2));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellStyle(styleRight);
			cc = row.createCell(12);
			cc.setCellValue(list.get(3)); // 团款
			cc.setCellStyle(cellStyle);
			cc = row.createCell(13);
			cc.setCellValue(list.get(4));// 已收
			cc.setCellStyle(cellStyle);
			cc = row.createCell(14);
			cc.setCellValue(list.get(5));// 未收
			cc.setCellStyle(cellStyle);
			CellRangeAddress region = new CellRangeAddress(orders.size() + 3,
					orders.size() + 4, 0, 14);
			sheet.addMergedRegion(region);
			row = sheet.createRow(orders.size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("应收款详情.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);
	}

	/**
	 * 应收款统计-对账单导出excel
	 * 
	 * @param request
	 * @param response
	 * @param vo
	 * @param page
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value = "/getPaymentData.do")
	@ResponseBody
	public void getPaymentData(HttpServletRequest request,
			HttpServletResponse response, PaymentExportVO vo, Integer page,
			Integer pageSize) {
		List<SysBizBankAccount> sysBizBankAccountList = bizBankAccountService
				.getListByBizId(WebUtils.getCurBizId(request));

		PageBean<PaymentExportVO> pageBean = new PageBean<PaymentExportVO>();
		pageBean.setParameter(vo);
		List<GroupOrder> orders = groupOrderService.selectPaymentDetailList(
				pageBean, WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		String path = "";

		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/paymentDetail.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			XSSFFont createFont = wb.createFont();
			createFont.setFontName("微软雅黑");
			createFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);// 粗体显示
			createFont.setFontHeightInPoints((short) 12);

			XSSFFont tableIndex = wb.createFont();
			tableIndex.setFontName("宋体");
			tableIndex.setFontHeightInPoints((short) 11);

			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleFontCenter = wb.createCellStyle();
			styleFontCenter.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontCenter.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontCenter.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontCenter.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontCenter.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontCenter.setFont(createFont);

			CellStyle styleFontTable = wb.createCellStyle();
			styleFontTable.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontTable.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontTable.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontTable.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontTable.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontTable.setFillForegroundColor(IndexedColors.GREY_25_PERCENT
					.getIndex());
			styleFontTable.setFillPattern(CellStyle.SOLID_FOREGROUND);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右

			CellStyle styleTop = wb.createCellStyle();
			styleTop.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleTop.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleTop.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleTop.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleTop.setAlignment(CellStyle.ALIGN_LEFT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			Iterator<GroupOrder> it = orders.iterator();
			int index = 0;
			while (it.hasNext()) {
				GroupOrder order = it.next();
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(order.getGroupCode());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(order.getDepartureDate());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue("【" + order.getProductBrandName() + "】"
						+ order.getProductName());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(4);
				cc.setCellValue(order.getSupplierName() + "\n"
						+ order.getSupplierCode() + "\n"
						+ order.getContactName());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(5);
				cc.setCellValue(order.getContactName());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(order.getReceiveMode());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(7);
				cc.setCellValue((order.getProvinceName() == null ? "" : order
						.getProvinceName())
						+ (order.getCityName() == null ? "" : order
								.getCityName()));
				cc.setCellStyle(cellStyle);
				cc = row.createCell(8);
				cc.setCellValue((order.getNumAdult() == null ? 0 : order
						.getNumAdult())
						+ "+"
						+ (order.getNumChild() == null ? 0 : order
								.getNumChild())
						+ "+"
						+ (order.getNumGuide() == null ? 0 : order
								.getNumGuide()));
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				cc.setCellValue(order.getSaleOperatorName());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(10);
				cc.setCellValue(order.getOperatorName());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(11);
				cc.setCellValue(order.getPrices().replace(",", "\n"));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(12);
				cc.setCellValue(order.getTotal() == null ? 0 : order.getTotal()
						.doubleValue()); // 团款
				cc.setCellStyle(cellStyle);
				cc = row.createCell(13);
				cc.setCellValue(order.getTotalCash().doubleValue());// 已收
				cc.setCellStyle(cellStyle);
				cc = row.createCell(14);
				cc.setCellValue((order.getTotal() == null ? 0 : order
						.getTotal().doubleValue())
						- (order.getTotalCash() == null ? 0 : order
								.getTotalCash().doubleValue()));// 未收
				cc.setCellStyle(cellStyle);
				index++;

			}
			List<String> list = getTotal(orders);
			row = sheet.createRow(orders.size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellValue(list.get(0) + "+" + list.get(1) + "+" + list.get(2));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellStyle(styleRight);
			cc = row.createCell(12);
			cc.setCellValue(list.get(3)); // 团款
			cc.setCellStyle(cellStyle);
			cc = row.createCell(13);
			cc.setCellValue(list.get(4));// 已收
			cc.setCellStyle(cellStyle);
			cc = row.createCell(14);
			cc.setCellValue(list.get(5));// 未收
			cc.setCellStyle(cellStyle);

			/**
			 * 增加支付明细
			 */
			List<FinancePay> payDetailList = financeService
					.getFinancePayBySupplierId(vo.getSupplierId(),
							WebUtils.getCurBizId(request));
			CellRangeAddress region1 = new CellRangeAddress(orders.size() + 3,
					orders.size() + 4, 0, 6);
			sheet.addMergedRegion(region1);
			row = sheet.createRow(orders.size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("收款明细表");
			cc.setCellStyle(styleFontCenter);
			row = sheet.createRow(orders.size() + 5);
			cc = row.createCell(0);
			cc.setCellValue("序号");
			cc.setCellStyle(styleFontTable);
			cc = row.createCell(1);
			cc.setCellValue("账号");
			cc.setCellStyle(styleFontTable);
			cc = row.createCell(2);
			cc.setCellValue("收款方式");
			cc.setCellStyle(styleFontTable);
			cc = row.createCell(3);
			cc.setCellValue("收款金额");
			cc.setCellStyle(styleFontTable);
			cc = row.createCell(4);
			cc.setCellValue("备注");
			cc.setCellStyle(styleFontTable);
			cc = row.createCell(5);
			cc.setCellValue("收款时间");
			cc.setCellStyle(styleFontTable);
			cc = row.createCell(6);
			cc.setCellValue("录入操作员");
			cc.setCellStyle(styleFontTable);
			// 遍历集合数据，产生数据
			Iterator<FinancePay> it1 = payDetailList.iterator();
			int index1 = 0;
			Integer totalCash = 0;
			int i = 6;
			while (it1.hasNext()) {
				FinancePay fp = it1.next();
				row = sheet.createRow(orders.size() + i);
				cc = row.createCell(0);
				cc.setCellValue(index1 + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(fp.getSupplierName());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(2);
				cc.setCellValue(fp.getPayType());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(3);
				cc.setCellValue(fp.getCash().intValue() + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(4);
				cc.setCellValue(fp.getRemark());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(5);
				cc.setCellValue(DateUtils.format(fp.getPayDate(), "yyyy-MM-dd"));
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(fp.getUserName());
				cc.setCellStyle(cellStyle);
				// System.out.println(fp.getCash().intValue());
				totalCash += fp.getCash().intValue();
				i++;
			}
			row = sheet.createRow(orders.size() + payDetailList.size() + 6);
			cc = row.createCell(0);
			cc.setCellValue(index1 + 1);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(1);
			cc.setCellValue("");
			cc.setCellStyle(cellStyle);
			cc = row.createCell(2);
			cc.setCellValue("合计：");
			cc.setCellStyle(cellStyle);
			cc = row.createCell(3);
			cc.setCellValue(totalCash + "");
			cc.setCellStyle(cellStyle);
			cc = row.createCell(4);
			cc.setCellValue("");
			cc.setCellStyle(cellStyle);
			cc = row.createCell(5);
			cc.setCellValue("");
			cc.setCellStyle(cellStyle);
			cc = row.createCell(6);
			cc.setCellValue("");
			cc.setCellStyle(cellStyle);

			/*
			 * CellRangeAddress region = new CellRangeAddress(orders.size()
			 * +payDetailList.size()+6 , orders.size() +payDetailList.size()+ 7,
			 * 0, 6); sheet.addMergedRegion(region); row =
			 * sheet.createRow(orders.size() +payDetailList.size()+6); cc =
			 * row.createCell(0); cc.setCellValue("合计："+totalCash) ;
			 */

			CellRangeAddress region2 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 8, orders.size()
					+ payDetailList.size() + 9, 0, 1);
			sheet.addMergedRegion(region2);
			CellRangeAddress region3 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 8, orders.size()
					+ payDetailList.size() + 8, 2, 3);
			sheet.addMergedRegion(region3);
			CellRangeAddress region4 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 8, orders.size()
					+ payDetailList.size() + 9, 4, 5);
			sheet.addMergedRegion(region4);

			row = sheet.createRow(orders.size() + payDetailList.size() + 8);
			setRowStyle(row, cellStyle);
			cc = row.createCell(0);
			styleLeft.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
			styleLeft.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString("期初金额"));
			cc = row.createCell(2);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString("期中发生"));
			cc = row.createCell(4);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString("期末余额"));
			row = sheet.createRow(orders.size() + payDetailList.size() + 9);
			setRowStyle(row, cellStyle);
			cc = row.createCell(0);
			cc = row.createCell(2);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString("应收"));
			cc = row.createCell(3);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString("已收"));

			CellRangeAddress region22 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 10, orders.size()
					+ payDetailList.size() + 10, 0, 1);
			sheet.addMergedRegion(region22);
			// 本期发生的应收已收
			GroupOrder orderMiddle = groupOrderService.selectTotalStatic(
					pageBean, WebUtils.getCurBizId(request),
					WebUtils.getDataUserIdSet(request));
			vo.setEndTime(null);
			pageBean.setParameter(vo);
			// 期初余额
			GroupOrder orderPre = groupOrderService.selectTotalStatic(pageBean,
					WebUtils.getCurBizId(request),
					WebUtils.getDataUserIdSet(request));
			if (orderPre == null) {
				orderPre = new GroupOrder();
				orderPre.setTotal(new BigDecimal(0));
				orderPre.setTotalCash(new BigDecimal(0));
			}
			if (orderMiddle == null) {
				orderMiddle = new GroupOrder();
				orderMiddle.setTotal(new BigDecimal(0));
				orderMiddle.setTotalCash(new BigDecimal(0));
			}
			CellRangeAddress region44 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 10, orders.size()
					+ payDetailList.size() + 10, 4, 5);
			sheet.addMergedRegion(region44);
			row = sheet.createRow(orders.size() + payDetailList.size() + 10);
			setRowStyle(row, cellStyle);
			cc = row.createCell(0);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString(NumberUtil
					.formatDouble((orderPre.getTotal().doubleValue() - orderPre
							.getTotalCash().doubleValue()))));
			cc = row.createCell(2);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString(NumberUtil
					.formatDouble(orderMiddle.getTotal())));
			cc = row.createCell(3);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString(NumberUtil
					.formatDouble(orderMiddle.getTotalCash())));
			cc = row.createCell(4);
			cc.setCellStyle(styleLeft);
			cc.setCellValue(new XSSFRichTextString(NumberUtil
					.formatDouble(orderPre.getTotal().doubleValue()
							- orderPre.getTotalCash().doubleValue()
							+ orderMiddle.getTotal().doubleValue()
							- orderMiddle.getTotalCash().doubleValue())));

			CellRangeAddress region5 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 11, orders.size()
					+ payDetailList.size() + 19, 0, 4);
			sheet.addMergedRegion(region5);
			row = sheet.createRow(orders.size() + payDetailList.size() + 11);
			cc = row.createCell(0);
			styleTop.setWrapText(true);
			cc.setCellStyle(styleTop);
			StringBuilder sb = new StringBuilder();
			StringBuilder sb1 = new StringBuilder();
			for (SysBizBankAccount sysBizBankAccount : sysBizBankAccountList) {
				sb.append("类别:"
						+ (sysBizBankAccount.getAccountType() == 1 ? "个人账户"
								: "对公账户") + " 银行名称："
						+ sysBizBankAccount.getBankName()
						+ sysBizBankAccount.getBankAccount() + " 开户全称："
						+ sysBizBankAccount.getAccountName() + " 公司账号："
						+ sysBizBankAccount.getAccountNo() + "\r\n");
				sb1.append("\r\n");
			}
			sb.append("\r\n" + "地接社盖章：" + "\r\n" + "签字：_________" + "\r\n"
					+ "日期：_________" + "\r\n");
			sb1.append("\r\n" + "组团社盖章：" + "\r\n" + "签字：_________" + "\r\n"
					+ "日期：_________" + "\r\n");
			cc.setCellValue(new XSSFRichTextString(sb.toString()));
			CellRangeAddress region6 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 11, orders.size()
					+ payDetailList.size() + 19, 5, 6);
			sheet.addMergedRegion(region6);
			row = sheet.getRow(orders.size() + payDetailList.size() + 11);
			cc = row.createCell(5);
			styleTop.setWrapText(true);
			cc.setCellStyle(styleTop);
			cc.setCellValue(new XSSFRichTextString(sb1.toString()));

			CellRangeAddress region7 = new CellRangeAddress(orders.size()
					+ payDetailList.size() + 20, orders.size()
					+ payDetailList.size() + 21, 0, 6);
			sheet.addMergedRegion(region7);
			row = sheet.createRow(orders.size() + payDetailList.size() + 19);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("应收款详情.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);
	}

	public void setRowStyle(Row row, CellStyle cellStyle) {
		Cell cc = null;
		cc = row.createCell(0);
		cc.setCellValue("");
		cc.setCellStyle(cellStyle);
		cc = row.createCell(1);
		cc.setCellValue("");
		cc.setCellStyle(cellStyle);
		cc = row.createCell(2);
		cc.setCellValue("");
		cc.setCellStyle(cellStyle);
		cc = row.createCell(3);
		cc.setCellValue("");
		cc.setCellStyle(cellStyle);
		cc = row.createCell(4);
		cc.setCellValue("");
		cc.setCellStyle(cellStyle);
		cc = row.createCell(5);
		cc.setCellValue("");
		cc.setCellStyle(cellStyle);
		cc = row.createCell(6);
		cc.setCellValue("");
		cc.setCellStyle(cellStyle);
	}

	private void download(String path, String fileName,
			HttpServletRequest request, HttpServletResponse response) {
		try {
			// path是指欲下载的文件的路径。
			File file = new File(path);
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();

			/*
			 * //解决IE浏览器下下载文件名乱码问题 if
			 * (request.getHeader("USER-AGENT").indexOf("msie") > -1){ fileName
			 * = new URLEncoder().encode(fileName) ; }
			 */
			// 设置response的Header
			response.addHeader("Content-Disposition", "attachment;filename="
					+ fileName);
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(
					response.getOutputStream());
			response.setContentType("application/vnd.ms-excel;charset=gb2312");
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
			file.delete();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

	private List<String> getTotal(List<GroupOrder> orders) {
		DecimalFormat format = new DecimalFormat("#.##");
		List<String> list = new ArrayList<String>();
		double numAdult = 0;
		double numChild = 0;
		double numGuide = 0;
		double total = 0;
		double totalCash = 0;
		double notCash = 0;
		for (GroupOrder order : orders) {
			numAdult += order.getNumAdult() == null ? 0 : order.getNumAdult();
			numChild += order.getNumChild() == null ? 0 : order.getNumChild();
			numGuide += order.getNumGuide() == null ? 0 : order.getNumGuide();
			total += (order.getTotal() == null ? 0 : order.getTotal()
					.doubleValue());
			totalCash += (order.getTotalCash() == null ? 0 : order
					.getTotalCash().doubleValue());
			notCash += (order.getTotal() == null ? 0 : order.getTotal()
					.doubleValue())
					- (order.getTotalCash() == null ? 0 : order.getTotalCash()
							.doubleValue());
		}
		list.add(format.format(numAdult));
		list.add(format.format(numChild));
		list.add(format.format(numGuide));
		list.add(format.format(total));
		list.add(format.format(totalCash));
		list.add(format.format(notCash));
		return list;
	}

	@RequestMapping(value = "/shopInfoDetailList.do")
	public String shopInfoDetail(HttpServletRequest request, ModelMap model,
			QueryShopInfo shop) {
		PageBean pageBean = new PageBean();
		if (shop.getPage() == null) {
			shop.setPage(1);
		}
		if (shop.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(shop.getPageSize());
		}
		// shop.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(WebUtils.getQueryParamters(request));
		pageBean.setPage(shop.getPage());
		pageBean = bookingShopService.getshopInfoDetail(pageBean);
		if (pageBean.getResult() != null && pageBean.getResult().size() > 0) {
			for (QueryShopInfo qsi : (List<QueryShopInfo>) pageBean.getResult()) {

				List<GroupOrder> gOrders = groupOrderService
						.selectOrderByGroupId(qsi.getGroupId());
				qsi.setGroupOrders(gOrders);
				// List<BookingSupplierPO> supplierPOs =
				// bookingSupplierService.getBookingSupplierByGroupIdAndSupplierType(bGroup.getGroupId(),
				// supplierType, null, null, null);
				// bGroup.setBookingSuppliers(supplierPOs);

			}
		}
		model.addAttribute("page", pageBean);
		return "queries/shop/shopInfoDetail-listView";
	}

	/**
	 * @author : xuzejun
	 * @date : 2015年7月25日 下午2:31:01
	 * @Description: 跳转购物列表下拉详情
	 */
	@RequestMapping(value = "/shopDetailList.htm")
	public String shopDetailList(ModelMap model, Integer id) {
		List<BookingShopDetail> bookingShopDetail = bookingShopDetailService
				.getShopDetailListByBookingId(id);
		model.addAttribute("shopDetail", bookingShopDetail);
		return "queries/shop/shop-listViewDetail";
	}

	/**
	 * 客人购物
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/guestShopList.htm")
	public String toGuestShopList(HttpServletRequest request, ModelMap model) {
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> sourceTypeList = dicService.getListByTypeCode(
				Constants.GUEST_SOURCE_TYPE, bizId);
		model.addAttribute("sourceTypeList", sourceTypeList);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/shop/guestShop-list";
	}

	@RequestMapping(value = "/guestShopList.do")
	public String guestShopList(ModelMap model, QueryGuideShop shop,
			HttpServletRequest request, TourGroupVO groupVo) {
		PageBean pageBean = new PageBean();
		if (shop.getPage() == null) {
			shop.setPage(1);
		}
		if (shop.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(shop.getPageSize());
		}
		shop.setBizId(WebUtils.getCurBizId(request));
		Map paramters = WebUtils.getQueryParamters(request);
		if (StringUtils.isBlank(groupVo.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupVo.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupVo.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				shop.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
				// paramters.put("saleOperatorIds",
				// salesOperatorIds.substring(0, salesOperatorIds.length()-1));
			}
		}
		pageBean.setParameter(shop);
		pageBean.setPage(shop.getPage());
		pageBean = bookingShopService.getGuideShop(pageBean,
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("shoppingDataState", shop.getShoppingDataState());
		model.addAttribute("page", pageBean);
		return "queries/shop/guestShop-listView";
	}

	/**
	 * 购物查询
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/shopSelectList.htm")
	public String toShopSelectList(ModelMap model) {

		return "queries/shop/shopSelect-list";
	}

	@RequestMapping(value = "/shopSelectList.do")
	public String shopSelectList(HttpServletRequest request, ModelMap model,
			TourGroupVO group) {
		PageBean pageBean = new PageBean();
		if (group.getPage() == null) {
			group.setPage(1);
		}
		if (group.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(group.getPageSize());
		}
		group.setSupplierType(Constants.SHOPPING);
		group.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(group);
		pageBean.setPage(group.getPage());

		pageBean = tourGroupService.getGroupInfoList(pageBean, group,
				WebUtils.getDataUserIdSet(request));
		fillData(pageBean.getResult());
		if (pageBean.getResult() != null && pageBean.getResult().size() > 0) {
			for (BookingGroup bGroup : (List<BookingGroup>) pageBean
					.getResult()) {

				List<GroupOrder> gOrders = groupOrderService
						.selectOrderByGroupId(bGroup.getGroupId());
				bGroup.setGroupOrderList(gOrders);
			}
		}
		model.addAttribute("page", pageBean);
		return "queries/shop/shopSelect-listView";
	}

	private void fillData(List<BookingGroup> bookingGroupList) {
		if (bookingGroupList != null && bookingGroupList.size() > 0) {
			for (BookingGroup group : bookingGroupList) {
				if (group.getProductBrandName() != null) {
					group.setProductName("【" + group.getProductBrandName()
							+ "】" + group.getProductName());
				}
				// 填充定制团的组团社名称
				if (group.getSupplierId() != null) {
					SupplierInfo supplierInfo = supplierSerivce
							.selectBySupplierId(group.getSupplierId());
					if (supplierInfo != null) {
						group.setSupplierName(supplierInfo.getNameFull());
					}
				}
				// 购物查询
				BookingShopSelect b = bookingShopService.getShopSelect(group
						.getGroupId());
				group.setBookingShopSelect(b);

			}
		}
	}

	@RequestMapping(value = "/getEmployeeIds.htm", method = RequestMethod.POST)
	@ResponseBody
	public String getEmployeeIds(HttpServletRequest request, String orgIds,
			Model model) {
		String employeeIds = "";
		Set<Integer> set = new HashSet<Integer>();
		String[] orgIdArr = orgIds.split(",");
		for (String orgIdStr : orgIdArr) {
			set.add(Integer.valueOf(orgIdStr));
		}
		set = platformEmployeeService.getUserIdListByOrgIdList(
				WebUtils.getCurBizId(request), set);
		String salesOperatorIds = "";
		for (Integer usrId : set) {
			salesOperatorIds += usrId + ",";
		}
		if (!salesOperatorIds.equals("")) {
			employeeIds = salesOperatorIds.substring(0,
					salesOperatorIds.length() - 1);
		}
		return successJson("employeeIds", employeeIds);
	}

	/**
	 * 应收款统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("paymentList")
	public String paymentQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(modelMap, bizId);
		return "queries/paymentList";
	}

	@RequestMapping("paymentStaticPreview.htm")
	public String paymentStaticPreview(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap, GroupOrder order) {
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();

		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(order.getOperatorIds())
				&& StringUtils.isNotBlank(order.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = order.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				order.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
				pms.put("saleOperatorIds", salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}

		pageBean.setPage(1);
		pageBean.setPageSize(10000);
		pageBean.setParameter(pms);
		// pageBean.setParameter(parameters);
		List<GroupOrder> orders = groupOrderService.selectPaymentStaticData2(
				pageBean, WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		modelMap.addAttribute("parameter", pms);
		modelMap.addAttribute("orders", orders);
		modelMap.addAttribute("printName", WebUtils.getCurUser(request)
				.getName());
		modelMap.addAttribute("printTime", DateUtils.format(new Date()));
		return "queries/paymentStaticPreview";
	}

	/**
	 * 应收款统计表导出
	 * 
	 * @param request
	 * @param response
	 * @param groupOrder
	 */
	@RequestMapping(value = "/paymentStaticExport.do")
	@ResponseBody
	public void paymentStaticExport(HttpServletRequest request,
			HttpServletResponse response, GroupOrder groupOrder) {
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
		pageBean.setPage(1);
		pageBean.setPageSize(10000);
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		// pageBean.setParameter(groupOrder);
		pageBean.setParameter(pms);
		List<GroupOrder> orders = groupOrderService.selectPaymentStaticData2(
				pageBean, WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		String path = "";

		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/paymentStatic.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			XSSFFont createFont = wb.createFont();
			createFont.setFontName("微软雅黑");
			createFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);// 粗体显示
			createFont.setFontHeightInPoints((short) 12);

			XSSFFont tableIndex = wb.createFont();
			tableIndex.setFontName("宋体");
			tableIndex.setFontHeightInPoints((short) 11);

			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleFontCenter = wb.createCellStyle();
			styleFontCenter.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontCenter.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontCenter.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontCenter.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontCenter.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontCenter.setFont(createFont);

			CellStyle styleFontTable = wb.createCellStyle();
			styleFontTable.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleFontTable.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleFontTable.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleFontTable.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleFontTable.setAlignment(CellStyle.ALIGN_CENTER); // 居中
			styleFontTable.setFillForegroundColor(IndexedColors.GREY_25_PERCENT
					.getIndex());
			styleFontTable.setFillPattern(CellStyle.SOLID_FOREGROUND);

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右

			CellStyle styleTop = wb.createCellStyle();
			styleTop.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleTop.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleTop.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleTop.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleTop.setAlignment(CellStyle.ALIGN_LEFT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			Iterator<GroupOrder> it = orders.iterator();
			int index = 0;
			while (it.hasNext()) {
				GroupOrder order = it.next();
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(order.getSupplierName());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				if (order.getPreTotal() != null) {
					cc.setCellValue(NumberUtil.formatDouble(order.getPreTotal()));
				}
				cc.setCellStyle(cellStyle);
				cc = row.createCell(3);
				cc.setCellValue(order.getOrderCount() + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(4);
				cc.setCellValue(order.getNumAdult() + "+" + order.getNumChild()
						+ "+" + order.getNumGuide() + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(5);
				cc.setCellValue(NumberUtil.formatDouble(order.getTotal()));
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(NumberUtil.formatDouble(order.getTotalCash()));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(7);
				Double tb = new Double(NumberUtil.formatDouble(order
						.getTotalBalance()));
				cc.setCellValue(NumberUtil.formatDouble(tb));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(8);
				Double bd = new Double(NumberUtil.formatDouble(order
						.getTotalBalance()))
						+ new Double(NumberUtil.formatDouble(order
								.getPreTotal()));
				cc.setCellValue(NumberUtil.formatDouble(bd));
				cc.setCellStyle(cellStyle);
				index++;
			}
			Map<String, String> map = getTotalData(orders);
			row = sheet.createRow(orders.size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellValue(map.get("preTotal"));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(3);
			cc.setCellValue(map.get("orderCountTotal"));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(4);
			cc.setCellValue(map.get("persons"));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(5);
			cc.setCellValue(map.get("groupTotal"));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(6);
			cc.setCellValue(map.get("groupTotalCash"));
			cc.setCellStyle(cellStyle);

			cc = row.createCell(7);
			cc.setCellValue(map.get("groupBlance1"));
			cc.setCellStyle(cellStyle);
			cc = row.createCell(8);
			cc.setCellValue(map.get("groupBlance"));
			cc.setCellStyle(cellStyle);
			CellRangeAddress region = new CellRangeAddress(orders.size() + 3,
					orders.size() + 3, 0, 8);
			sheet.addMergedRegion(region);
			row = sheet.createRow(orders.size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("应收款详情.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);
	}

	public Map<String, String> getTotalData(List<GroupOrder> orders) {
		Double preTotal = new Double(0);
		Integer orderCountTotal = 0;
		Integer totalAdult = 0;
		Integer totalChild = 0;
		Integer totalGuide = 0;
		Double groupTotal = new Double(0);
		Double groupTotalCash = new Double(0);
		Double groupBlance = new Double(0);
		Double groupBlance1 = new Double(0);
		for (GroupOrder order : orders) {
			preTotal += new Double(NumberUtil.formatDouble(order.getPreTotal()));
			orderCountTotal += order.getOrderCount();
			totalAdult += order.getNumAdult();
			totalChild += order.getNumChild();
			totalGuide += order.getNumGuide();
			groupTotal += new Double(NumberUtil.formatDouble(order.getTotal()));
			groupTotalCash += new Double(NumberUtil.formatDouble(order
					.getTotalCash()));
			groupBlance += new Double(NumberUtil.formatDouble(order
					.getTotalBalance()))
					+ new Double(NumberUtil.formatDouble(order.getPreTotal()));
			groupBlance1 += groupBlance - preTotal;
		}
		Map<String, String> map = new HashMap<String, String>();
		map.put("preTotal", NumberUtil.formatDouble(preTotal));
		map.put("orderCountTotal", orderCountTotal + "");
		map.put("persons", totalAdult + "大" + totalChild + "小" + totalGuide
				+ "陪");
		map.put("groupTotal", NumberUtil.formatDouble(groupTotal));
		map.put("groupTotalCash", NumberUtil.formatDouble(groupTotalCash));
		map.put("groupBlance", NumberUtil.formatDouble(groupBlance));
		map.put("groupBlance1", NumberUtil.formatDouble(groupBlance1));
		return map;
	}

	/**
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping("paymentDetailList")
	public String paymentDetailQueries(HttpServletRequest request,
			ModelMap model, PaymentCondition condition)
			throws UnsupportedEncodingException {
		List<RegionInfo> allProvince = regionService.getAllProvince();
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		model.addAttribute("allProvince", allProvince);
		// try {
		// System.out.println(new
		// String(condition.getSupplierName().getBytes("ISO-8859-1"),"UTF-8")) ;
		// condition.setSupplierName(new
		// String(condition.getSupplierName().getBytes("ISO-8859-1"),"UTF-8"));
		// } catch (UnsupportedEncodingException e) {
		// e.printStackTrace();
		// }
		model.put("condition", condition);
		return "queries/paymentDetailList";
	}

	@RequestMapping("toDebtList.htm")
	public String toDebtList(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		Calendar a = Calendar.getInstance();
		modelMap.put("yearLimit", a.get(Calendar.YEAR));
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(modelMap, bizId);
		return "queries/debtList";
	}

	@RequestMapping("restaurantQueryList.htm")
	public String restaurantList(HttpServletRequest request, Model model) {
		return "queries/restaurant/queryList";
	}

	/**
	 * 订餐统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("restaurantList.htm")
	public String restaurantQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.RESTAURANT);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 餐类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.RESTAURANT_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		modelMap.addAttribute("allProvince", allProvince);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		// 获取餐厅类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		modelMap.addAttribute("levelList", levelList);

		return "queries/restaurant/restaurantList";
	}

	/**
	 * 跳转到餐厅明细
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("restaurantBooking.htm")
	public String restaurantBooking(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.RESTAURANT);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/restaurant/restaurantDetailList";
	}

	/**
	 * 跳转到餐厅结算方式查询
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("restaurantJSFS.htm")
	public String restaurantJSFS(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.RESTAURANT);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取商家类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/restaurant/restaurantJSFSList";
	}

	@RequestMapping("restaurantDetailList.htm")
	public String restaurantDetailList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		List<RegionInfo> allProvince = regionService.getAllProvince();

		model.addAttribute("supplierType", Constants.RESTAURANT);
		model.addAttribute("bizId", bizId);
		model.addAttribute("levelList", levelList);
		model.addAttribute("cashType", cashTypes);
		model.addAttribute("allProvince", allProvince);

		return "queries/restaurant/restaurantDetailList2";
	}

	@RequestMapping("hotelQueryList.htm")
	public String hotelList(HttpServletRequest request, Model model) {
		return "queries/hotel/queryList";
	}

	/**
	 * 订房统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("hotelList.htm")
	public String hotelQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			SupplierInfo supplierInfo) {
		model.addAttribute("supplierType", Constants.HOTEL);
		model.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 酒店类型
		List<DicInfo> hotelType1 = dicService
				.getListByTypeCode(Constants.HOTEL_TYPE_CODE_1);
		model.addAttribute("hotelType1", hotelType1);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取酒店类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("levelList", levelList);

		return "queries/hotel/hotelList";
	}

	@RequestMapping("hotelBooking.htm")
	public String HotelBookingQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.HOTEL);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取酒店类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/hotel/hotelDetailList";
	}

	@RequestMapping("hotelJSFS.htm")
	public String hotelJSFS(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.HOTEL);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取酒店类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		return "queries/hotel/hotelJSFSList";
	}

	@RequestMapping("hotelDetailList.htm")
	public String HoteldetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.GYXX_JDXJ);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		List<RegionInfo> allProvince = regionService.getAllProvince();

		model.addAttribute("supplierType", Constants.HOTEL);
		model.addAttribute("bizId", bizId);
		model.addAttribute("levelList", levelList);
		model.addAttribute("cashType", cashTypes);
		model.addAttribute("allProvince", allProvince);

		return "queries/hotel/hotelDetailList2";
	}

	@RequestMapping("fleetQueryList.htm")
	public String fleetList(HttpServletRequest request, Model model) {
		return "queries/fleet/queryList";
	}

	/**
	 * 跳转到车队统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("fleetList.htm")
	public String fleetQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.FLEET);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 费用项目类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.FLEET_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		modelMap.addAttribute("allProvince", allProvince);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		// 获取类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_FLEET);
		modelMap.addAttribute("levelList", levelList);

		return "queries/fleet/fleetList";
	}

	/**
	 * 跳转到车队明细
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("fleetDetailList.htm")
	public String fleetDetailList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.FLEET);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_FLEET);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/fleet/fleetDetailList";
	}

	/**
	 * 跳转到车队结算方式
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("fleetJSFSList.htm")
	public String fleetJSFSList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.FLEET);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取商家类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_FLEET);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/fleet/fleetJSFSList";
	}

	/**
	 * 娱乐统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("entertainmentList.htm")
	public String entertainmentQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("supplierType", Constants.ENTERTAINMENT);
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		return "queries/entertainment/entertainmentList";
	}

	@RequestMapping("entertainmentDetailList.htm")
	public String entertainmentDetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("bizId", bizId);
		condition.setSupplierType(Constants.ENTERTAINMENT);
		model.put("condition", condition);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);
		return "queries/entertainment/entertainmentDetailList";
	}

	@RequestMapping("sightQueryList.htm")
	public String sightList(HttpServletRequest request, Model model) {
		return "queries/sight/queryList";
	}

	/**
	 * 门票统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("sightList.htm")
	public String sightList(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.SCENICSPOT);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.SCENICSPOT_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		modelMap.addAttribute("allProvince", allProvince);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		// 获取餐厅类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		modelMap.addAttribute("levelList", levelList);

		return "queries/sight/sightList";
	}

	/**
	 * 门票明细
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("sightBooking.htm")
	public String sightBookingList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.SCENICSPOT);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/sight/sightDetailList";
	}

	/**
	 * 门票结算方式
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("sightJSFS.htm")
	public String sightJSFS(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.SCENICSPOT);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取商家类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/sight/sightJSFSList";
	}

	@RequestMapping("sightDetailList.htm")
	public String sightDetailList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_SCENICSPOT);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		List<RegionInfo> allProvince = regionService.getAllProvince();

		model.addAttribute("supplierType", Constants.SCENICSPOT);
		model.addAttribute("bizId", bizId);
		model.addAttribute("levelList", levelList);
		model.addAttribute("cashType", cashTypes);
		model.addAttribute("allProvince", allProvince);

		return "queries/sight/sightDetailList2";
	}

	@RequestMapping("airTicketQueryList.htm")
	public String airTicketList(HttpServletRequest request, Model model) {
		return "queries/airTicket/queryList";
	}

	/**
	 * 飞机票统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("airTicketList.htm")
	public String airTicketQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.AIRTICKETAGENT);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 餐类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.AIRTICKET_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		modelMap.addAttribute("allProvince", allProvince);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		// 获取餐厅类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_AIRTICKETAGENT);
		modelMap.addAttribute("levelList", levelList);

		return "queries/airTicket/airTicketList";
	}

	@RequestMapping("airTicketBooking.htm")
	public String airTicketBookingQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		condition.setSupplierType(Constants.AIRTICKETAGENT);
		// model.addAttribute("bizId", bizId);
		model.put("condition", condition);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);

		model.addAttribute("cashType", cashTypes);
		return "queries/airTicket/airTicketDetailList1";
	}

	@RequestMapping("airTicketJSFS.htm")
	public String airTicketJSFS(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.AIRTICKETAGENT);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取商家类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_AIRTICKETAGENT);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/airTicket/airTicketJSFSList";
	}

	@RequestMapping("airTicketDetailList.htm")
	public String airTicketDetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		// model.addAttribute("bizId", bizId);
		Map parameters = WebUtils.getQueryParamters(request);
		if (null == parameters.get("startTime")
				&& null == parameters.get("endTime")) {
			Calendar c = Calendar.getInstance();
			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			c.set(year, month, 1, 0, 0, 0);
			// condition.setStartTime(df.format(c.getTime()));
			parameters.put("startTime", df.format(c.getTime()));
			// c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			parameters.put("endTime", df.format(c.getTime()));
			// condition.setEndTime(df.format(c.getTime()));

		}
		// condition.setSupplierType(Constants.AIRTICKETAGENT);
		if (StringUtils.isNotBlank((String) parameters.get("orgIds"))) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = ((String) parameters.get("orgIds")).split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			List<PlatformOrgPo> orgList = orgService.getOrgListByIdSet(
					WebUtils.getCurBizId(request), set);
			StringBuilder sb = new StringBuilder();
			for (PlatformOrgPo orgPo : orgList) {
				sb.append(orgPo.getName() + ",");
			}
			// condition.setOrgNames(sb.substring(0, sb.length()-1));
			parameters.put("orgNames", sb.substring(0, sb.length() - 1));

		}
		// 如果计调不为null，查询计调名字
		if (StringUtils.isNotBlank((String) parameters.get("saleOperatorIds"))) {
			Set<Integer> set = new HashSet<Integer>();
			String[] userIdArr = ((String) parameters.get("saleOperatorIds"))
					.split(",");
			for (String userIdStr : userIdArr) {
				set.add(Integer.valueOf(userIdStr));
			}
			List<PlatformEmployeePo> empList = platformEmployeeService
					.getEmpList(WebUtils.getCurBizId(request), set);
			StringBuilder sb = new StringBuilder();
			for (PlatformEmployeePo employeePo : empList) {
				sb.append(employeePo.getName() + "");
			}
			// condition.setSaleOperatorName(sb.substring(0, sb.length()-1));
			parameters
					.put("saleOperatorName", sb.substring(0, sb.length() - 1));
		}
		parameters.put("supplierType", Constants.AIRTICKETAGENT);
		model.put("condition", parameters);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);

		model.addAttribute("cashType", cashTypes);
		return "queries/airTicket/airTicketDetailList";
	}

	@RequestMapping("trainTicketQueryList.htm")
	public String trainTicketList(HttpServletRequest request, Model model) {
		return "queries/trainTicket/queryList";
	}

	/**
	 * 火车票统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("trainTicketList.htm")
	public String trainTicketQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.TRAINTICKETAGENT);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 餐类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.TRAINTICKET_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		modelMap.addAttribute("allProvince", allProvince);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		return "queries/trainTicket/trainTicketList";
	}

	@RequestMapping("trainTicketBooking.htm")
	public String trainTicketBookingQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		// model.addAttribute("bizId", bizId);
		condition.setSupplierType(Constants.TRAINTICKETAGENT);
		model.put("condition", condition);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);

		model.addAttribute("cashType", cashTypes);
		return "queries/trainTicket/trainTicketDetailList";
	}

	@RequestMapping("trainTicketJSFS.htm")
	public String trainTicketJSFS(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.TRAINTICKETAGENT);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取商家类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_TRAINTICKETAGENT);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/trainTicket/trainTicketJSFSList";
	}

	@RequestMapping("trainTicketDetailList.htm")
	public String trainTicketDetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		// model.addAttribute("bizId", bizId);
		Map parameters = WebUtils.getQueryParamters(request);
		if (null == parameters.get("startTime")
				&& null == parameters.get("endTime")) {
			Calendar c = Calendar.getInstance();
			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			c.set(year, month, 1, 0, 0, 0);
			// condition.setStartTime(df.format(c.getTime()));
			parameters.put("startTime", df.format(c.getTime()));
			// c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			parameters.put("endTime", df.format(c.getTime()));
			// condition.setEndTime(df.format(c.getTime()));

		}
		// condition.setSupplierType(Constants.AIRTICKETAGENT);
		if (StringUtils.isNotBlank((String) parameters.get("orgIds"))) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = ((String) parameters.get("orgIds")).split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			List<PlatformOrgPo> orgList = orgService.getOrgListByIdSet(
					WebUtils.getCurBizId(request), set);
			StringBuilder sb = new StringBuilder();
			for (PlatformOrgPo orgPo : orgList) {
				sb.append(orgPo.getName() + ",");
			}
			// condition.setOrgNames(sb.substring(0, sb.length()-1));
			parameters.put("orgNames", sb.substring(0, sb.length() - 1));

		}
		// 如果计调不为null，查询计调名字
		if (StringUtils.isNotBlank((String) parameters.get("saleOperatorIds"))) {
			Set<Integer> set = new HashSet<Integer>();
			String[] userIdArr = ((String) parameters.get("saleOperatorIds"))
					.split(",");
			for (String userIdStr : userIdArr) {
				set.add(Integer.valueOf(userIdStr));
			}
			List<PlatformEmployeePo> empList = platformEmployeeService
					.getEmpList(WebUtils.getCurBizId(request), set);
			StringBuilder sb = new StringBuilder();
			for (PlatformEmployeePo employeePo : empList) {
				sb.append(employeePo.getName() + "");
			}
			// condition.setSaleOperatorName(sb.substring(0, sb.length()-1));
			parameters
					.put("saleOperatorName", sb.substring(0, sb.length() - 1));
		}
		parameters.put("supplierType", Constants.TRAINTICKETAGENT);
		model.put("condition", parameters);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);

		model.addAttribute("cashType", cashTypes);
		return "queries/trainTicket/trainTicketDetailList2";
	}

	/**
	 * 高尔夫统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("golfList.htm")
	public String golfQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("supplierType", Constants.GOLF);
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		return "queries/golf/golfList";
	}

	@RequestMapping("golfDetailList.htm")
	public String golfDetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		condition.setSupplierType(Constants.GOLF);
		model.put("condition", condition);
		return "queries/golf/golfDetailList";
	}

	@RequestMapping("insuranceQueryList.htm")
	public String insuranceList(HttpServletRequest request, Model model) {
		return "queries/insurance/queryList";
	}

	/**
	 * 保险业务统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("insuranceList.htm")
	public String insuranceQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.INSURANCE);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 餐类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.INSURANCE_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		modelMap.addAttribute("allProvince", allProvince);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		// 获取餐厅类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_INSURANCE);
		modelMap.addAttribute("levelList", levelList);
		return "queries/insurance/insuranceList";
	}

	@RequestMapping("insuranceDetailList.htm")
	public String insuranceDetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_INSURANCE);
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		List<RegionInfo> allProvince = regionService.getAllProvince();

		model.addAttribute("supplierType", Constants.INSURANCE);
		model.addAttribute("bizId", bizId);
		model.addAttribute("levelList", levelList);
		model.addAttribute("cashType", cashTypes);
		model.addAttribute("allProvince", allProvince);

		return "queries/insurance/insuranceDetailList2";
	}

	@RequestMapping("insuranceBooking.htm")
	public String insuranceBookingQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.INSURANCE);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_INSURANCE);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/insurance/insuranceDetailList";
	}

	@RequestMapping("insuranceJSFS.htm")
	public String insuranceJSFS(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.INSURANCE);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取商家类别
		List<DicInfo> levelList = dicService
				.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_INSURANCE);
		model.addAttribute("levelList", levelList);

		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);

		return "queries/insurance/insuranceJSFSList";
	}

	/**
	 * 下接社统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("angencyList.htm")
	public String angencyQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		return null;
	}

	@RequestMapping("incomeQueryList.htm")
	public String incomeList(HttpServletRequest request, Model model) {
		return "queries/income/queryList";
	}

	/**
	 * 其他收入统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("incomeList.htm")
	public String incomeQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.OTHERINCOME);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.OTHER_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.QTSR_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		/*
		 * List<RegionInfo> allProvince = regionService.getAllProvince();
		 * modelMap.addAttribute("allProvince", allProvince);
		 * 
		 * List<DicInfo> levelList =
		 * dicService.getListByTypeCode(BasicConstants.
		 * SUPPLIER_LEVEL_RESTAURANT); modelMap.addAttribute("levelList",
		 * levelList);
		 */

		return "queries/income/incomeList";
	}

	@RequestMapping("incomeDetailList")
	public String incomeDetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.OTHERINCOME);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.QTSR_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取类别
		// List<DicInfo> levelList =
		// dicService.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		// model.addAttribute("levelList", levelList);

		// List<RegionInfo> allProvince = regionService.getAllProvince();
		// model.addAttribute("allProvince", allProvince);

		return "queries/income/incomeDetailList";
	}

	@RequestMapping("outcomeQueryList.htm")
	public String outcomeList(HttpServletRequest request, Model model) {
		return "queries/outcome/queryList";
	}

	/**
	 * 其他支出统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("outcomeList.htm")
	public String outcomeQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap,
			SupplierInfo supplierInfo) {
		modelMap.addAttribute("supplierType", Constants.OTHEROUTCOME);
		modelMap.addAttribute("supplierInfo", supplierInfo);
		Integer bizId = WebUtils.getCurBizId(request);

		// 类型
		List<DicInfo> Type1 = dicService
				.getListByTypeCode(Constants.OTHER_TYPE_CODE);
		modelMap.addAttribute("Type1", Type1);

		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		modelMap.addAttribute("cashType", cashTypes);

		/*
		 * List<RegionInfo> allProvince = regionService.getAllProvince();
		 * modelMap.addAttribute("allProvince", allProvince);
		 * 
		 * List<DicInfo> levelList =
		 * dicService.getListByTypeCode(BasicConstants.
		 * SUPPLIER_LEVEL_RESTAURANT); modelMap.addAttribute("levelList",
		 * levelList);
		 */
		return "queries/outcome/outcomeList";
	}

	@RequestMapping("outcomeDetailList")
	public String outcomeDetailQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			PaymentCondition condition) {
		Integer bizId = WebUtils.getCurBizId(request);
		condition.setSupplierType(Constants.OTHEROUTCOME);
		model.addAttribute("condition", condition);

		// 从字典中查询结算方式
		List<DicInfo> cashTypes = dicService.getListByTypeCode(
				BasicConstants.GYXX_JSFS, bizId);
		model.addAttribute("cashType", cashTypes);

		// 获取类别
		// List<DicInfo> levelList =
		// dicService.getListByTypeCode(BasicConstants.SUPPLIER_LEVEL_RESTAURANT);
		// model.addAttribute("levelList", levelList);

		// List<RegionInfo> allProvince = regionService.getAllProvince();
		// model.addAttribute("allProvince", allProvince);

		return "queries/outcome/outcomeDetailList";
	}

	@RequestMapping("deliveryQueryList.htm")
	public String deliveryList(HttpServletRequest request, Model model) {
		return "queries/deliveryQueryList";
	}

	/**
	 * 跳转到下接社统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("deliveryList.htm")
	public String deliveryList(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(modelMap, bizId);
		// Integer bizId = WebUtils.getCurBizId(request);
		// modelMap.addAttribute("bizId", bizId);
		return "queries/delivery-list";
	}

	/**
	 * 跳转到下接社明细
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("deliveryDetailList.htm")
	public String deliveryDetailList(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(modelMap, bizId);
		// modelMap.addAttribute("bizId", bizId);

		Map paramters = WebUtils.getQueryParamters(request);
		if (null == paramters.get("start_min")
				&& null == paramters.get("start_max")) {
			Calendar c = Calendar.getInstance();
			int year = c.get(Calendar.YEAR);
			int month = c.get(Calendar.MONTH);
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			c.set(year, month, 1, 0, 0, 0);
			// condition.setStartTime(c.getTime()+"");
			paramters.put("start_min", df.format(c.getTime()));
			c.set(year, month, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			paramters.put("start_max", df.format(c.getTime()));
			// condition.setEndTime(c.getTime()+"");

		}
		if (StringUtils.isNotBlank((String) paramters.get("orgIds"))) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = ((String) paramters.get("orgIds")).split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			List<PlatformOrgPo> orgList = orgService.getOrgListByIdSet(
					WebUtils.getCurBizId(request), set);
			StringBuilder sb = new StringBuilder();
			for (PlatformOrgPo orgPo : orgList) {
				sb.append(orgPo.getName() + ",");
			}
			// condition.setOrgNames(sb.substring(0, sb.length()-1));
			paramters.put("orgNames", sb.substring(0, sb.length() - 1));

		}
		// 如果计调不为null，查询计调名字
		if (StringUtils.isNotBlank((String) paramters.get("saleOperatorIds"))) {
			Set<Integer> set = new HashSet<Integer>();
			String[] userIdArr = ((String) paramters.get("saleOperatorIds"))
					.split(",");
			for (String userIdStr : userIdArr) {
				set.add(Integer.valueOf(userIdStr));
			}
			List<PlatformEmployeePo> empList = platformEmployeeService
					.getEmpList(WebUtils.getCurBizId(request), set);
			StringBuilder sb = new StringBuilder();
			for (PlatformEmployeePo employeePo : empList) {
				sb.append(employeePo.getName() + "");
			}
			// condition.setSaleOperatorName(sb.substring(0, sb.length()-1));
			paramters.put("saleOperatorName", sb.substring(0, sb.length() - 1));

		}
		modelMap.addAttribute("parameters", paramters);
		return "queries/delivery-detail-list";
	}

	@RequestMapping(value = "getAirTicketDetail.do")
	public String getAirTicketDetail(HttpServletRequest request,
			HttpServletResponse reponse, Integer flag, ModelMap model,
			String sl, String ssl, String svc, Integer visit) {

		Integer page = 1;
		Integer pageSize = 15;
		try {
			page = Integer.parseInt(request.getParameter("page"));
			pageSize = Integer.parseInt(request.getParameter("pageSize"));
		} catch (NumberFormatException e) {
			// log.error(e);
		}
		String supplierType = request.getParameter("supplierType");
		String dateType = request.getParameter("dateType");
		String dateFrom = request.getParameter("dateFrom");
		String dateTo = request.getParameter("dateTo");
		String groupCode = request.getParameter("groupCode");
		String supplierName = request.getParameter("supplierName");
		String paymentState = request.getParameter("paymentState");
		String productName = request.getParameter("productName");
		String lineName = request.getParameter("lineName");
		String receiveMode = request.getParameter("receiveMode");
		String operatorIds = request.getParameter("operatorIds");
		String operatorNames = request.getParameter("operatorNames");
		String groupMode = request.getParameter("groupMode");
		String cashType = request.getParameter("cashType");
		HashMap<String, String> parameter = new HashMap<String, String>();
		if (supplierType != null && !supplierType.equals("")) {
			parameter.put("supplierType", supplierType);
		}
		if (dateType != null && !dateType.equals("")) {
			parameter.put("dateType", dateType);
		}
		if (dateFrom != null && !dateFrom.equals("")) {
			parameter.put("dateFrom", dateFrom);
		}
		if (dateTo != null && !dateTo.equals("")) {
			parameter.put("dateTo", dateTo);
		}
		parameter.put("bizId", WebUtils.getCurBizId(request).toString());
		if (groupCode != null && !groupCode.equals("")) {
			parameter.put("groupCode", groupCode);
		}
		if (supplierName != null && !supplierName.equals("")) {
			parameter.put("supplierName", supplierName);
		}
		if (paymentState != null && !paymentState.equals("")) {
			parameter.put("paymentState", paymentState);
		}
		if (productName != null && !productName.equals("")) {
			parameter.put("productName", productName);
		}
		if (lineName != null && !lineName.equals("")) {
			parameter.put("lineName", lineName);
		}
		if (receiveMode != null && !receiveMode.equals("")) {
			parameter.put("receiveMode", receiveMode);
		}
		if (operatorIds != null && !operatorIds.equals("")) {
			parameter.put("operatorIds", operatorIds);
		}
		if (groupMode != null && !groupMode.equals("")) {
			parameter.put("groupMode", groupMode);
		}
		if (cashType != null && !cashType.equals("")) {
			parameter.put("cashType", cashType);
		}

		PageBean<BookingAirTicket> pageBean = new PageBean<BookingAirTicket>();
		pageBean.setPage(page);
		pageBean.setPageSize(pageSize);
		pageBean.setParameter(parameter);

		model.addAttribute("sum",
				bookingSupplierService.sumAirTicketBooking(pageBean));
		pageBean = bookingSupplierService
				.selectAirTicketBookingListPage(pageBean);
		model.addAttribute("pageBean", pageBean);

		// 取得订单明细
		/*
		 * HashMap<Integer, String> detailHtml = new HashMap<Integer, String>();
		 * SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); for
		 * (BookingAirTicket booking : pageBean.getResult()) {
		 * List<BookingSupplierDetail> detailList =
		 * detailService.selectByPrimaryBookId(booking.getId()); StringBuffer
		 * html = new StringBuffer(); for (BookingSupplierDetail detail :
		 * detailList) {
		 * html.append(sdf.format(detail.getItemDate())).append(" &nbsp; ");
		 * html.append("【").append(detail.getTicketFlight()).append("】").append(
		 * " &nbsp; ");
		 * html.append(detail.getItemPrice()).append("*(").append(detail
		 * .getItemNum()).append("-")
		 * .append(detail.getItemNumMinus()).append(")<br/>"); }
		 * detailHtml.put(booking.getId(), html.toString()); }
		 * model.addAttribute("detailHtmlMap", detailHtml);
		 */

		// 取得本页合计
		BigDecimal sumPageTotal = new BigDecimal(0);
		BigDecimal sumPageTotalCash = new BigDecimal(0);
		for (BookingAirTicket booking : pageBean.getResult()) {
			sumPageTotal = sumPageTotal.add(booking.getTotal());
			sumPageTotalCash = sumPageTotalCash
					.add(booking.getTotalCash() == null ? new BigDecimal(0)
							: booking.getTotalCash());
		}
		model.addAttribute("sumPageTotal", sumPageTotal);
		model.addAttribute("sumPageTotalCash", sumPageTotalCash);
		model.addAttribute("sumPageTotalBalance",
				sumPageTotal.subtract(sumPageTotalCash));

		return "queries/airTicket/airTicketDetailTable1";
	}

	@RequestMapping(value = "getTrainTicketDetail.do")
	public String getTrainTicketDetail(HttpServletRequest request,
			HttpServletResponse reponse, Integer flag, ModelMap model,
			String sl, String ssl, String svc, Integer visit) {

		Integer page = 1;
		Integer pageSize = 15;
		try {
			page = Integer.parseInt(request.getParameter("page"));
			pageSize = Integer.parseInt(request.getParameter("pageSize"));
		} catch (NumberFormatException e) {
			// log.error(e);
		}
		String supplierType = request.getParameter("supplierType");
		String dateType = request.getParameter("dateType");
		String dateFrom = request.getParameter("dateFrom");
		String dateTo = request.getParameter("dateTo");
		String groupCode = request.getParameter("groupCode");
		String supplierName = request.getParameter("supplierName");
		String paymentState = request.getParameter("paymentState");
		String productName = request.getParameter("productName");
		String lineName = request.getParameter("lineName");
		String receiveMode = request.getParameter("receiveMode");
		String operatorIds = request.getParameter("operatorIds");
		String operatorNames = request.getParameter("operatorNames");
		String groupMode = request.getParameter("groupMode");
		String cashType = request.getParameter("cashType");
		HashMap<String, String> parameter = new HashMap<String, String>();
		if (supplierType != null && !supplierType.equals("")) {
			parameter.put("supplierType", supplierType);
		}
		if (dateType != null && !dateType.equals("")) {
			parameter.put("dateType", dateType);
		}
		if (dateFrom != null && !dateFrom.equals("")) {
			parameter.put("dateFrom", dateFrom);
		}
		if (dateTo != null && !dateTo.equals("")) {
			parameter.put("dateTo", dateTo);
		}
		parameter.put("bizId", WebUtils.getCurBizId(request).toString());
		if (groupCode != null && !groupCode.equals("")) {
			parameter.put("groupCode", groupCode);
		}
		if (supplierName != null && !supplierName.equals("")) {
			parameter.put("supplierName", supplierName);
		}
		if (paymentState != null && !paymentState.equals("")) {
			parameter.put("paymentState", paymentState);
		}
		if (productName != null && !productName.equals("")) {
			parameter.put("productName", productName);
		}
		if (lineName != null && !lineName.equals("")) {
			parameter.put("lineName", lineName);
		}
		if (receiveMode != null && !receiveMode.equals("")) {
			parameter.put("receiveMode", receiveMode);
		}
		if (operatorIds != null && !operatorIds.equals("")) {
			parameter.put("operatorIds", operatorIds);
		}
		if (groupMode != null && !groupMode.equals("")) {
			parameter.put("groupMode", groupMode);
		}
		if (cashType != null && !cashType.equals("")) {
			parameter.put("cashType", cashType);
		}

		PageBean<BookingAirTicket> pageBean = new PageBean<BookingAirTicket>();
		pageBean.setPage(page);
		pageBean.setPageSize(pageSize);
		pageBean.setParameter(parameter);

		model.addAttribute("sum",
				bookingSupplierService.sumAirTicketBooking(pageBean));
		pageBean = bookingSupplierService
				.selectAirTicketBookingListPage(pageBean);
		model.addAttribute("pageBean", pageBean);

		// 取得订单明细
		/*
		 * HashMap<Integer, String> detailHtml = new HashMap<Integer, String>();
		 * SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); for
		 * (BookingAirTicket booking : pageBean.getResult()) {
		 * List<BookingSupplierDetail> detailList =
		 * detailService.selectByPrimaryBookId(booking.getId()); StringBuffer
		 * html = new StringBuffer(); for (BookingSupplierDetail detail :
		 * detailList) {
		 * html.append(sdf.format(detail.getItemDate())).append(" &nbsp; ");
		 * html.append("【").append(detail.getTicketFlight()).append("】").append(
		 * " &nbsp; ");
		 * html.append(detail.getItemPrice()).append("*(").append(detail
		 * .getItemNum()).append("-")
		 * .append(detail.getItemNumMinus()).append(")<br/>"); }
		 * detailHtml.put(booking.getId(), html.toString()); }
		 * model.addAttribute("detailHtmlMap", detailHtml);
		 */

		// 取得本页合计
		BigDecimal sumPageTotal = new BigDecimal(0);
		BigDecimal sumPageTotalCash = new BigDecimal(0);
		for (BookingAirTicket booking : pageBean.getResult()) {
			sumPageTotal = sumPageTotal.add(booking.getTotal());
			sumPageTotalCash = sumPageTotalCash
					.add(booking.getTotalCash() == null ? new BigDecimal(0)
							: booking.getTotalCash());
		}
		model.addAttribute("sumPageTotal", sumPageTotal);
		model.addAttribute("sumPageTotalCash", sumPageTotalCash);
		model.addAttribute("sumPageTotalBalance",
				sumPageTotal.subtract(sumPageTotalCash));

		return "queries/airTicket/airTicketDetailTable1";
	}

	/*
	 * @RequestMapping("getTotalNum") public String
	 * getTotalNum(HttpServletRequest request, HttpServletResponse reponse,
	 * ModelMap model, String sl, String ssl, String rp, Integer page, Integer
	 * pageSize, String svc, Integer visit) { PageBean pb = commonQuery(request,
	 * model, sl, page, pageSize, svc); if (StringUtils.isNotBlank(ssl)) { Map
	 * pm = (Map) pb.getParameter(); pm.put("parameter", pm);
	 * model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm)); }
	 * return rp; }
	 */
	/**
	 * 酒店统计
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @param visit
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("getHotelStatistics")
	public String getNumAndOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {
		@SuppressWarnings("rawtypes")
		Map paramters = WebUtils.getQueryParamters(request);

		// 如果选择了【省份】作为查询条件
		@SuppressWarnings("rawtypes")
		Map map = new HashMap<String, Object>();
		map.put("provinceId", paramters.get("provinceId"));
		map.put("cityId", paramters.get("cityId"));
		map.put("supplierType", paramters.get("supplierType"));
		map.put("level", paramters.get("level"));
		map.put("bizId", paramters.get("bizId"));
		if (paramters.get("provinceId") != null) {
			StringBuilder supplierIds = new StringBuilder();
			List<Map<String, Integer>> supplier_province = supplierSerivce
					.searchSupplierByArea(map); // map需要包含 procinceId, cityId,
												// supplier三个参数
			if (supplier_province != null && supplier_province.size() > 0) {
				for (Map<String, Integer> item : supplier_province) {
					supplierIds.append(item.get("id") + ",");
				}
			}
			if (supplierIds.length() > 0)
				request.setAttribute("citysSupplierIds", supplierIds.toString()
						.substring(0, supplierIds.toString().length() - 1));
			else
				request.setAttribute("citysSupplierIds", "0");
		}
		// 如果选择了【商家类别】作为查询条件
		if (paramters.get("level") != null) {
			StringBuilder supplierIds = new StringBuilder();
			List<SupplierInfo> supplier_level = supplierSerivce
					.findSupplierLevelCode(map);
			if (supplier_level != null && supplier_level.size() > 0) {
				Set<Integer> set = new HashSet<Integer>();
				for (SupplierInfo item : supplier_level) {
					supplierIds.append(item.getId() + ",");
				}
			}
			if (supplierIds.length() > 0)
				request.setAttribute("supplierLevel", supplierIds.toString()
						.substring(0, supplierIds.toString().length() - 1));
			else
				request.setAttribute("supplierLevel", "0");
		}

		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);

		// 总计查询
		if (StringUtils.isNotBlank(ssl)) {
			Map<String, Object> pm = (Map<String, Object>) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));
		}

		return rp;
	}

	/**
	 * 业务查询/供应商统计、订单统计、订单明细
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @param visit
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("getSupplierStatistics")
	public String getSupplierOrder(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {
		@SuppressWarnings("rawtypes")
		Map paramters = WebUtils.getQueryParamters(request);

		// 如果选择了【省份】作为查询条件
		@SuppressWarnings("rawtypes")
		Map map = new HashMap<String, Object>();
		map.put("provinceId", paramters.get("provinceId"));
		map.put("cityId", paramters.get("cityId"));
		map.put("supplierType", paramters.get("supplierType"));
		map.put("level", paramters.get("level"));
		map.put("bizId", paramters.get("bizId"));
		if (paramters.get("provinceId") != null) {
			StringBuilder supplierIds = new StringBuilder();
			List<Map<String, Integer>> supplier_province = supplierSerivce
					.searchSupplierByArea(map); // map需要包含 procinceId, cityId,
												// supplier三个参数
			if (supplier_province != null && supplier_province.size() > 0) {
				for (Map<String, Integer> item : supplier_province) {
					supplierIds.append(item.get("id") + ",");
				}
			}
			if (supplierIds.length() > 0)
				request.setAttribute("citysSupplierIds", supplierIds.toString()
						.substring(0, supplierIds.toString().length() - 1));
			else
				request.setAttribute("citysSupplierIds", "0");
		}
		// 如果选择了【商家类别】作为查询条件
		if (paramters.get("level") != null) {
			StringBuilder supplierIds = new StringBuilder();
			List<SupplierInfo> supplier_level = supplierSerivce
					.findSupplierLevelCode(map);
			if (supplier_level != null && supplier_level.size() > 0) {
				Set<Integer> set = new HashSet<Integer>();
				for (SupplierInfo item : supplier_level) {
					supplierIds.append(item.getId() + ",");
				}
			}
			if (supplierIds.length() > 0)
				request.setAttribute("supplierLevel", supplierIds.toString()
						.substring(0, supplierIds.toString().length() - 1));
			else
				request.setAttribute("supplierLevel", "0");
		}

		@SuppressWarnings("rawtypes")
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);

		// 总计查询
		if (StringUtils.isNotBlank(ssl)) {
			Map<String, Object> pm = (Map<String, Object>) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));
		}

		return rp;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("getSupplierStatisticsDetail")
	public String getSupplierDetails(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {
		@SuppressWarnings("rawtypes")
		Map paramters = WebUtils.getQueryParamters(request);

		// 如果选择了【省份】作为查询条件
		@SuppressWarnings("rawtypes")
		Map map = new HashMap<String, Object>();
		map.put("provinceId", paramters.get("provinceId"));
		map.put("cityId", paramters.get("cityId"));
		map.put("supplierType", paramters.get("supplierType"));
		map.put("level", paramters.get("level"));
		map.put("bizId", paramters.get("bizId"));
		if (paramters.get("provinceId") != null) {
			StringBuilder supplierIds = new StringBuilder();
			List<Map<String, Integer>> supplier_province = supplierSerivce
					.searchSupplierByArea(map); // map需要包含 procinceId, cityId,
												// supplier三个参数
			if (supplier_province != null && supplier_province.size() > 0) {
				for (Map<String, Integer> item : supplier_province) {
					supplierIds.append(item.get("id") + ",");
				}
			}
			if (supplierIds.length() > 0)
				request.setAttribute("citysSupplierIds", supplierIds.toString()
						.substring(0, supplierIds.toString().length() - 1));
			else
				request.setAttribute("citysSupplierIds", "0");
		}
		// 如果选择了【商家类别】作为查询条件
		if (paramters.get("level") != null) {
			StringBuilder supplierIds = new StringBuilder();
			List<SupplierInfo> supplier_level = supplierSerivce
					.findSupplierLevelCode(map);
			if (supplier_level != null && supplier_level.size() > 0) {
				Set<Integer> set = new HashSet<Integer>();
				for (SupplierInfo item : supplier_level) {
					supplierIds.append(item.getId() + ",");
				}
			}
			if (supplierIds.length() > 0)
				request.setAttribute("supplierLevel", supplierIds.toString()
						.substring(0, supplierIds.toString().length() - 1));
			else
				request.setAttribute("supplierLevel", "0");
		}

		@SuppressWarnings("rawtypes")
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);

		// 总计查询
		if (StringUtils.isNotBlank(ssl)) {
			Map<String, Object> pm = (Map<String, Object>) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));
		}

		return rp;
	}

	@RequestMapping("ageQueryList.htm")
	public String ageList(HttpServletRequest request, Model model) {
		return "queries/byAge/queryList";
	}

	// 根据产品查询客人年龄段
	@RequestMapping("getAgeListByProduct")
	public String getAgeListByProduct(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		List<Map<String, Object>> ageMaps = tourGroupService
				.selectAgeCount(WebUtils.getQueryParamters(request));
		Map<Object, Object> ageMap = new HashMap<Object, Object>();
		for (Map<String, Object> map2 : ageMaps) {
			ageMap.put(map2.get("ageRanges"), map2.get("agecnt"));
		}
		model.addAttribute("ageMap", ageMap);
		// Map parameters = WebUtils.getQueryParamters(request);
		// parameters.put("set", WebUtils.getDataUserIdSet(request));

		model.addAttribute("personMap", queryService.getPersonCountMap(WebUtils
				.getQueryParamters(request)));
		return rp;
	}

	// 客人年龄段分析：产品+组团社
	@RequestMapping("getAgeListByProductAndAgency")
	public String getAgeListByProductAndAgency(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		List<Map<String, Object>> ageMaps = tourGroupService
				.selectAgeCountWithAgency(WebUtils.getQueryParamters(request));
		Map<Object, Object> ageMap = new HashMap<Object, Object>();
		for (Map<String, Object> map2 : ageMaps) {
			ageMap.put(map2.get("ageRanges"), map2.get("agecnt"));
		}
		model.addAttribute("ageMap", ageMap);
		// Map parameters = WebUtils.getQueryParamters(request);
		// parameters.put("set", WebUtils.getDataUserIdSet(request));

		model.addAttribute("personMap", queryService.getPersonCountMap(WebUtils
				.getQueryParamters(request)));
		return rp;
	}

	// 客人年龄段分析：组团社
	@RequestMapping("getAgeListByAgency")
	public String getAgeListByAgency(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		List<Map<String, Object>> ageMaps = tourGroupService
				.selectAgeCountWithAgencyOnly(WebUtils
						.getQueryParamters(request));
		// .selectAgeCountWithAgency(WebUtils.getQueryParamters(request));
		Map<Object, Object> ageMap = new HashMap<Object, Object>();
		for (Map<String, Object> map2 : ageMaps) {
			ageMap.put(map2.get("ageRanges"), map2.get("agecnt"));
		}
		model.addAttribute("ageMap", ageMap);
		// Map parameters = WebUtils.getQueryParamters(request);
		// parameters.put("set", WebUtils.getDataUserIdSet(request));
		model.addAttribute("personMap", queryService.getPersonCountMap(WebUtils
				.getQueryParamters(request)));
		return rp;
	}

	// 业务查询公共方法
	private PageBean commonQuery(HttpServletRequest request, ModelMap model,
			String sl, Integer page, Integer pageSize, String svc) {
		PageBean pb = new PageBean();
		if (page == null) {
			pb.setPage(1);
		} else {

			pb.setPage(page);
		}
		if (pageSize == null) {
			pageSize = Constants.PAGESIZE;
		}
		pb.setPageSize(pageSize);
		Map paramters = WebUtils.getQueryParamters(request);

		paramters.put("citysSupplierIds",
				request.getAttribute("citysSupplierIds"));
		paramters.put("supplierLevel", request.getAttribute("supplierLevel"));
		// paramters.put("supplierDetailLevel",
		// request.getAttribute("supplierDetailLevel"));

		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank((String) paramters.get("saleOperatorIds"))
				&& StringUtils.isNotBlank((String) paramters.get("orgIds"))) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = paramters.get("orgIds").toString().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				paramters.put("saleOperatorIds", salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pb.setParameter(paramters);
		pb = getCommonService(svc).queryListPage(sl, pb);
		model.addAttribute("pageBean", pb);

		return pb;
	}

	@RequestMapping(value = "getDetail2.do")
	public String getDetail2(HttpServletRequest request,
			HttpServletResponse reponse, Integer flag, ModelMap model,
			String sl, String ssl, String rp, Integer page, Integer pageSize,
			String svc) {

		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);
		List result = pb.getResult();

		if (result != null && result.size() > 0) {
			for (int i = 0; i < result.size(); i++) {
				Map map = (Map) result.get(i);
				List<BookingSupplierDetail> detailList = detailService
						.selectByPrimaryBookId((Integer) map.get("id"));
				map.put("detailList", detailList);
				Long createTime = (Long) map.get("createTime");
				if (createTime != null) {
					map.put("create_Time", new SimpleDateFormat("yyyy-MM-dd")
							.format(new Date(createTime)));
				}

			}
		}

		// 总计查询
		if (StringUtils.isNotBlank(ssl)) {
			Map pm = (Map) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));
		}
		return rp;
	}

	/**
	 * 获取查询服务
	 * 
	 * @author Jing.Zhuo
	 * @create 2015年8月18日 上午9:34:25
	 * @param svc
	 * @return
	 */
	private CommonService getCommonService(String svc) {
		if (StringUtils.isBlank(svc)) {
			svc = "commonsaleService";
		}
		return appContext.getBean(svc, CommonService.class);
	}

	/**
	 * 接送信息查询列表
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("transportList.htm")
	public String tranportList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		// 交通类型
		List<DicInfo> transportTypeList = dicService.getListByTypeCode(
				BasicConstants.GYXX_JTFS, bizId);
		model.addAttribute("transportTypeList", transportTypeList);
		model.addAttribute("bizId", bizId);
		return "queries/transport/transportList";
	}

	// /////////////////计调安排查询

	@RequestMapping("groupInfoList.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupInfo(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, TourGroupVO tourGroup) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/groupInfo-list";

	}

	@RequestMapping("opearteGroupList.do")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String opearteGroupList(ModelMap model, HttpServletRequest request,
			TourGroupVO tourGroup) {
		PageBean pageBean = new PageBean();
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			// pageBean.setPageSize(Constants.PAGESIZE);
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
		}
		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds())
				&& StringUtils.isNotBlank(tourGroup.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = tourGroup.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean.setParameter(tourGroup);
		pageBean = tourGroupService.getGroupOperateList(pageBean, tourGroup,
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("pageBean", pageBean);

		return "queries/groupInfo-list-table";
	}

	// ////////////////预定安排

	@RequestMapping("groupBooking.htm")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupBooking(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, TourGroupVO tourGroup) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "operation/group-booking-list";

	}

	@RequestMapping("groupBookingList.do")
	@RequiresPermissions(PermissionConstants.JDGL_YDAP)
	public String groupBookingList(ModelMap model, HttpServletRequest request,
			TourGroupVO tourGroup) {

		PageBean pageBean = new PageBean();
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
		}

		if (tourGroup != null
				&& StringUtils.isNotEmpty(tourGroup.getReceiveMode())) {
			if (tourGroup.getGroupMode() != null
					&& tourGroup.getGroupMode().intValue() == 0) {
				// 如果为散客，输入接站牌查询为空
				pageBean.setResult(null);
				model.addAttribute("pageBean", pageBean);
				return "operation/group-booking-list-table";
			}
		}

		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds())
				&& StringUtils.isNotBlank(tourGroup.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = tourGroup.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		Integer bizId = WebUtils.getCurBizId(request);
		tourGroup.setBizId(bizId);
		pageBean.setParameter(tourGroup);

		List<Map<String, Object>> mapList = groupOrderService
				.selectGroupIdsByReceiveMode(tourGroup);
		if (mapList != null && mapList.size() > 0) {
			Set<Integer> groupIdSet = new HashSet<Integer>();
			for (Map<String, Object> map : mapList) {
				groupIdSet.add(TypeUtils.castToInt(map.get("group_id")));
			}
			if (groupIdSet.size() == 0) {
				groupIdSet.add(-1);
			}
			tourGroup.setGroupIdSet(groupIdSet);
		}

		Set<Integer> set = WebUtils.getDataUserIdSet(request);
		pageBean = queryService
				.selectGroupBookingListPage(pageBean, bizId, set);
		List result = pageBean.getResult();
		if (result != null && result.size() > 0) {

			GroupBookingInfo bookingInfo = null;
			StringBuilder groupIds = new StringBuilder();
			for (int i = 0; i < result.size(); i++) {
				if (i > 0) {
					groupIds.append(",");
				}
				bookingInfo = (GroupBookingInfo) result.get(i);
				groupIds.append(bookingInfo.getGroupId());
			}

			String groupIdStr = groupIds.toString();

			List<Map<String, Object>> sightList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.SCENICSPOT, tourGroup.getSupplierName());
			List<Map<String, Object>> hotelList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.HOTEL, tourGroup.getSupplierName());
			List<Map<String, Object>> eatList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.RESTAURANT, tourGroup.getSupplierName());
			List<Map<String, Object>> carList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.FLEET, tourGroup.getSupplierName());
			List<Map<String, Object>> airList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.AIRTICKETAGENT,
							tourGroup.getSupplierName());
			List<Map<String, Object>> trainList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.TRAINTICKETAGENT,
							tourGroup.getSupplierName());
			List<Map<String, Object>> insuranceList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.INSURANCE, tourGroup.getSupplierName());
			List<Map<String, Object>> shopList = queryService
					.selectBookingShopCountForGroups(groupIdStr,
							tourGroup.getSupplierName());
			List<Map<String, Object>> inList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.OTHERINCOME, tourGroup.getSupplierName());
			List<Map<String, Object>> outList = queryService
					.selectBookingSupplierCountForGroups(groupIdStr,
							Constants.OTHEROUTCOME, tourGroup.getSupplierName());

			List<Map<String, Object>> guideList = queryService
					.selectBookingGuideForGroups(groupIdStr,
							tourGroup.getSupplierName());
			List<Map<String, Object>> deliveryList = queryService
					.selectBookingDeliveryForGroups(groupIdStr,
							tourGroup.getSupplierName());

			for (int i = 0; i < result.size(); i++) {
				bookingInfo = (GroupBookingInfo) result.get(i);
				Integer groupId = bookingInfo.getGroupId();
				bookingInfo.setSightCnt(getCountByGroupId(sightList, groupId));
				bookingInfo.setHotelCnt(getCountByGroupId(hotelList, groupId));
				bookingInfo.setEatCnt(getCountByGroupId(eatList, groupId));
				bookingInfo.setCarCnt(getCountByGroupId(carList, groupId));
				bookingInfo.setAirCnt(getCountByGroupId(airList, groupId));
				bookingInfo.setTrainCnt(getCountByGroupId(trainList, groupId));
				bookingInfo.setInsuranceCnt(getCountByGroupId(insuranceList,
						groupId));
				bookingInfo.setShopCnt(getCountByGroupId(shopList, groupId));
				bookingInfo.setInCnt(getCountByGroupId(inList, groupId));
				bookingInfo.setOutCnt(getCountByGroupId(outList, groupId));
				bookingInfo
						.setGuideNames(getNamesByGroupId(guideList, groupId));
				bookingInfo.setDeliveryNames(getNamesByGroupId(deliveryList,
						groupId));
			}
		}
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("sum",
				queryService.getPersonCount(pageBean, bizId, set));

		return "operation/group-booking-list-table";
	}

	private Integer getCountByGroupId(List<Map<String, Object>> list,
			Integer groupId) {
		if (list == null || list.size() == 0 || groupId == null) {
			return 0;
		}

		Map<String, Object> map = null;
		for (int i = 0; i < list.size(); i++) {
			map = list.get(i);
			Integer mapGroupId = (Integer) map.get("group_id");
			if (mapGroupId == null) {
				continue;
			}
			if (groupId.intValue() == mapGroupId.intValue()) {
				return Integer.parseInt(map.get("count").toString());
			}
		}
		return 0;
	}

	private String getNamesByGroupId(List<Map<String, Object>> list,
			Integer groupId) {
		if (list == null || list.size() == 0 || groupId == null) {
			return null;
		}

		Map<String, Object> map = null;
		for (int i = 0; i < list.size(); i++) {
			map = list.get(i);
			Integer mapGroupId = (Integer) map.get("group_id");
			if (mapGroupId == null) {
				continue;
			}
			if (groupId.intValue() == mapGroupId.intValue()) {
				return map.get("bookSupplierName").toString();
			}
		}
		return null;
	}

	@RequestMapping(value = "groupInfoListView.htm")
	public String groupInfoList(ModelMap model, HttpServletRequest request,
			TourGroupVO tourGroup) {
		PageBean pageBean = new PageBean();
		model.addAttribute("tourGroup", tourGroup);
		model.addAttribute("pageNum", tourGroup.getPage());
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		} else {
			pageBean.setPage(tourGroup.getPage());
		}
		if (tourGroup.getPageSize() == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(tourGroup.getPageSize());
		}
		if (StringUtils.isBlank(tourGroup.getSaleOperatorIds())
				&& StringUtils.isNotBlank(tourGroup.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = tourGroup.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				tourGroup.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(tourGroup);
		tourGroup.setBizId(WebUtils.getCurBizId(request));
		pageBean = tourGroupService.getGroupInfoList(pageBean, tourGroup,
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("pageBean", pageBean);

		return "queries/groupInfo-list-table";

	}

	/**
	 * 子公司未收债务查询页面
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("toSubsidiaryDebt.htm")
	public String toSubsidiaryDebt(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		/**
		 * 昆明乐景旅行社有限公司 1-3- 昆明乐美旅行社有限公司 1-47- 昆明悦享旅行社有限公司 1-5- 昆明优派旅行社有限公司 1-4-
		 * 昆明乐途旅行社有限公司 1-6-
		 */
		String lj = platformEmployeeService.findByOrgPath("1-3-");
		String lm = platformEmployeeService.findByOrgPath("1-47-");
		String yx = platformEmployeeService.findByOrgPath("1-5-");
		String yp = platformEmployeeService.findByOrgPath("1-4-");
		String llt = platformEmployeeService.findByOrgPath("1-6-");
		if ("".equals(lj)) {
			lj = "11111";
		}
		if ("".equals(lm)) {
			lm = "11111";
		}
		if ("".equals(yx)) {
			yx = "11111";
		}
		if ("".equals(yp)) {
			yp = "11111";
		}
		if ("".equals(llt)) {
			llt = "11111";
		}

		model.put("llt", llt);
		model.put("yp", yp);
		model.put("yx", yx);
		model.put("lm", lm);
		model.put("lj", lj);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		// model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/subsidiaryDebtList";
	}

	@RequestMapping(value = "toSubsidiaryDebt.do")
	public String toSubsidiaryDebt(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,
			TourGroupVO group) {
		PageBean pb = new PageBean();
		pb.setPage(page);
		if (pageSize == null) {
			pageSize = Constants.PAGESIZE;
		}
		pb.setPageSize(pageSize);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(group.getSaleOperatorIds())
				&& StringUtils.isNotBlank(group.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				group.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		if (null != group.getSaleOperatorIds()
				&& !"".equals(group.getSaleOperatorIds())) {
			pms.put("operatorIds", group.getSaleOperatorIds());
		}
		// pms.put("set", WebUtils.getDataUserIdSet(request));
		pb.setParameter(pms);
		pb = getCommonService(svc).queryListPage(sl, pb);
		model.addAttribute("pageBean", pb);
		if (StringUtils.isNotBlank(ssl)) {
			Map pm = (Map) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));
		}
		return rp;
	}

	/* 购物统计-导游 */
	@RequestMapping("toGuideList.htm")
	public String toGuideList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/shopStatistics/guideList";
	}

	/* 购物统计-导管 */
	@RequestMapping("toGuideManageList.htm")
	public String toGuideManageList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/shopStatistics/guideManageList";
	}

	/* 购物统计-购物店 */
	@RequestMapping("toShopList.htm")
	public String toShopList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/shopStatistics/shopList";
	}

	/* 购物统计-产品 */
	@RequestMapping("toProductList.htm")
	public String toProductList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {

		// 产品品牌下拉列表数据
		List<DicInfo> pp = dicService.getListByTypeCode(BasicConstants.CPXL_PP,
				WebUtils.getCurBizId(request));
		model.addAttribute("pp", pp);

		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/shopStatistics/productList";
	}

	/* 购物统计-导游 */
	@RequestMapping("toSupplierList.htm")
	public String toSupplierList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/shopStatistics/supplierList";
	}

	/* 车辆统计 */
	@RequestMapping("toCarList.htm")
	public String toCarList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		//
		// model.addAttribute("bizId", bizId); // 过滤B商家
		return "queries/car/carList";
	}

	/**
	 * 根据产品统计年龄段
	 * 
	 * @return
	 */
	@RequestMapping("ageListByProduct.htm")
	public String ageListByProduct(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// model.addAttribute("bizId", bizId);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/byAge/ageListByProduct";

	}

	/**
	 * 根据产品+旅行社统计年龄段
	 * 
	 * @return
	 */

	@RequestMapping("toAgeListByProductAndAgency.htm")
	public String toAgeListByProductAndAgency(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// model.addAttribute("bizId", WebUtils.getCurBizId(request));
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/byAge/ageListByProductAndAgency";

	}

	/**
	 * 根据旅行社统计年龄段
	 * 
	 * @return
	 */

	@RequestMapping("toAgeListByAgency.htm")
	public String toAgeListByAgency(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// model.addAttribute("bizId", WebUtils.getCurBizId(request));
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/byAge/ageListByAgency";

	}

	/**
	 * 线路团量分布
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param condition
	 * @return
	 */
	@RequestMapping("productGuestStatics.htm")
	public String productGuestStaticsList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		String startDate = DateUtils.getMonthFirstDay();
		String endDate = DateUtils.getMonthLastDay();
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/order/product-guest";
	}

	@RequestMapping("productGuestStatics.do")
	public String productGuestStatics(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			ProductGuestCondition condition) {
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				condition.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		queryProductGuestStatics(request, model, condition);
		return "queries/order/product-guest-table";
	}

	private void queryProductGuestStatics(HttpServletRequest request,
			ModelMap model, ProductGuestCondition condition) {
		condition.setBizId(WebUtils.getCurBizId(request));
		// if (condition.getStartDate() != null) {
		// condition.setStartDateNum(condition.getStartDate().getTime());
		// }
		// if (condition.getEndDate() != null) {
		// condition.setEndDateNum(condition.getEndDate().getTime());
		// }

		if (condition.getDateType() != null && condition.getDateType() == 1) {
			if (!"".equals(condition.getStartDate())) {
				condition.setStartDateNum(condition.getStartDate().getTime());
			}
			if (!"".equals(condition.getEndDate())) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(condition.getEndDate());
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				condition.setEndDateNum(calendar.getTime().getTime());
			}
		}

		/*
		 * List<ProductGuestStaticsVo> list =
		 * queryService.productGuestStatics(condition); Integer totalCnt = 0;
		 * if(list!=null&& list.size()>0){ for(ProductGuestStaticsVo vo :list){
		 * totalCnt+=vo.getGuestCnt(); } } model.addAttribute("total",
		 * totalCnt); model.addAttribute("list", list);
		 */
		String jsonStr = queryService.productGuestStatics(condition,
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("jsonStr", jsonStr);
	}

	@RequestMapping("queryGroupNumber.htm")
	public String queryGroupNumber(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			GroupOrder groupOrder, Integer type, Integer dataType)
			throws ParseException {

		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				groupOrder.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		if (type == 0) {
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			cal.set(Calendar.DAY_OF_MONTH, 1);
			groupOrder.setStartTime(new SimpleDateFormat("yyyy-MM-dd")
					.format(cal.getTime()));
			cal.roll(Calendar.DAY_OF_MONTH, -1);
			groupOrder.setEndTime(new SimpleDateFormat("yyyy-MM-dd").format(cal
					.getTime()));
			groupOrder.setShowNum(10);
			dataType = 0;
			groupOrder.setDateType(1);
		}
		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			if (groupOrder.getStartTime() != null) {
				groupOrder.setStartTime(new SimpleDateFormat("yyyy-MM-dd")
						.parse(groupOrder.getStartTime()).getTime() + "");
			}
			if (groupOrder.getEndTime() != null) {
				Calendar calendar = new GregorianCalendar();
				calendar.setTime(new SimpleDateFormat("yyyy-MM-dd")
						.parse(groupOrder.getEndTime()));
				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}

		}
		List<GroupOrder> allGroupOrder = groupOrderService
				.selectGroupNumForQuery(groupOrder,
						WebUtils.getCurBizId(request),
						WebUtils.getDataUserIdSet(request));

		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			if (groupOrder.getStartTime() != null) {
				groupOrder.setStartTime((new SimpleDateFormat("yyyy-MM-dd")
						.format(new Date(
								Long.valueOf(groupOrder.getStartTime())))));
			}
			if (groupOrder.getEndTime() != null) {
				Calendar calendar = new GregorianCalendar();
				calendar.setTimeInMillis(Long.valueOf(groupOrder.getEndTime()));
				calendar.add(calendar.DATE, -1);// 把日期往后增加一天.整数往后推,负数往前移动
				groupOrder.setEndTime((new SimpleDateFormat("yyyy-MM-dd")
						.format(calendar.getTime())));
			}
		}

		String jsonStr = queryService.getGroupNumStatics(allGroupOrder,
				dataType);
		model.addAttribute("groupOrder", groupOrder);
		model.addAttribute("dataType", dataType);
		model.addAttribute("jsonStr", jsonStr);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/order/groupNumber";
	}

	@RequestMapping("expGroupNumber.do")
	public String expGroupNumber(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, GroupOrder groupOrder)
			throws ParseException {
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				groupOrder.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		groupOrder.setShowNum(null);
		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 2) {
			if (groupOrder.getStartTime() != null) {
				groupOrder.setStartTime(new SimpleDateFormat("yyyy-MM-dd")
						.parse(groupOrder.getStartTime()).getTime() + "");
			}
			if (groupOrder.getEndTime() != null) {
				Calendar calendar = new GregorianCalendar();
				calendar.setTime(new SimpleDateFormat("yyyy-MM-dd")
						.parse(groupOrder.getEndTime()));
				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
				groupOrder.setEndTime(calendar.getTime().getTime() + "");
			}

		}
		List<GroupOrder> allGroupOrder = groupOrderService
				.selectGroupNumForQuery(groupOrder,
						WebUtils.getCurBizId(request),
						WebUtils.getDataUserIdSet(request));
		model.addAttribute("allGroupOrder", allGroupOrder);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "queries/order/expGroupNumber";
	}

	/**
	 * 客源分布
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("guestSourceStatics.htm")
	public String guestSourceStaticsList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		String startDate = DateUtils.getMonthFirstDay();
		String endDate = DateUtils.getMonthLastDay();
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/order/guest-source";
	}

	@RequestMapping("guestSourceStatics.do")
	public String guestSourceStatics(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			ProductGuestCondition condition) {
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				condition.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		queryGuestSourceStatics(request, model, condition);
		return "queries/order/guest-source-table";
	}

	private void queryGuestSourceStatics(HttpServletRequest request,
			ModelMap model, ProductGuestCondition condition) {
		condition.setBizId(WebUtils.getCurBizId(request));
		if (condition.getStartDate() != null) {
			condition.setStartDateNum(condition.getStartDate().getTime());
		}
		if (condition.getEndDate() != null) {
			// 添加时间时，结束时间需要加一天
			condition.setEndDateNum(com.yihg.images.util.DateUtils.addDay(
					condition.getEndDate(), 1).getTime());
		}
		String jsonStr = queryService.guestSourceStatics(condition,
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("jsonStr", jsonStr);
	}

	/* 购物项目统计 */
	@RequestMapping("toBookingShopList.htm")
	public String toBookingShopList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/bookingshop/shopList";
	}

	/**
	 * 购物项目统计
	 * 
	 * @param request
	 * @param model
	 * @param guide
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "/toBookingShopList.do")
	public String toBookingShopList(HttpServletRequest request, ModelMap model,
			Integer pageSize, Integer page) {
		PageBean pageBean = new PageBean();
		if (page == null) {
			pageBean.setPage(1);
		} else {
			pageBean.setPage(page);
		}
		if (pageSize == null) {
			pageBean.setPageSize(Constants.PAGESIZE);
		} else {
			pageBean.setPageSize(pageSize);
		}
		pageBean.setParameter(WebUtils.getQueryParamters(request));
		pageBean = bookingShopService.selectShopListPage(pageBean,
				WebUtils.getCurBizId(request));
		model.addAttribute("pageBean", pageBean);

		return "queries/bookingshop/shopList-table";
	}

	/**
	 * 酒店订单明细预览页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */
	@RequestMapping(value = "hotelDetailPreview.htm")
	public String hotelDetailPreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "/queries/hotel/hotelDetailPreview";
	}

	/**
	 * 酒店导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("exportExcel.htm")
	public void exportExcel(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String sl,
			String ssl, String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);

		String path = "";
		BigDecimal total = new BigDecimal(0);
		BigDecimal totalNum = new BigDecimal(0);
		BigDecimal totalNumMinus = new BigDecimal(0);

		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/hotelBusinessDetail.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			// Iterator<GroupOrder> it = orders.iterator();
			List<Map<String, Object>> result = pb.getResult();
			int index = 0;
			for (Map<String, Object> map : result) {
				// GroupOrder order = it.next() ;
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(map.get("groupCode") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(map.get("totalAdult") + "大"
						+ map.get("totalChild") + "小" + map.get("totalGuide")
						+ "陪");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue(map.get("supplierName") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(4);
				cc.setCellValue(map.get("bookingGuideInfo") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(5);
				cc.setCellValue(map.get("operatorName") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(map.get("itemDate") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(7);
				cc.setCellValue(map.get("type1Name") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(8);
				cc.setCellValue(map.get("itemBrief") == null ? "" : map
						.get("itemBrief") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				BigDecimal itemNum = new BigDecimal(0);
				itemNum = itemNum.add((BigDecimal) map.get("itemNum"));
				cc.setCellValue(itemNum.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(10);
				BigDecimal itemPrice = new BigDecimal(0);
				itemPrice = itemPrice.add((BigDecimal) map.get("itemPrice"));
				cc.setCellValue(itemPrice.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(11);
				BigDecimal itemNumMinus = new BigDecimal(0);
				itemNumMinus = itemNumMinus.add((BigDecimal) map
						.get("itemNumMinus"));
				cc.setCellValue(itemNumMinus.doubleValue()); // 团款
				cc.setCellStyle(cellStyle);
				cc = row.createCell(12);
				cc.setCellValue(map.get("cashType") == null ? "" : map
						.get("cashType") + "");// 已收
				cc.setCellStyle(cellStyle);
				cc = row.createCell(13);
				BigDecimal itemTotal = new BigDecimal(0);
				itemTotal = itemTotal.add((BigDecimal) map.get("itemTotal"));
				cc.setCellValue(itemTotal.doubleValue());// 未收
				cc.setCellStyle(cellStyle);
				index++;
				total = total.add((BigDecimal) map.get("itemTotal"));
				totalNum = totalNum.add((BigDecimal) map.get("itemNum"));
				totalNumMinus = totalNumMinus.add((BigDecimal) map
						.get("itemNumMinus"));
			}

			row = sheet.createRow(pb.getResult().size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);
			cc.setCellValue(totalNum.intValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellValue(totalNumMinus.doubleValue());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(12);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(13);
			cc.setCellValue(total.doubleValue());
			cc.setCellStyle(cellStyle);

			CellRangeAddress region = new CellRangeAddress(pb.getResult()
					.size() + 3, pb.getResult().size() + 4, 0, 13);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	private void download2(String path, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			// path是指欲下载的文件的路径。
			File file = new File(path);
			// 取得文件名。
			String fileName = "";
			try {
				fileName = new String("业务统计明细.xlsx".getBytes("UTF-8"),
						"iso-8859-1");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();

			/*
			 * //解决IE浏览器下下载文件名乱码问题 if
			 * (request.getHeader("USER-AGENT").indexOf("msie") > -1){ fileName
			 * = new URLEncoder().encode(fileName) ; }
			 */
			// 设置response的Header
			response.addHeader("Content-Disposition", "attachment;filename="
					+ fileName);
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(
					response.getOutputStream());
			response.setContentType("application/vnd.ms-excel;charset=gb2312");
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
			file.delete();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * 餐厅、门票、保险预览页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */

	@RequestMapping(value = "detailPreview.htm")
	public String detailPreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "/queries/detailPreview";
	}

	/**
	 * 餐厅、门票、保险导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("exportExcel2.htm")
	public void exportExcel2(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String sl,
			String ssl, String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);

		String path = "";
		BigDecimal total = new BigDecimal(0);
		BigDecimal totalNum = new BigDecimal(0);
		BigDecimal totalNumMinus = new BigDecimal(0);
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/businessDetail.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			// Iterator<GroupOrder> it = orders.iterator();
			List<Map<String, Object>> result = pb.getResult();
			int index = 0;
			for (Map<String, Object> map : result) {
				// GroupOrder order = it.next() ;
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(map.get("groupCode") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(map.get("totalAdult") + "大"
						+ map.get("totalChild") + "小" + map.get("totalGuide")
						+ "陪");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue(map.get("supplierName") + "");
				cc.setCellStyle(styleLeft);

				cc = row.createCell(4);
				cc.setCellValue(map.get("operatorName") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(5);
				cc.setCellValue(map.get("itemDate") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(map.get("type1Name") == null ? "" : map
						.get("type1Name") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(7);
				cc.setCellValue(map.get("itemBrief") == null ? "" : map
						.get("itemBrief") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(8);
				BigDecimal itemNum = new BigDecimal(0);
				itemNum = itemNum.add((BigDecimal) map.get("itemNum"));
				cc.setCellValue(itemNum.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				BigDecimal itemPrice = new BigDecimal(0);
				itemPrice = itemPrice.add((BigDecimal) map.get("itemPrice"));
				cc.setCellValue(itemPrice.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(10);
				BigDecimal itemNumMinus = new BigDecimal(0);
				itemNumMinus = itemNumMinus.add((BigDecimal) map
						.get("itemNumMinus"));
				cc.setCellValue(itemNumMinus.doubleValue()); // 团款
				cc.setCellStyle(cellStyle);
				cc = row.createCell(11);
				cc.setCellValue(map.get("cashType") == null ? "" : map
						.get("cashType") + "");// 已收
				cc.setCellStyle(cellStyle);
				cc = row.createCell(12);
				BigDecimal itemTotal = new BigDecimal(0);
				itemTotal = itemTotal.add((BigDecimal) map.get("itemTotal"));
				cc.setCellValue(itemTotal.doubleValue());// 未收
				cc.setCellStyle(cellStyle);
				index++;
				total = total.add((BigDecimal) map.get("itemTotal"));
				totalNum = totalNum.add((BigDecimal) map.get("itemNum"));
				totalNumMinus = totalNumMinus.add((BigDecimal) map
						.get("itemNumMinus"));
			}
			row = sheet.createRow(pb.getResult().size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellValue(totalNum.intValue());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellValue(totalNumMinus.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellStyle(cellStyle);
			/*
			 * cc = row.createCell(12); cc.setCellStyle(cellStyle);
			 */
			cc = row.createCell(12);
			cc.setCellValue(total.doubleValue());
			cc.setCellStyle(cellStyle);

			CellRangeAddress region = new CellRangeAddress(pb.getResult()
					.size() + 3, pb.getResult().size() + 4, 0, 12);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	/**
	 * 机票、火车票预览页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */
	@RequestMapping(value = "ticketDetailPreview.htm")
	public String ticketDetailPreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "/queries/ticketDetailPreview";
	}

	/**
	 * 机票、火车票导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("exportExcel3.htm")
	public void exportExcel3(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String sl,
			String ssl, String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);

		String path = "";
		BigDecimal total = new BigDecimal(0);
		BigDecimal totalNum = new BigDecimal(0);
		BigDecimal totalNumMinus = new BigDecimal(0);
		try {
			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/ticketBusinessDetail.xlsx");
			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			// Iterator<GroupOrder> it = orders.iterator();
			List<Map<String, Object>> result = pb.getResult();
			int index = 0;
			for (Map<String, Object> map : result) {
				// GroupOrder order = it.next() ;
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(map.get("groupCode") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(map.get("totalAdult") + "大"
						+ map.get("totalChild") + "小" + map.get("totalGuide")
						+ "陪");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue(map.get("supplierName") + "");
				cc.setCellStyle(styleLeft);

				cc = row.createCell(4);
				cc.setCellValue(map.get("operatorName") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(5);
				cc.setCellValue(map.get("itemDate") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(map.get("ticketFligh") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(7);
				cc.setCellValue(map.get("type1Name") == null ? "" : map
						.get("type1Name") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(8);
				cc.setCellValue(map.get("ticketDeparture") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				cc.setCellValue(map.get("ticketArrival") + "");
				cc.setCellStyle(cellStyle);

				cc = row.createCell(10);
				BigDecimal itemNum = new BigDecimal(0);
				itemNum = itemNum.add((BigDecimal) map.get("itemNum"));
				cc.setCellValue(itemNum.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(11);
				BigDecimal itemPrice = new BigDecimal(0);
				itemPrice = itemPrice.add((BigDecimal) map.get("itemPrice"));
				cc.setCellValue(itemPrice.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(12);
				BigDecimal itemNumMinus = new BigDecimal(0);
				itemNumMinus = itemNumMinus.add((BigDecimal) map
						.get("itemNumMinus"));
				cc.setCellValue(itemNumMinus.doubleValue()); // 团款
				cc.setCellStyle(cellStyle);
				cc = row.createCell(13);
				cc.setCellValue(map.get("cashType") == null ? "" : map
						.get("cashType") + "");// 已收
				cc.setCellStyle(cellStyle);
				cc = row.createCell(14);
				BigDecimal itemTotal = new BigDecimal(0);
				itemTotal = itemTotal.add((BigDecimal) map.get("itemTotal"));
				cc.setCellValue(itemTotal.doubleValue());// 未收
				cc.setCellStyle(cellStyle);
				index++;
				total = total.add((BigDecimal) map.get("itemTotal"));

				totalNum = totalNum.add((BigDecimal) map.get("itemNum"));
				totalNumMinus = totalNumMinus.add((BigDecimal) map
						.get("itemNumMinus"));
			}
			row = sheet.createRow(pb.getResult().size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellValue(totalNum.intValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(12);
			cc.setCellValue(totalNumMinus.doubleValue());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(13);
			cc.setCellStyle(cellStyle);
			/*
			 * cc = row.createCell(12); cc.setCellStyle(cellStyle);
			 */
			cc = row.createCell(14);
			cc.setCellValue(total.doubleValue());
			// cc.setCellValue(total + "");
			cc.setCellStyle(cellStyle);

			CellRangeAddress region = new CellRangeAddress(pb.getResult()
					.size() + 3, pb.getResult().size() + 4, 0, 14);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	/**
	 * 点击团号时，根据团id加载订单id
	 * 
	 * @param request
	 * @param response
	 * @param groupId
	 * @return
	 */
	@RequestMapping("loadOrderId.htm")
	@ResponseBody
	public String loadOrderId(HttpServletRequest request,
			HttpServletResponse response, Integer groupId) {
		List<GroupOrder> groupOrders = groupOrderService
				.selectOrderByGroupId(groupId);
		Map<String, Object> map = new HashMap<String, Object>();
		if (groupOrders != null && groupOrders.size() > 0) {
			map.put("orderId", groupOrders.get(0).getId());
		}
		return successJson(map);
	}

	/**
	 * 客户产品人数统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("productWithCustomerList.htm")
	public String productWithCustomerQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(modelMap, bizId);
		modelMap.addAttribute("bizId", WebUtils.getCurBizId(request));
		return "queries/productWithCustomer/productWithCustomerList";
	}

	@RequestMapping("productWithCustomerList.do")
	public String productWithCustomerList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);
		/*
		 * List result = pb.getResult(); Map paramters =
		 * WebUtils.getQueryParamters(request); if (result != null &&
		 * result.size() > 0) { for (int i = 0; i < result.size(); i++) { Map
		 * map = (Map) result.get(i); String productBrandName = (String)
		 * map.get("productBrandName"); String productName = (String)
		 * map.get("productName"); paramters.put("productBrandName",
		 * productBrandName); paramters.put("productName", productName); int
		 * buyTotal = detailDeployService .selectBuyTotalByProduct(paramters);
		 * map.put("buyTotal", buyTotal); } }
		 */
		return rp;

	}

	/**
	 * 产品盈亏分析
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("productProfitList.htm")
	public String productProfitQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(modelMap, bizId);
		// modelMap.addAttribute("bizId", bizId);
		return "queries/productProfit/productProfitList";
	}

	@RequestMapping("productProfitList.do")
	public String productProfitList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		// 如果为散客团，查询库存
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);
		List result = pb.getResult();
		Map paramters = WebUtils.getQueryParamters(request);
		Map conditionMap = new HashMap();
		if (result != null && result.size() > 0) {

			if (WebUtils.getQueryParamters(request).get("groupMode")
					.equals('0')) {
				for (int i = 0; i < result.size(); i++) {
					Map map = (Map) result.get(i);
					String productBrandId = (String) map.get("productBrandId");
					String productId = (String) map.get("productId");
					conditionMap.put("productBrandId", productBrandId);
					conditionMap.put("productId", productId);
					map.put("planedPersonCount", groupPriceService
							.selectProductByProduct(WebUtils
									.getQueryParamters(request)));
				}
			}
		}
		return rp;

	}

	/**
	 * 其他收入、其他支出预览页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */
	@RequestMapping(value = "otherDetailPreview.htm")
	public String otherDetailPreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("supplierType", WebUtils.getQueryParamters(request)
				.get("supplierType"));
		return "/queries/otherDetailPreview";
	}

	/**
	 * 其他收入、其他支出导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("exportExcel4.htm")
	public void exportExcel4(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String sl,
			String ssl, String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);

		String path = "";
		BigDecimal total2 = new BigDecimal(0);
		BigDecimal totalCash2 = new BigDecimal(0);
		BigDecimal totalBalance2 = new BigDecimal(0);
		BigDecimal totalNum = new BigDecimal(0);
		try {
			String url = "";
			if (Constants.OTHERINCOME.toString().equals(
					WebUtils.getQueryParamters(request).get("supplierType"))) {

				url = request
						.getSession()
						.getServletContext()
						.getRealPath(
								"/template/excel/incomeBusinessDetail.xlsx");
			}
			if (Constants.OTHEROUTCOME.toString().equals(
					WebUtils.getQueryParamters(request).get("supplierType"))) {

				url = request
						.getSession()
						.getServletContext()
						.getRealPath(
								"/template/excel/outcomeBusinessDetail.xlsx");
			}

			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			// Iterator<GroupOrder> it = orders.iterator();
			List<Map<String, Object>> result = pb.getResult();
			int index = 0;
			for (Map<String, Object> map : result) {
				// GroupOrder order = it.next() ;
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(map.get("groupCode") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(map.get("productBrandName") + "-"
						+ map.get("productName"));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue(map.get("supplierName") + "");
				cc.setCellStyle(styleLeft);

				cc = row.createCell(4);
				cc.setCellValue(map.get("cashType") == null ? "" : map
						.get("cashType") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(5);
				cc.setCellValue(map.get("item_date") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(6);
				cc.setCellValue(map.get("type1_name") == null ? "" : map
						.get("type1_name") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(7);
				BigDecimal itemPrice = new BigDecimal(0);
				itemPrice = itemPrice.add((BigDecimal) map.get("item_price"));
				cc.setCellValue(itemPrice.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(8);
				BigDecimal itemNum = new BigDecimal(0);
				itemNum = itemNum.add((BigDecimal) map.get("item_num"));
				cc.setCellValue(itemNum.intValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				BigDecimal total = new BigDecimal(0);
				total = total.add((BigDecimal) map.get("total"));
				cc.setCellValue(total.doubleValue());// 应收
				cc.setCellStyle(cellStyle);

				cc = row.createCell(10);
				BigDecimal totalCash = new BigDecimal(0);
				totalCash = totalCash.add((BigDecimal) map.get("totalCash"));
				cc.setCellValue(totalCash.doubleValue());// 已收
				cc.setCellStyle(cellStyle);

				cc = row.createCell(11);
				BigDecimal totalBalance = new BigDecimal(0);
				// totalBalance = totalBalance.add((BigDecimal)
				// map.get("totalBalance"));
				totalBalance = total.subtract(totalCash);
				cc.setCellValue(totalBalance.doubleValue());// 未收
				cc.setCellStyle(cellStyle);
				index++;
				total2 = total2.add((BigDecimal) map.get("total"));
				totalNum = totalNum.add((BigDecimal) map.get("item_num"));

				totalCash2 = totalCash2.add((BigDecimal) map.get("totalCash"));
				totalBalance2 = totalBalance2.add(totalBalance);
			}
			row = sheet.createRow(pb.getResult().size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellValue(totalNum.intValue());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);
			cc.setCellValue(total2.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellValue(totalCash2.doubleValue());
			// cc.setCellValue(totalCash2.intValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellValue(totalBalance2.doubleValue());
			cc.setCellStyle(cellStyle);

			CellRangeAddress region = new CellRangeAddress(pb.getResult()
					.size() + 3, pb.getResult().size() + 4, 0, 12);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	/**
	 * 车队预览页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */
	@RequestMapping(value = "fleetDetailPreview.htm")
	public String fleetDetailPreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		return "/queries/fleet/fleetDetailPreview";
	}

	/**
	 * 车队导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("exportExcel5.htm")
	public void exportExcel5(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String sl,
			String ssl, String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);

		String path = "";
		BigDecimal total2 = new BigDecimal(0);
		BigDecimal totalCash2 = new BigDecimal(0);
		BigDecimal totalBalance2 = new BigDecimal(0);
		try {

			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/fleetBusinessDetail.xlsx");

			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			// Iterator<GroupOrder> it = orders.iterator();
			List<Map<String, Object>> result = pb.getResult();
			int index = 0;
			for (Map<String, Object> map : result) {
				// GroupOrder order = it.next() ;
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(map.get("groupCode") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(map.get("operatorName") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue(map.get("productBrandName") + "-"
						+ map.get("productName"));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(4);
				cc.setCellValue(map.get("totalAdult") + "大"
						+ map.get("totalChild") + "小");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(5);
				cc.setCellValue(map.get("supplierName") + "");
				cc.setCellStyle(styleLeft);

				cc = row.createCell(6);
				cc.setCellValue(map.get("type1Name") == null ? "" : map
						.get("type1Name") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(7);
				cc.setCellValue(map.get("type2Name") == null ? "" : map
						.get("type2Name") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(8);
				cc.setCellValue(map.get("driverName") == null ? "" : map
						.get("driverName") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				cc.setCellValue(map.get("carLisence") == null ? "" : map
						.get("carLisence") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(10);
				cc.setCellValue(map.get("itemDate") + "~"
						+ map.get("itemDateTo"));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(11);
				BigDecimal itemTotal = new BigDecimal(0);
				itemTotal = itemTotal.add((BigDecimal) map.get("total"));
				cc.setCellValue(itemTotal.doubleValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(12);
				BigDecimal totalCash = new BigDecimal(0);
				totalCash = totalCash.add((BigDecimal) map.get("totalCash"));
				cc.setCellValue(totalCash.doubleValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(13);
				BigDecimal totalBalance = new BigDecimal(0);
				totalBalance = itemTotal.subtract(totalCash);
				cc.setCellValue(totalBalance.doubleValue());
				cc.setCellStyle(cellStyle);

				cc = row.createCell(14);
				cc.setCellValue(map.get("remark") == null ? "" : map
						.get("remark") + "");
				cc.setCellStyle(cellStyle);

				index++;
				total2 = total2.add((BigDecimal) map.get("total"));

				totalCash2 = totalCash2.add((BigDecimal) map.get("totalCash"));
				totalBalance2 = totalBalance2.add(totalBalance);
			}
			row = sheet.createRow(pb.getResult().size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);

			cc.setCellStyle(styleRight);
			cc = row.createCell(10);

			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellValue(total2.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(12);
			cc.setCellValue(totalCash2.doubleValue());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(13);
			cc.setCellValue(totalBalance2.doubleValue());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(14);
			cc.setCellStyle(cellStyle);

			CellRangeAddress region = new CellRangeAddress(pb.getResult()
					.size() + 3, pb.getResult().size() + 4, 0, 15);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	/**
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "guestSourceShopping.htm")
	public String productGuestSourceShoppingList(HttpServletRequest request,
			ModelMap model) {
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "/queries/product/product-guest-shopping/product-guest_source-shopping-list";
	}

	@RequestMapping(value = "guestSourceShoppingList.do", method = RequestMethod.POST)
	public String productGuestSourceShoppingStatics(HttpServletRequest request,
			ModelMap model, ProductGuestShoppingCondition condition) {
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String operatorIds = "";
			for (Integer usrId : set) {
				operatorIds += usrId + ",";
			}
			if (!operatorIds.equals("")) {
				condition.setOperatorIds(operatorIds.substring(0,
						operatorIds.length() - 1));
			}
		}
		PageBean pageBean = new PageBean();
		if (condition.getPage() == null) {
			condition.setPage(1);
		}
		if (condition.getPageSize() == null) {
			condition.setPageSize(Constants.PAGESIZE);
		}
		condition.setBizId(WebUtils.getCurBizId(request));
		condition.setDataRightSet(WebUtils.getDataUserIdSet(request));
		pageBean.setPage(condition.getPage());
		pageBean.setPageSize(condition.getPageSize());
		pageBean.setParameter(condition);
		pageBean = queryService.selectProductGuestShopStatics(pageBean);
		model.addAttribute("pageBean", pageBean);
		return "/queries/product/product-guest-shopping/product-guest_source-shopping-list-table";
	}

	/**
	 * 产品收客统计预览页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */
	@RequestMapping(value = "productGuestDetailPreview.htm")
	public String productGuestDetailPreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			ProductGuestCondition condition) {
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				condition.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		// if (condition.getStartDate() != null) {
		// condition.setStartDateNum(condition.getStartDate().getTime());
		// }
		// if (condition.getEndDate() != null) {
		// condition.setEndDateNum(condition.getEndDate().getTime());
		// }
		if (condition.getDateType() != null && condition.getDateType() == 1) {
			if (!"".equals(condition.getStartDate())) {
				condition.setStartDateNum(condition.getStartDate().getTime());
			}
			if (!"".equals(condition.getEndDate())) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(condition.getEndDate());
				calendar.add(Calendar.DAY_OF_MONTH, +1);// 让日期加1
				condition.setEndDateNum(calendar.getTime().getTime());
			}
		}

		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		condition.setBizId(WebUtils.getCurBizId(request));
		List<ProductGuestStaticsVo> productGuestStatics = queryService
				.productGuestStatics2(condition,
						WebUtils.getDataUserIdSet(request));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("productGuest", productGuestStatics);
		return "/queries/order/productGuestPreview";
	}

	/**
	 * 数据分析/产品收客统计导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("exportExcel6.htm")
	public void exportExcel6(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			ProductGuestCondition condition) {
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				condition.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		if (condition.getStartDate() != null) {
			condition.setStartDateNum(condition.getStartDate().getTime());
		}
		if (condition.getEndDate() != null) {
			condition.setEndDateNum(condition.getEndDate().getTime());
		}
		condition.setBizId(WebUtils.getCurBizId(request));
		List<ProductGuestStaticsVo> productGuestStatics = queryService
				.productGuestStatics2(condition,
						WebUtils.getDataUserIdSet(request));

		String path = "";
		BigDecimal personCount = new BigDecimal(0);
		BigDecimal orderCount = new BigDecimal(0);
		try {

			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/productGuestCount.xlsx");

			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			// Iterator<GroupOrder> it = orders.iterator();
			// List<Map<String, Object>> result = pb.getResult();
			int index = 0;
			for (ProductGuestStaticsVo pg : productGuestStatics) {
				// GroupOrder order = it.next() ;
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue(pg.getProductBrandName() + "-"
						+ pg.getProductName());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(pg.getGuestCnt().intValue());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue(pg.getOrderCount().intValue());
				cc.setCellStyle(styleLeft);
				index++;
				personCount = personCount.add(new BigDecimal(pg.getGuestCnt()));

				orderCount = orderCount.add(new BigDecimal(pg.getOrderCount()));
			}

			row = sheet.createRow(productGuestStatics.size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellValue(personCount.intValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellValue(orderCount.intValue());
			cc.setCellStyle(styleRight);

			CellRangeAddress region = new CellRangeAddress(
					productGuestStatics.size() + 3,
					productGuestStatics.size() + 4, 0, 4);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(productGuestStatics.size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	/**
	 * 客源地统计预览页面
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */
	@RequestMapping(value = "productSourcePreview.htm")
	public String productSourcePreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model,
			ProductGuestCondition condition) {
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				condition.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		if (condition.getStartDate() != null) {
			condition.setStartDateNum(condition.getStartDate().getTime());
		}
		if (condition.getEndDate() != null) {
			// 添加时间时，结束时间需要加一天
			condition.setEndDateNum(com.yihg.images.util.DateUtils.addDay(
					condition.getEndDate(), 1).getTime());
		}
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);
		condition.setBizId(WebUtils.getCurBizId(request));
		List<Map<String, Object>> guestSourceStatics = queryService
				.guestSourceStatics2(condition,
						WebUtils.getDataUserIdSet(request));
		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		model.addAttribute("guestSource", guestSourceStatics);
		return "/queries/order/productSourcePreview";
	}

	/**
	 * 数据分析/客源地统计导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("exportExcel7.htm")
	public void exportExcel7(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			ProductGuestCondition condition) {
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				condition.setOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		if (condition.getStartDate() != null) {
			condition.setStartDateNum(condition.getStartDate().getTime());
		}
		if (condition.getEndDate() != null) {
			// 添加时间时，结束时间需要加一天
			condition.setEndDateNum(com.yihg.images.util.DateUtils.addDay(
					condition.getEndDate(), 1).getTime());
		}
		condition.setBizId(WebUtils.getCurBizId(request));
		List<Map<String, Object>> guestSourceStatics = queryService
				.guestSourceStatics2(condition,
						WebUtils.getDataUserIdSet(request));
		String path = "";
		Integer personCount = 0;
		Integer adultCount = 0;
		Integer childCount = 0;
		try {

			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/guestSource.xlsx");

			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			int index = 0;
			for (Map<String, Object> map : guestSourceStatics) {
				row = sheet.createRow(index + 2);
				
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue(map.get("provinceName") + "");
				cc.setCellStyle(styleLeft);
				
				cc = row.createCell(2);
				cc.setCellValue(map.get("adultCnt").toString());
				cc.setCellStyle(styleLeft);
				
				cc = row.createCell(3);
				cc.setCellValue(map.get("childCnt").toString());
				cc.setCellStyle(styleLeft);
				
				index++;
				personCount += TypeUtils.castToInt(map.get("guestCnt"));
				adultCount += TypeUtils.castToInt(map.get("adultCnt"));
				childCount += TypeUtils.castToInt(map.get("childCnt"));

			}

			row = sheet.createRow(guestSourceStatics.size() + 2); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellValue("合计：");
			
			cc.setCellStyle(styleLeft);
			cc = row.createCell(2);
			cc.setCellValue(adultCount.intValue());
			
			cc.setCellStyle(styleLeft);
			cc = row.createCell(3);
			cc.setCellValue(childCount.intValue());
			
			cc.setCellStyle(styleLeft);
			CellRangeAddress region = new CellRangeAddress(
					guestSourceStatics.size() + 3,
					guestSourceStatics.size() + 4, 0, 3);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(guestSourceStatics.size() + 3);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	/**
	 * @author zhangxiaoyang 产品客户购物统计
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("productShopList.htm")
	public String productShopQueries(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(modelMap, bizId);
		// modelMap.addAttribute("bizId", bizId);
		return "queries/productShopping/productShoppingList";
	}

	@RequestMapping("productShopList.do")
	public String productShopList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);

		return rp;

	}

	/**
	 * 客户产品人数统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("productGuestNum.htm")
	public String productGuestNumList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);

		return "queries/productGuestNum/productGuestNumList";

	}

	@RequestMapping("productGuestNum.do")
	public String productGuestNumTable(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, GroupOrder order) {
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
		if (order.getPage() == null) {
			order.setPage(1);
		}
		pageBean.setPage(order.getPage());

		if (order.getPageSize() == null) {
			order.setPageSize(Constants.PAGESIZE);
		}
		pageBean.setPageSize(order.getPageSize());

		if (StringUtils.isBlank(order.getSaleOperatorIds())
				&& StringUtils.isNotBlank(order.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = order.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				order.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(order);
		pageBean = groupOrderService.selectOrderByParameterListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		List<GroupOrder> result = pageBean.getResult();
		Map parameters = WebUtils.getQueryParamters(request);
		if (result != null && result.size() > 0) {
			for (int i = 0; i < result.size(); i++) {
				Integer supplierId = result.get(i).getSupplierId();
				parameters.put("supplierId", supplierId);
				// parameters.put("set", WebUtils.getDataUserIdSet(request));
				List<GroupOrder> orders = groupOrderService
						.selectOrderByParameter2(parameters);
				result.get(i).setOrderList(orders);
				result.get(i).setRowSpan(orders.size());
			}
		}
		model.addAttribute("pageBean", pageBean);
		return "queries/productGuestNum/productGuestNumTable";

	}

	@RequestMapping("deservedCash.htm")
	public String deservedCashList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		// int bizId = WebUtils.getCurBizId(request);
		List<DicInfo> lysfxmList = dicService.getListByTypeCode(
				BasicConstants.GYXX_LYSFXM, WebUtils.getCurBizId(request));
		model.addAttribute("lysfxmList", lysfxmList);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		return "queries/deservedCash/deservedCashList";

	}

	@RequestMapping("deservedCash.do")
	public String deservedCashTable(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, GroupOrder order)
			throws ParseException {
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
		if (order.getPage() == null) {
			order.setPage(1);
		}
		pageBean.setPage(order.getPage());

		if (order.getPageSize() == null) {
			order.setPageSize(Constants.PAGESIZE);
		}
		pageBean.setPageSize(order.getPageSize());

		if (StringUtils.isBlank(order.getSaleOperatorIds())
				&& StringUtils.isNotBlank(order.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = order.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				order.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		order.setBizId(WebUtils.getCurBizId(request));
		if (order.getDateType() == 1
				&& StringUtils.isNotBlank(order.getEndTime())) {
			String endTime = org.apache.commons.lang.time.DateFormatUtils
					.format(org.apache.commons.lang.time.DateUtils.addDays(
							new SimpleDateFormat("yyyy-MM-dd").parse(order
									.getEndTime()), 1), "yyyy-MM-dd");
			order.setEndTime(endTime);
		}
		pageBean.setParameter(order);
		Map<String, Object> sum = groupOrderService
				.getDeservedCashGroupByOrderIdTotal(pageBean,
						WebUtils.getDataUserIdSet(request));
		pageBean = groupOrderService.getDeservedCashGroupByOrderId(pageBean,
				WebUtils.getDataUserIdSet(request));
		/*
		 * List<GroupOrder> result = pageBean.getResult(); Map parameters=new
		 * HashMap(); if(result!=null && result.size()>0){ for (int i = 0; i <
		 * result.size(); i++) { Integer supplierId =
		 * result.get(i).getSupplierId(); parameters.put("supplierId",
		 * supplierId); List<GroupOrder> orders =
		 * groupOrderService.selectOrderByParameter2(parameters);
		 * result.get(i).setOrderList(orders);
		 * result.get(i).setRowSpan(orders.size()); } }
		 */
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("sum", sum);
		return "queries/deservedCash/deservedCashTable";

	}

	@RequestMapping("toGroupDateQuery.htm")
	public String toGroupDateQuery() {
		return "queries/order/groupDateQuery";
	}

	@RequestMapping("groupDateQuery.htm")
	public String groupDateQuery(HttpServletRequest request, ModelMap model,
			Integer operType) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		model.addAttribute("pageSize", Constants.PAGESIZE);
		if (operType == 0) {
			return "queries/order/groupDateQuery_start";
		} else {
			return "queries/order/groupDateQuery_end";
		}
	}

	@RequestMapping("groupDateQueryData.do")
	public String groupDateQueryData(HttpServletRequest request,
			ModelMap model, TourGroup tourGroup) {

		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		PageBean<TourGroup> pageBean = new PageBean<TourGroup>();
		if (tourGroup.getPage() == null) {
			tourGroup.setPage(1);
		}
		pageBean.setPage(tourGroup.getPage());

		if (tourGroup.getPageSize() == null
				|| tourGroup.getPageSize().equals("")) {
			tourGroup.setPageSize(Constants.PAGESIZE);
		}
		pageBean.setPageSize(tourGroup.getPageSize());

		if (StringUtils.isBlank(tourGroup.getOperatorIds())
				&& StringUtils.isNotBlank(tourGroup.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = tourGroup.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String OperatorIds = "";
			for (Integer usrId : set) {
				OperatorIds += usrId + ",";
			}
			if (!OperatorIds.equals("")) {
				tourGroup.setOperatorIds(OperatorIds.substring(0,
						OperatorIds.length() - 1));
			}
		}
		pageBean.setParameter(tourGroup);
		pageBean = tourGroupService.selectTourGroupToQueryListPage(pageBean,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		List<TourGroup> result = pageBean.getResult();
		if (result != null && result.size() > 0) {
			for (TourGroup tg : result) {
				List<BookingGuide> guideList = bookingGuideService
						.selectGuidesByGroupId(tg.getId());
				tg.setGuideList(guideList);
			}
		}
		TourGroup tg = tourGroupService.selectTourGroupToQueryCon(tourGroup,
				WebUtils.getCurBizId(request),
				WebUtils.getDataUserIdSet(request));
		model.addAttribute("page", pageBean);
		model.addAttribute("tg", tg);
		if (tourGroup.getOperType() != null && tourGroup.getOperType() == 1) {
			return "queries/order/groupDateQuery_start_data";
		} else {
			return "queries/order/groupDateQuery_end_data";
		}

	}

	/**
	 * 
	 * 客户客源地购物分析
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("supplierGuestSourceShoppingList.htm")
	public String supplierGuestSourceShopList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		List<RegionInfo> allProvince = regionService.getAllProvince();
		model.addAttribute("allProvince", allProvince);
		return "queries/guestSourceShop/supplier-guest_source-shopping-list";

	}

	@RequestMapping("supplierGuestSourceShoppingList.do")
	// @ResponseBody
	public String supplierGuestSourceShop(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, GroupOrder groupOrder) {
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String OperatorIds = "";
			for (Integer usrId : set) {
				OperatorIds += usrId + ",";
			}
			if (!OperatorIds.equals("")) {
				groupOrder.setSaleOperatorIds(OperatorIds.substring(0,
						OperatorIds.length() - 1));
			}
		}
		PageBean pageBean = new PageBean();
		if (groupOrder.getPage() == null) {
			groupOrder.setPage(1);
		}
		if (groupOrder.getPageSize() == null) {
			groupOrder.setPageSize(Constants.PAGESIZE);
		}
		groupOrder.setBizId(WebUtils.getCurBizId(request));
		pageBean.setPage(groupOrder.getPage());
		pageBean.setPageSize(groupOrder.getPageSize());
		pageBean.setParameter(groupOrder);

		model.addAttribute("shopState", groupOrder.getShopDetailDeploy()
				.getShoppingDataState());
		model.addAttribute(
				"pageBean",
				queryService.selectSupplierGuestShopStatics(pageBean,
						WebUtils.getDataUserIdSet(request)));

		return "queries/guestSourceShop/supplier-guest_source-shopping-list-table";

	}

	/**
	 * 客人画像分析
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("guestInfoStatics.htm")
	public String guestInfoList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		return "queries/guestInfo/guest-info";

	}

	@RequestMapping("guestInfoStatics.do")
	public String guestInfoStatistics(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, GroupOrder groupOrder)
			throws ParseException {
		// 设置计调人员的值
		Map parameters = WebUtils.getQueryParamters(request);
		if (StringUtils.isBlank(groupOrder.getSaleOperatorIds())
				&& StringUtils.isNotBlank(groupOrder.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = groupOrder.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				parameters.put("saleOperatorIds", salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}

		groupOrder.setBizId(WebUtils.getCurBizId(request));
		// 如果选择日期类型为输单日期，将日期转换为毫秒值
		if (groupOrder.getDateType() != null && groupOrder.getDateType() == 1) {
			if (groupOrder.getStartTime() != null) {
				// groupOrder.setStartTime(new SimpleDateFormat("yyyy-MM-dd")
				// .parse(groupOrder.getStartTime()).getTime() + "");
				parameters.put("startTime", new SimpleDateFormat("yyyy-MM-dd")
						.parse(groupOrder.getStartTime()).getTime() + "");
			}
			if (groupOrder.getEndTime() != null) {
				Calendar calendar = new GregorianCalendar();
				calendar.setTime(new SimpleDateFormat("yyyy-MM-dd")
						.parse(groupOrder.getEndTime()));
				calendar.add(calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
				// groupOrder.setEndTime(calendar.getTime().getTime() + "");
				parameters.put("endTime", calendar.getTime().getTime() + "");
			}

		}

		// parameters.put("set", WebUtils.getDataUserIdSet(request));
		// parameters.put("bizId", WebUtils.getCurBizId(request));
		String jsonSexStr = queryService.getGuestSexInfo(parameters);
		model.addAttribute("jsonSexStr", jsonSexStr);
		String jsonAgeStr = queryService.getGuestAgeInfo(parameters);
		model.addAttribute("jsonAgeStr", jsonAgeStr);
		String jsonAirStr = queryService.getGuestAirTimeInfo(parameters);
		model.addAttribute("jsonAirStr", jsonAirStr);
		String jsonSourceStr = queryService.getGuestSouceInfo(parameters);
		model.addAttribute("jsonSourceStr", jsonSourceStr);
		return "queries/guestInfo/guest-info-table";

	}

	/**
	 * 跳转到团利润查询页面
	 */
	@RequestMapping(value = "settleList.htm")
	public String settleList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		List<TourGroup> auditorList = tourGroupService.getAuditorList();
		model.addAttribute("auditorList", auditorList);
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		// model.addAttribute("bizId", WebUtils.getCurBizId(request)); // 过滤B商家
		return "queries/groupProfit/settle-list";
	}

	/**
	 * 团利润查询预览
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 * @param svc
	 * @param sl
	 * @return
	 */
	@RequestMapping("groupProfitPreview.htm")
	public String groupProfitPreview(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, TourGroupVO group,
			String svc, String sl) {
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());
		PageBean pb = new PageBean();
		pb.setPage(1);
		pb.setPageSize(100000);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(group.getSaleOperatorIds())
				&& StringUtils.isNotBlank(group.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				group.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		if (null != group.getSaleOperatorIds()
				&& !"".equals(group.getSaleOperatorIds())) {
			pms.put("operator_id", group.getSaleOperatorIds());
		}
		// pms.put("set", WebUtils.getDataUserIdSet(request));
		pb.setParameter(pms);
		pb = getCommonService(svc).queryListPage(sl, pb);
		model.addAttribute("pageBean", pb);

		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		List<Map> results = pb.getResult();
		Map item = null;
		for (int i = 0; i < results.size(); i++) {
			item = results.get(i);
			Integer groupId = Integer.parseInt(item.get("id").toString());
			List<BookingGuide> bookingGuides = bookingGuideService
					.selectGuidesByGroupId(groupId);
			StringBuffer s = new StringBuffer();
			for (int j = 0; j < bookingGuides.size(); j++) {
				if (j == (bookingGuides.size() - 1)) {
					s.append(bookingGuides.get(j).getGuideName());
				} else {
					s.append(bookingGuides.get(j).getGuideName() + ",");
				}
			}
			guideMap.put(groupId, s.toString());

			BigDecimal totalIncome = NumberUtil.parseObj2Num(item
					.get("total_income"));
			BigDecimal totalCost = NumberUtil.parseObj2Num(item
					.get("total_cost"));

			// 团收入 = 团收入 - 购物汇总
			InfoBean shop = financeService.statsShopWithCommInfoBean(groupId);
			totalIncome = totalIncome.subtract(shop.getNum());

			item.put("total_income", totalIncome);
			item.put("total_cost", totalCost);
			item.put("total_profit", totalIncome.subtract(totalCost));

		}
		model.addAttribute("guideMap", guideMap);
		return "/queries/groupProfit/groupProfitPreview";

	}

	/**
	 * 团利润查询列表
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @param group
	 * @return
	 */
	@RequestMapping(value = "settleListPage.htm")
	public String settleListPage(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc,
			TourGroupVO group) {

		PageBean pb = new PageBean();
		pb.setPage(page);
		if (pageSize == null) {
			pageSize = Constants.PAGESIZE;
		}
		pb.setPageSize(pageSize);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(group.getSaleOperatorIds())
				&& StringUtils.isNotBlank(group.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				group.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		if (null != group.getSaleOperatorIds()
				&& !"".equals(group.getSaleOperatorIds())) {
			pms.put("operator_id", group.getSaleOperatorIds());
		}
		// pms.put("set", WebUtils.getDataUserIdSet(request));
		pb.setParameter(pms);
		pb = getCommonService(svc).queryListPage(sl, pb);
		model.addAttribute("pageBean", pb);

		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		List<Map> results = pb.getResult();
		Map item = null;
		for (int i = 0; i < results.size(); i++) {
			item = results.get(i);
			Integer groupId = Integer.parseInt(item.get("id").toString());
			List<BookingGuide> bookingGuides = bookingGuideService
					.selectGuidesByGroupId(groupId);
			StringBuffer s = new StringBuffer();
			for (int j = 0; j < bookingGuides.size(); j++) {
				if (j == (bookingGuides.size() - 1)) {
					s.append(bookingGuides.get(j).getGuideName());
				} else {
					s.append(bookingGuides.get(j).getGuideName() + ",");
				}
			}
			guideMap.put(groupId, s.toString());

			BigDecimal totalIncome = NumberUtil.parseObj2Num(item
					.get("total_income"));
			BigDecimal totalCost = NumberUtil.parseObj2Num(item
					.get("total_cost"));

			// 团收入 = 团收入 - 购物汇总
			InfoBean shop = financeService.statsShopWithCommInfoBean(groupId);
			totalIncome = totalIncome.subtract(shop.getNum());

			item.put("total_income", totalIncome);
			item.put("total_profit", totalIncome.subtract(totalCost));

		}
		model.addAttribute("guideMap", guideMap);

		// 总计查询
		if (StringUtils.isNotBlank(ssl)) {
			Map pm = (Map) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));

		}
		return "queries/groupProfit/settle-list-table";
	}

	/**
	 * 团利润查询导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param group
	 */

	@RequestMapping("groupProfitExportExcel.htm")
	public void groupProfitExportExcel(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, TourGroupVO group,
			String svc, String sl) {
		PageBean pb = new PageBean();
		pb.setPage(1);
		pb.setPageSize(100000);
		// 如果人员为空并且部门不为空，则取部门下的人id
		if (StringUtils.isBlank(group.getSaleOperatorIds())
				&& StringUtils.isNotBlank(group.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = group.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				group.setSaleOperatorIds(salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1));
			}
		}
		Map<String, Object> pms = WebUtils.getQueryParamters(request);
		if (null != group.getSaleOperatorIds()
				&& !"".equals(group.getSaleOperatorIds())) {
			pms.put("operator_id", group.getSaleOperatorIds());
		}
		// pms.put("set", WebUtils.getDataUserIdSet(request));
		pb.setParameter(pms);
		pb = getCommonService(svc).queryListPage(sl, pb);
		// model.addAttribute("pageBean", pb);

		Map<Integer, String> guideMap = new HashMap<Integer, String>();
		List<Map> results = pb.getResult();
		Map item = null;
		for (int i = 0; i < results.size(); i++) {
			item = results.get(i);
			Integer groupId = Integer.parseInt(item.get("id").toString());
			List<BookingGuide> bookingGuides = bookingGuideService
					.selectGuidesByGroupId(groupId);
			StringBuffer s = new StringBuffer();
			for (int j = 0; j < bookingGuides.size(); j++) {
				if (j == (bookingGuides.size() - 1)) {
					s.append(bookingGuides.get(j).getGuideName());
				} else {
					s.append(bookingGuides.get(j).getGuideName() + ",");
				}
			}
			guideMap.put(groupId, s.toString());

			BigDecimal totalIncome = NumberUtil.parseObj2Num(item
					.get("total_income"));
			BigDecimal totalCost = NumberUtil.parseObj2Num(item
					.get("total_cost"));

			// 团收入 = 团收入 - 购物汇总
			InfoBean shop = financeService.statsShopWithCommInfoBean(groupId);
			totalIncome = totalIncome.subtract(shop.getNum());

			item.put("total_income", totalIncome);
			item.put("total_profit", totalIncome.subtract(totalCost));
			item.put("total_cost", totalCost);

		}
		// model.addAttribute("guideMap", guideMap);
		String path = "";
		Integer guideCount = 0;
		Integer adultCount = 0;
		Integer childCount = 0;
		BigDecimal incomeTotal = new BigDecimal(0);
		BigDecimal outcomeTotal = new BigDecimal(0);
		BigDecimal profitTotal = new BigDecimal(0);
		try {

			String url = request.getSession().getServletContext()
					.getRealPath("/template/excel/tourGroupProfit.xlsx");

			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			int index = 0;
			for (int i = 0; i < pb.getResult().size(); i++) {
				item = (Map) pb.getResult().get(i);
				row = sheet.createRow(index + 2);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);

				cc = row.createCell(1);
				cc.setCellValue(item.get("group_code") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue("【" + item.get("product_brand_name") + "】"
						+ item.get("product_name"));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue((item.get("total_adult") == null ? "0" : item
						.get("total_adult"))
						+ "大"
						+ (item.get("total_child") == null ? "0" : item
								.get("total_child"))
						+ "小"
						+ (item.get("total_guide") == null ? "0" : item
								.get("total_guide")) + "陪");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(4);
				cc.setCellValue(item.get("operator_name") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(5);
				for (Map.Entry<Integer, String> entry : guideMap.entrySet()) {
					if (TypeUtils.castToInt(item.get("id")).equals(
							entry.getKey())) {

						cc.setCellValue(entry.getValue());
					}
				}
				cc.setCellStyle(styleLeft);
				cc = row.createCell(6);

				cc.setCellValue(item.get("date_start") == null ? ""
						: new SimpleDateFormat("MM-dd").format(TypeUtils
								.castToDate(item.get("date_start")))
								+ "/"
								+ (item.get("date_end") == null ? ""
										: new SimpleDateFormat("MM-dd").format(TypeUtils
												.castToDate(item
														.get("date_end")))));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(7);

				if (TypeUtils.castToInt(item.get("group_state")) == 0) {

					cc.setCellValue("未确认");
				} else if (TypeUtils.castToInt(item.get("group_state")) == 1
						&& item.get("date_start") != null
						&& (System.currentTimeMillis()
								- TypeUtils.castToDate(item.get("date_start"))
										.getTime() < 0)) {

					cc.setCellValue("已确认（待出团）");
				} else if (TypeUtils.castToInt(item.get("group_state")) == 1
						&& item.get("date_end") != null
						&& (System.currentTimeMillis()
								- TypeUtils.castToDate(item.get("date_end"))
										.getTime() > 0)) {

					cc.setCellValue("已确认（已离开）");
				} else if (TypeUtils.castToInt(item.get("group_state")) == 1
						&& item.get("date_end") != null
						&& item.get("date_start") != null
						&& (System.currentTimeMillis()
								- TypeUtils.castToDate(item.get("date_end"))
										.getTime() > 0)
						&& (System.currentTimeMillis()
								- TypeUtils.castToDate(item.get("date_end"))
										.getTime() < 0)) {

					cc.setCellValue("已确认（行程中）");
				} else if (TypeUtils.castToInt(item.get("group_state")) == 2) {

					cc.setCellValue("废弃");
				} else if (TypeUtils.castToInt(item.get("group_state")) == 3) {

					cc.setCellValue("已审核");
				} else if (TypeUtils.castToInt(item.get("group_state")) == 4) {

					cc.setCellValue("封存");
				}
				cc.setCellStyle(styleLeft);
				cc = row.createCell(8);
				cc.setCellValue(item.get("audit_user") == null ? "" : item
						.get("audit_user") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(9);
				cc.setCellValue(TypeUtils.castToBigDecimal(
						item.get("total_income") == null ? 0 : item
								.get("total_income")).doubleValue());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(10);
				cc.setCellValue(TypeUtils.castToBigDecimal(
						item.get("total_cost") == null ? 0 : item
								.get("total_cost")).doubleValue());
				cc.setCellStyle(styleLeft);
				cc = row.createCell(11);
				cc.setCellValue(TypeUtils.castToBigDecimal(
						item.get("total_profit") == null ? 0 : item
								.get("total_profit")).doubleValue());
				cc.setCellStyle(styleLeft);
				index++;
				guideCount += TypeUtils
						.castToInt(item.get("total_guide") == null ? 0 : item
								.get("total_guide"));
				adultCount += TypeUtils
						.castToInt(item.get("total_adult") == null ? 0 : item
								.get("total_adult"));
				childCount += TypeUtils
						.castToInt(item.get("total_child") == null ? 0 : item
								.get("total_child"));
				incomeTotal = incomeTotal.add(NumberUtil.parseObj2Num(item
						.get("total_income") == null ? 0 : item
						.get("total_income")));
				outcomeTotal = outcomeTotal
						.add(NumberUtil
								.parseObj2Num(item.get("total_cost") == null ? 0
										: item.get("total_cost")));
				profitTotal = profitTotal.add(NumberUtil.parseObj2Num(item
						.get("total_profit") == null ? 0 : item
						.get("total_profit")));

			}

			row = sheet.createRow(pb.getResult().size() + 1); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellValue(adultCount + "大" + childCount + "小" + guideCount
					+ "陪");
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellStyle(styleRight);
			cc = row.createCell(9);
			cc.setCellValue(incomeTotal.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellValue(outcomeTotal.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			cc.setCellValue(profitTotal.doubleValue());
			cc.setCellStyle(styleRight);

			CellRangeAddress region = new CellRangeAddress(pb.getResult()
					.size() + 2, pb.getResult().size() + 2, 0, 11);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 2);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
	}

	/**
	 * 部门订单分析
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */

	@RequestMapping("departmentOrderList.htm")
	public String departmentOrderList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		// List<RegionInfo> allProvince = regionService.getAllProvince();
		// model.addAttribute("allProvince", allProvince);
		String startTime = org.apache.commons.lang.time.DateFormatUtils.format(
				new Date(), "yyyy-MM-dd");
		String endTime = org.apache.commons.lang.time.DateFormatUtils.format(
				org.apache.commons.lang.time.DateUtils.addDays(new Date(), 6),
				"yyyy-MM-dd");
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);
		return "queries/departmentOrder/departmentOrderList";
	}

	@RequestMapping("departmentOrderList.do")
	public String departmentOrderList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			DeparentmentOrderCondition condition) throws ParseException {
		Integer bizId = WebUtils.getCurBizId(request);
		List<PlatformOrgPo> secLevelOrgList = null;
		String staticsOrgIds = WebUtils.getBizConfigValue(request,
				BizConfigConstant.DEPT_ORDER_STATICS);
		if (staticsOrgIds != null) {
			String[] orgIdArr = staticsOrgIds.split(",");
			Set<Integer> sets = new HashSet<Integer>();
			for (String orgIdStr : orgIdArr) {
				sets.add(TypeUtils.castToInt(orgIdStr));
			}
			// 获取商户二级部门的集合
			secLevelOrgList = orgService.getOrgListByIdSet(bizId, sets);
		} else {
			// 获取商户二级部门的集合
			secLevelOrgList = orgService.getSecLevelOrgList(bizId);
		}
		if (StringUtils.isBlank(condition.getOperatorIds())
				&& StringUtils.isNotBlank(condition.getOrgIds())) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = condition.getOrgIds().split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String OperatorIds = "";
			for (Integer usrId : set) {
				OperatorIds += usrId + ",";
			}
			if (!OperatorIds.equals("")) {
				condition.setOperatorIds(OperatorIds.substring(0,
						OperatorIds.length() - 1));
			}
		}

		model.addAttribute("secLevelOrgList", secLevelOrgList);
		List<Integer> orgIdList = new ArrayList<Integer>();
		for (PlatformOrgPo org : secLevelOrgList) {
			orgIdList.add(org.getOrgId());
		}
		// 获取当前商户三级部门的集合
		List<PlatformOrgPo> subLevelOrgList = orgService.getSubLevelOrgList(
				bizId, orgIdList);
		model.addAttribute("subLevelOrgList", subLevelOrgList);
		Map<Integer, List<PlatformOrgPo>> orgDepMap = new HashMap<Integer, List<PlatformOrgPo>>();
		for (PlatformOrgPo org : subLevelOrgList) {
			List<PlatformOrgPo> depList = null;
			if (orgDepMap.containsKey(org.getParentId())) {
				depList = orgDepMap.get(org.getParentId());
			} else {
				depList = new ArrayList<PlatformOrgPo>();
			}
			depList.add(org);
			orgDepMap.put(org.getParentId(), depList);
		}
		model.addAttribute("orgDepMap", orgDepMap);
		// 获取当前商家的用户集合
		List<PlatformEmployeePo> employeeList = platformEmployeeService
				.getEmployeeListByName(bizId, null);
		// 存储用户及其所属的部门
		Map<Integer, Integer> empOrgMap = new HashMap<Integer, Integer>();
		for (PlatformEmployeePo employee : employeeList) {
			empOrgMap.put(employee.getEmployeeId(), employee.getOrgId());
		}
		// 获取各用户的订单统计信息
		condition.setBizId(WebUtils.getCurBizId(request));
		if (condition.getDateType() == 0) {
			condition.setStartTimeNum(condition.getStartTime().getTime());
			condition.setEndTimeNum(condition.getEndTime().getTime());
		}
		List<DepartmentOrderResult> orderList = groupOrderService
				.getDepartmentOrderStatistics(condition,
						WebUtils.getDataUserIdSet(request));
		// 存储部门和其对应的订单信息
		// List<Map<Integer, Integer>> orgOrderMapList=new
		// ArrayList<Map<Integer, Integer>>();
		// Map<Integer, DepartmentOrderVO> orgOrderMap = new HashMap<Integer,
		// DepartmentOrderVO>();

		List<String> dateList = new ArrayList<String>();
		Map<Date, Integer> dateMap = new HashMap<Date, Integer>();
		for (int i = 0; i < 7; i++) {
			dateList.add(DateUtils.format(
					org.apache.commons.lang.time.DateUtils.addDays(
							condition.getStartTime(), i), "yyyy-MM-dd"));
			dateMap.put(
					org.apache.commons.lang.time.DateUtils.addDays(
							condition.getStartTime(), i), i);
		}

		Map<Integer, DepartmentOrderVO> deptOrderVoMap = new HashMap<Integer, DepartmentOrderVO>();
		DepartmentOrderVO vo = null;
		for (DepartmentOrderResult order : orderList) {
			if (!empOrgMap.containsKey(order.getOperatorId())) {
				continue;
			}
			Integer orgId = empOrgMap.get(order.getOperatorId());
			if (deptOrderVoMap.containsKey(orgId)) {
				vo = deptOrderVoMap.get(orgId);
			} else {
				vo = new DepartmentOrderVO();
			}
			int idx = 0;
			if (condition.getDateType() == 0) {
				idx = dateMap.get(order.getCreateDate());
			} else {
				idx = dateMap.get(order.getDepartureDate());
			}
			switch (idx) {
			case 0:
				vo.setDay1NumAdult(zeroIfNull(vo.getDay1NumAdult())
						+ zeroIfNull(order.getNumAdult()));
				vo.setDay1NumChild(zeroIfNull(vo.getDay1NumChild())
						+ zeroIfNull(order.getNumChild()));
				break;
			case 1:
				vo.setDay2NumAdult(zeroIfNull(vo.getDay2NumAdult())
						+ zeroIfNull(order.getNumAdult()));
				vo.setDay2NumChild(zeroIfNull(vo.getDay2NumChild())
						+ zeroIfNull(order.getNumChild()));
				break;
			case 2:
				vo.setDay3NumAdult(zeroIfNull(vo.getDay3NumAdult())
						+ zeroIfNull(order.getNumAdult()));
				vo.setDay3NumChild(zeroIfNull(vo.getDay3NumChild())
						+ zeroIfNull(order.getNumChild()));
				break;
			case 3:
				vo.setDay4NumAdult(zeroIfNull(vo.getDay4NumAdult())
						+ zeroIfNull(order.getNumAdult()));
				vo.setDay4NumChild(zeroIfNull(vo.getDay4NumChild())
						+ zeroIfNull(order.getNumChild()));
				break;
			case 4:
				vo.setDay5NumAdult(zeroIfNull(vo.getDay5NumAdult())
						+ zeroIfNull(order.getNumAdult()));
				vo.setDay5NumChild(zeroIfNull(vo.getDay5NumChild())
						+ zeroIfNull(order.getNumChild()));
				break;
			case 5:
				vo.setDay6NumAdult(zeroIfNull(vo.getDay6NumAdult())
						+ zeroIfNull(order.getNumAdult()));
				vo.setDay6NumChild(zeroIfNull(vo.getDay6NumChild())
						+ zeroIfNull(order.getNumChild()));
				break;
			case 6:
				vo.setDay7NumAdult(zeroIfNull(vo.getDay7NumAdult())
						+ zeroIfNull(order.getNumAdult()));
				vo.setDay7NumChild(zeroIfNull(vo.getDay7NumChild())
						+ zeroIfNull(order.getNumChild()));
				break;
			default:
				break;
			}
			if (order.getAffirmOrderCount() != null) {
				vo.setAffirmOrderCount(zeroIfNull(vo.getAffirmOrderCount())
						+ zeroIfNull(order.getAffirmOrderCount()));
			}
			if (order.getReserveOrderCount() != null) {
				vo.setReserveOrderCount(zeroIfNull(vo.getReserveOrderCount())
						+ zeroIfNull(order.getReserveOrderCount()));
			}
			deptOrderVoMap.put(orgId, vo);
		}

		model.addAttribute("orgOrderMap", deptOrderVoMap);
		model.addAttribute("dateList", dateList);

		return "queries/departmentOrder/departmentOrderTable";

	}

	/**
	 * 接待人数统计
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping("receivePersonCountList.htm")
	public String receivePersonCountList(HttpServletRequest request,
			HttpServletResponse response, ModelMap model) {
		// Integer bizId = WebUtils.getCurBizId(request);
		// getOrgAndUserTreeJsonStr(model, bizId);
		model.addAttribute("yearLimit",
				Calendar.getInstance().get(Calendar.YEAR));

		return "queries/receivePersonCount/receivePersonCountList";

	}

	@RequestMapping("receivePersonCountList.do")
	public String receivePersonCountTable(HttpServletRequest request,
			HttpServletResponse response, ModelMap model,
			String saleOperatorIds, String orgIds) {
		Map parameters = WebUtils.getQueryParamters(request);
		if (StringUtils.isBlank(saleOperatorIds)
				&& StringUtils.isNotBlank(orgIds)) {
			Set<Integer> set = new HashSet<Integer>();
			String[] orgIdArr = orgIds.split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String OperatorIds = "";
			for (Integer usrId : set) {
				OperatorIds += usrId + ",";
			}
			if (!OperatorIds.equals("")) {
				parameters.put("saleOperatorIds",
						OperatorIds.substring(0, OperatorIds.length() - 1));
			}
		}
		// parameters.put("set", WebUtils.getDataUserIdSet(request));
		Map<String, Object> personMap = queryService
				.getReceivePersonStatistics(parameters);
		model.addAttribute("personMap", personMap);
		return "queries/receivePersonCount/receivePersonCountTable";

	}

	private Integer zeroIfNull(Integer cnt) {
		return cnt == null ? 0 : cnt;
	}

	@RequestMapping(value = "deliveryDetailPreview.htm")
	public String deliveryDetailPreview(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);
		String imgPath = bizSettingCommon.getMyBizLogo(request);
		model.addAttribute("imgPath", imgPath);

		model.addAttribute("printName", WebUtils.getCurUser(request).getName());

		return "/queries/deliveryDetailPreview";
	}

	/**
	 * 其他收入、其他支出导出excel
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 */
	@RequestMapping("deliveryExportExcel.do")
	public void deliveryExportExcel(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, String sl,
			String ssl, String rp, Integer page, Integer pageSize, String svc) {
		PageBean pb = commonQuery(request, model, sl, page, 10000, svc);

		String path = "";
		BigDecimal total = new BigDecimal(0);
		BigDecimal totalCash = new BigDecimal(0);
		BigDecimal totalBalance = new BigDecimal(0);
		long totalAdult = 0;
		long totalChild = 0;
		long totalGuide = 0;
		try {
			String url = "";
			url = request.getSession().getServletContext()
					.getRealPath("/template/excel/delivery_bookings.xlsx");

			FileInputStream input = new FileInputStream(new File(url)); // 读取的文件路径
			XSSFWorkbook wb = new XSSFWorkbook(new BufferedInputStream(input));
			CellStyle cellStyle = wb.createCellStyle();
			cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			cellStyle.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			cellStyle.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			cellStyle.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			cellStyle.setAlignment(CellStyle.ALIGN_CENTER); // 居中

			CellStyle styleLeft = wb.createCellStyle();
			styleLeft.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleLeft.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleLeft.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleLeft.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleLeft.setAlignment(CellStyle.ALIGN_LEFT); // 居左
			styleLeft.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			styleLeft.setWrapText(true);

			CellStyle styleRight = wb.createCellStyle();
			styleRight.setBorderBottom(CellStyle.BORDER_THIN); // 下边框
			styleRight.setBorderLeft(CellStyle.BORDER_THIN);// 左边框
			styleRight.setBorderTop(CellStyle.BORDER_THIN);// 上边框
			styleRight.setBorderRight(CellStyle.BORDER_THIN);// 右边框
			styleRight.setAlignment(CellStyle.ALIGN_RIGHT); // 居右
			Sheet sheet = wb.getSheetAt(0); // 获取到第一个sheet
			Row row = null;
			Cell cc = null;
			// 遍历集合数据，产生数据行
			List<Map<String, Object>> result = pb.getResult();
			int index = 0;
			for (Map<String, Object> map : result) {
				row = sheet.createRow(index + 3);
				cc = row.createCell(0);
				cc.setCellValue(index + 1);
				cc.setCellStyle(cellStyle);
				cc = row.createCell(1);
				cc.setCellValue(map.get("group_code") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(2);
				cc.setCellValue(map.get("date_arrival") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(3);
				cc.setCellValue(map.get("supplier_name") + "");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(4);
				cc.setCellValue((Integer) map.get("group_mode") > 0 ? "团队"
						: "散客");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(5);
				cc.setCellValue(map.get("total_adult") + "大"
						+ map.get("total_adult") + "小" + map.get("total_adult")
						+ "陪");
				cc.setCellStyle(styleLeft);
				cc = row.createCell(6);
				cc.setCellValue("【" + map.get("product_brand_name") + "】"
						+ map.get("product_name"));
				cc.setCellStyle(styleLeft);

				cc = row.createCell(7);
				cc.setCellValue(map.get("detailInfo") == null ? "" : map
						.get("detailInfo").toString().replace(";", "\n"));
				cc.setCellStyle(styleLeft);
				cc = row.createCell(8);
				BigDecimal total2 = new BigDecimal(0);
				total2 = total2.add((BigDecimal) map.get("total"));
				cc.setCellValue(total2.doubleValue());
				// cc.setCellValue(map.get("total") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(9);
				BigDecimal totalCash2 = new BigDecimal(0);
				totalCash2 = totalCash2.add((BigDecimal) map.get("totalCash"));
				cc.setCellValue(totalCash2.doubleValue());
				// cc.setCellValue(map.get("totalCash") + "");
				cc.setCellStyle(cellStyle);
				cc = row.createCell(10);
				// BigDecimal itemPrice = new BigDecimal(0);
				// itemPrice = itemPrice.add((BigDecimal)
				// map.get("item_price"));
				cc.setCellValue(total2.subtract(totalCash2).doubleValue());
				cc.setCellStyle(cellStyle);
				cc = row.createCell(11);
				// BigDecimal itemNum = new BigDecimal(0);
				// itemNum = itemNum.add((BigDecimal) map.get("item_num"));
				cc.setCellValue(map.get("operator_name") + "");
				cc.setCellStyle(cellStyle);

				index++;
				totalAdult += (Long) map.get("total_adult");
				totalChild += (Long) map.get("total_child");
				totalGuide += (Long) map.get("total_guide");
				total = total.add((BigDecimal) map.get("total"));
				totalCash = totalCash.add((BigDecimal) map.get("totalCash"));
				totalBalance = totalBalance.add(total.subtract(totalCash2));
			}
			row = sheet.createRow(pb.getResult().size() + 3); // 加合计行
			cc = row.createCell(0);
			cc.setCellStyle(styleRight);
			cc = row.createCell(1);
			cc.setCellStyle(styleRight);
			cc = row.createCell(2);
			cc.setCellStyle(styleRight);
			cc = row.createCell(3);
			cc.setCellStyle(styleRight);
			cc = row.createCell(4);
			cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(5);
			cc.setCellValue(String.valueOf(totalAdult) + "大"
					+ String.valueOf(totalChild) + "小"
					+ String.valueOf(totalGuide) + "陪");
			cc.setCellStyle(styleRight);
			cc = row.createCell(6);
			cc.setCellStyle(styleRight);
			cc = row.createCell(7);
			// cc.setCellValue("合计：");
			cc.setCellStyle(styleRight);
			cc = row.createCell(8);
			cc.setCellValue(total.doubleValue());
			cc.setCellStyle(cellStyle);
			cc = row.createCell(9);
			cc.setCellValue(totalCash.doubleValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(10);
			cc.setCellValue(totalBalance.doubleValue());
			// cc.setCellValue(totalCash2.intValue());
			cc.setCellStyle(styleRight);
			cc = row.createCell(11);
			// cc.setCellValue(totalBalance2.doubleValue());
			cc.setCellStyle(cellStyle);

			CellRangeAddress region = new CellRangeAddress(pb.getResult()
					.size() + 4, pb.getResult().size() + 4, 0, 12);
			sheet.addMergedRegion(region);
			// row = sheet.getRow(orders.size()+3); //打印信息
			row = sheet.createRow(pb.getResult().size() + 4);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/")
					+ "/download/" + System.currentTimeMillis() + ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		download2(path, request, response);
		// return "";
	}

	/**
	 * 跳转到应付款统计
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("accountList.htm")
	public String accountList(HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		Map<Integer, String> suppliers = SupplierConstant.supplierTypeMapAccount;
		modelMap.addAttribute("suppliers", suppliers);
		return "queries/account/account-list";
	}

	/**
	 * 
	 * 应付款统计
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @param visit
	 * @return
	 */
	@RequestMapping("getAccountDetail.do")
	public String getAccountDetail(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, String sl, String ssl,
			String rp, Integer page, Integer pageSize, String svc, Integer visit) {
		PageBean pb = commonQuery(request, model, sl, page, pageSize, svc);
		if (StringUtils.isNotBlank(ssl)) {
			Map pm = (Map) pb.getParameter();
			pm.put("parameter", pm);
			model.addAttribute("sum", getCommonService(svc).queryOne(ssl, pm));
		}
		return rp;
	}

	/**
	 * 产品收客趋势
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("productTrend.htm")
	public String productTrendList(HttpServletRequest request, Model model) {
		// 获取产品品牌信息
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandList = dicService.getListByTypeCode(
				BasicConstants.CPXL_PP, bizId);
		model.addAttribute("brandList", brandList);

		return "queries/productTrend/productTrendList";
	}

	/**
	 * 显示产品收客人数信息
	 * 
	 * @param request
	 * @param reponse
	 * @param model
	 * @param sl
	 * @param ssl
	 * @param rp
	 * @param page
	 * @param pageSize
	 * @param svc
	 * @return
	 */
	@RequestMapping(value = "productTrendList.htm")
	public String productTrendTableList(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model, GroupOrder groupOrder,
			String productBrandId, String saleOperatorIds, String orgIds,
			Integer page, Integer pageSize) throws ParseException {
		Integer bizId = WebUtils.getCurBizId(request);
		// 如果人员为空并且部门不为空，则取部门下的人id
		Set<Integer> set = new HashSet<Integer>();
		if (StringUtils.isBlank(saleOperatorIds)
				&& StringUtils.isNotBlank(orgIds)) {
			String[] orgIdArr = orgIds.split(",");
			for (String orgIdStr : orgIdArr) {
				set.add(Integer.valueOf(orgIdStr));
			}
			set = platformEmployeeService.getUserIdListByOrgIdList(
					WebUtils.getCurBizId(request), set);
			String salesOperatorIds = "";
			for (Integer usrId : set) {
				salesOperatorIds += usrId + ",";
			}
			if (!salesOperatorIds.equals("")) {
				saleOperatorIds = salesOperatorIds.substring(0,
						salesOperatorIds.length() - 1);
			}
		}

		Map<String, Object> parameters = WebUtils.getQueryParamters(request);
		if (null != saleOperatorIds && !"".equals(saleOperatorIds)) {
			parameters.put("orgIds", saleOperatorIds);
		}
		parameters.put("set", WebUtils.getDataUserIdSet(request));
		// parameters.put("orgIds", groupOrder.getOrgIds());
		// parameters.put("saleOperatorIds", groupOrder.getSaleOperatorIds());
		// Map parameters = new HashMap();
		// parameters.put("bizId", bizId);
		// parameters.put("productBrandId", productBrandId);
		// parameters.put("startTime", startTime);
		// parameters.put("endTime", endTime);
		// parameters.put("groupMode", groupMode);

		// parameters.put("productName", groupOrder.getProductName());
		// parameters.put("orgId", WebUtils.getCurUser(request).getOrgId());
		// parameters.put("set", WebUtils.getDataUserIdSet(request));

		// ===================InnerLayer=============================================
		/*
		 * PageBean pageBeanInnerLayer = new PageBean(); if (pageSize == null) {
		 * pageBeanInnerLayer.setPageSize(Constants.PAGESIZE); } else {
		 * pageBeanInnerLayer.setPageSize(pageSize); }
		 */
		// pageBeanInnerLayer.setParameter(groupOrder);
		// pageBeanInnerLayer.setPage(page);
		PageBean<GroupOrder> pageBean = new PageBean<GroupOrder>();
		pageBean.setPage(1);
		pageBean.setPageSize(1000000);

		List<GroupOrder> pbInnerLayer = groupOrderService
				.selectProductTrendListPageInnerLayer(pageBean, parameters);
		// List<GroupOrder> goListInnerLayer = pbInnerLayer.getResult();
		for (GroupOrder go : pbInnerLayer) {
			System.out.println("----1---" + go.getProductBrandName()
					+ "--------" + go.getProductName() + ","
					+ go.getDepartureDate() + "," + go.getPerson());
		}
		// =====================InnerLayer===========================================

		// =====================OutLayer===========================================
		PageBean pageBeanOutLayer = new PageBean();
		if (page == null) {
			page = 1;
		}
		if (pageSize == null) {
			pageBeanOutLayer.setPageSize(Constants.PAGESIZE);
		} else {
			pageBeanOutLayer.setPageSize(pageSize);
		}
		pageBeanOutLayer.setParameter(groupOrder.getGroupMode());
		pageBeanOutLayer.setPage(page);

		PageBean<GroupOrder> pbOutLayer = groupOrderService
				.selectProductTrendListPageOutLayer(pageBeanOutLayer,
						parameters);
		List<GroupOrder> goListOutLayer = pbOutLayer.getResult();

		for (GroupOrder gg : goListOutLayer) {
			// List<Map<String, Object>> listMap = new
			// ArrayList<Map<String,Object>>();
			// System.out.println(gg.getProductBrandName()+","+gg.getProductName()+","+gg.getDepartureDate()+","+gg.getNumAdult()+","+gg.getNumChild());

			for (GroupOrder go : pbInnerLayer) {
				// System.out.println("-------"+go.getProductBrandName()+"--------"+go.getProductName()+","+go.getDepartureDate()+","+go.getNumAdult()+","+go.getNumChild()+","+go.getPerson());
				if (go.getProductBrandName().equals(gg.getProductBrandName())
						&& go.getProductName().equals(gg.getProductName())) {
					String firstDate = go.getDepartureDate().substring(8, 10);
					if ("01".equals(firstDate)) {
						gg.setDay1(go.getPerson());
					}
					if ("02".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay2(go.getPerson());
					}
					if ("03".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay3(go.getPerson());
					}
					if ("04".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay4(go.getPerson());
					}
					if ("05".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay5(go.getPerson());
					}
					if ("06".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay6(go.getPerson());
					}
					if ("07".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay7(go.getPerson());
					}
					if ("08".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay8(go.getPerson());
					}
					if ("09".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay9(go.getPerson());
					}
					if ("10".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay10(go.getPerson());
					}
					if ("11".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay11(go.getPerson());
					}
					if ("12".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay12(go.getPerson());
					}
					if ("13".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay13(go.getPerson());
					}
					if ("14".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay14(go.getPerson());
					}
					if ("15".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay15(go.getPerson());
					}
					if ("16".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay16(go.getPerson());
					}
					if ("17".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay17(go.getPerson());
					}
					if ("18".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay18(go.getPerson());
					}
					if ("19".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay19(go.getPerson());
					}
					if ("20".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay20(go.getPerson());
					}
					if ("21".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay21(go.getPerson());
					}
					if ("22".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay22(go.getPerson());
					}
					if ("23".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay23(go.getPerson());
					}
					if ("24".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay24(go.getPerson());
					}
					if ("25".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay25(go.getPerson());
					}
					if ("26".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay26(go.getPerson());
					}
					if ("27".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay27(go.getPerson());
					}
					if ("28".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay28(go.getPerson());
					}
					if ("29".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay29(go.getPerson());
					}
					if ("30".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay30(go.getPerson());
					}
					if ("31".equals(go.getDepartureDate().substring(8, 10))) {
						gg.setDay31(go.getPerson());
					}
				}
			}
		}
		model.addAttribute("page", pbOutLayer);

		return "queries/productTrend/productTrendTables";

	}

}
