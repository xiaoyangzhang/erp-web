package com.yihg.erp.controller.sys.platform;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PathPrefixConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.utils.ResultWebUtils;
import com.yihg.erp.utils.SysServiceSingleton;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.sys.po.AdditionalParameters;
import com.yimayhd.erpcenter.dal.sys.po.PlatformMenuPo;
import com.yimayhd.erpcenter.dal.sys.po.PlatformRoleMenuLinkPo;
import com.yimayhd.erpcenter.facade.sys.query.PlatformMenuPoDTO;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformMenuFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformRoleFacade;

/**
 * @author : zhangchao
 * @date : 2015年5月26日 下午1:18:46
 * @Description: 菜单控制类
 */
@Controller
@RequestMapping("/platFormMenu")
public class PlatFormMenuController {

	@Autowired
	private SysPlatformMenuFacade sysPlatformMenuFacade;
	@Autowired
	private SysPlatformRoleFacade sysPlatformRoleFacade;
	/**
	 * @author : zhangchao
	 * @date : 2015年5月26日 下午1:20:41
	 * @Description: 菜单列表
	 */
	@RequestMapping("/treeIndex")
	@RequiresPermissions(PermissionConstants.SYS_RES)
	public String index(Integer rootId,
			HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		int sysId = SysServiceSingleton.getPlatformSysPo().getPlatformSysPo().getSysId();
		//UserSession userSession = platformSessionService.getUserSession(SecurityConstant.USER_LOGIN_SESSION_KEY);
		Integer curBizId = WebUtils.getCurBizId(request);
		//List<PlatformMenuPo> itemList = this.menuList(sysId, rootId);
		PlatformMenuPo root = new PlatformMenuPo();
		root.setBizId(curBizId);
		root.setMenuId(0);;
		root.setName("根目录");		
		List<PlatformMenuPo> menuListByBizId = sysPlatformMenuFacade.getMenuListByBizId(curBizId, rootId).getPlatformMenuPos();
		menuListByBizId.add(root);
		//String items = new Gson().toJson(itemList);
		String jsonBizs = new Gson().toJson(menuListByBizId);
		//model.put("items", items);
		model.put("items", jsonBizs);
		return PathPrefixConstant.SYSTEM_MENU_PREFIX+"menu_index";
	}

	/**
	 * @author : zhangchao
	 * @date : 2015年5月27日 上午10:44:32
	 * @Description: 加载子菜单
	 */
	@RequestMapping(value = "getChild", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SYS_RES)
	@ResponseBody
	public String getChild(Integer id) {
		int sysId = SysServiceSingleton.getPlatformSysPo().getPlatformSysPo().getSysId();
		if (StringUtils.isBlank(id.toString())) {
			id = 0;
		}
		List<PlatformMenuPo> itemList = new ArrayList<PlatformMenuPo>();
		List<PlatformMenuPo> menulList = sysPlatformMenuFacade
				.getPlatformMenuListBysysIdAndParentId(sysId, id).getPlatformMenuPos();
		if (null != menulList && menulList.size() > 0) {
			for (PlatformMenuPo menu : menulList) {
				PlatformMenuPo item = new PlatformMenuPo();
				int child_count = sysPlatformMenuFacade
						.getPlatformMenuListBysysIdAndParentId(sysId,
								menu.getMenuId()).getPlatformMenuPos().size();
				item.setName(menu.getName());
				item.setMenuId(menu.getMenuId());
				if (child_count > 0) {
					item.setType("folder");
					AdditionalParameters adp = new AdditionalParameters();
					adp.setId(menu.getMenuId());
					item.setAdditionalParameters(adp);
				} else {
					AdditionalParameters adp = new AdditionalParameters();
					adp.setId(menu.getMenuId());
					item.setAdditionalParameters(adp);
					item.setType("item");
				}
				itemList.add(item);
			}
		}
		return new Gson().toJson(itemList);
	}
	
	@RequestMapping(value = "/commons/listAllMenu", method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SYS_RES)
	@ResponseBody
	public String listAllMenu(
			@RequestParam(defaultValue="1")int rootId,
			HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		int sysId = SysServiceSingleton.getPlatformSysPo().getPlatformSysPo().getSysId();
		List<PlatformMenuPo> itemList = this.menuList(sysId, rootId);
		return new Gson().toJson(itemList);
	}
	
	public List<PlatformMenuPo> menuList(int sysId,int parentid){
		List<PlatformMenuPo> itemList = new ArrayList<PlatformMenuPo>();
		List<PlatformMenuPo> menulList = sysPlatformMenuFacade.getAllMenuList(sysId, parentid).getPlatformMenuPos();
		if (null != menulList && menulList.size() > 0) {
			for (PlatformMenuPo menu : menulList) {
				PlatformMenuPo item = new PlatformMenuPo();
				int child_count = sysPlatformMenuFacade.getAllMenuList(sysId,menu.getMenuId()).getPlatformMenuPos().size();
				item.setParentId(parentid);
				item.setName(menu.getName());
				item.setMenuId(menu.getMenuId());
				if (child_count > 0) {
					item.setChildMenuList(this.menuList(sysId, menu.getMenuId()));
					item.setType("folder");
					AdditionalParameters adp = new AdditionalParameters();
					adp.setId(menu.getMenuId());
					item.setAdditionalParameters(adp);
				} else {
					AdditionalParameters adp = new AdditionalParameters();
					adp.setId(menu.getMenuId());
					item.setAdditionalParameters(adp);
					item.setType("item");
				}
				itemList.add(item);
			}
		}
		return itemList;
	}
	
	/**
	 * @author : zhangchao
	 * @date : 2015年5月27日 下午1:56:40
	 * @Description: 添加子级菜单
	 */
	@RequestMapping(value = "/getMenu")
	@RequiresPermissions(PermissionConstants.SYS_RES)
	public String getOrg(Integer menuId, ModelMap model) {
		PlatformMenuPo platformMenuPo = sysPlatformMenuFacade
				.getPlatformMenuMenuId(menuId);
		model.addAttribute("platformMenuPo", platformMenuPo);
		return PathPrefixConstant.SYSTEM_MENU_PREFIX+"menu_edit";
	}

	/**
	 * @author : zhangchao
	 * @date : 2015年5月27日 下午3:12:58
	 * @Description: 新增子菜单跳转
	 */
	@RequestMapping(value = "toCreateMenu")
	@RequiresPermissions(PermissionConstants.SYS_RES)
	public String toCreateMenu(Integer menuId, Integer sysId, ModelMap model) {
		PlatformMenuPo platformMenuPo = new PlatformMenuPo();
		platformMenuPo.setParentId(menuId);
		platformMenuPo.setSysId(sysId);
		model.addAttribute("platformMenuPo", platformMenuPo);
		return PathPrefixConstant.SYSTEM_MENU_PREFIX+"menu_edit";
	}

	/**
	 * @author : zhangchao
	 * @date : 2015年5月27日 下午3:16:19
	 * @Description: 新增子菜单到数据库
	 */
	@RequestMapping(value = "/saveMenu", method = RequestMethod.POST)
	public String saveMenu(PlatformMenuPo platformMenu,
			HttpServletRequest request, HttpServletResponse response) {
		Map<Object, Object> mapMsg = new HashMap<Object, Object>();
		PlatformMenuPoDTO dto = new PlatformMenuPoDTO();
		dto.setPlatformMenuPo(platformMenu);
		int temp = sysPlatformMenuFacade.addPlatformMenu(dto);
		if (temp > 0) {
			mapMsg.put("error", 0);
		} else {
			mapMsg.put("error", 1);
		}
		//String json = JSONObject.fromObject(mapMsg).toString();
		String json = JSON.toJSONString(mapMsg);
		// System.out.println("json:"+json);
		PrintWriter out;
		try {
			out = response.getWriter();
			out.println(json);
			out.flush();
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @author : zhangchao
	 * @date : 2015年5月27日 下午3:51:02
	 * @Description: 删除菜单
	 */
	@ResponseBody
	@RequestMapping("/delMenu")
	public String delMenu(String menuId) {
		List<PlatformRoleMenuLinkPo> tempList = sysPlatformRoleFacade
				.findPlatformRoleMenuLinkPoByMenuId(menuId).getPlatformRoleMenuLinkPos();
		List<PlatformMenuPo> menuPos = sysPlatformMenuFacade
				.getPlatformMenuListBysysIdAndParentId(SysServiceSingleton
						.getPlatformSysPo().getPlatformSysPo().getSysId(), Integer
						.parseInt(menuId)).getPlatformMenuPos();
		if (tempList.size() > 0) {
			JsonObject json = new JsonObject();
			json.addProperty("error", true);
			json.addProperty("msg", "删除失败,已有角色绑定此菜单！");
			return json.toString();
		} else if (menuPos.size() > 0) {
			JsonObject json = new JsonObject();
			json.addProperty("error", true);
			json.addProperty("msg", "删除失败,请先删除子级菜单!");
			return json.toString();
		} else {
			int temp = sysPlatformMenuFacade.deletePlatformMenuByMenuId(Integer
					.parseInt(menuId));
			return temp > 0 ? ResultWebUtils.successJson() : ResultWebUtils
					.errorJson("删除失败");
		}

	}
	
	/**
	 * 判断菜单名称是否已经存在
	 * **
	 */
	@ResponseBody
	@RequestMapping("/commons/valideteMenuName")
	public String valideteMenuName(
			@RequestParam(defaultValue="0")int parentMenuId, 
			@RequestParam(defaultValue="")String menuName, 
			@RequestParam(defaultValue="0")int exceptMenuId,
			HttpServletRequest request, HttpServletResponse response, ModelMap model){
		List<PlatformMenuPo> list = sysPlatformMenuFacade.getMenuList(parentMenuId, menuName, exceptMenuId).getPlatformMenuPos();
		if(list.size()==0){
			return ResultWebUtils.successJson();
		}else{
			return ResultWebUtils.errorJson("菜单名已存在！");
		}
	}
	

}
