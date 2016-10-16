package com.yihg.erp.controller.product;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.product.api.ProductGroupPriceService;
import com.yihg.product.api.ProductGroupSellerService;
import com.yihg.product.api.ProductGroupService;
import com.yihg.product.api.ProductGroupSupplierService;
import com.yihg.product.api.ProductInfoService;
import com.yihg.product.po.ProductGroup;
import com.yihg.product.po.ProductGroupPrice;
import com.yihg.product.po.ProductGroupSeller;
import com.yihg.product.po.ProductGroupSupplier;
import com.yihg.product.po.ProductInfo;
import com.yihg.product.vo.PriceCopyVo;
import com.yihg.supplier.api.ContractService;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.po.PlatformEmployeePo;
/**
 * @author : xuzejun
 * @date : 2015年7月1日 下午3:06:44
 * @Description: 价格设置
 */
@Controller
@RequestMapping(value = "/productInfo/price")
public class ProductPriceController extends BaseController {
	private static final Logger log = LoggerFactory
			.getLogger(ProductPriceController.class);

	@Autowired
	private ProductGroupService productGroupService;
	@Autowired
    private ProductGroupPriceService groupService;
	@Autowired
    private ProductInfoService productInfoService;
	@Autowired
	private PlatformOrgService orgService;
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private ProductGroupSellerService productGroupSellerService;
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月1日 下午3:10:12
	 * @Description: 跳转至价格设置页面
	 */
	@RequestMapping(value = "/list.htm")
	// @RequiresPermissions(PermissionConstants.PRODUCT_PRICE)
	public String toList(HttpServletRequest request,
			HttpServletResponse response,ModelMap model,Integer productId) {
		List<ProductGroup> selectProductGroups = productGroupService.selectProductGroups(productId);
		//查询价格组，计算是否过期
		Date nowdate=new Date(); 
		for (ProductGroup productGroup : selectProductGroups) {
			List<ProductGroupPrice> list = groupService.selectProductGroupPrices(productGroup.getId(), null, null);
			List<String> yflag=new ArrayList<String>();//过期
			List<String> nflag=new ArrayList<String>();//未过期
			for (ProductGroupPrice pList : list) {
				boolean flag = pList.getGroupDateTo().before(nowdate);
				if(flag){//过期
					yflag.add("1");
				}else{//没有过期
					nflag.add("2");
				}
				
			}
			if(yflag.isEmpty()){
				productGroup.setFlag("未过期");
			}
			if(nflag.isEmpty()){
				productGroup.setFlag("已过期");
			}
			if(!yflag.isEmpty()&&!nflag.isEmpty()){
				productGroup.setFlag("部分过期");
			}
				
		}
		ProductInfo productInfo = productInfoService.findProductInfoById(productId);
		
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("orgJsonStr", orgService.getComponentOrgTreeJsonStr(bizId));
		model.addAttribute("orgUserJsonStr", platformEmployeeService.getComponentOrgUserTreeJsonStr(bizId));
		
		model.addAttribute("prouctGroups", selectProductGroups);
		model.addAttribute("productId", productId);
		model.addAttribute("productInfo", productInfo);
		return "product/price/price";
	}
	
	@RequestMapping(value = "/saveObligate.do",method = RequestMethod.POST)
	@ResponseBody
	public String saveObligate(ProductInfo productInfo) {
		if(productInfo!=null && productInfo.getObligate() == null){
			//如果chekbox未选中，设置预留选项为不预留
			productInfo.setObligate(0);
		}
		return productInfoService.updateProductInfo(productInfo)==1?successJson():errorJson("操作失败！");
	}
	
	
	/**
	 * @author : xuzejun
	 * @date : 2015年7月2日 下午3:24:28
	 * @Description: 保存
	 */
	@RequestMapping(value = "/save.do",method = RequestMethod.POST)
	// @RequiresPermissions(PermissionConstants.PRODUCT_PRICE)
	@ResponseBody
	public String save(ProductGroup productGroup) {
		if(productGroup.getGroupSetting()==null){
			productGroup.setGroupSetting(0);
		}
		return productGroupService.save(productGroup)==1?successJson():errorJson("操作失败！");
	}
	

	@ResponseBody
	@RequestMapping("valideteEmpName.do")
	public String valideteMenuName(String name, Integer productId,Integer id){
		return productGroupService.validateName(name,productId,id) == 0 ? "true" : "false";
	}

	@RequestMapping(value = "/copyPrice.htm")
	public String priceCopy(HttpServletRequest request,ModelMap model,Integer groupId){
		String startTime = DateUtils.getMonthFirstDay();
		String endTime = DateUtils.getMonthLastDay();
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, 1);
		int month = c.get(Calendar.MONTH)+1;
		String destTime = c.get(Calendar.YEAR)+"-"+ (month<10 ? "0"+month:month);
		
		model.addAttribute("startTime", startTime);
		model.addAttribute("endTime", endTime);
		model.addAttribute("destTime", destTime);
		model.addAttribute("groupId", groupId);
		return "/product/price/price_copy";
	}
	
	@RequestMapping(value = "/saveCopy.do",method=RequestMethod.POST)
	@ResponseBody
	public String saveCopy(HttpServletRequest request,PriceCopyVo copyVo){
		if(copyVo.getGroupId()==null){
			return errorJson("groupId为空");
		}
		if(copyVo.getStartTime()==null || copyVo.getEndTime()==null){
			return errorJson("时间范围为空");
		}
		if(copyVo.getDestYear()==null || copyVo.getDestMonth()==null){
			return errorJson("目标年月份为空");
		}
		int result = groupService.copyGroupPrice(copyVo);
		if(result==0){
			return successJson("日期范围内的数据为空");
		}		
		return successJson();
	}
	
	
	@RequestMapping(value = "/group_seller_list.htm")
	public String toList(HttpServletRequest request,ModelMap model,Integer groupId,Integer productId) {
		Integer bizId = WebUtils.getCurBizId(request);
		model.addAttribute("productId", productId);
		model.addAttribute("groupId", groupId);
		model.addAttribute("groupSuppliers", productGroupSellerService.selectGroupSellerList(bizId,groupId,productId));
		return "product/price/seller_list";
	}
	
	@RequestMapping(value = "/expSellers.htm")
	@ResponseBody
	public String expSellers(HttpServletRequest request,ModelMap model,Integer productId){
		Integer bizId = WebUtils.getCurBizId(request);
		String ids = productGroupSellerService.selectExpSellersByProductId(bizId, productId);
		return successJson("result",ids);
	}
	
	
	@RequestMapping(value = "/saveSeller.do",method=RequestMethod.POST)
	@ResponseBody
	public String saveSeller(HttpServletRequest request,String ids,Integer groupId,Integer productId){
		Integer bizId = WebUtils.getCurBizId(request);
		String str[] =ids.split(",");
		for (String id : str) {
			ProductGroupSeller productGroupSeller = productGroupSellerService.selectGroupSeller(bizId,productId,Integer.parseInt(id));
			if(null==productGroupSeller){
				PlatformEmployeePo platformEmployeePo = platformEmployeeService.findByEmployeeId(Integer.parseInt(id));
				ProductGroupSeller p =new ProductGroupSeller();
				p.setBizId(bizId);
				p.setProductId(productId);
				p.setGroupId(groupId);
				p.setOperatorId(Integer.parseInt(id));
				p.setOperatorName(platformEmployeePo.getName());
				p.setCreateTime(System.currentTimeMillis());
				productGroupSellerService.insertSelective(p);
			}
		}
		return successJson();
	}
	
	@RequestMapping(value = "/delSeller.do",method=RequestMethod.POST)
	@ResponseBody
	public String delSeller(HttpServletRequest request,Integer id){
		return productGroupSellerService.delSeller(id)==1?successJson():errorJson("操作失败！");
	}
	
	@RequestMapping("addPriceGroup.htm")
	public String addPriceGroup(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer groupId){
		List<ProductGroupPrice> productGroupPrices = groupService.selectPriceByGroupId(groupId);
		model.addAttribute("productGroupPrices", productGroupPrices);
		return  "product/price/priceAdd";
		
	}
	
	@RequestMapping(value = "/savePriceGroup.do",method=RequestMethod.POST)
	@ResponseBody
	public String savePriceGroup(HttpServletRequest request, HttpServletResponse reponse, String json){
		Integer bizId = WebUtils.getCurBizId(request);
		try{
			 groupService.batchInsertPriceGroup(bizId,json);
			return successJson();
		}catch(Exception e){
			e.printStackTrace();
			return errorJson("操作失败");
		}	
	}
	
}
