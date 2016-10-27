package com.yihg.erp.controller.sales;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.GroupRouteVO;
import com.yimayhd.erpcenter.facade.sales.query.grouproute.EditGroupRouteDTO;
import com.yimayhd.erpcenter.facade.sales.result.grouproute.GetImpDataResult;
import com.yimayhd.erpcenter.facade.sales.result.grouproute.ToEditRouteListResult;
import com.yimayhd.erpcenter.facade.sales.result.grouproute.ToGroupRouteResult;
import com.yimayhd.erpcenter.facade.sales.result.grouproute.ToImpRouteListResult;
import com.yimayhd.erpcenter.facade.sales.service.GroupRouteFacade;

@Controller
@RequestMapping(value = "/groupRoute")
public class GroupRouteController extends BaseController {
	
//	private static final Logger logger = LoggerFactory.getLogger(GroupRouteController.class);
//	
//	@Autowired
//	private TourGroupService tourGroupService;
//	@Autowired
//	private GroupRouteService groupRouteService;
//	@Autowired
//	private GroupOrderService groupOrderService;
//	@Autowired
//	private ProductRouteService productRouteService;
//	@Autowired
//	private ProductInfoService productInfoService;
//	@Autowired
//	private ProductRemarkService productRemarkService;
	
	//FIXME 特殊暂放
	@Autowired
	private SysConfig config;

	@Autowired
	private GroupRouteFacade groupRouteFacade;
	
	/**
	 * 跳转到行程列表
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toGetRouteList.htm")
	public String toEditRouteList(Model model, Integer groupId,
			Integer stateFinance, Integer orderId,Integer state) {
		
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("config", config);
//		model.addAttribute("orderId", orderId);
//		model.addAttribute("stateFinance", stateFinance);
//		model.addAttribute("state", state);
//		List<GroupRoute> list = groupRouteService.selectByGroupId(groupId);
//		if (list != null && list.size() > 0) {
//			return "sales/tourGroup/routeList/editRouteList";
//		} else {
//			return "sales/tourGroup/routeList/addRouteList";
//		}
		
		model.addAttribute("config", config);
		model.addAttribute("orderId", orderId);
		model.addAttribute("stateFinance", stateFinance);
		model.addAttribute("state", state);
		
		ToEditRouteListResult result=groupRouteFacade.toEditRouteList(groupId);
		model.addAttribute("tourGroup", result.getTourGroup());
		
		if (!result.isSuccess()) {
			return "sales/tourGroup/routeList/editRouteList";
		} else {
			return "sales/tourGroup/routeList/addRouteList";
		}
	}

	/**
	 * 
	 * 跳转到导入行程列表
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "toImpRouteList.htm")
	public String toImpRouteList(Model model, Integer groupId, Integer productId,
			Integer orderId,Integer state) {
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		ProductInfo productInfo = productInfoService.findProductInfoById(productId);
//		ProductRemark productRemark = productRemarkService.findProductRemarkByProductId(productId);
//		model.addAttribute("productRemark", productRemark);
//		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("config", config);
//		model.addAttribute("productInfo", productInfo);
//		model.addAttribute("orderId", orderId);
//		GroupOrder groupOrder = groupOrderService.findById(orderId);
//		model.addAttribute("stateFinance", groupOrder.getStateFinance()==null?0:groupOrder.getStateFinance());
//		model.addAttribute("state", state);
//		
//		return "sales/tourGroup/routeList/impRouteList";
		
		model.addAttribute("orderId", orderId);
		model.addAttribute("state", state);
		model.addAttribute("config", config);
		
		ToImpRouteListResult result=groupRouteFacade.toImpRouteList(productId,orderId,groupId);
		
		GroupOrder groupOrder = result.getGroupOrder();
		model.addAttribute("stateFinance", groupOrder.getStateFinance()==null?0:groupOrder.getStateFinance());
		
		model.addAttribute("productRemark", result.getProductRemark());
		model.addAttribute("tourGroup", result.getTourGroup());
		model.addAttribute("productInfo", result.getProductInfo());
		
		return "sales/tourGroup/routeList/impRouteList";
	}

	@RequestMapping(value = "/getImpData.do")
	@ResponseBody
	public String getImpData(Model model, Integer productId) {
//		// -------------------------------------------------------------------------------
//		ProductRouteVo productRouteVo = productRouteService.findByProductId(productId);
//		GroupRouteVO groupRouteVO = new GroupRouteVO();
//		List<GroupRouteDayVO> groupRouteDayVOList = new ArrayList<GroupRouteDayVO>();
//		List<ProductRouteDayVo> productRoteDayVoList = productRouteVo.getProductRoteDayVoList();
//
//		if (productRoteDayVoList != null && productRoteDayVoList.size() > 0) {
//			for (ProductRouteDayVo productRouteDayVo : productRoteDayVoList) {
//				ProductRoute productRoute = productRouteDayVo.getProductRoute();
//				GroupRoute groupRoute = new GroupRoute();
//				GroupRouteDayVO groupRouteDayVO = new GroupRouteDayVO();
//				try {
//					BeanUtils.copyProperties(groupRoute, productRoute);
//					groupRoute.setId(null);
//					List<ProductAttachment> productAttachmentsList = productRouteDayVo.getProductAttachments();
//					List<GroupRouteAttachment> groupRouteAttachmentList = new ArrayList<GroupRouteAttachment>();
//					if (productAttachmentsList != null && productAttachmentsList.size() > 0) {
//
//						for (ProductAttachment productAttachment : productAttachmentsList) {
//							GroupRouteAttachment groupRouteAttachment = new GroupRouteAttachment();
//							BeanUtils.copyProperties(groupRouteAttachment, productAttachment);
//							System.out.println(groupRouteAttachment.getPath() + ";" + groupRouteAttachment.getName());
//							groupRouteAttachment.setId(null);
//							groupRouteAttachmentList.add(groupRouteAttachment);
//						}
//					}
//
//					List<ProductRouteTraffic> productRouteTrafficList = productRouteDayVo.getProductRouteTrafficList();
//					List<GroupRouteTraffic> groupRouteTrafficList = new ArrayList<GroupRouteTraffic>();
//					if (productRouteTrafficList != null && productRouteTrafficList.size() > 0) {
//						for (ProductRouteTraffic productRouteTraffic : productRouteTrafficList) {
//							GroupRouteTraffic groupRouteTraffic = new GroupRouteTraffic();
//							BeanUtils.copyProperties(groupRouteTraffic, productRouteTraffic);
//							groupRouteTraffic.setId(null);
//							groupRouteTrafficList.add(groupRouteTraffic);
//
//						}
//					}
//
//					List<GroupRouteSupplier> groupRouteOptionsSupplierList = new ArrayList<GroupRouteSupplier>();
//					List<ProductRouteSupplier> productOptionsSupplierList = productRouteDayVo
//							.getProductOptionsSupplierList();
//					if (productOptionsSupplierList != null && productOptionsSupplierList.size() > 0) {
//						for (ProductRouteSupplier productRouteSupplier : productOptionsSupplierList) {
//							GroupRouteSupplier groupRouteOptionsSupplier = new GroupRouteSupplier();
//							BeanUtils.copyProperties(groupRouteOptionsSupplier, productRouteSupplier);
//							groupRouteOptionsSupplier.setId(null);
//							groupRouteOptionsSupplierList.add(groupRouteOptionsSupplier);
//						}
//					}
//					groupRouteDayVO.setGroupRoute(groupRoute);
//					groupRouteDayVO.setGroupRouteAttachmentList(groupRouteAttachmentList);
//					groupRouteDayVO.setGroupRouteOptionsSupplierList(groupRouteOptionsSupplierList);
//					// groupRouteDayVO
//					// .setGroupRouteScenicSupplierList(groupRouteScenicSupplierList);
//					groupRouteDayVO.setGroupRouteTrafficList(groupRouteTrafficList);
//
//				} catch (Exception e) {
//					return errorJson("行程转换错误!");
//				}
//				groupRouteDayVOList.add(groupRouteDayVO);
//
//			}
//
//		}
//		groupRouteVO.setGroupRouteDayVOList(groupRouteDayVOList);
//
//		return JSON.toJSONString(groupRouteVO);
		
		GetImpDataResult result=groupRouteFacade.getImpData(productId);
		if(result.isSuccess()){
			return JSON.toJSONString(result.getGroupRouteVO());
		}else{
			return errorJson(result.getError());
		}
	}

	@RequestMapping(value = "/saveGroupRoute.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveGroupRoute(GroupRouteVO groupRouteVO) {
//		groupRouteService.saveGroupRoute(groupRouteVO);
//		return successJson();
		
		EditGroupRouteDTO editGroupRouteDTO=new EditGroupRouteDTO();
		editGroupRouteDTO.setGroupRouteVO(groupRouteVO);
		
		groupRouteFacade.saveGroupRoute(editGroupRouteDTO);
		return successJson();
	}

	@RequestMapping(value = "/getData.do")
	@ResponseBody
	public String getDataByGroupId(Model model, Integer groupId) {
//		GroupRouteVO groupRouteVO = groupRouteService
//				.findGroupRouteByGroupId(groupId);
//		return JSON.toJSONString(groupRouteVO);
		
		GetImpDataResult result=groupRouteFacade.getDataByGroupId(groupId);
		return JSON.toJSONString(result.getGroupRouteVO());
	}
	
	@RequestMapping(value = "/getDataByOrderId.do")
	@ResponseBody
	public String getDataByOrderId(Model model, Integer orderId) {
//		GroupRouteVO groupRouteVO = groupRouteService.findGroupRouteByOrderId(orderId);
//		return JSON.toJSONString(groupRouteVO);
		GetImpDataResult result=groupRouteFacade.getDataByOrderId(orderId);
		return JSON.toJSONString(result.getGroupRouteVO());
	}

	@RequestMapping(value = "/toGroupRoute.htm")
	public String toGroupRoute(HttpServletRequest request, Model model,
			Integer groupId,Integer operType) {
//		TourGroup tourGroup = tourGroupService.selectByPrimaryKey(groupId);
//		model.addAttribute("tourGroup", tourGroup);
//		model.addAttribute("config", config);
//		model.addAttribute("operType", operType);
//		return "sales/groupOrder/fitRouteList";
		
		model.addAttribute("config", config);
		model.addAttribute("operType", operType);
	
		ToGroupRouteResult result=groupRouteFacade.toGroupRoute(groupId);
		model.addAttribute("tourGroup", result.getTourGroup());
		
		return "sales/groupOrder/fitRouteList";
	}

	@RequestMapping(value = "/editGroupRoute.do", method = RequestMethod.POST)
	@ResponseBody
	public String editGroupRoute(Model model, GroupRouteVO groupRouteVO) {
		//groupRouteService.editGroupRoute(groupRouteVO);
		
		EditGroupRouteDTO editGroupRouteDTO=new EditGroupRouteDTO();
		editGroupRouteDTO.setGroupRouteVO(groupRouteVO);
		
		groupRouteFacade.editGroupRoute(editGroupRouteDTO);
		
		return successJson();
	}
}
