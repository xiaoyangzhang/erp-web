package com.yihg.erp.controller.quality;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

//import com.yihg.basic.api.DicService;
//import com.yihg.basic.contants.BasicConstants;
//import com.yihg.basic.po.DicInfo;
//import com.yihg.customer.api.CustomerService;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.sales.client.quality.vo.QualityTourGroupCondition;
import com.yimayhd.erpcenter.facade.sales.query.quality.LoadQualityListDTO;
import com.yimayhd.erpcenter.facade.sales.query.quality.SaveReplyDTO;
import com.yimayhd.erpcenter.facade.sales.query.quality.SupplierCommentListDTO;
import com.yimayhd.erpcenter.facade.sales.result.BaseStateResult;
import com.yimayhd.erpcenter.facade.sales.result.quality.GroupQualityInfoResult;
import com.yimayhd.erpcenter.facade.sales.result.quality.LoadQualityListResult;
import com.yimayhd.erpcenter.facade.sales.result.quality.QualityListResult;
import com.yimayhd.erpcenter.facade.sales.result.quality.SupplierCommentListResult;
//import com.yihg.erp.utils.WebUtils;
//import com.yihg.mybatis.utility.PageBean;
//import com.yihg.quality.api.QualityService;
//import com.yihg.quality.vo.QualityCustomerTag;
//import com.yihg.quality.vo.QualityGroupGuestFeedback;
//import com.yihg.quality.vo.QualityTourGroupCondition;
//import com.yihg.sales.api.GroupFeedbackService;
//import com.yihg.sales.api.GroupOrderGuestService;
//import com.yihg.sales.api.GroupOrderService;
//import com.yihg.sales.api.TourGroupService;
//import com.yihg.sales.po.GroupOrder;
//import com.yihg.sales.po.GroupOrderGuest;
//import com.yihg.sales.po.TourGroup;
//import com.yihg.sales.vo.GroupFeedbackGroupStaticsVO;
//import com.yihg.sales.vo.GroupFeedbackPersonalStaticsVO;
//import com.yihg.supplier.api.SupplierCommentService;
//import com.yihg.supplier.constants.Constants;
import com.yimayhd.erpcenter.facade.sales.service.QualityFacade;

@Controller
@RequestMapping("/quality")
public class QualityController extends BaseController {
	
//	@Resource
//	private QualityService qualityService;
//	@Resource
//	private DicService dicService;
//	@Resource
//	private GroupOrderService orderService;
//	@Resource
//	private TourGroupService groupService;
//	@Resource
//	private GroupOrderGuestService orderGuestService;
//	@Resource
//	private GroupFeedbackService feedbackService;
//	@Resource
//	private CustomerService customerService;
//	@Resource
//	private SupplierCommentService supplierCommentService;
	
	@Autowired
	private QualityFacade qualityFacade;
	
	/**
	 * 质量管理-团列表
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/qualityList.htm")
	public String qualityList(HttpServletRequest request,HttpServletResponse response,ModelMap modelMap){
		
//		List<DicInfo> brandList = dicService
//				.getListByTypeCode(BasicConstants.CPXL_PP,WebUtils.getCurBizId(request));
//		modelMap.addAttribute("brandList", brandList);
		
		QualityListResult result=qualityFacade.qualityList(WebUtils.getCurBizId(request));
		modelMap.addAttribute("brandList", result.getBrandList());
		
		return "/quality/quality-list";
	}
	
	@RequestMapping(value="/qualityList.do",method=RequestMethod.POST)
	public String loadQualityList(HttpServletRequest request,HttpServletResponse response,ModelMap modelMap,
			QualityTourGroupCondition condition){
		
//		PageBean pageBean = new PageBean();
//		pageBean.setPage(condition.getPage());
//		if(condition.getPageSize() == null){
//			pageBean.setPageSize(Constants.PAGESIZE);			
//		}else{
//			pageBean.setPageSize(condition.getPageSize());
//		}
//		condition.setBizId(WebUtils.getCurBizId(request));
//		pageBean.setParameter(condition);		
//		pageBean = qualityService.getQualityTourGroupList(pageBean);
//		modelMap.addAttribute("pageBean", pageBean);
		
		LoadQualityListDTO loadQualityListDTO=new LoadQualityListDTO();
		loadQualityListDTO.setCondition(condition);
		loadQualityListDTO.setCurBizId(WebUtils.getCurBizId(request));
		
		LoadQualityListResult result=qualityFacade.loadQualityList(loadQualityListDTO);
		modelMap.addAttribute("pageBean", result.getPageBean());
		
		return "/quality/quality-list-table";
	}
	
	/**
	 * 团质量详情
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/groupQuality.htm")
	public String groupQualityInfo(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer groupId){
		
//		//团基本信息
//		TourGroup groupInfo = groupService.selectByPrimaryKey(groupId);
//		GroupFeedbackGroupStaticsVO groupStaticsVO = feedbackService.getGroupStaticsByGroupId(groupId);
//		List<GroupOrder> orderList = orderService.selectOrderByGroupId(groupId);
//		List<QualityGroupGuestFeedback> guestFeedbackStaticsList = getGuestFeedbackStatics(groupId,orderList);
//		model.addAttribute("group", groupInfo);
//		model.addAttribute("groupStaticsVo", groupStaticsVO);
//		model.addAttribute("guestFeedbackStaticsList", guestFeedbackStaticsList);
		
		GroupQualityInfoResult result=qualityFacade.groupQualityInfo(groupId);
		
		model.addAttribute("group", result.getGroupInfo());
		model.addAttribute("groupStaticsVo", result.getGroupStaticsVO());
		model.addAttribute("guestFeedbackStaticsList", result.getGuestFeedbackStaticsList());
		
		return "/quality/group-quality-info";
	}
	
//	/**
//	 * 顾客反馈统计
//	 * @param groupId
//	 * @return
//	 */	
//	private List<QualityGroupGuestFeedback> getGuestFeedbackStatics(Integer groupId,List<GroupOrder> orderList){		
//		List<QualityGroupGuestFeedback> guestFeedbackList = new ArrayList<QualityGroupGuestFeedback>();
//		if(orderList!=null && orderList.size()>0){
//			for(GroupOrder guestOrder : orderList){
//				List<GroupOrderGuest> guestList = orderGuestService.selectByOrderId(guestOrder.getId());
//				if(guestList!=null && guestList.size()>0){
//					for(GroupOrderGuest orderGuest : guestList){
//						QualityGroupGuestFeedback guest = new QualityGroupGuestFeedback();
//						guest.setGroupId(guestOrder.getGroupId());
//						guest.setSupplierName(guestOrder.getSupplierName());
//						guest.setReceiverMode(guestOrder.getReceiveMode());
//						guest.setGuestName(orderGuest.getName());
//						guest.setMobile(orderGuest.getMobile());
//						guest.setOrderNo(guestOrder.getOrderNo());
//						
//						GroupFeedbackPersonalStaticsVO staticsVo = feedbackService.getPersonalStaticsByGroupIdAndIdNo(groupId, orderGuest.getCertificateNum());
//						if(staticsVo!=null){
//							guest.setDriverAttitude(staticsVo.getDriverAttitude());
//							guest.setDriverEnvironment(staticsVo.getDriverEnvironment());
//							guest.setFoodEnvironment(staticsVo.getFoodEnvironment());
//							guest.setFoodQuality(staticsVo.getFoodQuality());
//							guest.setGuideAttitude(staticsVo.getGuideAttitude());
//							guest.setGuideProfession(staticsVo.getGuideProfession());
//							guest.setHotelEnvironment(staticsVo.getHotelEnvironment());
//							guest.setHotelQuality(staticsVo.getHotelQuality());
//							guest.setScenicWhole(staticsVo.getScenicWhole());
//							guest.setSuggest(staticsVo.getSuggestion());
//							guest.setScore(staticsVo.getScore());
//						}
//						guestFeedbackList.add(guest);
//					}					
//				}
//			}
//		}
//		return guestFeedbackList;
//	}
//	
//	private List<QualityCustomerTag> getCustomerTagStatics(List<GroupOrder> orderList){
//		if(orderList!=null && orderList.size()>0){
//			for(GroupOrder guestOrder : orderList){
//				
//			}
//			//customerService.
//		}
//		return null;
//	}
	
	/**
	 * 客人意见质量详情
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/customerQuality.htm")
	public String customerQualityInfo(HttpServletRequest request,HttpServletResponse response,ModelMap modelMap){
		return "/quality/customer-quality-info";
	}	
	
	/**
	 * 导游质量详情
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/guideQuality.htm")
	public String guideQualityInfo(HttpServletRequest request,HttpServletResponse response,ModelMap modelMap){
		return "/quality/guide-quality-info";
	}	
	
	/**
	 * 商家评论列表
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/supplierCommentList.htm")
	public String supplierCommentList(HttpServletRequest request,HttpServletResponse response,ModelMap modelMap){
		modelMap.addAttribute("supplierName", "滇池");
		modelMap.addAttribute("supplierEnName", "dianchi");
		modelMap.addAttribute("groupId", "215");
		modelMap.addAttribute("supplierId", "29");
		return "/quality/supplier-comment-list";
	}
	
	
	@RequestMapping(value = "/supplierCommentList.do")
	public String supplierCommentList(HttpServletRequest request, ModelMap model,Integer pageSize,Integer page,Integer groupId,Integer supplierId,String theKey) {
		
//		PageBean pageBean = new PageBean();
//		if(page==null){
//			pageBean.setPage(1);
//		}else{
//			pageBean.setPage(page);
//		}
//		if(pageSize==null){
//			pageBean.setPageSize(Constants.PAGESIZE);
//		}else{
//			pageBean.setPageSize(pageSize);
//		}
//		pageBean.setParameter(WebUtils.getQueryParamters(request));
//		pageBean = supplierCommentService.supplierCommentListSelectPage(pageBean, groupId,supplierId,theKey);
//		model.addAttribute("pageBean", pageBean);
		
		SupplierCommentListDTO supplierCommentListDTO=new SupplierCommentListDTO();
		supplierCommentListDTO.setGroupId(groupId);
		supplierCommentListDTO.setPage(page);
		supplierCommentListDTO.setPageSize(pageSize);
		supplierCommentListDTO.setSupplierId(supplierId);
		supplierCommentListDTO.setTheKey(theKey);
		supplierCommentListDTO.setQueryParamters(WebUtils.getQueryParamters(request));
		
		SupplierCommentListResult result=qualityFacade.supplierCommentList(supplierCommentListDTO);
		model.addAttribute("pageBean", result.getPageBean());
		
		return "/quality/supplier-comment-list-table";
	}
	
	/**
	 * 商家印象标签列表
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/supplierTagList.htm")
	public String supplierTagList(HttpServletRequest request,HttpServletResponse response,ModelMap modelMap){
		modelMap.addAttribute("supplierName", "滇池");
		modelMap.addAttribute("supplierEnName", "dianchi");
		modelMap.addAttribute("groupId", "215");
		modelMap.addAttribute("supplierId", "29");
		return "/quality/supplier-tag-list";
	}
	
	/**
	 * 商家印象标签统计
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping("/supplierTagStatics.htm")
	public String supplierTagStatics(HttpServletRequest request,HttpServletResponse response,ModelMap modelMap){
		return "/quality/supplier-tag-statics";
	}
	
	
	/**
	 * 修改商家评论状态
	 * @param request
	 * @param reponse
	 * @param model
	 */
	@RequestMapping(value = "updateCommentState.do", method = RequestMethod.POST)
	public void updateCommentState(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		
		//supplierCommentService.updateCommentState(Integer.parseInt(request.getParameter("id")),
		//Integer.parseInt(request.getParameter("state")));
		
		int id = Integer.parseInt(request.getParameter("id"));
		int state = Integer.parseInt(request.getParameter("state"));
		qualityFacade.updateCommentState(id,state);
	}
	
	/**
	 * 修改印象标签状态
	 * @param request
	 * @param reponse
	 * @param model
	 */
	@RequestMapping(value = "updateTagState.do", method = RequestMethod.POST)
	public void updateTagState(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
//		supplierCommentService.updateTagState(request.getParameter("name").toString(),
//				Integer.parseInt(request.getParameter("state")));
		
		String name = request.getParameter("name").toString();
		int state = Integer.parseInt(request.getParameter("state"));
		
		qualityFacade.updateTagState(name,state);
	}
	
	/**
	 * 跳转到回复页面
	 */
	@RequestMapping(value = "addReply.htm")
	public String addVerifyRecord(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {
		return "/quality/supplier-comment-reply";
	}
	
	/**
	 * 保存回复
	 * @param request
	 * @param reponse
	 * @param model
	 */
	@RequestMapping(value = "saveReply.do")
	@ResponseBody
	public String saveReply(HttpServletRequest request, HttpServletResponse reponse, ModelMap model, Integer id,String reply) {
//		try{
//			supplierCommentService.saveReply(id, reply,WebUtils.getCurUser(request).getEmployeeId(),WebUtils.getCurUser(request).getName(),System.currentTimeMillis());
//			return successJson("msg", "操作成功");
//		}catch(Exception e){
//			e.printStackTrace();
//			return errorJson("操作失败");
//		}	
		
		SaveReplyDTO saveReplyDTO=new SaveReplyDTO();
		saveReplyDTO.setEmployeeId(WebUtils.getCurUser(request).getEmployeeId());
		saveReplyDTO.setId(id);
		saveReplyDTO.setReply(reply);
		saveReplyDTO.setUserName(WebUtils.getCurUser(request).getName());
	
		BaseStateResult result=qualityFacade.saveReply(saveReplyDTO);
		if(result.isSuccess()){
			return successJson("msg", "操作成功");
		}else{
			return errorJson(result.getError());
		}
	}	
}
