package com.yihg.erp.controller.supplier;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.yimayhd.erpcenter.facade.supplier.result.ContractPagaResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.basic.po.RegionInfo;
import com.yimayhd.erpcenter.facade.supplier.query.SupplierContractVoDTO;
import com.yimayhd.erpcenter.facade.supplier.result.ContractSupplierListResult;
import com.yimayhd.erpcenter.facade.supplier.result.NewContractPagaResult;
import com.yimayhd.erpcenter.facade.supplier.result.WebResult;
import com.yimayhd.erpcenter.facade.supplier.service.ContractFacade;
import com.yimayhd.erpresource.dal.constants.Constants;
import com.yimayhd.erpresource.dal.constants.SupplierConstant;
import com.yimayhd.erpresource.dal.po.SupplierContract;
import com.yimayhd.erpresource.dal.po.SupplierContractPrice;
import com.yimayhd.erpresource.dal.po.SupplierInfo;
import com.yimayhd.erpresource.dal.vo.SupplierContractVo;

/**
 * Created by ZhengZiyu on 2015/6/10.
 */
@Controller
@RequestMapping("contract")
public class ContractController extends BaseController{
	private static final Logger log = LoggerFactory
			.getLogger(ContractController.class);
	
    @Autowired
    private ContractFacade contractFacade;

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
        model.addAttribute("LOCALTRAVEL", Constants.LOCALTRAVEL);
        model.addAttribute("supplierTypeMap", supplierTypeMap);
        model.addAttribute("supplierStateMap", supplierStateMap);
        model.addAttribute("contractStateMap", contractStateMap);
    }

    @RequestMapping(value="/{supplierId}/add.htm", method = RequestMethod.GET)
    public String newContractPage(HttpServletRequest request,@PathVariable("supplierId") String supplierId, Model model){
        Integer bizId = WebUtils.getCurBizId(request);
        NewContractPagaResult webResult = contractFacade.newContractPage(bizId, supplierId);
        
        SupplierContractVo supplierContractVo = webResult.getSupplierContractVo();
       
		try {
			SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd");
			 String signDate =  df.format(new Date());
			 model.addAttribute("signDate", df.parse(signDate));
		} catch (ParseException e) {
			log.error(e.getMessage());
		}
		
        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	model.addAttribute("dictTypeList", webResult.getDictTypeList());
        	
        }else if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.LOCALTRAVEL)){
         	model.addAttribute("dictTypeList", webResult.getDicInfoList());
        }else{
        	model.addAttribute("dictTypeList", webResult.getDicInfoList());
		}

        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            model.addAttribute("dictSecLevelTypeList", webResult.getDictSecLevelTypeList());
        }
        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("supplierId", supplierId);
        model.addAttribute("config", config);
		
		
		model.addAttribute("cashTypes", webResult.getCashTypes());
        return "contract/contract_add";
    }

    @RequestMapping(value="/{supplierId}/{contractId}/edit.htm", method = RequestMethod.GET)
    public String editContractPage(HttpServletRequest request,@PathVariable("supplierId") String supplierId, Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        NewContractPagaResult webResult = contractFacade.editContractPage(bizId, supplierId, contractId);
        
        SupplierContractVo supplierContractVo = webResult.getSupplierContractVo();
        
        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	model.addAttribute("dictTypeList", webResult.getDictTypeList());
        	
        }else if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.LOCALTRAVEL)){
         	model.addAttribute("dictTypeList", webResult.getDicInfoList());
        }else{
        	model.addAttribute("dictTypeList", webResult.getDicInfoList());
		}
        //酒店两种字典类型
        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            model.addAttribute("dictType2List", webResult.getDictType2List());
        }
      //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            model.addAttribute("dictSecLevelTypeList", webResult.getDictSecLevelTypeList());
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        model.addAttribute("cashTypes", webResult.getCashTypes());
        return "contract/contract_edit";
    }
    @RequestMapping(value="/{supplierId}/delivery-add.htm", method = RequestMethod.GET)
    public String newDeliveryContractPage(HttpServletRequest request, Model model,@PathVariable("supplierId")Integer supplierId){
        Integer bizId = WebUtils.getCurBizId(request);
       /* SupplierContractVo supplierContractVo = contractService.findContract(bizId, Integer.valueOf(supplierId), null);


        List<DicInfo> dictTypeList = dicService.getListByTypeCode(BasicConstants.XMFY_DJXM,bizId);
        model.addAttribute("dictTypeList", dictTypeList);


        List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
        model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        model.addAttribute("supplierId", supplierId);
        model.addAttribute("deliveryType", "temp");
        List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);*/
        NewContractPagaResult result = contractFacade.newDeliveryContractPage(bizId,supplierId+"");
        model.addAttribute("dictTypeList", result.getDicInfoList());
        model.addAttribute("dictSecLevelTypeList", result.getDictSecLevelTypeList());
        model.addAttribute("supplierContractVo", result.getSupplierContractVo());
        model.addAttribute("config", config);
        model.addAttribute("supplierId", supplierId);
        model.addAttribute("deliveryType", "temp");
        model.addAttribute("cashTypes", result.getCashTypes());
        return "contract/contract_add";
    }
    @RequestMapping(value="/{contractId}/delivery-edit.htm", method = RequestMethod.GET)
    public String editDeliveryContractPage(HttpServletRequest request, Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        /*SupplierContractVo supplierContractVo = contractService.findDelveryContract(bizId, Integer.valueOf(contractId));

        List<DicInfo> dictTypeList = dicService.getListByTypeCode(BasicConstants.XMFY_DJXM,bizId);
        model.addAttribute("dictTypeList", dictTypeList);

        List<DicInfo> dictSecLevelTypeList = dicService.getListByTypeCode(Constants.FLEET_LINE_BRAND_TYPE_CODE,bizId);
        model.addAttribute("dictSecLevelTypeList", dictSecLevelTypeList);

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        model.addAttribute("deliveryType", "temp");
        List<DicInfo> cashTypes = dicService.getListByTypeCode(BasicConstants.GYXX_JSFS, bizId);*/

        NewContractPagaResult result = contractFacade.editDeliveryContractPage(bizId, contractId);
        model.addAttribute("dictTypeList", result.getDicInfoList());
        model.addAttribute("dictSecLevelTypeList", result.getDictSecLevelTypeList());
        model.addAttribute("supplierContractVo", result.getSupplierContractVo());
        model.addAttribute("config", config);
        model.addAttribute("deliveryType", "temp");
        model.addAttribute("cashTypes", result.getCashTypes());
        return "contract/contract_edit";
    }
    @RequestMapping(value="/{supplierId}/{contractId}/view.htm", method = RequestMethod.GET)
    public String viewContractPage(HttpServletRequest request,@PathVariable("supplierId") String supplierId, Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        NewContractPagaResult webResult = contractFacade.viewContractPage(bizId, supplierId, contractId);
        
        SupplierContractVo supplierContractVo = webResult.getSupplierContractVo();
        
        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	model.addAttribute("dictTypeList", webResult.getDictTypeList());
        }else{
        	model.addAttribute("dictTypeList", webResult.getDicInfoList());
		}
      //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            model.addAttribute("dictSecLevelTypeList", webResult.getDictSecLevelTypeList());
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        model.addAttribute("cashTypes", webResult.getCashTypes());
        return "contract/contract_view";
    }

    @RequestMapping(value="/fleet-add.htm", method = RequestMethod.GET)
    public String newFleetContractPage(HttpServletRequest request, Model model,Integer supplierId){
        Integer bizId = WebUtils.getCurBizId(request);
        NewContractPagaResult webResult = contractFacade.newFleetContractPage(bizId, supplierId);
        
        SupplierContractVo supplierContractVo = webResult.getSupplierContractVo();

        model.addAttribute("dictTypeList", webResult.getDicInfoList());

        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
           
            model.addAttribute("dictSecLevelTypeList", webResult.getDictSecLevelTypeList());
        }
        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        model.addAttribute("supplierId", supplierId);
		
		model.addAttribute("cashTypes", webResult.getCashTypes());
        return "contract/contract_add";
    }


    @RequestMapping(value="/{contractId}/fleet-edit.htm", method = RequestMethod.GET)
    public String editFleetContractPage(HttpServletRequest request, Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        
        NewContractPagaResult webResult = contractFacade.editFleetContractPage(bizId, contractId);
        SupplierContractVo supplierContractVo = webResult.getSupplierContractVo();
        if(supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SCENICSPOT)||supplierContractVo.getSupplierInfo().getSupplierType().equals(Constants.SHOPPING)){
        	model.addAttribute("dictTypeList", webResult.getDictTypeList());
        }else {
        	model.addAttribute("dictTypeList", webResult.getDicInfoList());
		}
        //酒店两种字典类型
        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            model.addAttribute("dictType2List", webResult.getDictType2List());
        }
        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            model.addAttribute("dictSecLevelTypeList", webResult.getDictSecLevelTypeList());
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
		
		
		model.addAttribute("cashTypes", webResult.getCashTypes());
        return "contract/contract_edit";
    }

    @RequestMapping(value="/{contractId}/fleet-view.htm", method = RequestMethod.GET)
    public String viewFleetContractPage(HttpServletRequest request,Model model, @PathVariable("contractId") String contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        NewContractPagaResult webResult = contractFacade.viewFleetContractPage(bizId, contractId);
        SupplierContractVo supplierContractVo = webResult.getSupplierContractVo();

        model.addAttribute("dictTypeList", webResult.getDicInfoList());

        //酒店两种字典类型
        if(Constants.HOTEL.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
            model.addAttribute("dictType2List", webResult.getDictType2List());
        }
        //车队二级类型
        if(Constants.FLEET.equals(supplierContractVo.getSupplierInfo().getSupplierType())){
        	 model.addAttribute("dictSecLevelTypeList", webResult.getDictSecLevelTypeList());
        }

        model.addAttribute("supplierContractVo", supplierContractVo);
        model.addAttribute("config", config);
        model.addAttribute("cashTypes", webResult.getCashTypes());
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

        ContractSupplierListResult webResult = contractFacade.contractSupplierList(bizId, pageBean, supplierInfo
                .getProvinceId() + "", supplierInfo.getCityId() + "");
        pageBean = webResult.getPageBean();
        model.addAttribute("page", pageBean);
        List<RegionInfo> allProvince = webResult.getAllProvince();
        model.addAttribute("allProvince", allProvince);
        List<RegionInfo> cityList = webResult.getCityList();
        model.addAttribute("cityList", cityList);

        List<RegionInfo> areaList = webResult.getAreaList();
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

    	
        pageBean.setPageSize(supplierContract.getPageSize());
        pageBean.setPage(supplierContract.getPage());
        pageBean.setParameter(supplierContract);
        Integer bizId = WebUtils.getCurBizId(request);
        ContractPagaResult webResult = contractFacade.contractList(supplierId, pageBean, bizId);
        model.addAttribute("page", webResult.getValue());
        model.addAttribute("flag", Integer.parseInt(flag));
        model.addAttribute("supplierInfo", webResult.getSupplierInfo());
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
        WebResult<PageBean> webResult =contractFacade.fleetList(bizId, pageBean, supplierId);
        pageBean =webResult.getValue();
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
                if (price.getContractSale() == null) {
                    price.setContractSale(new Float(0));
                }
			}
		}
		return ;
    }
    
    
    @RequestMapping(value = "/add.do", method = RequestMethod.POST)
    @ResponseBody
    public String newContract(SupplierContractVo supplierContractVo){
    	SupplierContractVoDTO supplierContractVoDTO = new SupplierContractVoDTO();
    	supplierContractVoDTO.setSupplierContractVo(supplierContractVo);
    	WebResult<SupplierContractVo> webResult = contractFacade.newContract(supplierContractVoDTO);
    	if(webResult.isSuccess()){
    		supplierContractVo = webResult.getValue();
            return successJson("contractId", String.valueOf(supplierContractVo.getSupplierContract().getId()));
	   	}else{
	   		return errorJson(webResult.getResultMsg());
	   	}
    }

    @RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    @ResponseBody
    public String editContract(SupplierContractVo supplierContractVo){
    	SupplierContractVoDTO supplierContractVoDTO = new SupplierContractVoDTO();
    	supplierContractVoDTO.setSupplierContractVo(supplierContractVo);
    	WebResult<Boolean> webResult = contractFacade.editContract(supplierContractVoDTO);
    	if(webResult.isSuccess()){
    		 return successJson();
    	}else{
    		return errorJson(webResult.getResultMsg());
    	}
       
    }

    @RequestMapping(value = "/{supplierId}/{contractId}/delete.do", method = RequestMethod.POST)
    @ResponseBody
    public String deleteContract(HttpServletRequest request,@PathVariable("supplierId") Integer supplierId, 
    		@PathVariable("contractId") Integer contractId){
        Integer bizId = WebUtils.getCurBizId(request);
        WebResult<Boolean> webResult =contractFacade.deleteContract(bizId, supplierId, contractId);
        if(!webResult.isSuccess()){
        	return errorJson("操作失败");
        }
        boolean success = webResult.getValue();
        if(success){
            return successJson();
        }else{
            return errorJson("操作失败");
        }

    }

    @RequestMapping(value = "/delPriceExtRow.do", method = RequestMethod.POST)
    @ResponseBody
    public String delPriceExtRow(HttpServletRequest request,Integer priceExtId){
        contractFacade.delPriceExtRow(priceExtId);
        return successJson();
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
    	try {
    		WebResult<Boolean> webResult = contractFacade.copyContract(supplierId, contractId);
    		if(!webResult.isSuccess()){
    			return errorJson("复制失败");
    		}
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
        WebResult<Boolean> webResult = contractFacade.deleteFleetContract(bizId, contractId);
        if(!webResult.isSuccess()){
			return errorJson("操作失败");
		}
        boolean success = webResult.getValue();
        if(success){
            return successJson();
        }else{
            return errorJson("操作失败");
        }

    }
}
