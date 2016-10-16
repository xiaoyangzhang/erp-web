package com.yihg.erp.controller.sys.role;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
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
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PathPrefixConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysServiceSingleton;
import com.yihg.erp.utils.ResultWebUtils;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.supplier.constants.Constants;
import com.yihg.sys.api.PlatformMenuService;
import com.yihg.sys.api.PlatformRoleService;
import com.yihg.sys.po.AdditionalParameters;
import com.yihg.sys.po.PlatformMenuPo;
import com.yihg.sys.po.PlatformRoleMenuLinkPo;
import com.yihg.sys.po.PlatformRolePo;


/**
 * 权限相关
 * @author Administrator
 *
 */
@Controller
@RequestMapping("/role")
public class RoleController extends BaseController{
	
	private static final Logger LOG = LoggerFactory
			.getLogger(RoleController.class);
	
	@Autowired
	private PlatformRoleService platformRoleService;
	@Autowired
	private PlatformMenuService platformMenuService;
	@Autowired
	private DicService  dicService;
	@RequestMapping("roleList")
	@RequiresPermissions(PermissionConstants.SYS_ROLE)
	public String  getRoleList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model){
		PlatformRolePo po = new PlatformRolePo();
		//po.setSysId(SysServiceSingleton.getPlatformSysPo().getSysId());
		po.setBizId(WebUtils.getCurBizId(request));
		po.setDelStatus(1);
		if (po.getPage()==null) {
			po.setPage(1);
		}
		if (po.getPageSize()==null) {
			po.setPageSize(Constants.PAGESIZE);
		}
		PageBean pageBean = platformRoleService.getRoleList(po,1);
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("pageSize", pageBean.getPageSize());
		
		return PathPrefixConstant.SYSTEM_ROLE_PREFIX+"roleList";
	}
	
	
	@RequestMapping(value="roleList.do",method=RequestMethod.POST)
	@RequiresPermissions(PermissionConstants.SYS_ROLE)
	public String  queryRoleList(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,PlatformRolePo po){
		//po.setSysId(SysServiceSingleton.getPlatformSysPo().getSysId());
		po.setDelStatus(1);
		po.setBizId(WebUtils.getCurBizId(request));
		if (po.getPage()==null) {
			po.setPage(1);
		}
		if (po.getPageSize()==null) {
			po.setPageSize(Constants.PAGESIZE);
		}
		
		PageBean pageBean = platformRoleService.getRoleList(po, po.getPage());
		model.addAttribute("pageBean", pageBean);
		model.addAttribute("pageSize", po.getPageSize());
		
		return PathPrefixConstant.SYSTEM_ROLE_PREFIX+"roleTableList";
	}
	
	@RequestMapping("deleteRole")
	@ResponseBody
	public String deleteRole(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,int roleId){
		
		int result = platformRoleService.deleteByRoleid(roleId);
		
		return resultJson("result",String.valueOf(result));
	}
	
	@RequestMapping("addRole")
	@RequiresPermissions(PermissionConstants.SYS_ROLE)
	public String addRole(HttpServletRequest request,HttpServletResponse reponse,ModelMap model){
		//查询权限菜单 从等级开始查询
		ArrayList<Map<Object, Object>> maps = new ArrayList<Map<Object,Object>>();
		List<PlatformMenuPo> menulList = platformMenuService.getMenuListByBizId(WebUtils.getCurBizId(request), null);
		for (PlatformMenuPo menu : menulList) {
			
			//查询此菜单下面是否有子菜单
			//List<PlatformMenuPo>  childreMenulList = platformMenuService.getPlatformMenuListBysysIdAndParentId(null, menu.getMenuId());
			//int child_count = childreMenulList.size();
			Map<Object, Object> map = new HashMap<Object, Object>();
			//封装一级
			map.put("id", menu.getMenuId());
			map.put("pId", menu.getParentId());
			map.put("name", menu.getName());
			//查询此菜单是否被角色关联
//			List<PlatformRoleMenuLinkPo> latformRoleMenuLinkPoList =platformRoleService.findPlatformRoleMenuLinkPoByRoleIdAndMenuId(roleId,menu.getMenuId());
//			if(latformRoleMenuLinkPoList.size()>0)
//			{
//				map.put("checked", "true");//是否已选中
//			}
			//if(child_count>0)
			//{
			//	map.put("open", "true");//是否展开
			//}
			maps.add(map);
		}
		//JSONArray menuJosnStr = JSONArray.fromObject(maps);
		String menuJosnStr = JSON.toJSONString(maps);
//				System.out.println("menuJosnStr:"+menuJosnStr);
		model.put("menuJosnStr", menuJosnStr);
		List<DicInfo> roleGroup = dicService.getListByTypeCode(BasicConstants.ROLE_GROUP,WebUtils.getCurBizId(request));
		model.addAttribute("roleGroup", roleGroup);
		
		return PathPrefixConstant.SYSTEM_ROLE_PREFIX+"addRole";
	}
	
	@RequestMapping("editRole")
	@RequiresPermissions(PermissionConstants.SYS_ROLE)
	public String editRole(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,int roleId){
		PlatformRolePo platformRolePo = platformRoleService.findByRoleId(roleId);
		model.addAttribute("platformRolePo", platformRolePo);
		//拼装此角色的权限map
		/*[
			{ id:1, pId:0, name:"随意勾选 1", open:true},
			{ id:11, pId:1, name:"随意勾选 1-1", open:true},
			{ id:111, pId:11, name:"随意勾选 1-1-1"},
			{ id:112, pId:11, name:"随意勾选 1-1-2"},
			{ id:12, pId:1, name:"随意勾选 1-2", open:true},
			{ id:121, pId:12, name:"随意勾选 1-2-1"},
			{ id:122, pId:12, name:"随意勾选 1-2-2"},
			{ id:2, pId:0, name:"随意勾选 2", checked:true, open:true},
			{ id:21, pId:2, name:"随意勾选 2-1"},
			{ id:22, pId:2, name:"随意勾选 2-2", open:true},
			{ id:221, pId:22, name:"随意勾选 2-2-1", checked:true},
			{ id:222, pId:22, name:"随意勾选 2-2-2"},
			{ id:23, pId:2, name:"随意勾选 2-3"}
		]*/
		//查询权限菜单 从等级开始查询
		ArrayList<Map<Object, Object>> maps = new ArrayList<Map<Object,Object>>();
		Integer bizId = WebUtils.getCurBizId(request);
		//List<PlatformMenuPo> menulList = platformMenuService.getPlatformMenuJosnList(SysServiceSingleton.getPlatformSysPo().getSysId());
		List<PlatformMenuPo> menulList = platformMenuService.getMenuListByBizId(bizId, null);
		for (PlatformMenuPo menu : menulList) {
			
			//查询此菜单下面是否有子菜单
			//List<PlatformMenuPo>  childreMenulList = platformMenuService.getPlatformMenuListBysysIdAndParentId(SysServiceSingleton.getPlatformSysPo().getSysId(), menu.getMenuId());
			//int child_count = childreMenulList.size();
			Map<Object, Object> map = new HashMap<Object, Object>();
			//封装一级
			map.put("id", menu.getMenuId());
			map.put("pId", menu.getParentId());
			map.put("name", menu.getName());
			//查询此菜单是否被角色关联
			List<PlatformRoleMenuLinkPo> latformRoleMenuLinkPoList =platformRoleService.findPlatformRoleMenuLinkPoByRoleIdAndMenuId(roleId,menu.getMenuId());
			if(latformRoleMenuLinkPoList.size()>0)
			{
				map.put("checked", "true");//是否已选中
			}
			///if(child_count>0)
			//{
			//	map.put("open", "true");//是否展开
			//}
			maps.add(map);
		}
		//JSONArray menuJosnStr = JSONArray.fromObject(maps);
		String menuJosnStr = JSON.toJSONString(maps);
//		System.out.println("menuJosnStr:"+menuJosnStr);
		model.put("menuJosnStr", menuJosnStr);
		List<DicInfo> roleGroup = dicService.getListByTypeCode(BasicConstants.ROLE_GROUP,WebUtils.getCurBizId(request));
		model.put("roleGroup", roleGroup);
		
		return PathPrefixConstant.SYSTEM_ROLE_PREFIX+"editRole";
	}
	
	@RequestMapping("submit")
	public String submit(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,PlatformRolePo platformRolePo){
		//platformRolePo.setSysId(SysServiceSingleton.getPlatformSysPo().getSysId());
		//由于sysId不能null，所以无奈设置了一个毫无用处的0
		platformRolePo.setSysId(0);
		platformRolePo.setDelStatus(1);
		Integer bizId = WebUtils.getCurBizId(request);
		platformRolePo.setBizId(bizId);
		int roleId = platformRoleService.saveRole(platformRolePo);
		
		return "redirect:roleList";
	}
	
	
	/**
	 * 判断角色名称是否已经存在
	 * **
	 */
	@ResponseBody
	@RequestMapping("/commons/valideteRoleName")
	public String valideteMenuName(
			@RequestParam(defaultValue="")String roleName, 
			@RequestParam(defaultValue="0")int exceptRoleId,
			HttpServletRequest request, HttpServletResponse response, ModelMap model){
		List<PlatformRolePo> list = platformRoleService.getRoleList(roleName, exceptRoleId);
		if(list.size()==0){
			return ResultWebUtils.successJson();
		}else{
			return ResultWebUtils.errorJson("角色名已存在！");
		}
	}
	/**
	 * 角色复制功能
	 * @param request
	 * @param response
	 * @param model
	 * @param roleId
	 * @return
	 */
	@RequestMapping("copyRole.do")
	@ResponseBody
	public String copyRole(HttpServletRequest request,HttpServletResponse response,ModelMap model,Integer roleId){
		try {
			platformRoleService.copyRole(roleId);
		} catch (Exception e) {
			return errorJson("复制失败");
		}
		return successJson();
		
	}
}
