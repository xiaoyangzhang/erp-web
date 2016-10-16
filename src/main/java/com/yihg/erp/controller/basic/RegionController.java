package com.yihg.erp.controller.basic;

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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.yihg.basic.api.RegionService;
import com.yihg.basic.po.RegionInfo;
import com.yihg.erp.controller.BaseController;

@Controller
@RequestMapping(value = "/basic")
public class RegionController extends BaseController {
	@Autowired
	private RegionService regionService;
	
	@RequestMapping(value = "getRegion.htm", method = RequestMethod.GET,produces="text/html;charset=UTF-8")
	@ResponseBody
	public String getRegion(HttpServletRequest request,
			HttpServletResponse response, String pid, ModelMap model){
		List<RegionInfo> list = regionService.getRegionById(pid);
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation()
				.create();
		String json = gson.toJson(list);
		return json;
	}
	
	@RequestMapping(value="regIndex.htm",method=RequestMethod.GET)
	public String regIndex(){
		return "/basic/region/region_index";
	}
	
	
	@RequestMapping(value="getRegion.do")
	@ResponseBody
	public String getReg(HttpServletRequest request){
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String level = request.getParameter("level");
		JSONArray jsonArray=new JSONArray();  
		if(StringUtils.isBlank(id)){
			return jsonArray.toJSONString();
		}
		List<RegionInfo> dicRegions = regionService.getRegionById(id);
		if(dicRegions==null || dicRegions.size()==0){
			return jsonArray.toJSONString();
		}
		for (RegionInfo dicRegion : dicRegions) {
			JSONObject jsonObject=new JSONObject();  
	        jsonObject.put("id",dicRegion.getId());  
	        jsonObject.put("pid",dicRegion.getPid());  
	        jsonObject.put("name",dicRegion.getName()); 
	        jsonObject.put("level", dicRegion.getLevel());
	        if(dicRegion.getLevel()!=4){
	        	 jsonObject.put("isParent", true);
	        }
	        jsonArray.add(jsonObject);
		}
		return jsonArray.toJSONString();  
	}
	
	
	@RequestMapping(value="regionEdit.htm",method=RequestMethod.GET)
	public String digUpdate(ModelMap model,String id){
		RegionInfo dicRegion = regionService.getById(id);
		model.addAttribute("region", dicRegion);
		return "/basic/region/region_edit";
	}
	
	@RequestMapping(value="submitRegion.do",method=RequestMethod.POST)
	@ResponseBody
	public String regionSubmit(RegionInfo dicRegion){
		if(dicRegion.getId()!=null){
			return  regionService.update(dicRegion)> 0 ?successJson() :errorJson("修改失败");
		}else{
			return  regionService.add(dicRegion)> 0 ?successJson() :errorJson("修改失败");

		}
		
	
	}
	
	@RequestMapping(value="regionAdd.htm",method=RequestMethod.GET)
	public String digAdd(ModelMap model,String id,String level){
		model.addAttribute("pid", id);
		model.addAttribute("level", level);
		return "/basic/region/region_add";
	}
	
	@RequestMapping(value="isNode.do",method=RequestMethod.GET,produces="text/html;charset=UTF-8")
	@ResponseBody
	public String isNode(String id){
		int i =  regionService.isNode(id);
		if(i==0){
			RegionInfo dicRegion = new RegionInfo();
			dicRegion.setId(Integer.valueOf(id));
			dicRegion.setStatus(0);
			regionService.update(dicRegion);
		}
		 return i== 0 ?successJson() :errorJson("不允许删除,存在子节点");
	}
	
	

	
}
