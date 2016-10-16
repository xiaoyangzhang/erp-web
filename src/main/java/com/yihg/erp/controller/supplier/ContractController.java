package com.yihg.erp.controller.supplier;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.yihg.basic.api.RegionService;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.utils.SysConfig;
import com.yihg.supplier.api.SupplierService;

import org.apache.commons.lang.StringUtils;
import org.apache.http.impl.cookie.DateUtils;
import org.apache.tools.ant.taskdefs.Input;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.supplier.api.BizSupplierRelationService;
import com.yihg.supplier.api.ContractService;
import com.yihg.supplier.api.SupplierItemService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.constants.SupplierConstant;
import com.yihg.supplier.po.BizSupplierRelation;
import com.yihg.supplier.po.SupplierContract;
import com.yihg.supplier.po.SupplierContractPrice;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.supplier.po.SupplierItem;
import com.yihg.supplier.vo.SupplierContractPriceVo;
import com.yihg.supplier.vo.SupplierContractVo;

/**
 * Created by ZhengZiyu on 2015/6/10.
 */
@Controller
@RequestMapping("contract")
public class ContractController extends BaseController{

    @Autowired
    private DicService dicService;

    @Autowired
    private ContractService contractService;

    @Autowired
    private RegionService regionService;
    @Autowired
    private BizSupplierRelationService bizSupplierRelationService;

    @Autowired
    private SupplierService supplierService;
    @Autowired
    private SupplierItemService itemService;
    @Autowired
    private SysConfig config;
    private static final Map<Integer, String> supplierTypeMap = SupplierConstant.supplierTypeMap;
    private static final Map<Integer, String> supplierStateMap = new HashMap<Integer, String>();
    private static final Map<Integer, String> contractStateMap = new HashMap<Integer, String>();
    static{       
        supplierStateMap.put(0, "未签订");
        supplierStateMap.put(1, "已签订");

        contractStateMap.put(1, "有效");
//        contractStateMap.put(2, "即将过期");
        contractStateMap.put(0, "已失效");
    }
    @ModelAttribute
    public void addConstants(Model model){
        model.addAttribute("TRAVELAGENCY", Constants.TRAVELAGENCY);
        model.addAttribute("RESTAURANT", Constants.RESTAURANT);
        model.addAttribute("HOTEL", Constants.HOTEL);
        model.addAttribute("FLEET", Constants.FLEET);
        model.addAttribute("SCENICSPOT", Constants.SCENICSPOT);
        model.addAttribute("SHOPPING", Constants.SHOPPING);
        model.addAttribute("ENTERTAINMENT", Constants.ENTERTAINMENT);
        model.addAttribute("GUIDE", Constants.GUIDE);
        model.addAttribute("AIRTICKETAGENT", Constants.AIRTICKETAGENT);
        model.addAttribute("TRAINTICKETAGENT", Constants.TRAINTICKETAGENT);
        model.addAttribute("GOLF", Constants.GOLF);
        model.addAttribute("OTHER", Constants.OTHER);
        model.addAttribute("CONTRACTAGREEMENT", Constants.CONTRACTAGREEMENT);

        model.addAttribute("supplierTypeMap", supplierTypeMap);
        model.addAttribute("supplierStateMap", supplierStateMap);
        model.addAttribute("contractStateMap", contractStateMap);
    }

    @RequestMapping(value="/{supplierId}/add.htm", method = RequestMethod.GET)
    public String newContractPage(HttpServletRequest request,@PathVariable("supplierId") String supplierId, Model model){
        Integer bizId = WebUtils.getCurBizId(request);
//        SupplierInfo supplierInfo = supplierService.selectBySupplierId(Integer.valueOf(supplierId));
//        BizSupplierRelation bizSupplierRelation = bizSupplierRelationService.getByBizIdAndSupplierId(bizId, Integer.valueOf(supplierId));
//        model.addAttribute("supplierInfo", supplierInfo);
//        model.addAttribute("bizSupplierRelation", bizSupplierRelation);
        SupplierContractVo supplierContractVo = contractService.findContract(bizId, Integer.valueOf(supplierId), null);
       
        		try {
					SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd");
					 String signDate =  df.format(new Date());
					 model.addAttribute("signDate", df.parse(signDate));
				} catch (ParseException e) {
					e.printStackTrace();
				}
        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	List<SupplierItem> dictTypeList = itemService.findSupplierItemBySupplierId(Integer.valueOf(supplierId));
        	model.addAttribute("dictTypeList", dictTypeList);
        	
        }else if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.LOCALTRAVEL)){
         	List<DicInfo> dictTypeList = dicService.getListByTypeCode(BasicConstants.XMFY_DJXM,bizId);
         	model.addAttribute("dictTypeList", dictTypeList);
        }else{
        	List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
        	model.addAttribute("dictTypeList", dictTypeList);
		}

        //酒店两种字典类型
//        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
//            List<DicInfo> dictType2List = dicService.getListByTypeCode(Constants.dictType2Map.get(supplierContractVo.getSupplierInfo().getSupplierType()));
//            model.addAttribute("dictType2List", dictType2List);
//        }
        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
            model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);
        }
        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("supplierId", supplierId);
        model.addAttribute("config", config);
        List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		
		
		model.addAttribute("cashTypes", cashTypes);
        return "contract/contract_add";
    }

    @RequestMapping(value="/{supplierId}/{contractId}/edit.htm", method = RequestMethod.GET)
    public String editContractPage(HttpServletRequest request,@PathVariable("supplierId") String supplierId, Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
//        SupplierInfo supplierInfo = supplierService.selectBySupplierId(Integer.valueOf(supplierId));
//        BizSupplierRelation bizSupplierRelation = bizSupplierRelationService.getByBizIdAndSupplierId(bizId, Integer.valueOf(supplierId));
        SupplierContractVo supplierContractVo = contractService.findContract(bizId, Integer.valueOf(supplierId), Integer.valueOf(contractId));
       // List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
       // model.addAttribute("dictTypeList", dictTypeList);
        
        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	List<SupplierItem> dictTypeList = itemService.findSupplierItemBySupplierId(Integer.valueOf(supplierId));
        	model.addAttribute("dictTypeList", dictTypeList);
        	
        	
        }else if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.LOCALTRAVEL)){
         	List<DicInfo> dictTypeList = dicService.getListByTypeCode(BasicConstants.XMFY_DJXM,bizId);
         	model.addAttribute("dictTypeList", dictTypeList);
        }else {
			
        	List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
        	model.addAttribute("dictTypeList", dictTypeList);
		}
        //酒店两种字典类型
        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictType2List = dicService.getListByTypeCode(Constants.dictType2Map.get(supplierContractVo.getSupplierInfo().getSupplierType()));
            model.addAttribute("dictType2List", dictType2List);
        }
        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
            model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		
		
		model.addAttribute("cashTypes", cashTypes);
        return "contract/contract_edit";
    }

    @RequestMapping(value="/{supplierId}/{contractId}/view.htm", method = RequestMethod.GET)
    public String viewContractPage(HttpServletRequest request,@PathVariable("supplierId") String supplierId, Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        SupplierContractVo supplierContractVo = contractService.findContract(bizId, Integer.valueOf(supplierId), Integer.valueOf(contractId));

        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	List<SupplierItem> dictTypeList = itemService.findSupplierItemBySupplierId(Integer.valueOf(supplierId));
        	model.addAttribute("dictTypeList", dictTypeList);
        	
        }else {
			
        	List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
        	model.addAttribute("dictTypeList", dictTypeList);
		}

        //酒店两种字典类型
        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            /*List<DicInfo> dictType2List = dicService.getListByTypeCode(Constants.dictType2Map.get(supplierContractVo.getSupplierInfo().getSupplierType()));
            model.addAttribute("dictType2List", dictType2List);*/
        }
        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
            model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		
		
		model.addAttribute("cashTypes", cashTypes);
        return "contract/contract_view";
    }

    @RequestMapping(value="/fleet-add.htm", method = RequestMethod.GET)
    public String newFleetContractPage(HttpServletRequest request, Model model,Integer supplierId){
        Integer bizId = WebUtils.getCurBizId(request);
        SupplierContractVo supplierContractVo = contractService.findFleetContract(bizId, null);

        List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
        model.addAttribute("dictTypeList", dictTypeList);

        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
            model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);
        }
        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        model.addAttribute("supplierId", supplierId);
        List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		
		
		model.addAttribute("cashTypes", cashTypes);
        return "contract/contract_add";
    }


    @RequestMapping(value="/{contractId}/fleet-edit.htm", method = RequestMethod.GET)
    public String editFleetContractPage(HttpServletRequest request, Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
//        SupplierInfo supplierInfo = supplierService.selectBySupplierId(Integer.valueOf(supplierId));
//        BizSupplierRelation bizSupplierRelation = bizSupplierRelationService.getByBizIdAndSupplierId(bizId, Integer.valueOf(supplierId));
        SupplierContractVo supplierContractVo = contractService.findFleetContract(bizId, Integer.valueOf(contractId));
      //  List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
       // model.addAttribute("dictTypeList", dictTypeList);
        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	List<SupplierItem> dictTypeList = itemService.findSupplierItemBySupplierId(supplierContractVo.getSupplierInfo().getId());
        	model.addAttribute("dictTypeList", dictTypeList);
//        	List<SupplierContract> contractList = contractService.findContracts(bizId, supplierContractVo.getSupplierInfo().getId());
//        	model.addAttribute("contractList", contractList);
        }else {
			
        	List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
        	model.addAttribute("dictTypeList", dictTypeList);
		}
        //酒店两种字典类型
        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictType2List = dicService.getListByTypeCode(Constants.dictType2Map.get(supplierContractVo.getSupplierInfo().getSupplierType()));
            model.addAttribute("dictType2List", dictType2List);
        }
        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
            model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		
		
		model.addAttribute("cashTypes", cashTypes);
        return "contract/contract_edit";
    }

    @RequestMapping(value="/{contractId}/fleet-view.htm", method = RequestMethod.GET)
    public String viewFleetContractPage(HttpServletRequest request,Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        SupplierContractVo supplierContractVo = contractService.findFleetContract(bizId, Integer.valueOf(contractId));


        List<DicInfo> dictTypeList = dicService.getListByTypeCode(Constants.dictTypeMap.get(supplierContractVo.getSupplierInfo().getSupplierType()));
        model.addAttribute("dictTypeList", dictTypeList);

        //酒店两种字典类型
        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictType2List = dicService.getListByTypeCode(Constants.dictType2Map.get(supplierContractVo.getSupplierInfo().getSupplierType()));
            model.addAttribute("dictType2List", dictType2List);
        }
        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
            model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);
		
		
		model.addAttribute("cashTypes", cashTypes);
        return "contract/contract_view";
    }



    @RequestMapping(value = "/list.htm")
    public String contractSupplierList(HttpServletRequest request,Model model,
                                       PageBean<SupplierInfo> pageBean,SupplierInfo supplierInfo){
        Integer bizId = WebUtils.getCurBizId(request);
        pageBean.setPageSize(supplierInfo.getPageSize());
        pageBean.setPage(supplierInfo.getPage());

        supplierInfo.setState(1);
        pageBean.setParameter(supplierInfo);

        pageBean = contractService.findSupplierInfos(pageBean, bizId);
        model.addAttribute("page", pageBean);
        List<RegionInfo> allProvince = regionService.getAllProvince();
        model.addAttribute("allProvince", allProvince);
        List<RegionInfo> cityList = regionService.getRegionById(supplierInfo
                .getProvinceId() + "");
        model.addAttribute("cityList", cityList);

        List<RegionInfo> areaList = regionService.getRegionById(supplierInfo
                .getCityId() + "");
        model.addAttribute("areaList", areaList);
        model.addAttribute("supplierInfo", supplierInfo);
        model.addAttribute("flag", 0);
        
        return "contract/contract_supplier_list";
    }

    @RequestMapping(value = "/{supplierId}/{flag}/view-list.htm")
    public String contractList(HttpServletRequest request,@PathVariable("supplierId") String supplierId,@PathVariable("flag") String flag,
                               SupplierContract supplierContract,
                               PageBean<SupplierContract> pageBean,
                               Model model){

//        pageBean = new PageBean<SupplierContract>();
    	/*if(supplierContract.getStartDate()==null && supplierContract.getEndDate()==null){
    		 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");    
    		 Date startDate = null;
    		 Date endDate = null;
    		 try{
    			 startDate = sdf.parse(com.yihg.erp.utils.DateUtils.getMonthFirstDay());
    			 endDate = sdf.parse(com.yihg.erp.utils.DateUtils.getMonthLastDay());
    		 }catch(ParseException ex){}
    		supplierContract.setStartDate(startDate);
    		supplierContract.setEndDate(endDate);
    	}*/
        pageBean.setPageSize(supplierContract.getPageSize());
        pageBean.setPage(supplierContract.getPage());
        pageBean.setParameter(supplierContract);
        Integer bizId = WebUtils.getCurBizId(request);
        BizSupplierRelation bizSupplierRelation = bizSupplierRelationService.getByBizIdAndSupplierId(bizId, Integer.valueOf(supplierId));
        if(bizSupplierRelation != null){
            pageBean = contractService.findContracts(pageBean, bizSupplierRelation.getId());
        }
        
        model.addAttribute("page", pageBean);
        model.addAttribute("flag", Integer.parseInt(flag));
        model.addAttribute("supplierId", supplierId);
        return "contract/contract_list";
    }

    @RequestMapping("/fleet-list.htm")
    public String fleetList(HttpServletRequest request,
                            SupplierContract supplierContract,
                            PageBean<SupplierContract> pageBean,Integer supplierId,
                            Model model){
        pageBean.setPageSize(supplierContract.getPageSize());
        pageBean.setPage(supplierContract.getPage());
        pageBean.setParameter(supplierContract);
        Integer bizId = WebUtils.getCurBizId(request);
        pageBean = contractService.findContracts(pageBean, 0 - bizId);//车队shop_supplier_id=0
        model.addAttribute("page", pageBean);
        model.addAttribute("supplierType", Constants.FLEET);
        model.addAttribute("supplierId", supplierId);
        return "contract/contract_list";
    }

    
    private void handleSupplierContractVo(SupplierContractVo supplierContractVo){
    	if (supplierContractVo.getPriceVoList()!=null && supplierContractVo.getPriceVoList().size()>0) {
			for (int i = 0; i < supplierContractVo.getPriceVoList().size(); i++) {
				SupplierContractPrice price = supplierContractVo
						.getPriceVoList().get(i).getSupplierContractPrice();
				if (price.getRebateMethod() != null
						&& price.getRebateMethod().equals(1)) {
					price.setRebateAmount(price.getRebateAmountPercent());
				}
			}
		}
		return ;
    }
    
    
    @RequestMapping(value = "/add.do", method = RequestMethod.POST)
    @ResponseBody
    public String newContract(SupplierContractVo supplierContractVo){
    	this.handleSupplierContractVo(supplierContractVo);
        supplierContractVo = contractService.saveContract(supplierContractVo);
        return successJson("contractId", String.valueOf(supplierContractVo.getSupplierContract().getId()));
    }

    @RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    @ResponseBody
    public String editContract(SupplierContractVo supplierContractVo){
    	this.handleSupplierContractVo(supplierContractVo);
        contractService.updateContract(supplierContractVo);
        return successJson();
    }

    @RequestMapping(value = "/{supplierId}/{contractId}/delete.do", method = RequestMethod.POST)
    @ResponseBody
    public String deleteContract(HttpServletRequest request,@PathVariable("supplierId") Integer supplierId, 
    		@PathVariable("contractId") Integer contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        boolean success = contractService.deleteContract(bizId, supplierId, contractId);
        if(success){
            return successJson();
        }else{
            return errorJson("操作失败");
        }

    }
    /**
     * 复制供应商协议
     * @param request
     * @param supplierId
     * @param contractId
     * @return
     */
    @RequestMapping(value = "/{supplierId}/{contractId}/copyContract.do", method = RequestMethod.POST)
    @ResponseBody
    public String copyContract(HttpServletRequest request,@PathVariable("supplierId") Integer supplierId, 
    		@PathVariable("contractId") Integer contractId){
    	//Integer bizId = WebUtils.getCurBizId(request);
    	//boolean success = contractService.deleteContract(bizId, supplierId, contractId);
    	try {
			contractService.copySupplierContract(contractId);
			return successJson();
		} catch (Exception e) {
			return errorJson("复制失败");
		}
    	
    	
    }

    @RequestMapping(value = "/{contractId}/fleet-delete.do", method = RequestMethod.POST)
    @ResponseBody
    public String deleteFleetContract(HttpServletRequest request,
                                 @PathVariable("contractId") Integer contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        boolean success = contractService.deleteFleetContract(bizId, contractId);
        if(success){
            return successJson();
        }else{
            return errorJson("操作失败");
        }

    }
}
