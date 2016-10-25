package com.yihg.erp.controller.sys.org;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PathPrefixConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.ResultWebUtils;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.sys.po.AdditionalParameters;
import com.yimayhd.erpcenter.dal.sys.po.PlatformOrgPo;
import com.yimayhd.erpcenter.facade.sys.query.PlatformOrgPoDTO;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;


@Controller
@RequestMapping("/org")
public class OrgController extends BaseController{
	private static final Logger LOG = LoggerFactory
			.getLogger(OrgController.class);
	
	@Autowired
	private SysPlatformOrgFacade sysPlatformOrgFacade;
//	private PlatformOrgService platformOrgService;
	@Autowired
	private SysConfig config;
	@RequestMapping(value="treeIndex")
	@RequiresPermissions(PermissionConstants.SYS_ORG)
    public String index(HttpServletRequest request,ModelMap model){
		
		
		//Integer sysId =SysServiceSingleton.getPlatformSysPo().getSysId();
		Integer bizId = WebUtils.getCurBizId(request);
		//查询组织机构树
		ArrayList<Map<Object, Object>> maps = new ArrayList<Map<Object,Object>>();
		List<PlatformOrgPo> orgTree = sysPlatformOrgFacade.getOrgTree(bizId, null).getPlatformOrgPos();
	
		for(PlatformOrgPo org : orgTree){
			//查询此组织机构下面是否有子菜单
			List<PlatformOrgPo> orgTreeChildre = sysPlatformOrgFacade.getOrgTree(bizId, org.getOrgId()).getPlatformOrgPos();
			int child_count = orgTreeChildre.size();
			Map<Object, Object> map = new HashMap<Object, Object>();
			//封装一级
			map.put("id", org.getOrgId());
			map.put("pId", org.getParentId());
			map.put("name", org.getName());
		
			if(child_count>0)
			{
				map.put("open", "true");//是否展开
			}
			maps.add(map);
			
		}
		//JSONArray menuJosnStr = JSONArray.fromObject(maps);
		String menuJosnStr = JSON.toJSONString(maps);
		
		model.addAttribute("orgJosnStr",menuJosnStr);
        return PathPrefixConstant.SYSTEM_ORG_PREFIX+"org_index";
    }
	
	@RequestMapping(value = "getChild", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SYS_ORG)
	@ResponseBody
	public String getChild(Integer id) {
		if(id==null){
			id=1;
		}
		List<PlatformOrgPo> itemList = new ArrayList<PlatformOrgPo>();
		//int sysId = SysServiceSingleton.getPlatformSysPo().getSysId();
		List<PlatformOrgPo> orglList = sysPlatformOrgFacade.findByPid(id,null).getPlatformOrgPos();
		if (null != orglList && orglList.size() > 0) {
			for (PlatformOrgPo org : orglList) {
				PlatformOrgPo item = new PlatformOrgPo();
				int child_count = sysPlatformOrgFacade.findByPid(org.getOrgId(),null).getPlatformOrgPos().size();
				item.setName(org.getName());
				item.setOrgId(org.getOrgId());
				if (child_count > 0) {
					item.setType("folder");
					AdditionalParameters adp = new AdditionalParameters
							();
					adp.setId(org.getOrgId());
					item.setAdditionalParameters(adp);
				} else {
					AdditionalParameters adp = new AdditionalParameters();
					adp.setId(org.getOrgId());
					item.setAdditionalParameters(adp);
					item.setType("item");
				}
				itemList.add(item);
			}
		}
		return new Gson().toJson(itemList);
	}
	@RequestMapping(value="getOrg")
	@RequiresPermissions(PermissionConstants.SYS_ORG)
	public String getOrg(Integer orgId,ModelMap model){
		PlatformOrgPo platformOrgPo = sysPlatformOrgFacade.findByOrgId(orgId).getPlatformOrgPo();
		model.addAttribute("org",platformOrgPo);
		model.addAttribute("config", config);
		return PathPrefixConstant.SYSTEM_ORG_PREFIX+"org_edit";
	}
	/**
	 * to创建org
	 * @param orgId
	 * @param sysId
	 * @param model
	 * @return
	 */
	@RequestMapping(value="toCreateOrg")
	@RequiresPermissions(PermissionConstants.SYS_ORG)
	public String toCreateOrg(Integer orgId,Integer sysId,ModelMap model){
		PlatformOrgPo po = new PlatformOrgPo();
		
		po.setParentId(orgId);
		
		po.setSysId(sysId);
		model.addAttribute("org", po);
		model.addAttribute("config", config);
		return PathPrefixConstant.SYSTEM_ORG_PREFIX+"org_edit";  
	}
	
	/**
	 * 保存org
	 * @param po
	 * @return
	 */
	
	@RequestMapping(value="saveOrg",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrg(HttpServletRequest request,PlatformOrgPo po)
	{
		Integer curBizId = WebUtils.getCurBizId(request);
		po.setBizId(curBizId);
		/*List<PlatformOrgPo> orgList = platformOrgService.getOrgTree(WebUtils.getCurBizId(request), null);
		for (PlatformOrgPo org : orgList) {
			if(org.getOrgId().equals(po.getParentId())){
				while(org.getParentId()!=0){
					po.setOrgPath(org.getParentId()+"-"+org.getOrgId()+"-");
					 org = platformOrgService.findByOrgId(org.getParentId());
				}
				break;
			}
		}*/	
		PlatformOrgPoDTO dto = new PlatformOrgPoDTO();
		dto.setPlatformOrgPo(po);
		int orgId = sysPlatformOrgFacade.saveOrg(dto);
		return orgId> 0 ?successJson("orgId",orgId+"") :errorJson("操作失败");
		
		
	}
	
	
	@RequestMapping(value="delOrg",method=RequestMethod.POST)
	@ResponseBody
	public String delOrg(Integer orgId,HttpServletRequest request)
	{
		List<PlatformOrgPo> orgTreeChildre = sysPlatformOrgFacade.getOrgTree(WebUtils.getCurBizId(request), orgId).getPlatformOrgPos();
		if(orgTreeChildre==null||orgTreeChildre.size()==0){
			return sysPlatformOrgFacade.delOrg(orgId)> 0 ?successJson() :errorJson("删除失败");
		}else{
			return errorJson("删除失败,存在下级");
		}   
		
	}
	
	/**
	 * 判断组织机构名称是否已经存在
	 * **
	 */
	@ResponseBody
	@RequestMapping("/commons/valideteOrgName")
	public String valideteMenuName(
			@RequestParam(defaultValue="")String orgName, 
			@RequestParam(defaultValue="0")int exceptOrgId,
			HttpServletRequest request, HttpServletResponse response, ModelMap model){
		List<PlatformOrgPo> list = sysPlatformOrgFacade.getOrgList(orgName, exceptOrgId).getPlatformOrgPos();
		if(list.size()==0){
			return ResultWebUtils.successJson();
		}else{
			return ResultWebUtils.errorJson("角色名已存在！");
		}
	}
	
}
