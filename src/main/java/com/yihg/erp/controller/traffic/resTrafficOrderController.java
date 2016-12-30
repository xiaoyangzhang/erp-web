package com.yihg.erp.controller.traffic;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.facade.sales.query.grouporder.ToNotGroupListDTO;
import com.yimayhd.erpcenter.facade.sales.result.grouporder.ToNotGroupListResult;
import com.yimayhd.erpcenter.facade.sales.service.GroupOrderFacade;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.SheetUtil;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.yihg.erp.utils.DateUtils;

import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.tj.client.query.LockListTableDTO;
import com.yimayhd.erpcenter.facade.tj.client.query.TrafficOrderDTO;
import com.yimayhd.erpcenter.facade.tj.client.result.AdminOrderListTableResult;
import com.yimayhd.erpcenter.facade.tj.client.result.LockListTableResult;
import com.yimayhd.erpcenter.facade.tj.client.service.ResTrafficOrderFacade;

@Controller
@RequestMapping("/resOrder")
public class resTrafficOrderController extends BaseController{
	
	@Autowired
	private BizSettingCommon settingCommon;
	
	@Autowired
	private ResTrafficOrderFacade resTrafficOrderFacade;

	@Autowired
	private GroupOrderFacade groupOrderFacade;
	
	@RequestMapping("resGroupOrderList.htm")
	public String loadGroupOrderInfo(HttpServletRequest request, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandProductList = resTrafficOrderFacade.loadGroupOrderInfo(bizId);
		model.addAttribute("brandProductList", brandProductList);
		return "resTraffic/resGroupOrderList";
	}
	
	/**
	 * 订单数据展示Table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "loadResGroupOrderInfo.do")
	public String lockListTable(HttpServletRequest request, ModelMap model,Integer pageSize, Integer page){
		LockListTableDTO lockListTableDTO = new LockListTableDTO();
		lockListTableDTO.setBizId(WebUtils.getCurBizId(request));
		lockListTableDTO.setPage(page);
		lockListTableDTO.setPageSize(pageSize);
		lockListTableDTO.setPmBean(WebUtils.getQueryParamters(request));
		lockListTableDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		LockListTableResult result = resTrafficOrderFacade.lockListTable(lockListTableDTO);
		model.addAttribute("sum",result.getSumGroupOrder());
		model.addAttribute("pageBean", result.getPageBean());
		return "resTraffic/resGroupOrderTable";
	}
	
	/**
	 * 取消订单信息
	 * @param request
	 * @param id 订单Id
	 * @param model
	 */
	@RequestMapping("toCancelOrder.do")
	public String cancelGroupOrderInfo(HttpServletRequest request,Integer id, ModelMap model){
		model.addAttribute("id", id);
		return "resTraffic/resCancelOrder";
	}
	
	@RequestMapping("toUpdateProductPrice.do")
	@ResponseBody
	public String toUpdateProductPrice(HttpServletRequest request,String id,String causeRemark, ModelMap model) throws ParseException{
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO(); 
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setCauseRemark(causeRemark);
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setUserId(WebUtils.getCurUserId(request));
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		trafficOrderDTO.setMyBizCode(settingCommon.getMyBizCode(request));
		String result = resTrafficOrderFacade.toUpdateProductPrice(trafficOrderDTO);
		return result;
	}
	
	/**
	 * 管理员端订单列表页面跳转
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("resAdminOrderList.htm")
	public String loadAdminOrderInfo(HttpServletRequest request, ModelMap model){
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> brandProductList = resTrafficOrderFacade.loadAdminOrderInfo(bizId);
		model.addAttribute("brandProductList", brandProductList);
		return "resTraffic/resAdminOrderList";
	}
	
	/**
	 * 订单数据展示Table
	 * @param request
	 * @param model
	 * @param pageSize
	 * @param page
	 * @return
	 */
	@RequestMapping(value = "loadResAdmOrderInfo.do")
	public String adminOrderListTable(HttpServletRequest request, ModelMap model,Integer pageSize, Integer page){
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO();
		trafficOrderDTO.setPage(page);
		trafficOrderDTO.setPageSize(pageSize);
		trafficOrderDTO.setPm(WebUtils.getQueryParamters(request));
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setDataUserIdSet(WebUtils.getDataUserIdSet(request));
		AdminOrderListTableResult result = resTrafficOrderFacade.adminOrderListTable(trafficOrderDTO);
		model.addAttribute("sum",result.getSumResAdminOrder());
		model.addAttribute("pageBean", result.getPageBean());
		//权限分配
		UserSession user = WebUtils.getCurrentUserSession(request);
		Map<String,Boolean> optMap = user.getOptMap();
		String menuCode = PermissionConstants.TRAFFICRES;
		model.addAttribute("optMap_EDIT", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.TRAFFICRES_EDIT)));
		model.addAttribute("optMap_PAY", optMap.containsKey(menuCode.concat("_").concat(PermissionConstants.TRAFFICRES_PAY)));
		return "resTraffic/resAdminOrderTable";
	}
	
	/**
	 * 管理员取消订单信息
	 * @param request
	 * @param id 订单Id
	 * @param model
	 */
	@RequestMapping("toAdminCancelOrder.do")
	public String cancelAdminOrderInfo(HttpServletRequest request,Integer id, ModelMap model){
		model.addAttribute("orderId", id);
		return "resTraffic/resAdminCancelOrder";
	}
	
	/**
	 * 取消订单，更新操作
	 * @param request
	 * @param id
	 * @param causeRemark
	 * @param model
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping("toUpdateAdminExtResState.do")
	@ResponseBody
	public String toUpdateAdminExtResState(HttpServletRequest request,String id,String causeRemark, ModelMap model) throws ParseException{
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO(); 
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setCauseRemark(causeRemark);
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setUserId(WebUtils.getCurUserId(request));
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		trafficOrderDTO.setMyBizCode(settingCommon.getMyBizCode(request));
		String result = resTrafficOrderFacade.toUpdateAdminExtResState(trafficOrderDTO);
		return result;
		
	}
	
	/**
	 * 跳转至状态修改页面
	 * @param request
	 * @param model
	 * @param id
	 * @param resId
	 * @return
	 */
	@RequestMapping(value = "/toUpdateOrderState.htm")
	public String toUpdateOrderState(HttpServletRequest request ,ModelMap model ,String id, Integer resId){
		//将选中的id传入页面
		GroupOrder orderBean = resTrafficOrderFacade.toUpdateOrderState(id);
		model.addAttribute("totalCash", orderBean.getTotalCash());
		model.addAttribute("extResPrepay", orderBean.getExtResPrepay());
		model.addAttribute("id", id);
		model.addAttribute("extResState", orderBean.getExtResState());
		return "resTraffic/resUpdateOrderState";
	}
	
	/**
	 * 保存修改的订单状态
	 * @param request
	 * @param model
	 * @param id
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping("toUpdateExtResState.do")
	@ResponseBody
	public String toUpdateExtResState(HttpServletRequest request ,ModelMap model,String id,String extResState) throws ParseException{
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO(); 
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setExtResState(extResState);
		trafficOrderDTO.setBizId(WebUtils.getCurBizId(request));
		trafficOrderDTO.setUserId(WebUtils.getCurUserId(request));
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		trafficOrderDTO.setMyBizCode(settingCommon.getMyBizCode(request));
		String result = resTrafficOrderFacade.toUpdateExtResState(trafficOrderDTO);
		return result;
	}
	
	@RequestMapping("toDeleteOrderInfo.do")
	@ResponseBody
	public String toDeleteOrderInfo(HttpServletRequest request ,ModelMap model,String id){
		TrafficOrderDTO trafficOrderDTO = new TrafficOrderDTO();
		trafficOrderDTO.setId(id);
		trafficOrderDTO.setCurUser(WebUtils.getCurUser(request));
		String result = resTrafficOrderFacade.toDeleteOrderInfo(trafficOrderDTO);
		return result;
	}


	/**
	 * 订单管理导出到excel
	 * @param request
	 * @param response
	 * @param model
	 * @throws ParseException
	 */
	@RequestMapping(value = "toResAdminOrderExcel.htm")
	public void toOrderPreview(HttpServletRequest request, HttpServletResponse response, Integer pageSize, Integer page,Model model)
			throws ParseException {

		ToNotGroupListDTO var1 = new ToNotGroupListDTO();
		var1.setPmBean( WebUtils.getQueryParamters(request));
		var1.setBizId(WebUtils.getCurBizId(request));
		var1.setUserIdSet(WebUtils.getDataUserIdSet(request));
		ToNotGroupListResult toNotGroupListResult = groupOrderFacade.toOrderPreview(var1);
		PageBean<GroupOrder> pageBean = toNotGroupListResult.getPageBean();
		HashMap<String, BigDecimal> map_sum = toNotGroupListResult.getMap_sum();

				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String path = "";
		try {
			String url = request.getSession().getServletContext().getRealPath("/template/excel/trafficOrderManageList.xlsx");
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
			//Iterator<GroupOrder> it = pageBean.getResult().iterator();

			int index = 0;
			DecimalFormat df = new DecimalFormat("0.##");
			if (pageBean.getResult() != null && pageBean.getResult().size() > 0) {
				for (GroupOrder goBean: pageBean.getResult()) {

					//GroupOrder go = it.next();

					row = sheet.createRow(index + 2);
					cc = row.createCell(0);
					cc.setCellValue(index + 1);
					cc.setCellStyle(cellStyle);

					cc = row.createCell(1);
					cc.setCellValue(goBean.getOrderNo());//订单号
					cc.setCellStyle(styleLeft);


					if(goBean.getRemarkInternal() != ""){
						cc = row.createCell(2);
						cc.setCellValue("【"+goBean.getProductBrandName()+"】"+goBean.getProductName()+goBean.getRemarkInternal());//产品名称
						cc.setCellStyle(styleLeft);
					}else{
						cc = row.createCell(2);
						cc.setCellValue("【"+goBean.getProductBrandName()+"】"+goBean.getProductName());//产品名称
						cc.setCellStyle(styleLeft);
					}

					cc = row.createCell(3);
					cc.setCellValue(goBean.getDepartureDate());//出团日期
					cc.setCellStyle(cellStyle);


					if(goBean.getExtResState()==1){
						cc = row.createCell(4);
						cc.setCellValue("");//预留
						cc.setCellStyle(cellStyle);
					}else {
						if(goBean.getType()==1){
							cc = row.createCell(4);
							cc.setCellValue("");//预留
							cc.setCellStyle(cellStyle);
						}else {
							cc = row.createCell(4);
							cc.setCellValue("是");//预留
							cc.setCellStyle(cellStyle);
						}
					}

					cc = row.createCell(5);
					cc.setCellValue(goBean.getSupplierName()+"-"+goBean.getCreatorName());//组团社
					cc.setCellStyle(styleLeft);

					cc = row.createCell(6);
					cc.setCellValue(goBean.getReceiveMode());//接站牌
					cc.setCellStyle(styleLeft);

					cc = row.createCell(7);
					cc.setCellValue(goBean.getNumAdult()+"+"+goBean.getNumChild()+"+"+goBean.getNumChildBaby());//人数
					cc.setCellStyle(cellStyle);

					cc = row.createCell(8);
					cc.setCellValue(df.format(goBean.getTotal()));//金额
					cc.setCellStyle(cellStyle);

					cc = row.createCell(9);
					cc.setCellValue(df.format(goBean.getExtResPrepay()));//定金
					cc.setCellStyle(cellStyle);

					cc = row.createCell(10);
					cc.setCellValue(df.format(goBean.getTotalCash()));//已付
					cc.setCellStyle(cellStyle);

					cc = row.createCell(11);
					cc.setCellValue(df.format(goBean.getTotal().subtract(goBean.getTotalCash())));//尾款
					cc.setCellStyle(cellStyle);
					index++;
				}

				//添加合计行  map_sum
				BigDecimal allTotal = new BigDecimal(0);
				BigDecimal allExtResPrepay = new BigDecimal(0);
				BigDecimal allTotalCash = new BigDecimal(0);
				BigDecimal allTotalSubtractTotalCash = new BigDecimal(0);


				if (null != map_sum) {
					if (null != map_sum.get("total")) {
						allTotal = new BigDecimal(map_sum.get("total").toString());
					}
					if (null != map_sum.get("extResPrepay")) {
						allExtResPrepay = new BigDecimal(map_sum.get("extResPrepay").toString());
					}
					if (null != map_sum.get("totalCash")) {
						allTotalCash = new BigDecimal(map_sum.get("totalCash").toString());
					}
					if (null != map_sum.get("total") && null != map_sum.get("totalCash")) {
						allTotalSubtractTotalCash = allTotal.subtract(allTotalCash);
					}
				}
				row = sheet.createRow(index + 2); // 加合计行
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
				cc.setCellValue("合计");
				cc.setCellStyle(styleRight);

				cc = row.createCell(7);
				cc.setCellValue(map_sum.get("numAdult")+"+"+map_sum.get("numChild")+"+"+map_sum.get("numChildBaby"));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(8);
				cc.setCellValue(df.format(allTotal));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(9);
				cc.setCellValue(df.format(allExtResPrepay));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(10);
				cc.setCellValue(df.format(allTotalCash));
				cc.setCellStyle(cellStyle);

				cc = row.createCell(11);
				cc.setCellValue(df.format(allTotalSubtractTotalCash));
				cc.setCellStyle(cellStyle);


			}
			CellRangeAddress region = new CellRangeAddress(pageBean.getResult().size() + 5,
					pageBean.getResult().size() + 5, 0, 10);
			sheet.addMergedRegion(region);

			row = sheet.createRow(pageBean.getResult().size() + 5);
			cc = row.createCell(0);
			cc.setCellValue("打印人：" + WebUtils.getCurUser(request).getName()
					+ " 打印时间："
					+ DateUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss"));
			path = request.getSession().getServletContext().getRealPath("/") + "/download/" + System.currentTimeMillis()
					+ ".xlsx";
			FileOutputStream out = new FileOutputStream(path);
			wb.write(out);
			out.close();
			wb.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		String fileName = "";
		try {
			fileName = new String("订单信息.xlsx".getBytes("UTF-8"), "iso-8859-1");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		download(path, fileName, request, response);

	}

	private void download(String path, String fileName, HttpServletRequest request, HttpServletResponse response) {
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
			response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
			response.setContentType("application/vnd.ms-excel;charset=gb2312");
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
			file.delete();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
