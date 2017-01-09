package com.yihg.erp.controller.component;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.erpcenterFacade.common.client.query.BrandQueryDTO;
import org.erpcenterFacade.common.client.result.BrandQueryResult;
import org.erpcenterFacade.common.client.result.CheckProductStockResult;
import org.erpcenterFacade.common.client.result.RegionResult;
import org.erpcenterFacade.common.client.result.ResultSupport;
import org.erpcenterFacade.common.client.service.ComponentFacade;
import org.erpcenterFacade.common.client.service.ProductCommonFacade;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.TfsUpload;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductGroupSupplier;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.product.vo.ProductSupplierCondition;
import com.yimayhd.erpcenter.dal.sys.po.PlatformOrgPo;
import com.yimayhd.erpcenter.facade.basic.service.DicFacade;
import com.yimayhd.erpcenter.facade.query.ComponentProductListDTO;
import com.yimayhd.erpcenter.facade.result.ComponentProductListResult;
import com.yimayhd.erpcenter.facade.sales.result.ContactManListResult;
import com.yimayhd.erpcenter.facade.sales.service.TeamGroupFacade;
import com.yimayhd.erpcenter.facade.service.ProductFacade;
import com.yimayhd.erpresource.dal.constants.SupplierConstant;
import com.yimayhd.erpresource.dal.po.SupplierDriver;
import com.yimayhd.erpresource.dal.po.SupplierInfo;

@Controller
@RequestMapping("/component")
public class ComponentController extends BaseController {
	
	private static final Logger log = LoggerFactory
			.getLogger(ComponentController.class);
	
	@Autowired
	private SysConfig config;
	@Autowired
	private DicFacade dicFacade;
	@Autowired
	private ProductCommonFacade productCommonFacade;
	@Autowired
	private ProductFacade productFacade;
	@Autowired
	private TeamGroupFacade teamGroupFacade;
	@Autowired
	private ComponentFacade componentFacade; 
	
	@RequestMapping("example.htm")
	public String example(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,String type){	
		return "component/componentExample";
	}

	/**
	 * 下载网络文件
	 * @param request
	 * @param response
	 * @param path
	 * @param name
	 * @return
	 */
	@RequestMapping("download.htm")
	@ResponseBody
	public String download(HttpServletRequest request,HttpServletResponse response,String path,String name){
		try{
			URL url = new URL(path);  
	        //打开链接  
	        HttpURLConnection conn = (HttpURLConnection)url.openConnection();  
	        //设置请求方式为"GET"  
	        conn.setRequestMethod("GET");  
	        //超时响应时间为5秒  
	        conn.setConnectTimeout(5 * 1000);  
	        //通过输入流获取图片数据  
	        InputStream is = conn.getInputStream();
	        
	        response.setCharacterEncoding("utf-8");
			//response.setContentType("application/msword"); // word格式
	        //设置响应头，控制浏览器下载该文件
	        //response.setHeader("content-disposition", "attachment;filename=" + URLDecoder.decode(name, "UTF-8"));
	        response.setHeader("content-disposition", "attachment;filename="+new String(name.getBytes("utf-8"), "ISO-8859-1"));
			// 创建输出流
			OutputStream out = response.getOutputStream();
			// 创建缓冲区
			byte buffer[] = new byte[1024];
			int len = 0;
			// 循环将输入流中的内容读取到缓冲区当中
			while ((len = is.read(buffer)) > 0) {
				// 输出缓冲区的内容到浏览器，实现文件下载
				out.write(buffer, 0, len);
			}
			// 关闭文件输入流
			is.close();
			// 关闭输出流
			out.close();
		}catch(FileNotFoundException ex){			
			ex.printStackTrace();
			return "文件不存在";
		} catch (IOException e) {
			e.printStackTrace();
			return "出现错误";
		}
		return null;
	}

	
	/**
	 * 选择人员页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param type 单选 single 多选multi
	 * @return
	 */
	@RequestMapping("orgUserTree.htm")
	public String orgUserTree(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,String type,String expIds){	
		if(StringUtils.isBlank(type)){
			type = "single";
		}
		List<Map<String, String>> result = productCommonFacade.orgUserTree(WebUtils.getCurBizId(request), type);
		model.addAttribute("orgUserJsonStr", JSON.toJSONString(result));
		model.addAttribute("expIds", expIds);		
		if(type.equals("single")){
			return "component/user/user_tree_single";
		}else{
			return "component/user/user_tree_multi";
		}
	}
	
	@RequestMapping(value="orgUserTree.do",method=RequestMethod.POST)
	@ResponseBody
	public String queryOrgUserTree(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,String type,String name){	
		List<Map<String, String>> list = productCommonFacade.queryOrgUserTree(WebUtils.getCurBizId(request),name,type);
		return successJson("orgUserJsonStr",JSON.toJSONString(list));
	}
	
	@RequestMapping("orgTree.htm")
	public String orgTree(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,String type,String orgId){	
		if(StringUtils.isBlank(type)){
			type = "single";
		}
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();		
		List<PlatformOrgPo> orgList = componentFacade.getOrgTree(WebUtils.getCurBizId(request), null);
		if(orgList!=null && orgList.size()>0){
			for(PlatformOrgPo org : orgList){
				Map<String, String> map = new HashMap<String,String>();
				map.put("id", org.getOrgId()+"");
				map.put("pId", org.getParentId() +"");
				map.put("name", org.getName());
				if(org.getParentId()==0){
					map.put("open", "true");
				}
				list.add(map);
			}			
		}
				
		model.addAttribute("orgJsonStr", JSON.toJSONString(list));
		if(type.equals("single")){
			return "component/user/org_tree_single";
		}else{
			return "component/user/org_tree_multi";
		}
	}
	
	@RequestMapping("supplierList.htm")
	public String supplierList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,SupplierInfo supplierInfo,String type){

		String canEditPrice = WebUtils.getBizConfigValue(request, "SUPPLIER_CHOOSE");
		Integer orgId =  WebUtils.getCurUser(request).getOrgId();
		if(canEditPrice !=null && supplierInfo.getSupplierType() != null && supplierInfo.getSupplierType()==1  && canEditPrice.equals("1")) {
			supplierInfo.setChooseType(1);
			String supplierIds = componentFacade.setSupplierIds(orgId);
			supplierInfo.setSupplierIds(supplierIds);
		}
		RegionResult provinceResult = productCommonFacade.queryProvinces();
		List<RegionInfo> allProvince = provinceResult.getRegionList();
		model.addAttribute("allProvince", allProvince);
		// 根据供应商类型查询当前登录商家所属的供应商
		PageBean pageBean = componentFacade.supplierList(WebUtils.getCurBizId(request), supplierInfo);
		model.addAttribute("supplierInfo", supplierInfo);
		model.addAttribute("page", pageBean);
		Map<Integer,String> typeMap = null;
		//过滤显示供应商类型
		if(StringUtils.isNotBlank(supplierInfo.getStypes())){
			typeMap = new HashMap<Integer,String>();
			String[] typeArr = supplierInfo.getStypes().split(",");
			if(typeArr.length>0){
				Map<Integer,String> tempMap = SupplierConstant.supplierTypeMap;
				for(String typeStr : typeArr){
					 int typeInt = NumberUtils.toInt(typeStr, 0);
					 if(tempMap.containsKey(typeInt)){
						 typeMap.put(typeInt,tempMap.get(typeInt));
					 }
				}
			}			
		}else{
			typeMap =  SupplierConstant.supplierTypeMap;
		}
		model.addAttribute("typeMap", typeMap);
		if(StringUtils.isBlank(type)){
			type = "single";
		}		
		model.addAttribute("type", type);	
		if(type.equals("single")){
			return "component/supplier/supplier-list-single";			
		}else{
			return "component/supplier/supplier-list-multi";
		}
	}
	
	@RequestMapping(value="supplierList.do",method=RequestMethod.POST)
	public String querySupplierList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,
			SupplierInfo supplierInfo,String type){
		// 根据供应商类型查询当前登录商家所属的供应商
		model.addAttribute("supplierInfo", supplierInfo);
		model.addAttribute("typeMap", SupplierConstant.supplierTypeMap);
		PageBean pageBean = componentFacade.supplierList(WebUtils.getCurBizId(request), supplierInfo);
		model.addAttribute("page", pageBean);
		if(StringUtils.isBlank(type)){
			type = "single";
		}	
		if(type.equals("single")){
			return "component/supplier/supplier-list-table-single";			
		}else{
			return "component/supplier/supplier-list-table-multi";	
		}
	}
	
	@RequestMapping("contactMan.htm")
	public String contactManList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,
			String supplierId){
		Integer id = 0;
		if(StringUtils.isNotBlank(supplierId)){
			id = NumberUtils.toInt(supplierId, 0);
		}
		/*List<SupplierContactMan> list = supplierService
				.selectPrivateManBySupplierId(WebUtils.getCurBizId(request), id);*/
		Integer curBizId = WebUtils.getCurBizId(request);
		ContactManListResult contactManListResult = teamGroupFacade.contactManList(curBizId, id);
		model.addAttribute("manList", contactManListResult.getManList());
		model.addAttribute("supplierId", id);		
		return "component/supplier/contact-man-list-single";
	}
	
	@RequestMapping("cardRegionList.htm")
	public String idCardRegionList(HttpServletRequest request,HttpServletResponse reponse, ModelMap model,
			String level){
		String json = "";
		if(StringUtils.isBlank(level)){
			level = "1";
		}
		/*if("1".equals(level)){
			json = JSON.toJSONString(cardService.getFirstList());
		}else if("2".equals(level)){
			json = JSON.toJSONString(cardService.getSecondList());
		}else if("3".equals(level)){
			json = JSON.toJSONString(cardService.getThirdList());
		}*/
		model.addAttribute("json",json);
		return "component/cardregion/card-region-list";
	}
	
	@RequestMapping(value = "driverList.htm", method = RequestMethod.GET)
	public String bizDriverList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,SupplierDriver driver, Integer supplierId, Integer page,Integer pageSize){
		RegionResult result = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", result.getRegionList());
		
		//loadMyDriverList(request, model, driver,page, pageSize, supplierId);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("images_source", config.getImages200Url());
		return "component/driver/driver-list";
	}
	
	@RequestMapping(value = "queryListPage.htm")
	public String queryListPage(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,SupplierDriver driver, Integer supplierId, Integer page,Integer pageSize){
		RegionResult result = productCommonFacade.queryProvinces();
		model.addAttribute("allProvince", result.getRegionList());
		
		loadMyDriverList(request, model, driver,page, pageSize, supplierId);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("images_source", config.getImages200Url());
		return "component/driver/driver-list-table";
	}
	
	@RequestMapping(value = "driverList.do",method=RequestMethod.POST)
	public String queryBizDriverList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,SupplierDriver driver, Integer supplierId, Integer page,Integer pageSize){
		loadMyDriverList(request, model, driver, page,pageSize, supplierId);
		model.addAttribute("supplierId", supplierId);
		model.addAttribute("images_source", config.getImages200Url());
		return "component/driver/driver-list-table";
	}
	
	
	private void loadMyDriverList(HttpServletRequest request, ModelMap model, SupplierDriver driver, Integer page, Integer pageSize, Integer supplierId) {
		if(page==null){
			page = 1;
		}
		if(pageSize==null){
			pageSize = 10;
		}
		
		Integer bizId = WebUtils.getCurBizId(request);
		PageBean pageBean = componentFacade.getMyDriverList(driver, bizId, supplierId, page, pageSize);
		model.addAttribute("pageBean", pageBean);
		
	}
	
	private static final String apiIdServiceUrl = "http://apis.baidu.com/apistore/idservice/id";
	
	@RequestMapping(value = "idCard.jsn",method=RequestMethod.GET)
	@ResponseBody
	public String idCard(HttpServletRequest request,HttpServletResponse reponse,String id,String apiKey){
		BufferedReader reader = null;
	    String result = null;
	    StringBuffer sbf = new StringBuffer();
	    String httpUrl = apiIdServiceUrl + "?id=" + id;

	    try {
	        URL url = new URL(httpUrl);
	        HttpURLConnection connection = (HttpURLConnection) url
	                .openConnection();
	        connection.setRequestMethod("GET");
	        // 填入apikey到HTTP header
	        connection.setRequestProperty("apikey", apiKey);
	        connection.connect();
	        InputStream is = connection.getInputStream();
	        reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
	        String strRead = null;
	        while ((strRead = reader.readLine()) != null) {
	            sbf.append(strRead);
	        }
	        reader.close();
	        result = sbf.toString();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}
	
	@RequestMapping(value="resetProductRight.do",method=RequestMethod.POST)
	public String resetProductRight(HttpServletRequest request){
		return successJson();
	}
	/**
	 * 复制组团社到其他产品时，弹出的产品选择页面
	 * @param request
	 * @param response
	 * @param model
	 * @return 产品选择页面
	 */
	@RequestMapping("productList.htm")
	public String productList(HttpServletRequest request,HttpServletResponse response,ModelMap model,ProductInfo productInfo){
		 //省市
        //List<RegionInfo> allProvince = regionService.getAllProvince();
        //产品名称
		
		Integer bizId = WebUtils.getCurBizId(request);
		BrandQueryDTO brandQueryDTO = new BrandQueryDTO();
		brandQueryDTO.setBizId(bizId);
		
        BrandQueryResult brandResult = productCommonFacade.brandQuery(brandQueryDTO);;
        List<com.yimayhd.erpcenter.dal.basic.po.DicInfo> brandList = brandResult.getBrandList();
        
       //model.addAttribute("allProvince",allProvince);
        model.addAttribute("brandList", brandList);
        model.addAttribute("state", productInfo.getState());
        model.addAttribute("productId", productInfo.getId());
		return "component/product/product-list-single";
		
	}
	@RequestMapping("productList.do")
	public String productQueryList(HttpServletRequest request,HttpServletResponse response,ModelMap model,ProductInfo productInfo,String productName, Integer page,Integer pageSize){
		
		ComponentProductListDTO componentProductListDTO = new ComponentProductListDTO();
		com.yimayhd.erpcenter.dal.product.po.ProductInfo info = new com.yimayhd.erpcenter.dal.product.po.ProductInfo();
		org.springframework.beans.BeanUtils.copyProperties(productInfo, info);
		info.setBizId(WebUtils.getCurBizId(request));
		componentProductListDTO.setProductInfo(info);
		
		componentProductListDTO.setName(null);
		componentProductListDTO.setProductName(productName);
		componentProductListDTO.setOrgId(WebUtils.getCurUser(request).getOrgId());
		componentProductListDTO.setSet(WebUtils.getDataUserIdSet(request));
		ComponentProductListResult result = productFacade.componentProductQueryList(componentProductListDTO);
		
		model.addAttribute("page", result.getPage());
		model.addAttribute("pageNum", result.getPageNum());
		return "component/product/product-list-single-table";
	}
	
	@RequestMapping(value="/productSupplierList.htm")
	public String productSupplierList(ModelMap model,ProductSupplierCondition condition){
		model.addAttribute("condition", condition);
		return "component/product/product-supplier-list";
	}
	
	@RequestMapping(value="/productSupplierList.do",method=RequestMethod.POST)
	public String productSupplierQueryList(HttpServletRequest request,HttpServletResponse response,ModelMap model,ProductSupplierCondition condition){
		List<ProductGroupSupplier> supplierList = componentFacade.selectSupplierList(condition);
		model.addAttribute("list", supplierList);
		model.addAttribute("single", condition.getSingle());
		return "component/product/product-supplier-list-table";
	}
	
	@Autowired
	private TfsUpload tfsUpload;
	
	@RequestMapping(value="/upload.htm",method=RequestMethod.GET)
	
	public String upload(){
		String tfsName = null;
		try {
			tfsName = tfsUpload.uploadLocal("E:/tfs/ezmgvFYDZOeAQOJHAAHHr59E0N4114.jpg");
		} catch (Exception e) {
			e.printStackTrace();
			return errorJson("文件上传失败");
		}
		return successJson("tfsName",tfsName);
	}
	@RequestMapping("updateRegion.do")
	
	@ResponseBody
	public String updateRegion(HttpServletRequest request){
	  	ResultSupport result = componentFacade.uploadRegion();
	  	if(result.isSuccess()){
	  		return successJson();
	  	}
	  	return errorJson("刷新失败");
	}

	@RequestMapping(value="/uploadAllImg.htm",method=RequestMethod.GET)
	@ResponseBody
	public String uploadAllImg(HttpServletRequest request,HttpServletResponse response,ModelMap model) throws Exception{
		/*response.setContentType("text/html;charset=utf-8");
		response.getWriter().write("use yihg_erp_basic;\n");
		response.flushBuffer();

		String path="E:/tfs/";
		File file=new File(path);
		File[] tempList = file.listFiles();
		
		
		for(File f: tempList){
			// upload to tfs
			String tfsName = "";
			System.out.println("E:/tfs/" + f.getName());
			tfsName = tfsUpload.uploadLocal("E:/tfs/" + f.getName());

			String sql = "update img_space set new_file_name=\""+ tfsName + "\" where file_path like \""+ f.getName()+"\";\n";
			System.out.println(sql);
			f.delete();
			response.getWriter().write(sql);
			response.flushBuffer();
		}*/
		return "";
	}
	
	@RequestMapping(value="/checkProductStock.htm",method=RequestMethod.GET)
	@ResponseBody
	public String checkProductStock(HttpServletRequest request,Integer year,Integer month){
		
		Integer bizId = WebUtils.getCurBizId(request);
		CheckProductStockResult result = componentFacade.checkProductStock(bizId, year, month);
    	return successJson("结果：", result.getSb(), "更新sql:", result.getSqlSb());
    	
	}
	
	@RequestMapping("initContractLog.htm")	
	@ResponseBody
	public String initContractLog(HttpServletRequest request){
		//List<SupplierContract> list = contractService.getAll();
		long start = new Date().getTime();
		/*if(list!=null){
			Integer bizId = WebUtils.getCurBizId(request);
			PlatformEmployeePo user = WebUtils.getCurUser(request);
			
			for(SupplierContract contract : list){
				if(contract.getShopSupplierId()<0){
					SupplierContractVo supplierContractVo = contractService.findFleetContract(0-contract.getShopSupplierId(), contract.getId());
					logService.addOptLog(LogOptType.INIT.toString(),LogTypeEnum.FLEET_CONTRACT.toString(), user.getEmployeeId(), user.getName(), contract.getId().toString(), JSON.toJSONString(supplierContractVo));
				}else{
					BizSupplierRelation relation = relationService.getById(contract.getShopSupplierId());
					if(relation!=null){
						SupplierContractVo supplierContractVo = contractService.findContract(bizId, relation.getSupplierId(), contract.getId());
						logService.addOptLog(LogOptType.INIT.toString(),LogTypeEnum.CONTRACT.toString(), user.getEmployeeId(), user.getName(), contract.getId().toString(), JSON.toJSONString(supplierContractVo));
					}
				}
			}
		}*/
		long end = new Date().getTime();
		return successJson("时间",String.valueOf(end-start));
	}
	
	@RequestMapping("dicItemDlg.htm")
	public String dicItemTree(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,String typeCode, String checkIds){	
		if(StringUtils.isBlank(typeCode)){
			typeCode = "ouZongYing";
		}
		Integer bizId = WebUtils.getCurBizId(request);
		List<DicInfo> typeList = dicFacade.getListByTypeCode(typeCode, bizId);
		
		List<Map<String,String>> mapList = new ArrayList<Map<String,String>>();
		Map<String,String> map = null;
		for(DicInfo item:typeList){
			map = new HashMap<String,String>();
			map.put("id", item.getId().toString());
			map.put("pId","0");
			map.put("name", item.getValue());
			mapList.add(map);
		}
		

		model.addAttribute("dicJSON", JSON.toJSONString(mapList));
		model.addAttribute("checkIds", checkIds);
		
		return "component/comm/dicItemDlg";
	}

}
