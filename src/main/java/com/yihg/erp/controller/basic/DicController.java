package com.yihg.erp.controller.basic;

import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.basic.po.DicTypeInfo;
import com.yimayhd.erpcenter.facade.basic.service.DicFacade;

@Controller
@RequestMapping("/basic")
public class DicController extends BaseController{
	@Autowired
	private DicFacade dicFacade;
	
	@RequestMapping(value="/dicTypeIndex.htm",method=RequestMethod.GET)
	public String dicTypeIndex(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		return null;
		/*String dicTypeJson = dicTypeService.getDicTypeJson();
		model.addAttribute("dicTypeJson", dicTypeJson);
		return "/basic/dic/dic_type_index";*/
	}
	
	@RequestMapping(value="/dicTypeList.htm",method=RequestMethod.GET)
	public String dicTypeList(HttpServletRequest request,HttpServletResponse response,ModelMap model,String pid,String name){
		List<DicTypeInfo> dicTypeList = dicFacade.dicTypeList(pid, name);
		model.addAttribute("list", dicTypeList);		
		model.addAttribute("pid", pid);
		model.addAttribute("name", name);
		return "/basic/dic/dic_type_main";
	}
	
	@RequestMapping(value="/addDicType.htm",method=RequestMethod.GET)
	public String dicTypeAdd(HttpServletRequest request,HttpServletResponse response,ModelMap model,String pid){
		DicTypeInfo info = dicFacade.getDicTypeById(pid);
		model.addAttribute("parentType", info);
		return "/basic/dic/dic_type_add";
	}
	
	@RequestMapping(value="/editDicType.htm",method=RequestMethod.GET)
	public String dicTypeEdit(HttpServletRequest request,HttpServletResponse response,ModelMap model,String id){
		DicTypeInfo info = dicFacade.getDicTypeById(id);
		model.addAttribute("type", info);
		DicTypeInfo parentType = dicFacade.getDicTypeById(info.getPid());
		model.addAttribute("parentType", parentType);
		return "/basic/dic/dic_type_edit";
	}
	
	
	@RequestMapping(value="/submitDicType.do",method=RequestMethod.POST)
	public String dicTypeSubmit(HttpServletRequest request,HttpServletResponse response,DicTypeInfo info){
		if(info.getId()!=null ){
			dicFacade.dicTypeUpdate(info);
		}else{
			dicFacade.dicTypeAdd(info);	
		}
		return "redirect:dicTypeList.htm?pid="+info.getPid();
	}
	
	@RequestMapping(value = "/delDicType.do", method = RequestMethod.POST)
	@ResponseBody
	public String dicTypeDel(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer id) {
		dicFacade.dicTypeDelete(id);
		return successJson();			
	} 
	
	@RequestMapping(value="/dicIndex.htm",method=RequestMethod.GET)
	public String dicIndex(HttpServletRequest request,HttpServletResponse response,ModelMap model){
		String dicTypeJson = dicFacade.getDicTypeJson();
		model.addAttribute("dicTypeJson", dicTypeJson);
		return "/basic/dic/dic_index";
	}
	
	/**
	 * 
	 * @param btype 业务类型：sys,hotel
	 * @param request
	 * @param response
	 * @param model
	 * @param type
	 * @param p
	 * @return
	 * @throws BussinessException 
	 */
	@RequestMapping(value="/dicList.htm",method=RequestMethod.GET)
	public String dicList(HttpServletRequest request,HttpServletResponse response,ModelMap model,String type,String name){
		if(StringUtils.isNotBlank(name)){
			try {
				name = new String(request.getParameter("name").getBytes("iso8859-1"),"utf-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		DicTypeInfo dicType = dicFacade.getDicTypeById(type);
		int share = 1;
		int bizId = WebUtils.getCurBizId(request);
		if(dicType!=null){
			share = dicType.getShareStatus() == null ?1:dicType.getShareStatus();
		}
		List<DicInfo> list = null;
		if(share==1){
			list = dicFacade.getListByTypeIdAndName(type, name);
		}else{
			list = dicFacade.getListByTypeIdAndName(type,bizId,name);			
		}
		model.addAttribute("bizId", bizId);
		model.addAttribute("share", share);
		model.addAttribute("type", type);		
		model.addAttribute("list", list);
		model.addAttribute("name", name);
		return "/basic/dic/dic_main";
	}
	
	@RequestMapping(value="/addDic.htm",method=RequestMethod.GET)
	public String dicAdd(HttpServletRequest request,HttpServletResponse response,ModelMap model,String type){
		DicTypeInfo dicTypeInfo = dicFacade.getDicTypeById(type);
		int share = 1;
		if(dicTypeInfo!=null){
			share = dicTypeInfo.getShareStatus() == null ?1:dicTypeInfo.getShareStatus();
		}
		model.addAttribute("bizId", WebUtils.getCurBizId(request));
		model.addAttribute("share", share);
		model.addAttribute("type", dicTypeInfo);
		return "/basic/dic/dic_add";
	}
	
	@RequestMapping(value="/editDic.htm",method=RequestMethod.GET)
	public String dicEdit(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer id){
		DicInfo dicInfo = dicFacade.getDicById(id);
		DicTypeInfo dicTypeInfo = dicFacade.getDicTypeById(dicInfo.getTypeId());
		int share = 1;
		if(dicTypeInfo!=null){
			share = dicTypeInfo.getShareStatus() == null ?1:dicTypeInfo.getShareStatus();
		}
		model.addAttribute("share", share);
		model.addAttribute("type", dicTypeInfo);
		model.addAttribute("dic", dicInfo);
		return "/basic/dic/dic_edit";
	}
	
	@RequestMapping(value = "/submitDic.do", method = RequestMethod.POST)
	public String dicSubmit(HttpServletRequest request,HttpServletResponse response,DicInfo dicInfo,String[] roleIds){
		if(dicInfo==null){
			return null;
		}
		try {
			if(dicInfo.getId()!=null){
				dicFacade.dicUpdate(dicInfo);
			}else{
				dicFacade.dicAdd(dicInfo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:dicList.htm?type="+dicInfo.getTypeId();
	}
	
	@RequestMapping(value = "/delDic.do", method = RequestMethod.POST)
	@ResponseBody
	public String dicDel(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer id) {
		//Long dicId = Long.valueOf(id);
		dicFacade.dicDel(id);		
		return successJson();
	}
}
